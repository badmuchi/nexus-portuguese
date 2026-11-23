import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/festas_entities.dart';

abstract class FestasRepository {
  /// Получить каталог народных праздников с опциональной фильтрацией по категории и диалекту.
  Future<Result<List<FestaEntity>>> getFestas({
    FestaCategory? category,
    String? dialect,
  });

  /// Получить подробную информацию о празднике по идентификатору.
  Future<Result<FestaEntity>> getFestaById(String id);

  /// Получить каталог традиций и обрядов.
  Future<Result<List<FestaTraditionEntity>>> getFestaTraditions();

  /// Получить вопросы викторины по фольклору и праздникам.
  Future<Result<List<FestaQuizQuestion>>> getFestaQuizzes();

  /// Зафиксировать знакомство с праздником в журнале обучения.
  Future<Result<void>> recordFestaViewed(String festaId);

  /// Добавить праздничный термин в интервальное повторение FSRS.
  Future<Result<void>> addFestaVocabToSrs(
    FestaVocabEntity vocab, {
    String dialect = 'all',
  });
}
