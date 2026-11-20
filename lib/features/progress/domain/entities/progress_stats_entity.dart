import 'package:equatable/equatable.dart';

class ProgressStatsEntity extends Equatable {
  final int cardsCount;
  final int reviewsCount;
  final int dialoguesCount;
  final int grammarLogsCount;
  final int listeningLogsCount;
  final Map<DateTime, int> activityByDay;

  const ProgressStatsEntity({
    required this.cardsCount,
    required this.reviewsCount,
    required this.dialoguesCount,
    required this.grammarLogsCount,
    required this.listeningLogsCount,
    required this.activityByDay,
  });

  @override
  List<Object?> get props => [
        cardsCount,
        reviewsCount,
        dialoguesCount,
        grammarLogsCount,
        listeningLogsCount,
        activityByDay,
      ];
}
