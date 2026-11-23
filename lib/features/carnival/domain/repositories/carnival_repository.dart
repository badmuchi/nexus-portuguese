import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/carnival_entities.dart';

abstract class CarnivalRepository {
  Future<Result<List<CarnivalTraditionEntity>>> getTraditions({
    CarnivalTraditionCategory? category,
    String? dialect,
  });

  Future<Result<CarnivalTraditionEntity>> getTraditionById(String id);

  Future<Result<List<RhythmWorkshopEntity>>> getRhythmWorkshops();

  Future<Result<List<CarnivalQuizQuestion>>> getCarnivalQuizzes();

  Future<Result<void>> recordTraditionViewed(String traditionId);

  Future<Result<void>> addCarnivalVocabToSrs(
    CarnivalVocabEntity vocab, {
    String dialect = 'all',
  });
}
