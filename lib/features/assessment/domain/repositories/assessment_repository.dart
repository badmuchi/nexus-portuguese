import '../../../../core/result/result.dart';
import '../entities/level_quiz_question.dart';
import '../entities/level_quiz_result.dart';

abstract class AssessmentRepository {
  Future<Result<List<LevelQuizQuestion>>> getQuestions();
  Future<Result<LevelQuizResult?>> getLatestResult();
  Future<Result<void>> saveResult(LevelQuizResult result);
}
