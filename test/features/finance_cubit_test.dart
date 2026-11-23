import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/finance/data/datasources/finance_seed_data.dart';
import 'package:nexus_portuguese_app/features/finance/domain/entities/finance_entities.dart';
import 'package:nexus_portuguese_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:nexus_portuguese_app/features/finance/presentation/cubit/finance_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/finance/presentation/cubit/finance_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/finance/presentation/cubit/finance_quiz_state.dart';
import 'package:nexus_portuguese_app/features/finance/presentation/cubit/finance_topic_detail_cubit.dart';

class MockFinanceRepository extends Mock implements FinanceRepository {}

class MockHybridAudioPlaybackService extends Mock
    implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const FinanceVocabEntity(
        id: 'fallback_vocab',
        termPt: 'chave',
        translationRu: 'ключ',
        definition: 'identificador',
        exampleSentence: 'exemplo',
        dialect: 'all',
      ),
    );
  });

  late MockFinanceRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockFinanceRepository();
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

  group('FinanceCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = FinanceCatalogCubit(mockRepo);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.selectedTab, 0);
      cubit.close();
    });

    test('loadData success populates topics and simulators', () async {
      when(() => mockRepo.getFinanceTopics())
          .thenAnswer((_) async => Result.ok(FinanceSeedData.getTopics()));
      when(() => mockRepo.getFintechSimulators())
          .thenAnswer((_) async => Result.ok(FinanceSeedData.getSimulators()));

      final cubit = FinanceCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.topics.length, 6);
      expect(cubit.state.simulators.length, 4);
      cubit.close();
    });

    test('loadData error emits error message', () async {
      when(() => mockRepo.getFinanceTopics()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load topics')));
      when(() => mockRepo.getFintechSimulators())
          .thenAnswer((_) async => Result.ok(FinanceSeedData.getSimulators()));

      final cubit = FinanceCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters topics by category, dialect and search', () async {
      when(() => mockRepo.getFinanceTopics())
          .thenAnswer((_) async => Result.ok(FinanceSeedData.getTopics()));
      when(() => mockRepo.getFintechSimulators())
          .thenAnswer((_) async => Result.ok(FinanceSeedData.getSimulators()));

      final cubit = FinanceCatalogCubit(mockRepo);
      await cubit.loadData();

      cubit.filterByDialect('pt_PT');
      expect(
        cubit.state.filteredTopics.every((t) => t.isPtPt || t.dialect == 'all'),
        isTrue,
      );

      cubit.filterByDialect('all');
      cubit.filterByCategory(FinanceCategory.fintech);
      expect(
        cubit.state.filteredTopics.every((t) => t.category == FinanceCategory.fintech),
        isTrue,
      );

      cubit.filterByCategory(null);
      expect(cubit.state.selectedCategory, isNull);

      cubit.search('faria lima');
      expect(cubit.state.filteredTopics.length, 1);

      cubit.setTab(1);
      expect(cubit.state.selectedTab, 1);

      cubit.close();
    });
  });

  group('FinanceTopicDetailCubit Tests', () {
    late FinanceTopicEntity testTopic;

    setUp(() {
      testTopic = FinanceSeedData.getTopics().first;

      when(() => mockRepo.recordTopicViewed(any()))
          .thenAnswer((_) async => const Result.ok(null));

      when(
        () => mockRepo.addFinanceVocabToSrs(
          any(),
          dialect: any(named: 'dialect'),
        ),
      ).thenAnswer((_) async => const Result.ok(null));
    });

    test('initial state matches topic and records view', () {
      final cubit = FinanceTopicDetailCubit(
        topic: testTopic,
        repository: mockRepo,
        audioService: mockAudio,
      );

      expect(cubit.state.topic.id, testTopic.id);
      expect(cubit.state.addedVocabIds, isEmpty);
      verify(() => mockRepo.recordTopicViewed(testTopic.id)).called(1);

      cubit.close();
    });

    test('playAudio and stopAudio control audio service', () async {
      final cubit = FinanceTopicDetailCubit(
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

      cubit.close();
    });

    test('addVocabToSrs adds id to set and calls repository', () async {
      final cubit = FinanceTopicDetailCubit(
        topic: testTopic,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final vocab = testTopic.vocabulary.first;
      await cubit.addVocabToSrs(vocab);

      expect(cubit.state.addedVocabIds, contains(vocab.id));
      verify(() => mockRepo.addFinanceVocabToSrs(
            vocab,
            dialect: testTopic.dialect,
          )).called(1);

      cubit.close();
    });
  });

  group('FinanceQuizCubit Tests', () {
    setUp(() {
      when(() => mockRepo.getFinanceQuizzes())
          .thenAnswer((_) async => Result.ok(FinanceSeedData.getQuizzes()));
    });

    test('loadQuizzes populates quiz questions', () async {
      final cubit = FinanceQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      expect(cubit.state.status, FinanceQuizStatus.inProgress);
      expect(cubit.state.quizzes.length, 6);
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);

      cubit.close();
    });

    test('selectOption, checkAnswer and nextQuestion progress quiz', () async {
      final cubit = FinanceQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      final correctIndex = cubit.state.currentQuiz!.correctIndex;
      cubit.selectOption(correctIndex);
      expect(cubit.state.selectedOption, correctIndex);

      cubit.checkAnswer();
      expect(cubit.state.isAnswerChecked, isTrue);
      expect(cubit.state.score, 1);
      expect(cubit.state.isCorrect, isTrue);

      cubit.nextQuestion();
      expect(cubit.state.currentIndex, 1);
      expect(cubit.state.selectedOption, isNull);
      expect(cubit.state.isAnswerChecked, isFalse);

      cubit.close();
    });

    test('restartQuiz resets state to beginning', () async {
      final cubit = FinanceQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      cubit.selectOption(0);
      cubit.checkAnswer();
      cubit.nextQuestion();
      expect(cubit.state.currentIndex, 1);

      cubit.restartQuiz();
      // wait for reload
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);
      expect(cubit.state.selectedOption, isNull);

      cubit.close();
    });
  });
}
