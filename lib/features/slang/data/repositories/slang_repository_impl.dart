import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/slang_entity.dart';
import '../../domain/repositories/slang_repository.dart';

class SlangRepositoryImpl implements SlangRepository {
  final AppDatabase _db;

  SlangRepositoryImpl(this._db);

  @override
  Future<Result<List<SlangEntity>>> getAllSlang() async {
    try {
      final rows = await _db.getAllSlang();
      final entities = rows.map((r) => SlangEntity(
        id: r.id,
        expression: r.expression,
        literalTranslation: r.literalTranslation,
        actualMeaning: r.actualMeaning,
        dialect: r.dialect,
        originNotes: r.originNotes,
        exampleSentence: r.exampleSentence,
        exampleTranslation: r.exampleTranslation,
      )).toList();
      return Result.ok(entities);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load slang: $e', stackTrace: stackTrace),
      );
    }
  }
}
