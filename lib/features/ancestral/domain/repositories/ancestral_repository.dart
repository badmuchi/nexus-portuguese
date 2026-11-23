import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/ancestral_entities.dart';

abstract class AncestralRepository {
  Future<Result<List<TraditionalCommunityEntity>>> getCommunities({
    CommunityCategory? category,
    String? dialect,
  });

  Future<Result<TraditionalCommunityEntity>> getCommunityById(String id);

  Future<Result<List<HerbalRemedyEntity>>> getHerbalRemedies();

  Future<Result<List<AncestralQuizQuestion>>> getAncestralQuizzes();

  Future<Result<void>> recordCommunityViewed(String communityId);

  Future<Result<void>> addAncestralVocabToSrs(
    AncestralVocabEntity vocab, {
    String dialect = 'all',
  });
}
