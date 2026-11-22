import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/career/data/datasources/career_seed_data.dart';
import 'package:nexus_portuguese_app/features/career/domain/entities/business_phrase_entity.dart';
import 'package:nexus_portuguese_app/features/career/domain/entities/interview_question_entity.dart';
import 'package:nexus_portuguese_app/features/career/domain/repositories/career_repository.dart';
import 'package:nexus_portuguese_app/features/career/presentation/cubit/career_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/career/presentation/cubit/career_catalog_state.dart';
import 'package:nexus_portuguese_app/features/career/presentation/cubit/interview_simulator_cubit.dart';

class MockCareerRepository extends Mock implements CareerRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('CareerCatalogCubit Tests', () {
    late MockCareerRepository mockRepo;
    late CareerCatalogCubit cubit;
    const testScenarios = CareerSeedData.scenarios;
    const testPhrases = CareerSeedData.phrases;
    const testGuides = CareerSeedData.cvGuides;

    setUp(() {
      mockRepo = MockCareerRepository();
      when(() => mockRepo.getScenarios()).thenAnswer((_) async => const Result.ok(testScenarios));
      when(() => mockRepo.getPhrases()).thenAnswer((_) async => const Result.ok(testPhrases));
      when(() => mockRepo.getCvGuides()).thenAnswer((_) async => const Result.ok(testGuides));

      cubit = CareerCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is initial and empty', () {
      expect(cubit.state.status, CareerCatalogStatus.initial);
      expect(cubit.state.allScenarios, isEmpty);
      expect(cubit.state.allPhrases, isEmpty);
      expect(cubit.state.allCvGuides, isEmpty);
      expect(cubit.state.activeTabIndex, 0);
    });

    test('loadCatalog loads scenarios, phrases and cvGuides successfully', () async {
      await cubit.loadCatalog();

      expect(cubit.state.status, CareerCatalogStatus.loaded);
      expect(cubit.state.allScenarios.length, testScenarios.length);
      expect(cubit.state.allPhrases.length, testPhrases.length);
      expect(cubit.state.allCvGuides.length, testGuides.length);
    });

    test('loadCatalog handles error failure', () async {
      when(() => mockRepo.getScenarios()).thenAnswer(
        (_) async => Result.err(const DatabaseFailure('Ошибка базы данных')),
      );

      await cubit.loadCatalog();

      expect(cubit.state.status, CareerCatalogStatus.error);
      expect(cubit.state.errorMessage, 'Ошибка базы данных');
    });

    test('filterByCategory filters scenarios', () async {
      await cubit.loadCatalog();
      cubit.filterByCategory(CareerCategory.tech);

      expect(cubit.state.selectedCategory, CareerCategory.tech);
      for (final sc in cubit.state.filteredScenarios) {
        expect(sc.category, CareerCategory.tech);
      }

      cubit.filterByCategory(null);
      expect(cubit.state.selectedCategory, isNull);
    });

    test('filterByPhraseType filters phrases', () async {
      await cubit.loadCatalog();
      cubit.filterByPhraseType(BusinessPhraseType.emailTemplate);

      expect(cubit.state.selectedPhraseType, BusinessPhraseType.emailTemplate);
      for (final p in cubit.state.filteredPhrases) {
        expect(p.phraseType, BusinessPhraseType.emailTemplate);
      }

      cubit.filterByPhraseType(null);
      expect(cubit.state.selectedPhraseType, isNull);
    });

    test('filterByDialect filters scenarios and phrases by BR / PT', () async {
      await cubit.loadCatalog();

      cubit.filterByDialect('BR');
      expect(cubit.state.selectedDialect, 'BR');
      for (final sc in cubit.state.filteredScenarios) {
        expect(sc.isPtBr, isTrue);
      }

      cubit.filterByDialect('PT');
      expect(cubit.state.selectedDialect, 'PT');
      for (final sc in cubit.state.filteredScenarios) {
        expect(sc.isPtPt, isTrue);
      }
    });

    test('search filters scenarios and phrases by search query', () async {
      await cubit.loadCatalog();

      cubit.search('Lisboa');
      for (final sc in cubit.state.filteredScenarios) {
        final matches = sc.jobTitlePt.toLowerCase().contains('lisboa') ||
            sc.jobTitleRu.toLowerCase().contains('lisboa') ||
            sc.companyName.toLowerCase().contains('lisboa');
        expect(matches, isTrue);
      }

      cubit.search('');
      expect(cubit.state.filteredScenarios.length, testScenarios.length);
    });

    test('setTab updates activeTabIndex', () {
      cubit.setTab(2);
      expect(cubit.state.activeTabIndex, 2);
    });
  });

  group('InterviewSimulatorCubit Tests', () {
    late MockCareerRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late InterviewSimulatorCubit cubit;
    final testScenario = CareerSeedData.scenarios.first;

    setUp(() {
      mockRepo = MockCareerRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockRepo.recordInterviewCompleted(
        scenarioId: any(named: 'scenarioId'),
        score: any(named: 'score'),
        maxScore: any(named: 'maxScore'),
      )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
        fallbackText: any(named: 'fallbackText'),
        dialect: any(named: 'dialect'),
      )).thenAnswer((_) async {});

      cubit = InterviewSimulatorCubit(
        scenario: testScenario,
        repository: mockRepo,
        audioService: mockAudio,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is set up for question 0', () {
      expect(cubit.state.currentQuestionIndex, 0);
      expect(cubit.state.totalScore, 0);
      expect(cubit.state.isAnswered, isFalse);
      expect(cubit.state.selectedOptionIndex, isNull);
      expect(cubit.state.isCompleted, isFalse);
      expect(cubit.state.currentQuestion.id, testScenario.questions.first.id);
    });

    test('selectOption updates selectedOptionIndex and totalScore', () {
      final q = testScenario.questions.first;
      final expectedPoints = q.options[0].points;

      cubit.selectOption(0);

      expect(cubit.state.selectedOptionIndex, 0);
      expect(cubit.state.isAnswered, isTrue);
      expect(cubit.state.totalScore, expectedPoints);

      // Subsequent call does nothing
      cubit.selectOption(1);
      expect(cubit.state.selectedOptionIndex, 0);
      expect(cubit.state.totalScore, expectedPoints);
    });

    test('nextQuestion moves to next question and resets answered state', () {
      cubit.selectOption(0);
      cubit.nextQuestion();

      expect(cubit.state.currentQuestionIndex, 1);
      expect(cubit.state.isAnswered, isFalse);
      expect(cubit.state.selectedOptionIndex, isNull);
    });

    test('nextQuestion on last question marks interview completed and logs score', () async {
      final totalQuestions = testScenario.questions.length;

      for (var i = 0; i < totalQuestions; i++) {
        cubit.selectOption(0);
        cubit.nextQuestion();
      }

      expect(cubit.state.isCompleted, isTrue);
      verify(() => mockRepo.recordInterviewCompleted(
        scenarioId: testScenario.id,
        score: any(named: 'score'),
        maxScore: testScenario.maxScore,
      )).called(1);
    });

    test('playQuestionAudio calls audioService with correct dialect', () {
      cubit.playQuestionAudio();

      final expectedDialect = testScenario.isPtPt
          ? PortugueseDialect.european
          : PortugueseDialect.brazilian;

      verify(() => mockAudio.playAudioOrSpeak(
        fallbackText: testScenario.questions.first.questionPt,
        dialect: expectedDialect,
      )).called(1);
    });

    test('restart resets simulator to question 0 with 0 score', () {
      cubit.selectOption(0);
      cubit.nextQuestion();
      expect(cubit.state.currentQuestionIndex, 1);

      cubit.restart();
      expect(cubit.state.currentQuestionIndex, 0);
      expect(cubit.state.totalScore, 0);
      expect(cubit.state.isAnswered, isFalse);
    });
  });
}
