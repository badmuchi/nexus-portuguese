import 'package:equatable/equatable.dart';

/// Результат завершенной дуэли диалектов.
class DuelSessionResultEntity extends Equatable {
  final int totalQuestions;
  final int correctAnswers;
  final int score;
  final int maxStreak;
  final double accuracyPercent;
  final String titlePt;
  final String titleRu;
  final String trophyEmoji;
  final DateTime completedAt;

  const DuelSessionResultEntity({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
    required this.maxStreak,
    required this.accuracyPercent,
    required this.titlePt,
    required this.titleRu,
    required this.trophyEmoji,
    required this.completedAt,
  });

  static DuelSessionResultEntity evaluate({
    required int total,
    required int correct,
    required int score,
    required int maxStreak,
  }) {
    final accuracy = total > 0 ? (correct / total * 100).clamp(0.0, 100.0) : 0.0;

    final (titlePt, titleRu, emoji) = switch (accuracy) {
      >= 90 => ('Embaixador do Atlântico', 'Посол Атлантики: безупречное чутье обоих диалектов!', '🏆'),
      >= 75 => ('Mestre dos Dois Mundos', 'Знаток двух миров: уверенное понимание нюансов!', '🎖️'),
      >= 50 => ('Viajante Curioso', 'Любознательный путник: базовые ловушки пройдены!', '🧭'),
      _ => ('Aprendiz Transatlântico', 'Трансатлантический ученик: продолжайте тренировки!', '🌱'),
    };

    return DuelSessionResultEntity(
      totalQuestions: total,
      correctAnswers: correct,
      score: score,
      maxStreak: maxStreak,
      accuracyPercent: accuracy,
      titlePt: titlePt,
      titleRu: titleRu,
      trophyEmoji: emoji,
      completedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        totalQuestions,
        correctAnswers,
        score,
        maxStreak,
        accuracyPercent,
        titlePt,
        titleRu,
        trophyEmoji,
        completedAt,
      ];
}
