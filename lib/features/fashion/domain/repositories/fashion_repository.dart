import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/fashion_entities.dart';

abstract class FashionRepository {
  Future<Result<List<FashionTopicEntity>>> getFashionTopics({
    FashionCategory? category,
    String? dialect,
  });

  Future<Result<FashionTopicEntity>> getFashionTopicById(String id);

  Future<Result<List<TextileCraftEntity>>> getTextileCrafts();

  Future<Result<List<FashionQuizQuestion>>> getFashionQuizzes();

  Future<Result<void>> recordTopicViewed(String topicId);

  Future<Result<void>> addFashionVocabToSrs(
    FashionVocabEntity vocab, {
    String dialect = 'all',
  });
}
