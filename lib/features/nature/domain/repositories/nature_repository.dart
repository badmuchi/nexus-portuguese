import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/nature_entities.dart';

abstract class NatureRepository {
  /// Получить список национальных парков и природных зон.
  Future<Result<List<NatureReserveEntity>>> getReserves({String? dialect});

  /// Получить заповедник по идентификатору.
  Future<Result<NatureReserveEntity>> getReserveById(String id);

  /// Получить все виды флоры и фауны.
  Future<Result<List<SpeciesEntity>>> getAllSpecies({SpeciesCategory? category});

  /// Получить вопросы викторины по экотуризму и биоразнообразию.
  Future<Result<List<EcoQuizQuestion>>> getEcoQuizzes();

  /// Записать прохождение трека в историю пользователя.
  Future<Result<void>> recordTrailCompleted({
    required String trailId,
    required double distanceKm,
  });

  /// Добавить название вида и описание в интервальное повторение FSRS.
  Future<Result<void>> addSpeciesToSrs(SpeciesEntity species);
}
