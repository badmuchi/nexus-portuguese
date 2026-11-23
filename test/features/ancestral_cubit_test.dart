import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/ancestral/data/datasources/ancestral_seed_data.dart';
import 'package:nexus_portuguese_app/features/ancestral/domain/entities/ancestral_entities.dart';
import 'package:nexus_portuguese_app/features/ancestral/domain/repositories/ancestral_repository.dart';
import 'package:nexus_portuguese_app/features/ancestral/presentation/cubit/ancestral_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/ancestral/presentation/cubit/ancestral_detail_cubit.dart';
import 'package:nexus_portuguese_app/features/ancestral/presentation/cubit/ancestral_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/ancestral/presentation/cubit/ancestral_quiz_state.dart';

class MockAncestralRepository extends Mock implements AncestralRepository {}

class MockHybridAudioPlaybackService extends Mock
    implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const AncestralVocabEntity(
        id: 'fallback_ancestral_vocab',
        termPt: 'Aboio',
        translationRu: 'Песня пастуха',
        definition: 'Canto de vaqueiro',
        exampleSentence: 'exemplo',
        dialect: 'all',
      ),
    );
  });

  late MockAncestralRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockAncestralRepository();
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

  group('AncestralCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = AncestralCatalogCubit(mockRepo);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.selectedTab, 0);
      cubit.close();
    });

    test('loadData success populates communities and remedies', () async {
      when(() => mockRepo.getCommunities())
          .thenAnswer((_) async => Result.ok(AncestralSeedData.getCommunities()));
      when(() => mockRepo.getHerbalRemedies())
          .thenAnswer((_) async => Result.ok(AncestralSeedData.getHerbalRemedies()));

      final cubit = AncestralCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.communities.length, 6);
      expect(cubit.state.remedies.length, 4);
      cubit.close();
    });

    test('loadData error emits error message', () async {
      when(() => mockRepo.getCommunities()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load communities')));
      when(() => mockRepo.getHerbalRemedies())
          .thenAnswer((_) async => Result.ok(AncestralSeedData.getHerbalRemedies()));

      final cubit = AncestralCatalogCubit(mockRepo);
      await cubit.loadData();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters communities by category, dialect and search', () async {
      when(() => mockRepo.getCommunities())
          .thenAnswer((_) async => Result.ok(AncestralSeedData.getCommunities()));
      when(() => mockRepo.getHerbalRemedies())
          .thenAnswer((_) async => Result.ok(AncestralSeedData.getHerbalRemedies()));

      final cubit = AncestralCatalogCubit(mockRepo);
      await cubit.loadData();

      // Filter category
      cubit.filterByCategory(CommunityCategory.caicaras);
      expect(cubit.state.filteredCommunities.length, 1);
      expect(cubit.state.filteredCommunities.first.id, 'caicaras-litoral');

      // Filter dialect
      cubit.filterByCategory(null);
      cubit.filterByDialect('pt_PT');
      expect(cubit.state.filteredCommunities.length, 2);
      expect(
        cubit.state.filteredCommunities.every((c) => c.dialect == 'pt_PT'),
        isTrue,
      );

      // Search
      cubit.filterByDialect('all');
      cubit.search('Transumância');
      expect(cubit.state.filteredCommunities.length, 1);
      expect(cubit.state.filteredCommunities.first.id, 'pastores-serra-estrela');

      // Clear filters
      cubit.clearFilters();
      expect(cubit.state.filteredCommunities.length, 6);
      expect(cubit.state.selectedCategory, isNull);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.searchQuery, '');

      // Tab
      cubit.setTab(1);
      expect(cubit.state.selectedTab, 1);

      cubit.close();
    });
  });

  group('AncestralDetailCubit Tests', () {
    late TraditionalCommunityEntity sampleCommunity;

    setUp(() {
      sampleCommunity = AncestralSeedData.getCommunities().first;
      when(() => mockRepo.recordCommunityViewed(any()))
          .thenAnswer((_) async => const Result.ok(null));
    });

    test('playAudio speaks audioNarration and updates state', () async {
      final cubit = AncestralDetailCubit(
        community: sampleCommunity,
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
      when(() => mockRepo.addAncestralVocabToSrs(any(), dialect: any(named: 'dialect')))
          .thenAnswer((_) async => const Result.ok(null));

      final cubit = AncestralDetailCubit(
        community: sampleCommunity,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final vocab = sampleCommunity.vocabulary.first;
      await cubit.addVocabToSrs(vocab);

      expect(cubit.state.addedVocabIds.contains(vocab.id), isTrue);
      verify(() => mockRepo.addAncestralVocabToSrs(vocab, dialect: sampleCommunity.dialect))
          .called(1);

      cubit.close();
    });
  });

  group('AncestralQuizCubit Tests', () {
    test('full quiz workflow works correctly', () async {
      final quizzes = AncestralSeedData.getQuizzes();
      when(() => mockRepo.getAncestralQuizzes())
          .thenAnswer((_) async => Result.ok(quizzes));

      final cubit = AncestralQuizCubit(repository: mockRepo);

      await cubit.loadQuizzes();
      expect(cubit.state.status, AncestralQuizStatus.inProgress);
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
