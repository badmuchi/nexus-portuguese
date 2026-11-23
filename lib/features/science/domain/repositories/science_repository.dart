import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/science_entities.dart';

abstract class ScienceRepository {
  Future<Result<List<ScienceTopicEntity>>> getScienceTopics({
    ScienceField? field,
    String? dialect,
  });

  Future<Result<ScienceTopicEntity>> getScienceTopicById(String id);

  Future<Result<List<LabExperimentEntity>>> getLabExperiments();

  Future<Result<List<ScienceQuizQuestion>>> getScienceQuizzes();

  Future<Result<void>> recordTopicViewed(String topicId);

  Future<Result<void>> addScienceVocabToSrs(
    ScienceVocabEntity vocab, {
    String dialect = 'all',
  });
}
