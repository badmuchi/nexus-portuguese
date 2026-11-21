import '../../../../core/result/result.dart';
import 'package:nexus_portuguese_app/features/assessment/domain/entities/level_quiz_question.dart';
import '../entities/sentence_puzzle.dart';

abstract class SentenceBuilderRepository {
  Future<Result<List<SentencePuzzle>>> getPuzzles({
    CefrLevel? level,
    String? dialect,
  });

  Future<Result<void>> recordCompletion({
    required String puzzleId,
    required bool isCorrect,
  });
}
