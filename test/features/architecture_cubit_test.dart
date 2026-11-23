import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/architecture/data/datasources/architecture_seed_data.dart';
import 'package:nexus_portuguese_app/features/architecture/domain/entities/architecture_entities.dart';
import 'package:nexus_portuguese_app/features/architecture/domain/repositories/architecture_repository.dart';
import 'package:nexus_portuguese_app/features/architecture/presentation/cubit/architecture_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/architecture/presentation/cubit/architecture_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/architecture/presentation/cubit/architecture_quiz_state.dart';
import 'package:nexus_portuguese_app/features/architecture/presentation/cubit/monument_detail_cubit.dart';

class MockArchitectureRepository extends Mock implements ArchitectureRepository {}

class MockHybridAudioPlaybackService extends Mock
    implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ArchitectVocabEntity(
        id: 'fallback_vocab',
        termPt: 'concreto',
        translationRu: 'железобетон',
        definition: 'определение',
        exampleSentence: 'пример',
        dialect: 'all',
      ),
    );
  });

  late MockArchitectureRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockArchitectureRepository();
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

  group('ArchitectureCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = ArchitectureCatalogCubit(mockRepo);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.selectedTab, 0);
      cubit.close();
    });

    test('loadData success populates monuments and styles', () async {
      when(() => mockRepo.getMonuments())
          .thenAnswer((_) async => Result.ok(ArchitectureSeedData.getMonuments()));
      when(() => mockRepo.getArchitecturalStyles())
          .thenAnswer((_) async => Result.ok(ArchitectureSeedData.getStyles()));

      final cubit = ArchitectureCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.monuments.length, 6);
      expect(cubit.state.styles.length, 4);
      cubit.close();
    });

    test('loadData error emits error message', () async {
      when(() => mockRepo.getMonuments()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load monuments')));
      when(() => mockRepo.getArchitecturalStyles())
          .thenAnswer((_) async => Result.ok(ArchitectureSeedData.getStyles()));

      final cubit = ArchitectureCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters monuments by category, dialect and search', () async {
      when(() => mockRepo.getMonuments())
          .thenAnswer((_) async => Result.ok(ArchitectureSeedData.getMonuments()));
      when(() => mockRepo.getArchitecturalStyles())
          .thenAnswer((_) async => Result.ok(ArchitectureSeedData.getStyles()));

      final cubit = ArchitectureCatalogCubit(mockRepo);
      await cubit.loadData();

      cubit.filterByDialect('pt_PT');
      expect(
        cubit.state.filteredMonuments
            .every((m) => m.isPtPt || m.dialect == 'all'),
        isTrue,
      );

      cubit.filterByDialect('all');
      cubit.filterByCategory(ArchitectureCategory.modernUrban);
      expect(
        cubit.state.filteredMonuments
            .every((m) => m.category == ArchitectureCategory.modernUrban),
        isTrue,
      );

      cubit.filterByCategory(null);
      expect(cubit.state.selectedCategory, isNull);

      cubit.search('niemeyer');
      expect(cubit.state.filteredMonuments.length, 1);

      cubit.setTab(1);
      expect(cubit.state.selectedTab, 1);

      cubit.close();
    });
  });

  group('MonumentDetailCubit Tests', () {
    late ArchitecturalMonumentEntity testMonument;

    setUp(() {
      testMonument = ArchitectureSeedData.getMonuments().first;

      when(() => mockRepo.recordMonumentViewed(any()))
          .thenAnswer((_) async => const Result.ok(null));

      when(
        () => mockRepo.addArchitectureVocabToSrs(
          any(),
          dialect: any(named: 'dialect'),
        ),
      ).thenAnswer((_) async => const Result.ok(null));
    });

    test('initial state matches monument and records view', () {
      final cubit = MonumentDetailCubit(
        monument: testMonument,
        repository: mockRepo,
        audioService: mockAudio,
      );

      expect(cubit.state.monument.id, testMonument.id);
      expect(cubit.state.showArchitectureDetails, isTrue);
      expect(cubit.state.addedVocabIds, isEmpty);
      verify(() => mockRepo.recordMonumentViewed(testMonument.id)).called(1);

      cubit.close();
    });

    test('toggleArchitectureDetails flips flag', () {
      final cubit = MonumentDetailCubit(
        monument: testMonument,
        repository: mockRepo,
        audioService: mockAudio,
      );

      cubit.toggleArchitectureDetails();
      expect(cubit.state.showArchitectureDetails, isFalse);

      cubit.toggleArchitectureDetails();
      expect(cubit.state.showArchitectureDetails, isTrue);

      cubit.close();
    });

    test('playAudio and stopAudio control audio service', () async {
      final cubit = MonumentDetailCubit(
        monument: testMonument,
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
      final cubit = MonumentDetailCubit(
        monument: testMonument,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final vocab = testMonument.vocabulary.first;
      await cubit.addVocabToSrs(vocab);

      expect(cubit.state.addedVocabIds, contains(vocab.id));
      verify(() => mockRepo.addArchitectureVocabToSrs(
            vocab,
            dialect: testMonument.dialect,
          )).called(1);

      cubit.close();
    });
  });

  group('ArchitectureQuizCubit Tests', () {
    setUp(() {
      when(() => mockRepo.getArchitectureQuizzes())
          .thenAnswer((_) async => Result.ok(ArchitectureSeedData.getQuizzes()));
    });

    test('loadQuizzes populates quiz questions', () async {
      final cubit = ArchitectureQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      expect(cubit.state.status, ArchitectureQuizStatus.inProgress);
      expect(cubit.state.quizzes.length, 6);
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);

      cubit.close();
    });

    test('selectOption, checkAnswer and nextQuestion progress quiz', () async {
      final cubit = ArchitectureQuizCubit(repository: mockRepo);
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
      final cubit = ArchitectureQuizCubit(repository: mockRepo);
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
