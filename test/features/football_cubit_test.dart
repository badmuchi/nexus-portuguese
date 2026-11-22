import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/football/data/datasources/football_seed_data.dart';
import 'package:nexus_portuguese_app/features/football/domain/entities/football_entities.dart';
import 'package:nexus_portuguese_app/features/football/domain/repositories/football_repository.dart';
import 'package:nexus_portuguese_app/features/football/presentation/cubit/football_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/football/presentation/cubit/football_catalog_state.dart';
import 'package:nexus_portuguese_app/features/football/presentation/cubit/football_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/football/presentation/cubit/match_simulator_cubit.dart';

class MockFootballRepository extends Mock implements FootballRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('FootballCatalogCubit Tests', () {
    late MockFootballRepository mockRepo;
    late FootballCatalogCubit cubit;
    const testMatches = FootballSeedData.matches;
    const testTerms = FootballSeedData.terms;
    const testChants = FootballSeedData.chants;

    setUp(() {
      mockRepo = MockFootballRepository();
      when(() => mockRepo.getMatches()).thenAnswer((_) async => const Result.ok(testMatches));
      when(() => mockRepo.getFootballTerms()).thenAnswer((_) async => const Result.ok(testTerms));
      when(() => mockRepo.getFanChants()).thenAnswer((_) async => const Result.ok(testChants));

      cubit = FootballCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty data and default index', () {
      expect(cubit.state.status, FootballCatalogStatus.initial);
      expect(cubit.state.allMatches, isEmpty);
      expect(cubit.state.allTerms, isEmpty);
      expect(cubit.state.allChants, isEmpty);
      expect(cubit.state.activeTabIndex, 0);
    });

    test('loadCatalog populates matches, terms, and chants', () async {
      await cubit.loadCatalog();

      expect(cubit.state.status, FootballCatalogStatus.loaded);
      expect(cubit.state.allMatches.length, testMatches.length);
      expect(cubit.state.allTerms.length, testTerms.length);
      expect(cubit.state.allChants.length, testChants.length);
      expect(cubit.state.filteredMatches.length, testMatches.length);
      expect(cubit.state.filteredTerms.length, testTerms.length);
      expect(cubit.state.filteredChants.length, testChants.length);
    });

    test('loadCatalog handles repository error', () async {
      when(() => mockRepo.getMatches()).thenAnswer(
        (_) async => Result.err(const DatabaseFailure('Ошибка загрузки матчей')),
      );

      await cubit.loadCatalog();

      expect(cubit.state.status, FootballCatalogStatus.error);
      expect(cubit.state.errorMessage, 'Ошибка загрузки матчей');
    });

    test('filterByDialect filters matches and chants', () async {
      await cubit.loadCatalog();

      cubit.filterByDialect('BR');
      expect(cubit.state.selectedDialect, 'BR');
      expect(cubit.state.filteredMatches.every((m) => m.isPtBr), isTrue);
      expect(cubit.state.filteredChants.every((c) => c.isPtBr), isTrue);

      cubit.filterByDialect('PT');
      expect(cubit.state.selectedDialect, 'PT');
      expect(cubit.state.filteredMatches.every((m) => m.isPtPt), isTrue);
      expect(cubit.state.filteredChants.every((c) => c.isPtPt), isTrue);

      cubit.filterByDialect('all');
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.filteredMatches.length, testMatches.length);
    });

    test('filterByCategory filters terms by category', () async {
      await cubit.loadCatalog();

      cubit.filterByCategory(FootballTermCategory.positions);
      expect(cubit.state.selectedCategory, FootballTermCategory.positions);
      expect(cubit.state.filteredTerms.every((t) => t.category == FootballTermCategory.positions), isTrue);

      cubit.filterByCategory(null);
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.filteredTerms.length, testTerms.length);
    });

    test('search filters terms and matches by query', () async {
      await cubit.loadCatalog();

      cubit.search('Goleiro');
      expect(cubit.state.filteredTerms.any((t) => t.termPtBr.contains('Goleiro')), isTrue);

      cubit.search('');
      expect(cubit.state.filteredTerms.length, testTerms.length);
    });

    test('setTab switches active tab index', () {
      cubit.setTab(1);
      expect(cubit.state.activeTabIndex, 1);
      cubit.setTab(2);
      expect(cubit.state.activeTabIndex, 2);
    });
  });

  group('MatchSimulatorCubit Tests', () {
    late MockFootballRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late MatchSimulatorCubit cubit;
    final testMatch = FootballSeedData.matches.first; // Fla-Flu

    setUp(() {
      mockRepo = MockFootballRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockRepo.recordMatchPractice(
        matchId: any(named: 'matchId'),
        momentsPracticed: any(named: 'momentsPracticed'),
      )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
        audioPathOrUrl: any(named: 'audioPathOrUrl'),
        fallbackText: any(named: 'fallbackText'),
        dialect: any(named: 'dialect'),
        rate: any(named: 'rate'),
      )).thenAnswer((_) async {});

      when(() => mockAudio.stop()).thenAnswer((_) async {});

      cubit = MatchSimulatorCubit(
        match: testMatch,
        repository: mockRepo,
        audioService: mockAudio,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state starts at moment 0', () {
      expect(cubit.state.match.id, testMatch.id);
      expect(cubit.state.currentMomentIndex, 0);
      expect(cubit.state.isFirstMoment, isTrue);
      expect(cubit.state.isPlayingAudio, isFalse);
      expect(cubit.state.isCompleted, isFalse);
    });

    test('nextMoment and previousMoment navigate through episodes', () {
      expect(cubit.state.currentMomentIndex, 0);

      cubit.nextMoment();
      expect(cubit.state.currentMomentIndex, 1);
      expect(cubit.state.isFirstMoment, isFalse);

      cubit.previousMoment();
      expect(cubit.state.currentMomentIndex, 0);
      expect(cubit.state.isFirstMoment, isTrue);
    });

    test('playCommentary triggers high-energy audio playback', () async {
      await cubit.playCommentary();

      verify(() => mockAudio.playAudioOrSpeak(
        fallbackText: testMatch.moments.first.commentaryPt,
        dialect: any(named: 'dialect'),
        rate: 1.05,
      )).called(1);
    });

    test('nextMoment on last moment finishes match and records practice', () {
      for (int i = 0; i < testMatch.moments.length - 1; i++) {
        cubit.nextMoment();
      }
      expect(cubit.state.isLastMoment, isTrue);

      cubit.nextMoment();

      expect(cubit.state.isCompleted, isTrue);
      verify(() => mockRepo.recordMatchPractice(
        matchId: testMatch.id,
        momentsPracticed: testMatch.moments.length,
      )).called(1);
    });

    test('restart resets match to beginning', () {
      cubit.nextMoment();
      cubit.restart();

      expect(cubit.state.currentMomentIndex, 0);
      expect(cubit.state.isCompleted, isFalse);
    });
  });

  group('FootballQuizCubit Tests', () {
    late MockFootballRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late FootballQuizCubit cubit;
    const testQuestions = FootballSeedData.quizQuestions;

    setUp(() {
      mockRepo = MockFootballRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockRepo.getQuizQuestions()).thenAnswer((_) async => const Result.ok(testQuestions));
      when(() => mockAudio.playAudioOrSpeak(
        fallbackText: any(named: 'fallbackText'),
        dialect: any(named: 'dialect'),
      )).thenAnswer((_) async {});

      cubit = FootballQuizCubit(
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

    test('selectOption checks answer and updates score', () {
      final firstQ = testQuestions.first;
      final correctIdx = firstQ.correctOptionIndex;

      cubit.selectOption(correctIdx);

      expect(cubit.state.selectedOptionIndex, correctIdx);
      expect(cubit.state.isAnswered, isTrue);
      expect(cubit.state.score, 1);
    });

    test('nextQuestion advances and marks completed at end', () {
      for (int i = 0; i < testQuestions.length; i++) {
        cubit.selectOption(testQuestions[i].correctOptionIndex);
        cubit.nextQuestion();
      }

      expect(cubit.state.isCompleted, isTrue);
      expect(cubit.state.score, testQuestions.length);
    });

    test('playQuestionAudio calls audioService', () {
      cubit.playQuestionAudio();

      verify(() => mockAudio.playAudioOrSpeak(
        fallbackText: testQuestions.first.questionPt,
        dialect: any(named: 'dialect'),
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
