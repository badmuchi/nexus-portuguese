import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/festas/data/datasources/festas_seed_data.dart';
import 'package:nexus_portuguese_app/features/festas/domain/entities/festas_entities.dart';
import 'package:nexus_portuguese_app/features/festas/domain/repositories/festas_repository.dart';
import 'package:nexus_portuguese_app/features/festas/presentation/cubit/festa_detail_cubit.dart';
import 'package:nexus_portuguese_app/features/festas/presentation/cubit/festa_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/festas/presentation/cubit/festa_quiz_state.dart';
import 'package:nexus_portuguese_app/features/festas/presentation/cubit/festas_catalog_cubit.dart';

class MockFestasRepository extends Mock implements FestasRepository {}

class MockHybridAudioPlaybackService extends Mock
    implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const FestaVocabEntity(
        id: 'fallback_vocab',
        termPt: 'pipoca',
        translationRu: 'пипока',
        definition: 'толпа',
        exampleSentence: 'exemplo',
        dialect: 'all',
      ),
    );
  });

  late MockFestasRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockFestasRepository();
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

  group('FestasCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = FestasCatalogCubit(mockRepo);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.selectedTab, 0);
      cubit.close();
    });

    test('loadData success populates festas and traditions', () async {
      when(() => mockRepo.getFestas())
          .thenAnswer((_) async => Result.ok(FestasSeedData.getFestas()));
      when(() => mockRepo.getFestaTraditions())
          .thenAnswer((_) async => Result.ok(FestasSeedData.getTraditions()));

      final cubit = FestasCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.festas.length, 6);
      expect(cubit.state.traditions.length, 4);
      cubit.close();
    });

    test('loadData error emits error message', () async {
      when(() => mockRepo.getFestas()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load festas')));
      when(() => mockRepo.getFestaTraditions())
          .thenAnswer((_) async => Result.ok(FestasSeedData.getTraditions()));

      final cubit = FestasCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters festas by category, dialect and search', () async {
      when(() => mockRepo.getFestas())
          .thenAnswer((_) async => Result.ok(FestasSeedData.getFestas()));
      when(() => mockRepo.getFestaTraditions())
          .thenAnswer((_) async => Result.ok(FestasSeedData.getTraditions()));

      final cubit = FestasCatalogCubit(mockRepo);
      await cubit.loadData();

      cubit.filterByDialect('pt_PT');
      expect(
        cubit.state.filteredFestas.every((f) => f.isPtPt || f.dialect == 'all'),
        isTrue,
      );

      cubit.filterByDialect('all');
      cubit.filterByCategory(FestaCategory.carnaval);
      expect(
        cubit.state.filteredFestas.every((f) => f.category == FestaCategory.carnaval),
        isTrue,
      );

      cubit.filterByCategory(null);
      expect(cubit.state.selectedCategory, isNull);

      cubit.search('maranhão');
      expect(cubit.state.filteredFestas.length, 1);

      cubit.setTab(1);
      expect(cubit.state.selectedTab, 1);

      cubit.close();
    });
  });

  group('FestaDetailCubit Tests', () {
    late FestaEntity testFesta;

    setUp(() {
      testFesta = FestasSeedData.getFestas().first;

      when(() => mockRepo.recordFestaViewed(any()))
          .thenAnswer((_) async => const Result.ok(null));

      when(
        () => mockRepo.addFestaVocabToSrs(
          any(),
          dialect: any(named: 'dialect'),
        ),
      ).thenAnswer((_) async => const Result.ok(null));
    });

    test('initial state matches festa and records view', () {
      final cubit = FestaDetailCubit(
        festa: testFesta,
        repository: mockRepo,
        audioService: mockAudio,
      );

      expect(cubit.state.festa.id, testFesta.id);
      expect(cubit.state.addedVocabIds, isEmpty);
      verify(() => mockRepo.recordFestaViewed(testFesta.id)).called(1);

      cubit.close();
    });

    test('playAudio and stopAudio control audio service', () async {
      final cubit = FestaDetailCubit(
        festa: testFesta,
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
      final cubit = FestaDetailCubit(
        festa: testFesta,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final vocab = testFesta.vocabulary.first;
      await cubit.addVocabToSrs(vocab);

      expect(cubit.state.addedVocabIds, contains(vocab.id));
      verify(() => mockRepo.addFestaVocabToSrs(
            vocab,
            dialect: testFesta.dialect,
          )).called(1);

      cubit.close();
    });
  });

  group('FestaQuizCubit Tests', () {
    setUp(() {
      when(() => mockRepo.getFestaQuizzes())
          .thenAnswer((_) async => Result.ok(FestasSeedData.getQuizzes()));
    });

    test('loadQuizzes populates quiz questions', () async {
      final cubit = FestaQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      expect(cubit.state.status, FestaQuizStatus.inProgress);
      expect(cubit.state.quizzes.length, 6);
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);

      cubit.close();
    });

    test('selectOption, checkAnswer and nextQuestion progress quiz', () async {
      final cubit = FestaQuizCubit(repository: mockRepo);
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
      final cubit = FestaQuizCubit(repository: mockRepo);
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
