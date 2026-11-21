import '../../../../core/result/result.dart';
import '../entities/portuguese_life_scene.dart';

abstract class ScenesRepository {
  Future<Result<List<PortugueseLifeScene>>> getScenes({SceneCategory? category});

  Future<Result<PortugueseLifeScene?>> getSceneById(String id);

  Future<Result<Map<String, SceneProgressEntity>>> getAllProgress();

  Future<Result<void>> saveSceneProgress({
    required String sceneId,
    required int completedCount,
    required int totalCount,
    required bool isCompleted,
  });
}
