import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/folklore/data/datasources/folklore_seed_data.dart';
import 'package:nexus_portuguese_app/features/folklore/domain/entities/folklore_entities.dart';
import 'package:nexus_portuguese_app/features/folklore/domain/repositories/folklore_repository.dart';
import 'package:nexus_portuguese_app/features/folklore/presentation/cubit/folklore_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/folklore/presentation/cubit/folklore_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/folklore/presentation/cubit/folklore_quiz_state.dart';
import 'package:nexus_portuguese_app/features/folklore/presentation/cubit/myth_detail_cubit.dart';

class MockFolkloreRepository extends Mock implements FolkloreRepository {}

class MockHybridAudioPlaybackService extends Mock
    implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const FolkloreVocabEntity(
        id: 'fallback_folk_vocab',
        termPt: 'carapuça',
        translationRu: 'колпак',
        definition: 'Gorro mágico',
        exampleSentence: 'exemplo',
        dialect: 'all',
      ),
    );
  });

  late MockFolkloreRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockFolkloreRepository();
    mockAudio = MockHybridAudioPlaybackService();

    when(() => mockAudio.stop()).thenAnswer((_) async {});
    when(
      () => mockAudio.playAudioOrSpeak(
        fallbackText: any(named: 'fallbackText'),
        audioPathOrUrl: any(named: 'audioPathOrUrl'),
        dialect: any(named: 'dialect'),
        rate: any(named: 'rate'),
      ),
    ).thenAnswer((_) async {});
  });

  group('FolkloreCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = FolkloreCatalogCubit(mockRepo);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedOrigin, isNull);
      expect(cubit.state.selectedTab, 0);
      cubit.close();
    });

    test('loadData success populates myths and snippets', () async {
      when(() => mockRepo.getMyths())
          .thenAnswer((_) async => Result.ok(FolkloreSeedData.getMyths()));
      when(() => mockRepo.getTaleSnippets())
          .thenAnswer((_) async => Result.ok(FolkloreSeedData.getTaleSnippets()));

      final cubit = FolkloreCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.myths.length, 6);
      expect(cubit.state.snippets.length, 4);
      cubit.close();
    });

    test('loadData error emits error message', () async {
      when(() => mockRepo.getMyths()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load myths')));
      when(() => mockRepo.getTaleSnippets())
          .thenAnswer((_) async => Result.ok(FolkloreSeedData.getTaleSnippets()));

      final cubit = FolkloreCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters myths by origin, dialect and search', () async {
      when(() => mockRepo.getMyths())
          .thenAnswer((_) async => Result.ok(FolkloreSeedData.getMyths()));
      when(() => mockRepo.getTaleSnippets())
          .thenAnswer((_) async => Result.ok(FolkloreSeedData.getTaleSnippets()));

      final cubit = FolkloreCatalogCubit(mockRepo);
      await cubit.loadData();

      // Filter by Portugal dialect
      cubit.filterByDialect('pt_PT');
      expect(cubit.state.filteredMyths.every((m) => m.isPtPt), isTrue);
      expect(cubit.state.filteredMyths.length, 1);
      expect(cubit.state.filteredMyths.first.id, 'galo-de-barcelos');

      // Filter by Indigena origin
      cubit.clearFilters();
      cubit.filterByOrigin(FolkloreOrigin.indigena);
      expect(cubit.state.filteredMyths.every((m) => m.origin == FolkloreOrigin.indigena), isTrue);

      // Search query
      cubit.clearFilters();
      cubit.search('Saci');
      expect(cubit.state.filteredMyths.length, 1);
      expect(cubit.state.filteredMyths.first.name, contains('Saci'));

      cubit.close();
    });

    test('setTab updates tab index', () {
      final cubit = FolkloreCatalogCubit(mockRepo);
      cubit.setTab(1);
      expect(cubit.state.selectedTab, 1);
      cubit.setTab(2);
      expect(cubit.state.selectedTab, 2);
      cubit.close();
    });
  });

  group('MythDetailCubit Tests', () {
    final testMyth = FolkloreSeedData.getMyths().first;

    test('initial state and recordMythViewed called', () {
      when(() => mockRepo.recordMythViewed(testMyth.id))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = MythDetailCubit(
        myth: testMyth,
        repository: mockRepo,
        audioService: mockAudio,
      );

      expect(cubit.state.myth, testMyth);
      expect(cubit.state.isPlayingAudio, isFalse);
      verify(() => mockRepo.recordMythViewed(testMyth.id)).called(1);
      cubit.close();
    });

    test('playAudio and stopAudio control audio playback', () async {
      when(() => mockRepo.recordMythViewed(testMyth.id))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = MythDetailCubit(
        myth: testMyth,
        repository: mockRepo,
        audioService: mockAudio,
      );

      await cubit.playAudio();
      verify(() => mockAudio.playAudioOrSpeak(
            fallbackText: any(named: 'fallbackText'),
            dialect: any(named: 'dialect'),
            rate: any(named: 'rate'),
          )).called(1);

      await cubit.stopAudio();
      verify(() => mockAudio.stop()).called(1);
      expect(cubit.state.isPlayingAudio, isFalse);
      cubit.close();
    });

    test('addVocabToSrs adds card and updates addedVocabIds', () async {
      when(() => mockRepo.recordMythViewed(testMyth.id))
          .thenAnswer((_) async => const Result.ok(null));
      when(() => mockRepo.addFolkloreVocabToSrs(any(), dialect: any(named: 'dialect')))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = MythDetailCubit(
        myth: testMyth,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final vocab = testMyth.vocabulary.first;
      await cubit.addVocabToSrs(vocab);

      expect(cubit.state.addedVocabIds.contains(vocab.id), isTrue);
      verify(() => mockRepo.addFolkloreVocabToSrs(vocab, dialect: testMyth.dialect))
          .called(1);
      cubit.close();
    });
  });

  group('FolkloreQuizCubit Tests', () {
    test('initial state has correct default values', () {
      final cubit = FolkloreQuizCubit(repository: mockRepo);
      expect(cubit.state.status, FolkloreQuizStatus.initial);
      expect(cubit.state.score, 0);
      expect(cubit.state.currentIndex, 0);
      cubit.close();
    });

    test('loadQuizzes populates quiz list and sets status to inProgress', () async {
      when(() => mockRepo.getFolkloreQuizzes())
          .thenAnswer((_) async => Result.ok(FolkloreSeedData.getQuizzes()));

      final cubit = FolkloreQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      expect(cubit.state.status, FolkloreQuizStatus.inProgress);
      expect(cubit.state.quizzes.length, 6);
      expect(cubit.state.totalQuestions, 6);
      cubit.close();
    });

    test('selectOption, checkAnswer and nextQuestion flow', () async {
      final quizzes = FolkloreSeedData.getQuizzes();
      when(() => mockRepo.getFolkloreQuizzes())
          .thenAnswer((_) async => Result.ok(quizzes));

      final cubit = FolkloreQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      // Select correct answer
      final correctIdx = quizzes[0].correctIndex;
      cubit.selectOption(correctIdx);
      expect(cubit.state.selectedOption, correctIdx);

      // Check answer
      cubit.checkAnswer();
      expect(cubit.state.isAnswerChecked, isTrue);
      expect(cubit.state.score, 1);

      // Next question
      cubit.nextQuestion();
      expect(cubit.state.currentIndex, 1);
      expect(cubit.state.selectedOption, isNull);
      expect(cubit.state.isAnswerChecked, isFalse);

      cubit.close();
    });

    test('restartQuiz reloads quizzes from beginning', () async {
      when(() => mockRepo.getFolkloreQuizzes())
          .thenAnswer((_) async => Result.ok(FolkloreSeedData.getQuizzes()));

      final cubit = FolkloreQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();
      cubit.selectOption(0);
      cubit.checkAnswer();

      await cubit.restartQuiz();
      expect(cubit.state.status, FolkloreQuizStatus.inProgress);
      expect(cubit.state.score, 0);
      expect(cubit.state.currentIndex, 0);
      cubit.close();
    });
  });
}
