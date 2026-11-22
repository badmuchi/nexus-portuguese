import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/gastronomy/data/datasources/gastronomy_seed_data.dart';
import 'package:nexus_portuguese_app/features/gastronomy/data/repositories/gastronomy_repository_impl.dart';
import 'package:nexus_portuguese_app/features/gastronomy/domain/entities/culinary_vocabulary_entity.dart';
import 'package:nexus_portuguese_app/features/gastronomy/domain/entities/recipe_entity.dart';

void main() {
  group('Gastronomy Entities Tests', () {
    test('RecipeEntity dialect helpers detect PT-BR and PT-PT correctly', () {
      const ptRecipe = RecipeEntity(
        id: 'test_pt',
        titlePt: 'Pastel de Nata',
        titleRu: 'Паштел де Ната',
        region: 'Lisboa',
        dialect: 'pt_PT',
        difficulty: 'Médio',
        prepTimeMinutes: 35,
        servings: 12,
        iconEmoji: '🥧',
        culturalStoryRu: 'История десерта',
        secretTipRu: 'Секрет шефа',
        ingredients: [],
        steps: [],
      );

      expect(ptRecipe.isPtPt, isTrue);
      expect(ptRecipe.isPtBr, isFalse);
      expect(ptRecipe.dialectFlag, '🇵🇹');
      expect(ptRecipe.dialectLabel, 'Portugal');

      const brRecipe = RecipeEntity(
        id: 'test_br',
        titlePt: 'Pão de Queijo',
        titleRu: 'Сырный хлеб',
        region: 'Minas Gerais',
        dialect: 'pt_BR',
        difficulty: 'Fácil',
        prepTimeMinutes: 40,
        servings: 20,
        iconEmoji: '🧀',
        culturalStoryRu: 'История хлеба',
        secretTipRu: 'Секрет шефа',
        ingredients: [],
        steps: [],
      );

      expect(brRecipe.isPtBr, isTrue);
      expect(brRecipe.isPtPt, isFalse);
      expect(brRecipe.dialectFlag, '🇧🇷');
      expect(brRecipe.dialectLabel, 'Brasil');
    });

    test('RecipeIngredient and RecipeStepEntity properties', () {
      const ing = RecipeIngredient(
        id: 'ing_1',
        namePt: 'Massa folhada',
        nameRu: 'Слоеное тесто',
        amount: '300g',
        dialectNoteRu: 'Тесто слоеное',
      );

      expect(ing.namePt, 'Massa folhada');
      expect(ing.amount, '300g');
      expect(ing.isKeyVocabulary, isTrue);

      const step = RecipeStepEntity(
        stepNumber: 1,
        instructionPt: 'Ferva o leite com a casca de limão.',
        instructionRu: 'Вскипятите молоко с цедрой лимона.',
        actionVerbPt: 'Ferver',
        actionVerbRu: 'Кипятить',
        timerSeconds: 300,
      );

      expect(step.stepNumber, 1);
      expect(step.actionVerbPt, 'Ferver');
      expect(step.timerSeconds, 300);
    });

    test('CulinaryTermEntity properties and dialect helpers', () {
      const term = CulinaryTermEntity(
        id: 'term_1',
        termPt: 'Refogar',
        translationRu: 'Пассеровать',
        type: CulinaryTermType.cookingVerb,
        dialect: 'all',
        usageExamplePt: 'Refogue a cebola no azeite.',
        usageExampleRu: 'Обжарьте лук в масле.',
        culturalNoteRu: 'Базовая техника',
      );

      expect(term.type, CulinaryTermType.cookingVerb);
      expect(term.dialectFlag, '🌐');
      expect(term.dialectLabel, 'Geral');
    });
  });

  group('GastronomySeedData Verification Tests', () {
    test('Seed data contains rich recipes with ingredients and steps', () {
      expect(GastronomySeedData.recipes.length, greaterThanOrEqualTo(6));

      final hasPt = GastronomySeedData.recipes.any((r) => r.isPtPt);
      final hasBr = GastronomySeedData.recipes.any((r) => r.isPtBr);
      expect(hasPt, isTrue);
      expect(hasBr, isTrue);

      for (final r in GastronomySeedData.recipes) {
        expect(r.id, isNotEmpty);
        expect(r.titlePt, isNotEmpty);
        expect(r.titleRu, isNotEmpty);
        expect(r.region, isNotEmpty);
        expect(r.culturalStoryRu, isNotEmpty);
        expect(r.secretTipRu, isNotEmpty);
        expect(r.ingredients.length, greaterThanOrEqualTo(4));
        expect(r.steps.length, greaterThanOrEqualTo(4));

        for (final ing in r.ingredients) {
          expect(ing.id, isNotEmpty);
          expect(ing.namePt, isNotEmpty);
          expect(ing.nameRu, isNotEmpty);
          expect(ing.amount, isNotEmpty);
        }

        for (final st in r.steps) {
          expect(st.stepNumber, greaterThan(0));
          expect(st.instructionPt, isNotEmpty);
          expect(st.instructionRu, isNotEmpty);
          expect(st.actionVerbPt, isNotEmpty);
          expect(st.actionVerbRu, isNotEmpty);
        }
      }
    });

    test('Seed data culinaryTerms cover all 4 types and dialect contrasts', () {
      expect(GastronomySeedData.culinaryTerms, isNotEmpty);

      final types = GastronomySeedData.culinaryTerms.map((t) => t.type).toSet();
      expect(types.contains(CulinaryTermType.cookingVerb), isTrue);
      expect(types.contains(CulinaryTermType.utensil), isTrue);
      expect(types.contains(CulinaryTermType.measurement), isTrue);
      expect(types.contains(CulinaryTermType.dialectFood), isTrue);

      for (final term in GastronomySeedData.culinaryTerms) {
        expect(term.id, isNotEmpty);
        expect(term.termPt, isNotEmpty);
        expect(term.translationRu, isNotEmpty);
        expect(term.usageExamplePt, isNotEmpty);
      }
    });
  });

  group('GastronomyRepositoryImpl Tests', () {
    final repo = GastronomyRepositoryImpl();

    test('getRecipes returns all recipes or filters by dialect and difficulty', () async {
      final allRes = await repo.getRecipes();
      expect(allRes.isOk, isTrue);
      expect(allRes.value.length, GastronomySeedData.recipes.length);

      final ptRes = await repo.getRecipes(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      for (final r in ptRes.value) {
        expect(r.isPtPt, isTrue);
      }

      final easyRes = await repo.getRecipes(difficulty: 'Fácil');
      expect(easyRes.isOk, isTrue);
      for (final r in easyRes.value) {
        expect(r.difficulty.toLowerCase(), 'fácil');
      }
    });

    test('getRecipeById returns recipe or failure', () async {
      final first = GastronomySeedData.recipes.first;
      final res = await repo.getRecipeById(first.id);
      expect(res.isOk, isTrue);
      expect(res.value.id, first.id);

      final notFound = await repo.getRecipeById('non_existent');
      expect(notFound.isFailure, isTrue);
    });

    test('getCulinaryTerms returns terms and filters by type', () async {
      final allTerms = await repo.getCulinaryTerms();
      expect(allTerms.isOk, isTrue);
      expect(allTerms.value.length, GastronomySeedData.culinaryTerms.length);

      final verbs = await repo.getCulinaryTerms(type: CulinaryTermType.cookingVerb);
      expect(verbs.isOk, isTrue);
      for (final t in verbs.value) {
        expect(t.type, CulinaryTermType.cookingVerb);
      }
    });

    test('recordRecipeCompleted handles null database gracefully', () async {
      final res = await repo.recordRecipeCompleted(
        recipeId: 'pastel_de_nata',
        timeSpentMinutes: 35,
      );
      expect(res.isOk, isTrue);
    });
  });
}
