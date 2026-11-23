import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/carnival/data/datasources/carnival_seed_data.dart';
import 'package:nexus_portuguese_app/features/carnival/domain/entities/carnival_entities.dart';
import 'package:nexus_portuguese_app/features/carnival/domain/repositories/carnival_repository.dart';
import 'package:nexus_portuguese_app/features/carnival/presentation/cubit/carnival_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/carnival/presentation/cubit/carnival_detail_cubit.dart';
import 'package:nexus_portuguese_app/features/carnival/presentation/cubit/carnival_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/carnival/presentation/cubit/carnival_quiz_state.dart';

class MockCarnivalRepository extends Mock implements CarnivalRepository {}

class MockHybridAudioPlaybackService extends Mock
    implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CarnivalVocabEntity(
        id: 'fallback_carnival_vocab',
        termPt: 'Batuque',
        translationRu: 'Батуке',
        definition: 'Batucada rítmica',
        exampleSentence: 'exemplo',
        dialect: 'all',
      ),
    );
  });

  late MockCarnivalRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockCarnivalRepository();
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

  group('CarnivalCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = CarnivalCatalogCubit(mockRepo);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.selectedTab, 0);
      cubit.close();
    });

    test('loadData success populates traditions and workshops', () async {
      when(() => mockRepo.getTraditions())
          .thenAnswer((_) async => Result.ok(CarnivalSeedData.getTraditions()));
      when(() => mockRepo.getRhythmWorkshops())
          .thenAnswer((_) async => Result.ok(CarnivalSeedData.getRhythmWorkshops()));

      final cubit = CarnivalCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.traditions.length, 6);
      expect(cubit.state.workshops.length, 4);
      cubit.close();
    });

    test('loadData error emits error message', () async {
      when(() => mockRepo.getTraditions()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load traditions')));
      when(() => mockRepo.getRhythmWorkshops())
          .thenAnswer((_) async => Result.ok(CarnivalSeedData.getRhythmWorkshops()));

      final cubit = CarnivalCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters traditions by category, dialect and search', () async {
      when(() => mockRepo.getTraditions())
          .thenAnswer((_) async => Result.ok(CarnivalSeedData.getTraditions()));
      when(() => mockRepo.getRhythmWorkshops())
          .thenAnswer((_) async => Result.ok(CarnivalSeedData.getRhythmWorkshops()));

      final cubit = CarnivalCatalogCubit(mockRepo);
      await cubit.loadData();

      // Filter category
      cubit.filterByCategory(CarnivalTraditionCategory.maracatu);
      expect(cubit.state.filteredTraditions.length, 1);
      expect(cubit.state.filteredTraditions.first.id, 'maracatu-baque-virado');

      // Filter dialect
      cubit.filterByCategory(null);
      cubit.filterByDialect('pt_PT');
      expect(cubit.state.filteredTraditions.length, 1);
      expect(cubit.state.filteredTraditions.first.id, 'entrudo-torres-podence');

      // Search
      cubit.filterByDialect('all');
      cubit.search('Sapucaí');
      expect(cubit.state.filteredTraditions.length, 1);
      expect(cubit.state.filteredTraditions.first.id, 'samba-enredo-sapucai');

      // Clear filters
      cubit.clearFilters();
      expect(cubit.state.filteredTraditions.length, 6);
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.searchQuery, '');

      // Tab
      cubit.setTab(1);
      expect(cubit.state.selectedTab, 1);

      cubit.close();
    });
  });

  group('CarnivalDetailCubit Tests', () {
    late CarnivalTraditionEntity sampleTradition;

    setUp(() {
      sampleTradition = CarnivalSeedData.getTraditions().first;
      when(() => mockRepo.recordTraditionViewed(any()))
          .thenAnswer((_) async => const Result.ok(null));
    });

    test('playAudio speaks audioNarration and updates state', () async {
      final cubit = CarnivalDetailCubit(
        tradition: sampleTradition,
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
      when(() => mockRepo.addCarnivalVocabToSrs(any(), dialect: any(named: 'dialect')))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = CarnivalDetailCubit(
        tradition: sampleTradition,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final vocab = sampleTradition.vocabulary.first;
      await cubit.addVocabToSrs(vocab);

      expect(cubit.state.addedVocabIds.contains(vocab.id), isTrue);
      verify(() => mockRepo.addCarnivalVocabToSrs(vocab, dialect: sampleTradition.dialect))
          .called(1);

      cubit.close();
    });
  });

  group('CarnivalQuizCubit Tests', () {
    test('full quiz workflow works correctly', () async {
      final quizzes = CarnivalSeedData.getQuizzes();
      when(() => mockRepo.getCarnivalQuizzes())
          .thenAnswer((_) async => Result.ok(quizzes));

      final cubit = CarnivalQuizCubit(repository: mockRepo);

      await cubit.loadQuizzes();
      expect(cubit.state.status, CarnivalQuizStatus.inProgress);
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
