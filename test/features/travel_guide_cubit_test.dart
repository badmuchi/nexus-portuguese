import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/travel_guide/data/datasources/travel_guide_seed_data.dart';
import 'package:nexus_portuguese_app/features/travel_guide/domain/entities/travel_phrase_entity.dart';
import 'package:nexus_portuguese_app/features/travel_guide/domain/repositories/travel_guide_repository.dart';
import 'package:nexus_portuguese_app/features/travel_guide/presentation/cubit/geography_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/travel_guide/presentation/cubit/travel_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/travel_guide/presentation/cubit/travel_catalog_state.dart';

class MockTravelGuideRepository extends Mock implements TravelGuideRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('TravelCatalogCubit Tests', () {
    late MockTravelGuideRepository mockRepo;
    late TravelCatalogCubit cubit;
    const testCountries = TravelGuideSeedData.countries;
    const testPhrases = TravelGuideSeedData.travelPhrases;

    setUp(() {
      mockRepo = MockTravelGuideRepository();
      when(() => mockRepo.getCountries()).thenAnswer((_) async => const Result.ok(testCountries));
      when(() => mockRepo.getTravelPhrases()).thenAnswer((_) async => const Result.ok(testPhrases));

      cubit = TravelCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty data and default index', () {
      expect(cubit.state.status, TravelCatalogStatus.initial);
      expect(cubit.state.allCountries, isEmpty);
      expect(cubit.state.allPhrases, isEmpty);
      expect(cubit.state.activeTabIndex, 0);
    });

    test('loadCatalog populates countries and phrases', () async {
      await cubit.loadCatalog();

      expect(cubit.state.status, TravelCatalogStatus.loaded);
      expect(cubit.state.allCountries.length, testCountries.length);
      expect(cubit.state.allPhrases.length, testPhrases.length);
      expect(cubit.state.filteredCountries.length, testCountries.length);
      expect(cubit.state.filteredPhrases.length, testPhrases.length);
    });

    test('loadCatalog handles repository error', () async {
      when(() => mockRepo.getCountries()).thenAnswer(
        (_) async => Result.err(const DatabaseFailure('Ошибка загрузки атласа')),
      );

      await cubit.loadCatalog();

      expect(cubit.state.status, TravelCatalogStatus.error);
      expect(cubit.state.errorMessage, 'Ошибка загрузки атласа');
    });

    test('filterByContinent filters countries appropriately', () async {
      await cubit.loadCatalog();

      cubit.filterByContinent('Европа');
      expect(cubit.state.selectedContinent, 'Европа');
      expect(cubit.state.filteredCountries.every((c) => c.continentRu == 'Европа'), isTrue);

      cubit.filterByContinent('Африка');
      expect(cubit.state.selectedContinent, 'Африка');
      expect(cubit.state.filteredCountries.every((c) => c.continentRu.contains('Африка')), isTrue);

      cubit.filterByContinent(null);
      expect(cubit.state.selectedContinent, isNull);
      expect(cubit.state.filteredCountries.length, testCountries.length);
    });

    test('filterByPhraseCategory filters travel phrases', () async {
      await cubit.loadCatalog();

      cubit.filterByPhraseCategory(TravelPhraseCategory.airportCustoms);
      expect(cubit.state.selectedPhraseCategory, TravelPhraseCategory.airportCustoms);
      expect(cubit.state.filteredPhrases.every((p) => p.category == TravelPhraseCategory.airportCustoms), isTrue);

      cubit.filterByPhraseCategory(null);
      expect(cubit.state.selectedPhraseCategory, isNull);
      expect(cubit.state.filteredPhrases.length, testPhrases.length);
    });

    test('filterByDialect filters phrases by BR/PT', () async {
      await cubit.loadCatalog();

      cubit.filterByDialect('BR');
      expect(cubit.state.selectedDialect, 'BR');
      expect(cubit.state.filteredPhrases.every((p) => p.isPtBr || (!p.isPtPt && !p.isPtBr)), isTrue);

      cubit.filterByDialect('PT');
      expect(cubit.state.selectedDialect, 'PT');
      expect(cubit.state.filteredPhrases.every((p) => p.isPtPt || (!p.isPtPt && !p.isPtBr)), isTrue);

      cubit.filterByDialect('all');
      expect(cubit.state.selectedDialect, 'all');
    });

    test('search filters countries by name and phrases by text', () async {
      await cubit.loadCatalog();

      cubit.search('Brasil');
      expect(cubit.state.filteredCountries.length, 1);
      expect(cubit.state.filteredCountries.first.namePt, 'Brasil');

      cubit.search('');
      expect(cubit.state.filteredCountries.length, testCountries.length);
    });

    test('setTab switches active tab index', () {
      cubit.setTab(1);
      expect(cubit.state.activeTabIndex, 1);
      cubit.setTab(0);
      expect(cubit.state.activeTabIndex, 0);
    });
  });

  group('GeographyQuizCubit Tests', () {
    late MockTravelGuideRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late GeographyQuizCubit cubit;
    const testQuestions = TravelGuideSeedData.quizQuestions;

    setUp(() {
      mockRepo = MockTravelGuideRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockRepo.getQuizQuestions()).thenAnswer((_) async => const Result.ok(testQuestions));
      when(() => mockRepo.recordQuizCompleted(
        score: any(named: 'score'),
        totalQuestions: any(named: 'totalQuestions'),
        earnedCountryIds: any(named: 'earnedCountryIds'),
      )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
        audioPathOrUrl: any(named: 'audioPathOrUrl'),
        fallbackText: any(named: 'fallbackText'),
      )).thenAnswer((_) async {});

      cubit = GeographyQuizCubit(
        repository: mockRepo,
        audioService: mockAudio,
        initialQuestions: testQuestions,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has questions and score 0', () {
      expect(cubit.state.questions.length, testQuestions.length);
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);
      expect(cubit.state.isAnswered, isFalse);
    });

    test('loadQuestions loads quiz questions from repository', () async {
      await cubit.loadQuestions();

      expect(cubit.state.questions.length, testQuestions.length);
      expect(cubit.state.currentIndex, 0);
    });

    test('selectOption checks correctness and updates score', () {
      final firstQ = testQuestions.first;
      final correctIdx = firstQ.correctOptionIndex;

      cubit.selectOption(correctIdx);

      expect(cubit.state.selectedOptionIndex, correctIdx);
      expect(cubit.state.isAnswered, isTrue);
      expect(cubit.state.score, 1);
      expect(cubit.state.earnedCountryIds.contains(firstQ.countryId), isTrue);
    });

    test('nextQuestion steps forward and completes at the end', () {
      // Answer all questions
      for (int i = 0; i < testQuestions.length; i++) {
        cubit.selectOption(testQuestions[i].correctOptionIndex);
        cubit.nextQuestion();
      }

      expect(cubit.state.isCompleted, isTrue);
      expect(cubit.state.score, testQuestions.length);
      verify(() => mockRepo.recordQuizCompleted(
        score: testQuestions.length,
        totalQuestions: testQuestions.length,
        earnedCountryIds: any(named: 'earnedCountryIds'),
      )).called(1);
    });

    test('playQuestionAudio calls audioService playAudioOrSpeak', () {
      cubit.playQuestionAudio();

      verify(() => mockAudio.playAudioOrSpeak(
        fallbackText: testQuestions.first.questionPt,
      )).called(1);
    });

    test('restart resets state to beginning', () {
      cubit.selectOption(testQuestions.first.correctOptionIndex);
      cubit.nextQuestion();

      cubit.restart();

      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);
      expect(cubit.state.isAnswered, isFalse);
      expect(cubit.state.isCompleted, isFalse);
      expect(cubit.state.selectedOptionIndex, isNull);
    });
  });
}
