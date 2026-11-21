import 'package:equatable/equatable.dart';
import 'verb_exercise.dart';
import 'verb_trainer_config.dart';

class VerbTrainerSessionResult extends Equatable {
  final int totalAttempts;
  final int correctCount;
  final int maxStreak;
  final int scorePoints;
  final double accuracyPercentage;
  final List<VerbExercise> mistakes;
  final DateTime completedAt;
  final TrainerMode mode;

  const VerbTrainerSessionResult({
    required this.totalAttempts,
    required this.correctCount,
    required this.maxStreak,
    required this.scorePoints,
    required this.accuracyPercentage,
    required this.mistakes,
    required this.completedAt,
    required this.mode,
  });

  factory VerbTrainerSessionResult.evaluate({
    required int totalAttempts,
    required int correctCount,
    required int maxStreak,
    required int scorePoints,
    required List<VerbExercise> mistakes,
    required TrainerMode mode,
    DateTime? completedAt,
  }) {
    final accuracy = totalAttempts > 0 ? (correctCount / totalAttempts) * 100.0 : 0.0;
    return VerbTrainerSessionResult(
      totalAttempts: totalAttempts,
      correctCount: correctCount,
      maxStreak: maxStreak,
      scorePoints: scorePoints,
      accuracyPercentage: accuracy,
      mistakes: mistakes,
      completedAt: completedAt ?? DateTime.now(),
      mode: mode,
    );
  }

  @override
  List<Object?> get props => [
        totalAttempts,
        correctCount,
        maxStreak,
        scorePoints,
        accuracyPercentage,
        mistakes,
        completedAt,
        mode,
      ];
}
