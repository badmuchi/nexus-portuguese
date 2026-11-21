import '../../../../core/result/result.dart';
import '../entities/verb_exercise.dart';
import '../entities/verb_trainer_config.dart';

abstract class VerbTrainerRepository {
  Future<Result<List<VerbExercise>>> generateExercises({
    required VerbTrainerConfig config,
    int count = 25,
  });

  Future<Result<void>> recordAttempt({
    required String verbId,
    required String tense,
    required String person,
    required bool isCorrect,
  });

  Future<Result<Map<String, double>>> getVerbMasteryStats();
}
