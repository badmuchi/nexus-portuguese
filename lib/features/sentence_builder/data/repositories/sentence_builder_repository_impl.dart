import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import 'package:nexus_portuguese_app/features/assessment/domain/entities/level_quiz_question.dart';
import '../../domain/entities/sentence_puzzle.dart';
import '../../domain/repositories/sentence_builder_repository.dart';
import '../datasources/portuguese_sentence_seed_data.dart';

class SentenceBuilderRepositoryImpl implements SentenceBuilderRepository {
  const SentenceBuilderRepositoryImpl();

  @override
  Future<Result<List<SentencePuzzle>>> getPuzzles({
    CefrLevel? level,
    String? dialect,
  }) async {
    try {
      var list = PortugueseSentenceSeedData.puzzles;
      if (level != null) {
        list = list.where((p) => p.level == level).toList();
      }
      if (dialect != null && dialect != 'all') {
        list = list.where((p) => p.dialect == 'all' || p.dialect == dialect).toList();
      }
      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load sentence puzzles: $e', stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<Result<void>> recordCompletion({
    required String puzzleId,
    required bool isCorrect,
  }) async {
    // In-memory or logging stub for future cloud sync
    return const Result.ok(null);
  }
}
