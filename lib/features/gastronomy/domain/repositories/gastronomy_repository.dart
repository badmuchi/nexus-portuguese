import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/culinary_vocabulary_entity.dart';
import '../entities/recipe_entity.dart';

abstract class GastronomyRepository {
  /// Получить список всех рецептов с опциональными фильтрами.
  Future<Result<List<RecipeEntity>>> getRecipes({
    String? dialect,
    String? difficulty,
  });

  /// Получить рецепт по ID.
  Future<Result<RecipeEntity>> getRecipeById(String id);

  /// Получить кулинарные термины и лексику.
  Future<Result<List<CulinaryTermEntity>>> getCulinaryTerms({
    CulinaryTermType? type,
    String? dialect,
  });

  /// Записать завершение приготовления блюда.
  Future<Result<void>> recordRecipeCompleted({
    required String recipeId,
    required int timeSpentMinutes,
  });
}
