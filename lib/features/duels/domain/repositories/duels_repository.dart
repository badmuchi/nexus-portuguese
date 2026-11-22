import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/duel_question_entity.dart';
import '../entities/duel_session_result_entity.dart';

abstract class DuelsRepository {
  /// Получить вопросы для дуэли с опциональной фильтрацией по категории и ограничением по количеству.
  Future<Result<List<DuelQuestion>>> getQuestions({
    DuelCategory? category,
    int count = 10,
  });

  /// Сохранить результат сессии дуэли в историю БД.
  Future<Result<void>> saveDuelResult(DuelSessionResultEntity result);
}
