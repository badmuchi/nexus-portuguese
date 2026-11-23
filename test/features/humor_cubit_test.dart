import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/humor/data/datasources/humor_seed_data.dart';
import 'package:nexus_portuguese_app/features/humor/domain/entities/humor_entities.dart';
import 'package:nexus_portuguese_app/features/humor/domain/repositories/humor_repository.dart';
import 'package:nexus_portuguese_app/features/humor/presentation/cubit/humor_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/humor/presentation/cubit/humor_catalog_state.dart';
import 'package:nexus_portuguese_app/features/humor/presentation/cubit/humor_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/humor/presentation/cubit/humor_quiz_state.dart';
import 'package:nexus_portuguese_app/features/humor/presentation/cubit/joke_reader_cubit.dart';

class MockHumorRepository extends Mock implements HumorRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const JokeVocabEntity(
        id: 'fallback_vocab',
        termPt: 'termo',
        translationRu: 'перевод',
        explanationRu: 'объяснение',
      ),
    );
  });

  late MockHumorRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockHumorRepository();
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

  group('HumorCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = HumorCatalogCubit(repository: mockRepo);
      expect(cubit.state.status, HumorCatalogStatus.initial);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedCategory, isNull);
      cubit.close();
    });

    test('loadCatalog success populates jokes and trocadilhos', () async {
      when(() => mockRepo.getJokes())
          .thenAnswer((_) async => Result.ok(HumorSeedData.getJokes()));
      when(() => mockRepo.getTrocadilhos())
          .thenAnswer((_) async => Result.ok(HumorSeedData.getTrocadilhos()));

      final cubit = HumorCatalogCubit(repository: mockRepo);
      await cubit.loadCatalog();

      expect(cubit.state.status, HumorCatalogStatus.loaded);
      expect(cubit.state.allJokes.length, greaterThanOrEqualTo(8));
      expect(cubit.state.allTrocadilhos.length, greaterThanOrEqualTo(6));
      cubit.close();
    });

    test('loadCatalog error emits error status', () async {
      when(() => mockRepo.getJokes())
          .thenAnswer((_) async => Result.err(const DatabaseFailure('Failed to load')));
      when(() => mockRepo.getTrocadilhos())
          .thenAnswer((_) async => Result.ok(HumorSeedData.getTrocadilhos()));

      final cubit = HumorCatalogCubit(repository: mockRepo);
      await cubit.loadCatalog();

      expect(cubit.state.status, HumorCatalogStatus.error);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters jokes by category, dialect and search', () async {
      when(() => mockRepo.getJokes())
          .thenAnswer((_) async => Result.ok(HumorSeedData.getJokes()));
      when(() => mockRepo.getTrocadilhos())
          .thenAnswer((_) async => Result.ok(HumorSeedData.getTrocadilhos()));

      final cubit = HumorCatalogCubit(repository: mockRepo);
      await cubit.loadCatalog();

      cubit.filterByCategory(JokeCategory.boteco);
      expect(cubit.state.filteredJokes.every((j) => j.category == JokeCategory.boteco), isTrue);

      cubit.filterByCategory(null);
      expect(cubit.state.selectedCategory, isNull);

      cubit.filterByDialect('pt_PT');
      expect(cubit.state.filteredJokes.every((j) => j.isPtPt || j.dialect == 'all'), isTrue);

      cubit.filterByDialect('all');
      cubit.search('espelho');
      expect(cubit.state.filteredJokes.length, 1);

      cubit.setTab(1);
      expect(cubit.state.activeTabIndex, 1);

      cubit.close();
    });
  });

  group('JokeReaderCubit Tests', () {
    late JokeEntity testJoke;

    setUp(() {
      testJoke = const JokeEntity(
        id: 'test_joke',
        titlePt: 'Piada Teste',
        titleRu: 'Тестовая шутка',
        setupPt: 'Início...',
        setupRu: 'Начало...',
        punchlinePt: 'Fim!',
        punchlineRu: 'Конец!',
        explanationRu: 'Объяснение',
        category: JokeCategory.boteco,
        dialect: 'pt_BR',
        vocabulary: [
          JokeVocabEntity(
            id: 'v1',
            termPt: 'Palavra',
            translationRu: 'Слово',
            explanationRu: 'Разбор',
          ),
        ],
      );

      when(
        () => mockRepo.recordJokeReaction(
          jokeId: any(named: 'jokeId'),
          liked: any(named: 'liked'),
        ),
      ).thenAnswer((_) async => const Result.ok(null));

      when(
        () => mockRepo.addWordToSrs(
          any(),
          dialect: any(named: 'dialect'),
        ),
      ).thenAnswer((_) async => const Result.ok(null));
    });

    test('revealPunchline and toggleExplanation update flags', () {
      final cubit = JokeReaderCubit(
        joke: testJoke,
        repository: mockRepo,
        audioService: mockAudio,
      );

      expect(cubit.state.isPunchlineRevealed, isFalse);
      cubit.revealPunchline();
      expect(cubit.state.isPunchlineRevealed, isTrue);

      expect(cubit.state.showExplanation, isFalse);
      cubit.toggleExplanation();
      expect(cubit.state.showExplanation, isTrue);

      cubit.close();
    });

    test('rateJoke persists reaction and updates state', () async {
      final cubit = JokeReaderCubit(
        joke: testJoke,
        repository: mockRepo,
        audioService: mockAudio,
      );

      await cubit.rateJoke(true);
      expect(cubit.state.userReaction, isTrue);
      verify(() => mockRepo.recordJokeReaction(jokeId: 'test_joke', liked: true)).called(1);

      cubit.close();
    });

    test('addToSrs adds vocab id to set and calls repository', () async {
      final cubit = JokeReaderCubit(
        joke: testJoke,
        repository: mockRepo,
        audioService: mockAudio,
      );

      await cubit.addToSrs(testJoke.vocabulary.first);
      expect(cubit.state.addedVocabIds, contains('v1'));
      verify(() => mockRepo.addWordToSrs(testJoke.vocabulary.first, dialect: 'pt_BR')).called(1);

      cubit.close();
    });
  });

  group('HumorQuizCubit Tests', () {
    setUp(() {
      when(() => mockRepo.getHumorQuizzes())
          .thenAnswer((_) async => Result.ok(HumorSeedData.getHumorQuizzes()));
    });

    test('loadQuizzes populates quiz questions', () async {
      final cubit = HumorQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      expect(cubit.state.status, HumorQuizStatus.inProgress);
      expect(cubit.state.quizzes.length, greaterThanOrEqualTo(4));
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);

      cubit.close();
    });

    test('selectOption, checkAnswer and nextQuestion progress quiz', () async {
      final cubit = HumorQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      final correctIndex = cubit.state.currentQuiz!.correctOptionIndex;
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

    test('restart resets state to beginning', () async {
      final cubit = HumorQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      cubit.selectOption(0);
      cubit.checkAnswer();
      cubit.nextQuestion();
      expect(cubit.state.currentIndex, 1);

      cubit.restart();
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);
      expect(cubit.state.selectedOption, isNull);

      cubit.close();
    });
  });
}
