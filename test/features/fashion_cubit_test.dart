import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/fashion/data/datasources/fashion_seed_data.dart';
import 'package:nexus_portuguese_app/features/fashion/domain/entities/fashion_entities.dart';
import 'package:nexus_portuguese_app/features/fashion/domain/repositories/fashion_repository.dart';
import 'package:nexus_portuguese_app/features/fashion/presentation/cubit/fashion_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/fashion/presentation/cubit/fashion_detail_cubit.dart';
import 'package:nexus_portuguese_app/features/fashion/presentation/cubit/fashion_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/fashion/presentation/cubit/fashion_quiz_state.dart';

class MockFashionRepository extends Mock implements FashionRepository {}

class MockHybridAudioPlaybackService extends Mock
    implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const FashionVocabEntity(
        id: 'fallback_fsh_vocab',
        termPt: 'Passarela',
        translationRu: 'Подиум',
        definition: 'Palco elevado para desfile',
        exampleSentence: 'exemplo',
        dialect: 'all',
      ),
    );
  });

  late MockFashionRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockFashionRepository();
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

  group('FashionCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = FashionCatalogCubit(mockRepo);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.selectedTab, 0);
      cubit.close();
    });

    test('loadData success populates topics and crafts', () async {
      when(() => mockRepo.getFashionTopics())
          .thenAnswer((_) async => Result.ok(FashionSeedData.getTopics()));
      when(() => mockRepo.getTextileCrafts())
          .thenAnswer((_) async => Result.ok(FashionSeedData.getTextileCrafts()));

      final cubit = FashionCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.topics.length, 6);
      expect(cubit.state.crafts.length, 4);
      cubit.close();
    });

    test('loadData error emits error message', () async {
      when(() => mockRepo.getFashionTopics()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load topics')));
      when(() => mockRepo.getTextileCrafts())
          .thenAnswer((_) async => Result.ok(FashionSeedData.getTextileCrafts()));

      final cubit = FashionCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters topics by category, dialect and search', () async {
      when(() => mockRepo.getFashionTopics())
          .thenAnswer((_) async => Result.ok(FashionSeedData.getTopics()));
      when(() => mockRepo.getTextileCrafts())
          .thenAnswer((_) async => Result.ok(FashionSeedData.getTextileCrafts()));

      final cubit = FashionCatalogCubit(mockRepo);
      await cubit.loadData();

      // Filter by Portugal dialect
      cubit.filterByDialect('pt_PT');
      expect(cubit.state.filteredTopics.every((t) => t.isPtPt || t.dialect == 'all'), isTrue);

      // Filter by Category
      cubit.clearFilters();
      cubit.filterByCategory(FashionCategory.calcadoCouro);
      expect(cubit.state.filteredTopics.every((t) => t.category == FashionCategory.calcadoCouro), isTrue);
      expect(cubit.state.filteredTopics.first.id, 'calcado-portugues');

      // Search query
      cubit.clearFilters();
      cubit.search('SPFW');
      expect(cubit.state.filteredTopics.length, 1);
      expect(cubit.state.filteredTopics.first.title, contains('São Paulo Fashion Week'));

      cubit.close();
    });

    test('setTab updates tab index', () {
      final cubit = FashionCatalogCubit(mockRepo);
      cubit.setTab(1);
      expect(cubit.state.selectedTab, 1);
      cubit.setTab(2);
      expect(cubit.state.selectedTab, 2);
      cubit.close();
    });
  });

  group('FashionDetailCubit Tests', () {
    final testTopic = FashionSeedData.getTopics().first;

    test('initial state and recordTopicViewed called', () {
      when(() => mockRepo.recordTopicViewed(testTopic.id))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = FashionDetailCubit(
        topic: testTopic,
        repository: mockRepo,
        audioService: mockAudio,
      );

      expect(cubit.state.topic, testTopic);
      expect(cubit.state.isPlayingAudio, isFalse);
      verify(() => mockRepo.recordTopicViewed(testTopic.id)).called(1);
      cubit.close();
    });

    test('playAudio and stopAudio control audio playback', () async {
      when(() => mockRepo.recordTopicViewed(testTopic.id))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = FashionDetailCubit(
        topic: testTopic,
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
      when(() => mockRepo.recordTopicViewed(testTopic.id))
          .thenAnswer((_) async => const Result.ok(null));
      when(() => mockRepo.addFashionVocabToSrs(any(), dialect: any(named: 'dialect')))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = FashionDetailCubit(
        topic: testTopic,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final vocab = testTopic.vocabulary.first;
      await cubit.addVocabToSrs(vocab);

      expect(cubit.state.addedVocabIds.contains(vocab.id), isTrue);
      verify(() => mockRepo.addFashionVocabToSrs(vocab, dialect: testTopic.dialect))
          .called(1);
      cubit.close();
    });
  });

  group('FashionQuizCubit Tests', () {
    test('initial state has correct default values', () {
      final cubit = FashionQuizCubit(repository: mockRepo);
      expect(cubit.state.status, FashionQuizStatus.initial);
      expect(cubit.state.score, 0);
      expect(cubit.state.currentIndex, 0);
      cubit.close();
    });

    test('loadQuizzes populates quiz list and sets status to inProgress', () async {
      when(() => mockRepo.getFashionQuizzes())
          .thenAnswer((_) async => Result.ok(FashionSeedData.getQuizzes()));

      final cubit = FashionQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      expect(cubit.state.status, FashionQuizStatus.inProgress);
      expect(cubit.state.quizzes.length, 6);
      expect(cubit.state.totalQuestions, 6);
      cubit.close();
    });

    test('selectOption, checkAnswer and nextQuestion flow', () async {
      final quizzes = FashionSeedData.getQuizzes();
      when(() => mockRepo.getFashionQuizzes())
          .thenAnswer((_) async => Result.ok(quizzes));

      final cubit = FashionQuizCubit(repository: mockRepo);
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
      when(() => mockRepo.getFashionQuizzes())
          .thenAnswer((_) async => Result.ok(FashionSeedData.getQuizzes()));

      final cubit = FashionQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();
      cubit.selectOption(0);
      cubit.checkAnswer();

      await cubit.restartQuiz();
      expect(cubit.state.status, FashionQuizStatus.inProgress);
      expect(cubit.state.score, 0);
      expect(cubit.state.currentIndex, 0);
      cubit.close();
    });
  });
}
