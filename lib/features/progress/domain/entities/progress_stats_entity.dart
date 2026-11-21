import 'package:equatable/equatable.dart';
import 'portuguese_badge.dart';

class ProgressStatsEntity extends Equatable {
  final int cardsCount;
  final int reviewsCount;
  final int dialoguesCount;
  final int grammarLogsCount;
  final int listeningLogsCount;
  final Map<DateTime, int> activityByDay;
  final int scenesCompletedCount;
  final double phoneticMasteryAvg;
  final String? cefrLevel;
  final double cefrScorePercentage;
  final double fluencyScore;
  final int currentStreak;
  final int maxStreak;
  final List<PortugueseBadge> badges;

  const ProgressStatsEntity({
    required this.cardsCount,
    required this.reviewsCount,
    required this.dialoguesCount,
    required this.grammarLogsCount,
    required this.listeningLogsCount,
    required this.activityByDay,
    this.scenesCompletedCount = 0,
    this.phoneticMasteryAvg = 0.0,
    this.cefrLevel,
    this.cefrScorePercentage = 0.0,
    this.fluencyScore = 0.0,
    this.currentStreak = 1,
    this.maxStreak = 1,
    this.badges = const [],
  });

  @override
  List<Object?> get props => [
        cardsCount,
        reviewsCount,
        dialoguesCount,
        grammarLogsCount,
        listeningLogsCount,
        activityByDay,
        scenesCompletedCount,
        phoneticMasteryAvg,
        cefrLevel,
        cefrScorePercentage,
        fluencyScore,
        currentStreak,
        maxStreak,
        badges,
      ];
}
