import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/duel_question_entity.dart';
import '../../domain/entities/duel_session_result_entity.dart';
import '../../domain/repositories/duels_repository.dart';
import '../datasources/duel_questions_seed.dart';

class DuelsRepositoryImpl implements DuelsRepository {
  final AppDatabase _database;

  DuelsRepositoryImpl({required AppDatabase database}) : _database = database;

  @override
  Future<Result<List<DuelQuestion>>> getQuestions({
    DuelCategory? category,
    int count = 10,
  }) async {
    try {
      var pool = List<DuelQuestion>.from(DuelQuestionsSeed.questions);

      if (category != null) {
        pool = pool.where((q) => q.category == category).toList();
      }

      pool.shuffle();
      final selected = pool.take(count).toList();
      return Result.ok(selected);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить вопросы дуэли: $e'));
    }
  }

  @override
  Future<Result<void>> saveDuelResult(DuelSessionResultEntity result) async {
    try {
      final accuracy = (result.accuracyPercent / 100.0).clamp(0.0, 1.0);
      final isExact = result.accuracyPercent >= 80.0;

      await _database.insertListeningAttemptLog(
        exerciseId: 'duel_arena_${result.completedAt.millisecondsSinceEpoch}',
        wordAccuracy: accuracy,
        isExactMatch: isExact,
        attemptedAt: result.completedAt,
      );

      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить результат дуэли: $e'));
    }
  }
}
