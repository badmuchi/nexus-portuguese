import 'package:equatable/equatable.dart';
import 'sentence_puzzle.dart';

class SentenceBuilderResult extends Equatable {
  final int totalQuestions;
  final int solvedCount;
  final int scorePoints;
  final double accuracyPercentage;
  final List<SentencePuzzle> mistakes;
  final DateTime completedAt;

  const SentenceBuilderResult({
    required this.totalQuestions,
    required this.solvedCount,
    required this.scorePoints,
    required this.accuracyPercentage,
    required this.mistakes,
    required this.completedAt,
  });

  factory SentenceBuilderResult.evaluate({
    required int totalQuestions,
    required int solvedCount,
    required int scorePoints,
    required List<SentencePuzzle> mistakes,
    DateTime? completedAt,
  }) {
    final accuracy = totalQuestions > 0 ? (solvedCount / totalQuestions) * 100.0 : 0.0;
    return SentenceBuilderResult(
      totalQuestions: totalQuestions,
      solvedCount: solvedCount,
      scorePoints: scorePoints,
      accuracyPercentage: accuracy,
      mistakes: mistakes,
      completedAt: completedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        totalQuestions,
        solvedCount,
        scorePoints,
        accuracyPercentage,
        mistakes,
        completedAt,
      ];
}
