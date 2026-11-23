import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/wine/data/datasources/wine_seed_data.dart';
import 'package:nexus_portuguese_app/features/wine/domain/entities/wine_entities.dart';
import 'package:nexus_portuguese_app/features/wine/domain/repositories/wine_repository.dart';
import 'package:nexus_portuguese_app/features/wine/presentation/cubit/wine_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/wine/presentation/cubit/wine_detail_cubit.dart';
import 'package:nexus_portuguese_app/features/wine/presentation/cubit/wine_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/wine/presentation/cubit/wine_quiz_state.dart';

class MockWineRepository extends Mock implements WineRepository {}

class MockHybridAudioPlaybackService extends Mock
    implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const WineVocabEntity(
        id: 'fallback_wine_vocab',
        termPt: 'Decantar',
        translationRu: 'Декантировать',
        definition: 'Separar o vinho dos sedimentos',
        exampleSentence: 'exemplo',
        dialect: 'all',
      ),
    );
  });

  late MockWineRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockWineRepository();
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

  group('WineCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = WineCatalogCubit(mockRepo);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.selectedTab, 0);
      cubit.close();
    });

    test('loadData success populates regions and tasting guides', () async {
      when(() => mockRepo.getWineRegions())
          .thenAnswer((_) async => Result.ok(WineSeedData.getRegions()));
      when(() => mockRepo.getTastingGuides())
          .thenAnswer((_) async => Result.ok(WineSeedData.getTastingGuides()));

      final cubit = WineCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.regions.length, 6);
      expect(cubit.state.guides.length, 4);
      cubit.close();
    });

    test('loadData error emits error message', () async {
      when(() => mockRepo.getWineRegions()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load regions')));
      when(() => mockRepo.getTastingGuides())
          .thenAnswer((_) async => Result.ok(WineSeedData.getTastingGuides()));

      final cubit = WineCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters regions by category, dialect and search', () async {
      when(() => mockRepo.getWineRegions())
          .thenAnswer((_) async => Result.ok(WineSeedData.getRegions()));
      when(() => mockRepo.getTastingGuides())
          .thenAnswer((_) async => Result.ok(WineSeedData.getTastingGuides()));

      final cubit = WineCatalogCubit(mockRepo);
      await cubit.loadData();

      // Filter category
      cubit.filterByCategory(WineCategory.azeiteVirgemExtra);
      expect(cubit.state.filteredRegions.length, 1);
      expect(cubit.state.filteredRegions.first.id, 'azeite-alentejo');

      // Filter dialect
      cubit.filterByCategory(null);
      cubit.filterByDialect('pt_BR');
      expect(cubit.state.filteredRegions.length, 2);
      expect(
        cubit.state.filteredRegions.every((r) => r.dialect == 'pt_BR'),
        isTrue,
      );

      // Search
      cubit.filterByDialect('all');
      cubit.search('Alvarinho');
      expect(cubit.state.filteredRegions.length, 1);
      expect(cubit.state.filteredRegions.first.id, 'vinho-verde-minho');

      // Clear filters
      cubit.clearFilters();
      expect(cubit.state.filteredRegions.length, 6);
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.searchQuery, '');

      // Tab
      cubit.setTab(1);
      expect(cubit.state.selectedTab, 1);

      cubit.close();
    });
  });

  group('WineDetailCubit Tests', () {
    late WineRegionEntity sampleRegion;

    setUp(() {
      sampleRegion = WineSeedData.getRegions().first;
      when(() => mockRepo.recordRegionViewed(any()))
          .thenAnswer((_) async => const Result.ok(null));
    });

    test('playAudio speaks audioNarration and updates state', () async {
      final cubit = WineDetailCubit(
        region: sampleRegion,
        repository: mockRepo,
        audioService: mockAudio,
      );

      expect(cubit.state.isPlayingAudio, isFalse);

      await cubit.playAudio();

      verify(
        () => mockAudio.playAudioOrSpeak(
          fallbackText: any(named: 'fallbackText'),
          dialect: any(named: 'dialect'),
          rate: any(named: 'rate'),
        ),
      ).called(1);

      await cubit.stopAudio();
      expect(cubit.state.isPlayingAudio, isFalse);
      verify(() => mockAudio.stop()).called(1);

      cubit.close();
    });

    test('addVocabToSrs updates addedVocabIds and calls repo', () async {
      when(() => mockRepo.addWineVocabToSrs(any(), dialect: any(named: 'dialect')))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = WineDetailCubit(
        region: sampleRegion,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final vocab = sampleRegion.vocabulary.first;
      await cubit.addVocabToSrs(vocab);

      expect(cubit.state.addedVocabIds.contains(vocab.id), isTrue);
      verify(() => mockRepo.addWineVocabToSrs(vocab, dialect: sampleRegion.dialect))
          .called(1);

      cubit.close();
    });
  });

  group('WineQuizCubit Tests', () {
    test('full quiz workflow works correctly', () async {
      final quizzes = WineSeedData.getQuizzes();
      when(() => mockRepo.getWineQuizzes())
          .thenAnswer((_) async => Result.ok(quizzes));

      final cubit = WineQuizCubit(repository: mockRepo);

      await cubit.loadQuizzes();
      expect(cubit.state.status, WineQuizStatus.inProgress);
      expect(cubit.state.quizzes.length, quizzes.length);
      expect(cubit.state.currentIndex, 0);

      // Select right option
      final correctOption = quizzes[0].correctIndex;
      cubit.selectOption(correctOption);
      expect(cubit.state.selectedOption, correctOption);

      cubit.checkAnswer();
      expect(cubit.state.isAnswerChecked, isTrue);
      expect(cubit.state.score, 1);

      // Next question
      cubit.nextQuestion();
      expect(cubit.state.currentIndex, 1);
      expect(cubit.state.selectedOption, isNull);
      expect(cubit.state.isAnswerChecked, isFalse);

      // Select wrong option
      final wrongOption = (quizzes[1].correctIndex + 1) % 4;
      cubit.selectOption(wrongOption);
      cubit.checkAnswer();
      expect(cubit.state.score, 1); // score didn't change

      // Restart
      await cubit.restartQuiz();
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);
      expect(cubit.state.selectedOption, isNull);

      cubit.close();
    });
  });
}
