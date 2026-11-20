import '../../../../core/result/result.dart';
import '../entities/story_entity.dart';

abstract class StoriesRepository {
  Future<Result<List<StoryEntity>>> getAllStories();
}
