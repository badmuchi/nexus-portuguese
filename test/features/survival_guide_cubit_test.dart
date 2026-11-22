import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/survival_guide/data/datasources/survival_guide_seed_data.dart';
import 'package:nexus_portuguese_app/features/survival_guide/domain/entities/survival_phrase_entity.dart';
import 'package:nexus_portuguese_app/features/survival_guide/domain/repositories/survival_guide_repository.dart';
import 'package:nexus_portuguese_app/features/survival_guide/presentation/cubit/survival_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/survival_guide/presentation/cubit/survival_quest_cubit.dart';

class MockSurvivalGuideRepository extends Mock implements SurvivalGuideRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('SurvivalCatalogCubit Tests', () {
    late MockSurvivalGuideRepository mockRepo;
    late SurvivalCatalogCubit cubit;
    const testQuests = SurvivalGuideSeedData.quests;
    const testPhrases = SurvivalGuideSeedData.phrases;
    const testTips = SurvivalGuideSeedData.tips;

    setUp(() {
      mockRepo = MockSurvivalGuideRepository();
      when(() => mockRepo.getQuests()).thenAnswer((_) async => const Result.ok(testQuests));
      when(() => mockRepo.getPhrases()).thenAnswer((_) async => const Result.ok(testPhrases));
      when(() => mockRepo.getTips()).thenAnswer((_) async => const Result.ok(testTips));

      cubit = SurvivalCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty data and is not loading', () {
      expect(cubit.state.allQuests, isEmpty);
      expect(cubit.state.allPhrases, isEmpty);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.activeTabIndex, 0);
    });

    test('loadCatalog populates quests, phrases and tips', () async {
      await cubit.loadCatalog();
      expect(cubit.state.allQuests.length, testQuests.length);
      expect(cubit.state.allPhrases.length, testPhrases.length);
      expect(cubit.state.allTips.length, testTips.length);
      expect(cubit.state.isLoading, isFalse);
    });

    test('filterByCategory updates category and filtered items', () async {
      await cubit.loadCatalog();
      cubit.filterByCategory(SurvivalCategory.bureaucracy);

      expect(cubit.state.selectedCategory, SurvivalCategory.bureaucracy);
      for (final q in cubit.state.filteredQuests) {
        expect(q.category, SurvivalCategory.bureaucracy);
      }
    });

    test('filterByDialect updates dialect and filtered items', () async {
      await cubit.loadCatalog();
      cubit.filterByDialect('pt_PT');

      expect(cubit.state.selectedDialect, 'pt_PT');
      for (final q in cubit.state.filteredQuests) {
        expect(q.dialect, 'pt_PT');
      }
    });

    test('search filters quests by title or overview', () async {
      await cubit.loadCatalog();
      cubit.search('NIF');

      expect(cubit.state.filteredQuests.length, 1);
      expect(cubit.state.filteredQuests.first.titlePt, contains('NIF'));
    });

    test('setTab switches active tab index', () {
      cubit.setTab(1);
      expect(cubit.state.activeTabIndex, 1);
      cubit.setTab(2);
      expect(cubit.state.activeTabIndex, 2);
    });
  });

  group('SurvivalQuestCubit Tests', () {
    late MockSurvivalGuideRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late SurvivalQuestCubit cubit;
    final testQuest = SurvivalGuideSeedData.quests.first;

    setUp(() {
      mockRepo = MockSurvivalGuideRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockRepo.recordQuestCompleted(
            questId: any(named: 'questId'),
            score: any(named: 'score'),
            totalSteps: any(named: 'totalSteps'),
          )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
            fallbackText: any(named: 'fallbackText'),
            dialect: any(named: 'dialect'),
          )).thenAnswer((_) async {});

      cubit = SurvivalQuestCubit(
        quest: testQuest,
        repository: mockRepo,
        audioService: mockAudio,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has step index 0 and is not answered', () {
      expect(cubit.state.currentStepIndex, 0);
      expect(cubit.state.isAnswered, isFalse);
      expect(cubit.state.score, 0);
      expect(cubit.state.isCompleted, isFalse);
    });

    test('selectOption with optimal choice increases score', () {
      final step = cubit.state.currentStep;
      final optimalIdx = step.options.indexWhere((o) => o.isOptimal);

      cubit.selectOption(optimalIdx);

      expect(cubit.state.isAnswered, isTrue);
      expect(cubit.state.selectedOptionIndex, optimalIdx);
      expect(cubit.state.score, 1);
    });

    test('selectOption with non-optimal choice marks answered without score increase', () {
      final step = cubit.state.currentStep;
      final nonOptimalIdx = step.options.indexWhere((o) => !o.isOptimal);

      if (nonOptimalIdx >= 0) {
        cubit.selectOption(nonOptimalIdx);

        expect(cubit.state.isAnswered, isTrue);
        expect(cubit.state.score, 0);
      }
    });

    test('nextStep advances step or completes quest on final step', () {
      // Step 1
      final step1 = cubit.state.currentStep;
      final opt1 = step1.options.indexWhere((o) => o.isOptimal);
      cubit.selectOption(opt1);
      cubit.nextStep();

      expect(cubit.state.currentStepIndex, 1);
      expect(cubit.state.isAnswered, isFalse);
      expect(cubit.state.selectedOptionIndex, isNull);

      // Remaining steps until completion
      while (!cubit.state.isCompleted) {
        final step = cubit.state.currentStep;
        final opt = step.options.indexWhere((o) => o.isOptimal);
        cubit.selectOption(opt);
        cubit.nextStep();
      }

      expect(cubit.state.isCompleted, isTrue);
      verify(() => mockRepo.recordQuestCompleted(
            questId: testQuest.id,
            score: any(named: 'score'),
            totalSteps: testQuest.steps.length,
          )).called(1);
    });

    test('playPromptAudio delegates to audioService', () {
      cubit.playPromptAudio();

      verify(() => mockAudio.playAudioOrSpeak(
            fallbackText: testQuest.steps.first.promptPt,
            dialect: any(named: 'dialect'),
          )).called(1);
    });

    test('restart resets state to beginning', () {
      cubit.selectOption(0);
      cubit.restart();

      expect(cubit.state.currentStepIndex, 0);
      expect(cubit.state.score, 0);
      expect(cubit.state.isAnswered, isFalse);
    });
  });
}
