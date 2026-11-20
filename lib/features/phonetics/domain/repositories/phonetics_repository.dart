import '../../../../core/result/result.dart';
import '../entities/phonetic_trainer_models.dart';

abstract class PhoneticsRepository {
  Future<Result<List<PhoneticExercise>>> getTrainerExercises();

  Future<Result<List<PhoneticMastery>>> getMasteryList();

  Future<Result<void>> recordEarAnswer({
    required String soundId,
    required bool isCorrect,
    required String soundCategory,
    required String title,
  });

  Future<Result<void>> recordMouthScore({
    required String soundId,
    required double scorePercent,
    required String soundCategory,
    required String title,
  });
}
