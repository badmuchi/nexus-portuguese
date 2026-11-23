import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/finance_entities.dart';

abstract class FinanceRepository {
  /// Получить темы финансов, финтеха и стартапов с фильтрацией по категории и диалекту.
  Future<Result<List<FinanceTopicEntity>>> getFinanceTopics({
    FinanceCategory? category,
    String? dialect,
  });

  /// Получить тему по идентификатору.
  Future<Result<FinanceTopicEntity>> getTopicById(String id);

  /// Получить каталог сценариев финтех-симулятора (Pix, MB WAY, Multibanco).
  Future<Result<List<FintechSimulatorEntity>>> getFintechSimulators();

  /// Получить вопросы финансовой викторины.
  Future<Result<List<FinanceQuizQuestion>>> getFinanceQuizzes();

  /// Зафиксировать изучение финансовой темы в истории обучения.
  Future<Result<void>> recordTopicViewed(String topicId);

  /// Добавить финансовый термин в интервальное повторение FSRS.
  Future<Result<void>> addFinanceVocabToSrs(
    FinanceVocabEntity vocab, {
    String dialect = 'all',
  });
}
