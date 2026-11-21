import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/portuguese_life_scene.dart';
import '../../domain/repositories/scenes_repository.dart';
import '../datasources/portuguese_scenes_seed_data.dart';

class ScenesRepositoryImpl implements ScenesRepository {
  final AppDatabase database;

  const ScenesRepositoryImpl({required this.database});

  @override
  Future<Result<List<PortugueseLifeScene>>> getScenes({SceneCategory? category}) async {
    try {
      const list = PortugueseScenesSeedData.scenes;
      if (category == null) {
        return const Result.ok(list);
      }
      return Result.ok(list.where((s) => s.category == category).toList());
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load scenes: $e', stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<Result<PortugueseLifeScene?>> getSceneById(String id) async {
    try {
      final scene = PortugueseScenesSeedData.scenes.cast<PortugueseLifeScene?>().firstWhere(
            (s) => s?.id == id,
            orElse: () => null,
          );
      return Result.ok(scene);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load scene $id: $e', stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<Result<Map<String, SceneProgressEntity>>> getAllProgress() async {
    try {
      final rows = await database.getAllSceneProgress();
      final map = <String, SceneProgressEntity>{};
      for (final r in rows) {
        map[r.sceneId] = SceneProgressEntity(
          sceneId: r.sceneId,
          completedChallengesCount: r.completedChallengesCount,
          totalChallengesCount: r.totalChallengesCount,
          isCompleted: r.isCompleted,
          lastVisitedAt: r.lastVisitedAt,
        );
      }
      return Result.ok(map);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load scenes progress: $e', stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<Result<void>> saveSceneProgress({
    required String sceneId,
    required int completedCount,
    required int totalCount,
    required bool isCompleted,
  }) async {
    try {
      await database.upsertSceneProgress(
        sceneId: sceneId,
        completedCount: completedCount,
        totalCount: totalCount,
        isCompleted: isCompleted,
      );
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to save scene progress: $e', stackTrace: stackTrace),
      );
    }
  }
}
