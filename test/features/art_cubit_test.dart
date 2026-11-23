import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/art/data/datasources/art_seed_data.dart';
import 'package:nexus_portuguese_app/features/art/domain/entities/art_entities.dart';
import 'package:nexus_portuguese_app/features/art/domain/repositories/art_repository.dart';
import 'package:nexus_portuguese_app/features/art/presentation/cubit/art_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/art/presentation/cubit/art_catalog_state.dart';
import 'package:nexus_portuguese_app/features/art/presentation/cubit/art_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/art/presentation/cubit/art_quiz_state.dart';
import 'package:nexus_portuguese_app/features/art/presentation/cubit/artwork_detail_cubit.dart';

class MockArtRepository extends Mock implements ArtRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ArtVocabEntity(
        id: 'fallback_vocab',
        termPt: 'termo',
        translationRu: 'термин',
        contextRu: 'контекст',
      ),
    );
  });

  late MockArtRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockArtRepository();
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

  group('ArtCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = ArtCatalogCubit(repository: mockRepo);
      expect(cubit.state.status, ArtCatalogStatus.initial);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedPeriod, isNull);
      cubit.close();
    });

    test('loadCatalog success populates artworks and styles', () async {
      when(() => mockRepo.getArtworks())
          .thenAnswer((_) async => Result.ok(ArtSeedData.getArtworks()));
      when(() => mockRepo.getArtStyles())
          .thenAnswer((_) async => Result.ok(ArtSeedData.getArtStyles()));

      final cubit = ArtCatalogCubit(repository: mockRepo);
      await cubit.loadCatalog();

      expect(cubit.state.status, ArtCatalogStatus.loaded);
      expect(cubit.state.allArtworks.length, 6);
      expect(cubit.state.allStyles.length, 4);
      cubit.close();
    });

    test('loadCatalog error emits error status', () async {
      when(() => mockRepo.getArtworks())
          .thenAnswer((_) async => Result.err(const DatabaseFailure('Failed to load')));
      when(() => mockRepo.getArtStyles())
          .thenAnswer((_) async => Result.ok(ArtSeedData.getArtStyles()));

      final cubit = ArtCatalogCubit(repository: mockRepo);
      await cubit.loadCatalog();

      expect(cubit.state.status, ArtCatalogStatus.error);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters artworks by dialect, period and search', () async {
      when(() => mockRepo.getArtworks())
          .thenAnswer((_) async => Result.ok(ArtSeedData.getArtworks()));
      when(() => mockRepo.getArtStyles())
          .thenAnswer((_) async => Result.ok(ArtSeedData.getArtStyles()));

      final cubit = ArtCatalogCubit(repository: mockRepo);
      await cubit.loadCatalog();

      cubit.filterByDialect('pt_PT');
      expect(cubit.state.filteredArtworks.every((a) => a.isPtPt || a.dialect == 'all'), isTrue);

      cubit.filterByDialect('all');
      cubit.filterByPeriod(ArtPeriod.azulejaria);
      expect(cubit.state.filteredArtworks.every((a) => a.period == ArtPeriod.azulejaria), isTrue);

      cubit.filterByPeriod(null);
      expect(cubit.state.selectedPeriod, isNull);

      cubit.search('portinari');
      expect(cubit.state.filteredArtworks.length, 1);

      cubit.setTab(1);
      expect(cubit.state.activeTabIndex, 1);

      cubit.close();
    });
  });

  group('ArtworkDetailCubit Tests', () {
    late ArtworkEntity testArtwork;

    setUp(() {
      testArtwork = ArtSeedData.getArtworks().first;

      when(
        () => mockRepo.recordArtworkViewed(any()),
      ).thenAnswer((_) async => const Result.ok(null));

      when(
        () => mockRepo.addArtVocabToSrs(
          any(),
          dialect: any(named: 'dialect'),
        ),
      ).thenAnswer((_) async => const Result.ok(null));
    });

    test('initial state matches artwork and records view', () {
      final cubit = ArtworkDetailCubit(
        artwork: testArtwork,
        repository: mockRepo,
        audioService: mockAudio,
      );

      expect(cubit.state.artwork.id, testArtwork.id);
      expect(cubit.state.showCuratorNotes, isTrue);
      expect(cubit.state.addedVocabIds, isEmpty);
      verify(() => mockRepo.recordArtworkViewed(testArtwork.id)).called(1);

      cubit.close();
    });

    test('toggleCuratorNotes flips flag', () {
      final cubit = ArtworkDetailCubit(
        artwork: testArtwork,
        repository: mockRepo,
        audioService: mockAudio,
      );

      cubit.toggleCuratorNotes();
      expect(cubit.state.showCuratorNotes, isFalse);

      cubit.toggleCuratorNotes();
      expect(cubit.state.showCuratorNotes, isTrue);

      cubit.close();
    });

    test('playAudio and stopAudio control audio service', () async {
      final cubit = ArtworkDetailCubit(
        artwork: testArtwork,
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
      final cubit = ArtworkDetailCubit(
        artwork: testArtwork,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final vocab = testArtwork.keyVocabulary.first;
      await cubit.addVocabToSrs(vocab);

      expect(cubit.state.addedVocabIds, contains(vocab.id));
      verify(() => mockRepo.addArtVocabToSrs(vocab, dialect: testArtwork.dialect)).called(1);

      cubit.close();
    });
  });

  group('ArtQuizCubit Tests', () {
    setUp(() {
      when(() => mockRepo.getArtQuizzes())
          .thenAnswer((_) async => Result.ok(ArtSeedData.getArtQuizzes()));
    });

    test('loadQuizzes populates quiz questions', () async {
      final cubit = ArtQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      expect(cubit.state.status, ArtQuizStatus.inProgress);
      expect(cubit.state.quizzes.length, 6);
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);

      cubit.close();
    });

    test('selectOption, checkAnswer and nextQuestion progress quiz', () async {
      final cubit = ArtQuizCubit(repository: mockRepo);
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
      final cubit = ArtQuizCubit(repository: mockRepo);
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
