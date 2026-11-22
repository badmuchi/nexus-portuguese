import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/culinary_vocabulary_entity.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/gastronomy_repository.dart';
import '../datasources/gastronomy_seed_data.dart';

class GastronomyRepositoryImpl implements GastronomyRepository {
  final AppDatabase? _database;

  GastronomyRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<RecipeEntity>>> getRecipes({
    String? dialect,
    String? difficulty,
  }) async {
    try {
      var pool = List<RecipeEntity>.from(GastronomySeedData.recipes);

      if (dialect != null && dialect.toLowerCase() != 'all') {
        final d = dialect.toLowerCase();
        final isPt = d.contains('pt') && !d.contains('br');
        final isBr = d.contains('br');

        if (isPt) {
          pool = pool.where((r) => r.isPtPt).toList();
        } else if (isBr) {
          pool = pool.where((r) => r.isPtBr).toList();
        }
      }

      if (difficulty != null && difficulty.toLowerCase() != 'all') {
        pool = pool.where((r) => r.difficulty.toLowerCase() == difficulty.toLowerCase()).toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить рецепты: $e'));
    }
  }

  @override
  Future<Result<RecipeEntity>> getRecipeById(String id) async {
    try {
      final recipe = GastronomySeedData.recipes.firstWhere(
        (r) => r.id == id,
        orElse: () => throw Exception('Рецепт $id не найден'),
      );
      return Result.ok(recipe);
    } catch (e) {
      return Result.err(DatabaseFailure('Рецепт не найден: $e'));
    }
  }

  @override
  Future<Result<List<CulinaryTermEntity>>> getCulinaryTerms({
    CulinaryTermType? type,
    String? dialect,
  }) async {
    try {
      var pool = List<CulinaryTermEntity>.from(GastronomySeedData.culinaryTerms);

      if (type != null) {
        pool = pool.where((t) => t.type == type).toList();
      }

      if (dialect != null && dialect.toLowerCase() != 'all') {
        final d = dialect.toLowerCase();
        final isPt = d.contains('pt') && !d.contains('br');
        final isBr = d.contains('br');

        if (isPt) {
          pool = pool.where((t) => t.isPtPt || (!t.isPtPt && !t.isPtBr)).toList();
        } else if (isBr) {
          pool = pool.where((t) => t.isPtBr || (!t.isPtPt && !t.isPtBr)).toList();
        }
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить кулинарный словарь: $e'));
    }
  }

  @override
  Future<Result<void>> recordRecipeCompleted({
    required String recipeId,
    required int timeSpentMinutes,
  }) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'gastronomy_recipe_$recipeId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка записи кулинарного прогресса: $e'));
    }
  }
}
