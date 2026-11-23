import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/wine_entities.dart';

abstract class WineRepository {
  Future<Result<List<WineRegionEntity>>> getWineRegions({
    WineCategory? category,
    String? dialect,
  });

  Future<Result<WineRegionEntity>> getWineRegionById(String id);

  Future<Result<List<TastingGuideEntity>>> getTastingGuides();

  Future<Result<List<WineQuizQuestion>>> getWineQuizzes();

  Future<Result<void>> recordRegionViewed(String regionId);

  Future<Result<void>> addWineVocabToSrs(
    WineVocabEntity vocab, {
    String dialect = 'all',
  });
}
