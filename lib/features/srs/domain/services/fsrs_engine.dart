import 'dart:math';

enum SrsRating {
  again(1),
  hard(2),
  good(3),
  easy(4);

  final int value;
  const SrsRating(this.value);
}

class FsrsItemState {
  final double stability;
  final double difficulty;
  final int reps;
  final int lapses;
  final String state; // 'newCard', 'learning', 'review', 'relearning'
  final DateTime dueAt;
  final int scheduledDays;

  const FsrsItemState({
    required this.stability,
    required this.difficulty,
    required this.reps,
    required this.lapses,
    required this.state,
    required this.dueAt,
    required this.scheduledDays,
  });
}

class FsrsEngine {
  // FSRS default parameters for language flashcards
  static const double requestRetention = 0.9;
  static const double w0 = 0.4;
  static const double w1 = 0.6;
  static const double w2 = 2.4;
  static const double w3 = 5.8;
  static const double w4 = 4.93;
  static const double w5 = 0.94;
  static const double w6 = 0.86;
  static const double w7 = 0.01;
  static const double w8 = 1.49;
  static const double w9 = 0.14;
  static const double w10 = 0.94;

  static FsrsItemState review({
    required FsrsItemState currentState,
    required SrsRating rating,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final isNew = currentState.state == 'newCard' || currentState.reps == 0;

    double newStability;
    double newDifficulty;
    int newReps = currentState.reps + 1;
    int newLapses = currentState.lapses;
    String newState;

    if (isNew) {
      newDifficulty = _initDifficulty(rating);
      newStability = _initStability(rating);
      newState = rating == SrsRating.again ? 'learning' : 'review';
      if (rating == SrsRating.again) newLapses++;
    } else {
      newDifficulty = _nextDifficulty(currentState.difficulty, rating);
      if (rating == SrsRating.again) {
        newStability = _stabilityAfterLapse(currentState.stability, newDifficulty);
        newLapses++;
        newState = 'relearning';
      } else {
        newStability = _stabilityAfterSuccess(
          currentState.stability,
          newDifficulty,
          currentState.scheduledDays.toDouble(),
          rating,
        );
        newState = 'review';
      }
    }

    // Interval calculation based on stability and desired retention
    final interval = max(1, (newStability * 9 * (1 / requestRetention - 1)).round());
    final scheduledDays = rating == SrsRating.again ? 1 : interval;
    final dueAt = currentTime.add(Duration(days: scheduledDays));

    return FsrsItemState(
      stability: double.parse(newStability.toStringAsFixed(2)),
      difficulty: double.parse(newDifficulty.toStringAsFixed(2)),
      reps: newReps,
      lapses: newLapses,
      state: newState,
      dueAt: dueAt,
      scheduledDays: scheduledDays,
    );
  }

  static double _initDifficulty(SrsRating rating) {
    return (w4 - exp(w5 * (rating.value - 1)) + 1).clamp(1.0, 10.0);
  }

  static double _initStability(SrsRating rating) {
    return switch (rating) {
      SrsRating.again => max(0.1, w0),
      SrsRating.hard => max(0.1, w1),
      SrsRating.good => max(0.1, w2),
      SrsRating.easy => max(0.1, w3),
    };
  }

  static double _nextDifficulty(double d, SrsRating rating) {
    final nextD = d - w6 * (rating.value - 3);
    return _meanReversion(w4, nextD).clamp(1.0, 10.0);
  }

  static double _meanReversion(double target, double current) {
    return w7 * target + (1 - w7) * current;
  }

  static double _stabilityAfterSuccess(
    double s,
    double d,
    double r,
    SrsRating rating,
  ) {
    final hardPenalty = rating == SrsRating.hard ? w8 : 1.0;
    final easyBonus = rating == SrsRating.easy ? w9 : 1.0;
    return s * (1 + exp(w10) * (11 - d) * pow(s, -0.5) * (exp((1 - r) * 0.1) - 1) * hardPenalty * easyBonus);
  }

  static double _stabilityAfterLapse(double s, double d) {
    return (s * 0.2).clamp(0.1, 10.0);
  }
}
