import 'dart:math';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/portuguese_badge.dart';
import '../../domain/entities/progress_stats_entity.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final AppDatabase _db;

  const ProgressRepositoryImpl(this._db);

  @override
  Future<Result<ProgressStatsEntity>> getProgressStats() async {
    try {
      final cards = await _db.countSrsCards();
      final reviews = await _db.getAllSrsReviewLogs();
      final dialogues = await _db.getAllDialogueHistory();
      final grammar = await _db.getAllGrammarPracticeLogs();
      final listening = await _db.getAllListeningAttemptLogs();
      final assessment = await _db.getLatestAssessmentResult();
      final phonetics = await _db.getAllPhoneticMastery();
      final scenes = await _db.getAllSceneProgress();

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

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      map[today] = (map[today] ?? 0) + 1;

      // 1. Calculate Streak
      int currentStreak = 0;
      var checkDate = today;
      while (map.containsKey(checkDate)) {
        currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }

      // Calculate historical max streak
      int maxStreak = currentStreak;
      final sortedDates = map.keys.toList()..sort();
      int tempStreak = 0;
      DateTime? prevDate;
      for (final d in sortedDates) {
        if (prevDate == null || d.difference(prevDate).inDays == 1) {
          tempStreak++;
        } else if (d.difference(prevDate).inDays > 1) {
          tempStreak = 1;
        }
        maxStreak = max(maxStreak, tempStreak);
        prevDate = d;
      }

      // 2. Scenes completed
      final completedScenesCount = scenes.where((s) => s.isCompleted).length;

      // 3. Phonetics average
      double phoneticAvg = 0.0;
      if (phonetics.isNotEmpty) {
        final sum = phonetics.fold<double>(0.0, (acc, p) => acc + p.masteryScore);
        phoneticAvg = sum / phonetics.length;
      }

      // 4. CEFR
      final cefrLevel = assessment?.determinedLevel;
      final cefrScore = assessment?.scorePercentage ?? 0.0;

      // 5. Fluency Score Formula
      final cefrPart = (cefrScore * 0.35);
      final phoneticPart = (phoneticAvg * 0.20);
      final fsrsPart = (min(reviews.length / 30.0, 1.0) * 100 * 0.20);
      final grammarPart = (min(grammar.length / 25.0, 1.0) * 100 * 0.15);
      final scenesPart = (min(completedScenesCount / 6.0, 1.0) * 100 * 0.10);

      final fluencyScore = (cefrPart + phoneticPart + fsrsPart + grammarPart + scenesPart).clamp(0.0, 100.0);

      // 6. Badges
      final badges = PortugueseBadge.evaluateAll(
        scenesCompletedCount: completedScenesCount,
        phoneticMasteryAvg: phoneticAvg,
        cefrLevel: cefrLevel,
        cefrScorePercentage: cefrScore,
        grammarLogsCount: grammar.length,
        reviewsCount: reviews.length,
        listeningLogsCount: listening.length,
        dialoguesCount: dialogues.length,
        currentStreak: currentStreak,
        maxStreak: maxStreak,
        fluencyScore: fluencyScore,
      );

      return Result.ok(
        ProgressStatsEntity(
          cardsCount: cards,
          reviewsCount: reviews.length,
          dialoguesCount: dialogues.length,
          grammarLogsCount: grammar.length,
          listeningLogsCount: listening.length,
          activityByDay: map,
          scenesCompletedCount: completedScenesCount,
          phoneticMasteryAvg: phoneticAvg,
          cefrLevel: cefrLevel,
          cefrScorePercentage: cefrScore,
          fluencyScore: fluencyScore,
          currentStreak: currentStreak,
          maxStreak: maxStreak,
          badges: badges,
        ),
      );
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load progress stats: $e', stackTrace: stackTrace),
      );
    }
  }
}
