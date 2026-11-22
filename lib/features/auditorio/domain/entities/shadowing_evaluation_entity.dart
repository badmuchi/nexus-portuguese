import 'package:equatable/equatable.dart';
import 'package:nexus_portuguese_app/core/speech/pronunciation_accuracy_evaluator.dart';

/// Результат сессии Shadowing (теневого повторения) фрагмента аудио.
class ShadowingEvaluationEntity extends Equatable {
  final String snippetId;
  final String targetText;
  final String spokenText;
  final double accuracyScore; // 0.0 .. 1.0
  final bool isPass;
  final List<WordEvaluation> wordEvaluations;
  final String feedback;
  final DateTime attemptedAt;

  const ShadowingEvaluationEntity({
    required this.snippetId,
    required this.targetText,
    required this.spokenText,
    required this.accuracyScore,
    required this.isPass,
    required this.wordEvaluations,
    required this.feedback,
    required this.attemptedAt,
  });

  int get scorePercent => (accuracyScore * 100).round().clamp(0, 100);

  @override
  List<Object?> get props => [
        snippetId,
        targetText,
        spokenText,
        accuracyScore,
        isPass,
        wordEvaluations,
        feedback,
        attemptedAt,
      ];
}
