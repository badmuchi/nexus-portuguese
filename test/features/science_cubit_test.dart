import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/science/data/datasources/science_seed_data.dart';
import 'package:nexus_portuguese_app/features/science/domain/entities/science_entities.dart';
import 'package:nexus_portuguese_app/features/science/domain/repositories/science_repository.dart';
import 'package:nexus_portuguese_app/features/science/presentation/cubit/science_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/science/presentation/cubit/science_detail_cubit.dart';
import 'package:nexus_portuguese_app/features/science/presentation/cubit/science_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/science/presentation/cubit/science_quiz_state.dart';

class MockScienceRepository extends Mock implements ScienceRepository {}

class MockHybridAudioPlaybackService extends Mock
    implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ScienceVocabEntity(
        id: 'fallback_sci_vocab',
        termPt: 'Amostragem',
        translationRu: 'Отбор проб',
        definition: 'Coleta padronizada',
        exampleSentence: 'exemplo',
        dialect: 'all',
      ),
    );
  });

  late MockScienceRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockScienceRepository();
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

  group('ScienceCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = ScienceCatalogCubit(mockRepo);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedField, isNull);
      expect(cubit.state.selectedTab, 0);
      cubit.close();
    });

    test('loadData success populates topics and experiments', () async {
      when(() => mockRepo.getScienceTopics())
          .thenAnswer((_) async => Result.ok(ScienceSeedData.getTopics()));
      when(() => mockRepo.getLabExperiments())
          .thenAnswer((_) async => Result.ok(ScienceSeedData.getLabExperiments()));

      final cubit = ScienceCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.topics.length, 6);
      expect(cubit.state.experiments.length, 4);
      cubit.close();
    });

    test('loadData error emits error message', () async {
      when(() => mockRepo.getScienceTopics()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load science topics')));
      when(() => mockRepo.getLabExperiments())
          .thenAnswer((_) async => Result.ok(ScienceSeedData.getLabExperiments()));

      final cubit = ScienceCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters topics by field, dialect and search', () async {
      when(() => mockRepo.getScienceTopics())
          .thenAnswer((_) async => Result.ok(ScienceSeedData.getTopics()));
      when(() => mockRepo.getLabExperiments())
          .thenAnswer((_) async => Result.ok(ScienceSeedData.getLabExperiments()));

      final cubit = ScienceCatalogCubit(mockRepo);
      await cubit.loadData();

      // Filter by Portugal dialect
      cubit.filterByDialect('pt_PT');
      expect(cubit.state.filteredTopics.every((t) => t.isPtPt), isTrue);
      expect(cubit.state.filteredTopics.length, 3);

      // Filter by Field
      cubit.clearFilters();
      cubit.filterByField(ScienceField.oceanografia);
      expect(cubit.state.filteredTopics.every((t) => t.field == ScienceField.oceanografia), isTrue);
      expect(cubit.state.filteredTopics.first.id, 'mar-dos-acores');

      // Search query
      cubit.clearFilters();
      cubit.search('Butantan');
      expect(cubit.state.filteredTopics.length, 1);
      expect(cubit.state.filteredTopics.first.title, contains('Butantan'));

      cubit.close();
    });

    test('setTab updates tab index', () {
      final cubit = ScienceCatalogCubit(mockRepo);
      cubit.setTab(1);
      expect(cubit.state.selectedTab, 1);
      cubit.setTab(2);
      expect(cubit.state.selectedTab, 2);
      cubit.close();
    });
  });

  group('ScienceDetailCubit Tests', () {
    final testTopic = ScienceSeedData.getTopics().first;

    test('initial state and recordTopicViewed called', () {
      when(() => mockRepo.recordTopicViewed(testTopic.id))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = ScienceDetailCubit(
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

      final cubit = ScienceDetailCubit(
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
      when(() => mockRepo.addScienceVocabToSrs(any(), dialect: any(named: 'dialect')))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = ScienceDetailCubit(
        topic: testTopic,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final vocab = testTopic.vocabulary.first;
      await cubit.addVocabToSrs(vocab);

      expect(cubit.state.addedVocabIds.contains(vocab.id), isTrue);
      verify(() => mockRepo.addScienceVocabToSrs(vocab, dialect: testTopic.dialect))
          .called(1);
      cubit.close();
    });
  });

  group('ScienceQuizCubit Tests', () {
    test('initial state has correct default values', () {
      final cubit = ScienceQuizCubit(repository: mockRepo);
      expect(cubit.state.status, ScienceQuizStatus.initial);
      expect(cubit.state.score, 0);
      expect(cubit.state.currentIndex, 0);
      cubit.close();
    });

    test('loadQuizzes populates quiz list and sets status to inProgress', () async {
      when(() => mockRepo.getScienceQuizzes())
          .thenAnswer((_) async => Result.ok(ScienceSeedData.getQuizzes()));

      final cubit = ScienceQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      expect(cubit.state.status, ScienceQuizStatus.inProgress);
      expect(cubit.state.quizzes.length, 6);
      expect(cubit.state.totalQuestions, 6);
      cubit.close();
    });

    test('selectOption, checkAnswer and nextQuestion flow', () async {
      final quizzes = ScienceSeedData.getQuizzes();
      when(() => mockRepo.getScienceQuizzes())
          .thenAnswer((_) async => Result.ok(quizzes));

      final cubit = ScienceQuizCubit(repository: mockRepo);
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
      when(() => mockRepo.getScienceQuizzes())
          .thenAnswer((_) async => Result.ok(ScienceSeedData.getQuizzes()));

      final cubit = ScienceQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();
      cubit.selectOption(0);
      cubit.checkAnswer();

      await cubit.restartQuiz();
      expect(cubit.state.status, ScienceQuizStatus.inProgress);
      expect(cubit.state.score, 0);
      expect(cubit.state.currentIndex, 0);
      cubit.close();
    });
  });
}
