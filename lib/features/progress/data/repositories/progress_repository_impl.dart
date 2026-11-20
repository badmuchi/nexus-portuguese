import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/progress_stats_entity.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final AppDatabase _db;

  ProgressRepositoryImpl(this._db);

  @override
  Future<Result<ProgressStatsEntity>> getProgressStats() async {
    try {
      final cards = await _db.countSrsCards();
      final reviews = await _db.getAllSrsReviewLogs();
      final dialogues = await _db.getAllDialogueHistory();
      final grammar = await _db.getAllGrammarPracticeLogs();
      final listening = await _db.getAllListeningAttemptLogs();

      final map = <DateTime, int>{};
      void recordDate(DateTime dt) {
        final key = DateTime(dt.year, dt.month, dt.day);
        map[key] = (map[key] ?? 0) + 1;
      }

      for (final r in reviews) {
        recordDate(r.reviewedAt);
      }
      for (final d in dialogues) {
        recordDate(d.answeredAt);
      }
      for (final g in grammar) {
        recordDate(g.practicedAt);
      }
      for (final l in listening) {
        recordDate(l.attemptedAt);
      }

      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      map[today] = (map[today] ?? 0) + 1;

      return Result.ok(
        ProgressStatsEntity(
          cardsCount: cards,
          reviewsCount: reviews.length,
          dialoguesCount: dialogues.length,
          grammarLogsCount: grammar.length,
          listeningLogsCount: listening.length,
          activityByDay: map,
        ),
      );
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load progress stats: $e', stackTrace: stackTrace),
      );
    }
  }
}
