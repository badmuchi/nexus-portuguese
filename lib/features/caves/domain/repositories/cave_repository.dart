import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/cave_entities.dart';

abstract class CaveRepository {
  Future<Result<List<CaveEntity>>> getCaves({
    CaveCategory? category,
    String? dialect,
  });

  Future<Result<CaveEntity>> getCaveById(String id);

  Future<Result<List<SpeleoProtocolEntity>>> getSpeleoProtocols();

  Future<Result<List<CaveQuizQuestion>>> getCaveQuizzes();

  Future<Result<void>> recordCaveViewed(String caveId);

  Future<Result<void>> addCaveVocabToSrs(
    CaveVocabEntity vocab, {
    String dialect = 'all',
  });
}
