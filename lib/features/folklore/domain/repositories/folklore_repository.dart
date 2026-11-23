import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/folklore_entities.dart';

abstract class FolkloreRepository {
  /// Получить список мифических существ и легенд с фильтрацией по происхождению и диалекту.
  Future<Result<List<MythicalEntity>>> getMyths({
    FolkloreOrigin? origin,
    String? dialect,
  });

  /// Получить мифическое существо по идентификатору.
  Future<Result<MythicalEntity>> getMythById(String id);

  /// Получить фрагменты сказок и повествовательных текстов.
  Future<Result<List<FolkloreTaleSnippet>>> getTaleSnippets();

  /// Получить вопросы викторины по фольклору и мифологии.
  Future<Result<List<FolkloreQuizQuestion>>> getFolkloreQuizzes();

  /// Зафиксировать знакомство с легендой в журнале обучения.
  Future<Result<void>> recordMythViewed(String mythId);

  /// Добавить фольклорный термин в интервальное повторение FSRS.
  Future<Result<void>> addFolkloreVocabToSrs(
    FolkloreVocabEntity vocab, {
    String dialect = 'all',
  });
}
