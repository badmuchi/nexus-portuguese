import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/gastronomy/data/datasources/gastronomy_seed_data.dart';
import 'package:nexus_portuguese_app/features/gastronomy/domain/entities/culinary_vocabulary_entity.dart';
import 'package:nexus_portuguese_app/features/gastronomy/domain/repositories/gastronomy_repository.dart';
import 'package:nexus_portuguese_app/features/gastronomy/presentation/cubit/gastronomy_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/gastronomy/presentation/cubit/gastronomy_catalog_state.dart';
import 'package:nexus_portuguese_app/features/gastronomy/presentation/cubit/recipe_cook_cubit.dart';

class MockGastronomyRepository extends Mock implements GastronomyRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('GastronomyCatalogCubit Tests', () {
    late MockGastronomyRepository mockRepo;
    late GastronomyCatalogCubit cubit;
    const testRecipes = GastronomySeedData.recipes;
    const testTerms = GastronomySeedData.culinaryTerms;

    setUp(() {
      mockRepo = MockGastronomyRepository();
      when(() => mockRepo.getRecipes()).thenAnswer((_) async => const Result.ok(testRecipes));
      when(() => mockRepo.getCulinaryTerms()).thenAnswer((_) async => const Result.ok(testTerms));

      cubit = GastronomyCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty data and is not loading', () {
      expect(cubit.state.status, GastronomyCatalogStatus.initial);
      expect(cubit.state.allRecipes, isEmpty);
      expect(cubit.state.allTerms, isEmpty);
      expect(cubit.state.activeTabIndex, 0);
    });

    test('loadCatalog populates recipes and culinary terms', () async {
      await cubit.loadCatalog();

      expect(cubit.state.status, GastronomyCatalogStatus.loaded);
      expect(cubit.state.allRecipes.length, testRecipes.length);
      expect(cubit.state.allTerms.length, testTerms.length);
    });

    test('loadCatalog handles error failure', () async {
      when(() => mockRepo.getRecipes()).thenAnswer(
        (_) async => Result.err(const DatabaseFailure('Ошибка загрузки рецептов')),
      );

      await cubit.loadCatalog();

      expect(cubit.state.status, GastronomyCatalogStatus.error);
      expect(cubit.state.errorMessage, 'Ошибка загрузки рецептов');
    });

    test('filterByDialect updates dialect and filters recipes', () async {
      await cubit.loadCatalog();

      cubit.filterByDialect('BR');
      expect(cubit.state.selectedDialect, 'BR');
      for (final r in cubit.state.filteredRecipes) {
        expect(r.isPtBr, isTrue);
      }

      cubit.filterByDialect('PT');
      expect(cubit.state.selectedDialect, 'PT');
      for (final r in cubit.state.filteredRecipes) {
        expect(r.isPtPt, isTrue);
      }
    });

    test('filterByDifficulty filters recipes by difficulty', () async {
      await cubit.loadCatalog();

      cubit.filterByDifficulty('Fácil');
      expect(cubit.state.selectedDifficulty, 'Fácil');
      for (final r in cubit.state.filteredRecipes) {
        expect(r.difficulty.toLowerCase(), 'fácil');
      }

      cubit.filterByDifficulty(null);
      expect(cubit.state.selectedDifficulty, isNull);
    });

    test('filterByTermType filters terms by culinary type', () async {
      await cubit.loadCatalog();

      cubit.filterByTermType(CulinaryTermType.cookingVerb);
      expect(cubit.state.selectedTermType, CulinaryTermType.cookingVerb);
      for (final t in cubit.state.filteredTerms) {
        expect(t.type, CulinaryTermType.cookingVerb);
      }

      cubit.filterByTermType(null);
      expect(cubit.state.selectedTermType, isNull);
    });

    test('search filters recipes by title or region', () async {
      await cubit.loadCatalog();

      cubit.search('Pastel');
      for (final r in cubit.state.filteredRecipes) {
        final matches = r.titlePt.toLowerCase().contains('pastel') ||
            r.titleRu.toLowerCase().contains('pastel');
        expect(matches, isTrue);
      }

      cubit.search('');
      expect(cubit.state.filteredRecipes.length, testRecipes.length);
    });

    test('setTab updates activeTabIndex', () {
      cubit.setTab(1);
      expect(cubit.state.activeTabIndex, 1);
    });
  });

  group('RecipeCookCubit Tests', () {
    late MockGastronomyRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late RecipeCookCubit cubit;
    final testRecipe = GastronomySeedData.recipes.first;

    setUp(() {
      mockRepo = MockGastronomyRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockRepo.recordRecipeCompleted(
        recipeId: any(named: 'recipeId'),
        timeSpentMinutes: any(named: 'timeSpentMinutes'),
      )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
        fallbackText: any(named: 'fallbackText'),
        dialect: any(named: 'dialect'),
      )).thenAnswer((_) async {});

      cubit = RecipeCookCubit(
        recipe: testRecipe,
        repository: mockRepo,
        audioService: mockAudio,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state starts at step 0 with timer set to step 0 timerSeconds', () {
      expect(cubit.state.currentStepIndex, 0);
      expect(cubit.state.isRecipeCompleted, isFalse);
      expect(cubit.state.isTimerRunning, isFalse);
      expect(cubit.state.remainingTimerSeconds, testRecipe.steps.first.timerSeconds);
    });

    test('toggleIngredient and checkAllIngredients work properly', () {
      final firstId = testRecipe.ingredients.first.id;

      cubit.toggleIngredient(firstId);
      expect(cubit.state.checkedIngredientIds.contains(firstId), isTrue);

      cubit.toggleIngredient(firstId);
      expect(cubit.state.checkedIngredientIds.contains(firstId), isFalse);

      cubit.checkAllIngredients();
      expect(cubit.state.allIngredientsChecked, isTrue);
    });

    test('nextStep advances step and updates timer seconds', () {
      cubit.nextStep();
      expect(cubit.state.currentStepIndex, 1);
      final expectedTimer = testRecipe.steps[1].timerSeconds ?? 0;
      expect(cubit.state.remainingTimerSeconds, expectedTimer);

      cubit.previousStep();
      expect(cubit.state.currentStepIndex, 0);
    });

    test('nextStep on last step marks recipe completed and calls repository', () {
      final totalSteps = testRecipe.steps.length;

      for (var i = 0; i < totalSteps; i++) {
        cubit.nextStep();
      }

      expect(cubit.state.isRecipeCompleted, isTrue);
      verify(() => mockRepo.recordRecipeCompleted(
        recipeId: testRecipe.id,
        timeSpentMinutes: testRecipe.prepTimeMinutes,
      )).called(1);
    });

    test('playStepAudio calls audioService with step instruction', () {
      cubit.playStepAudio();

      final expectedDialect = testRecipe.isPtPt
          ? PortugueseDialect.european
          : PortugueseDialect.brazilian;

      verify(() => mockAudio.playAudioOrSpeak(
        fallbackText: testRecipe.steps.first.instructionPt,
        dialect: expectedDialect,
      )).called(1);
    });

    test('restartCooking resets state to step 0', () {
      cubit.nextStep();
      expect(cubit.state.currentStepIndex, 1);

      cubit.restartCooking();
      expect(cubit.state.currentStepIndex, 0);
      expect(cubit.state.isRecipeCompleted, isFalse);
    });
  });
}
