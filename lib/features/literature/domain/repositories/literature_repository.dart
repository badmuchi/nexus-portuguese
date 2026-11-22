import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/literary_work_entity.dart';

abstract class LiteratureRepository {
  /// Получить каталог произведений с фильтрацией по диалекту и жанру.
  Future<Result<List<LiteraryWorkEntity>>> getWorks({
    String? dialect,
    String? genre,
  });

  /// Получить произведение по ID.
  Future<Result<LiteraryWorkEntity>> getWorkById(String id);

  /// Получить подборку крылатых литературных цитат.
  Future<Result<List<LiteraryQuoteEntity>>> getFamousQuotes({
    String? dialect,
  });

  /// Сохранить отметку о прочтении произведения.
  Future<Result<void>> recordWorkRead({
    required String workId,
    required int passagesRead,
  });
}
