import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/architecture_entities.dart';

abstract class ArchitectureRepository {
  /// Получить каталог архитектурных памятников с опциональной фильтрацией по категории и диалекту.
  Future<Result<List<ArchitecturalMonumentEntity>>> getMonuments({
    ArchitectureCategory? category,
    String? dialect,
  });

  /// Получить архитектурный памятник по идентификатору.
  Future<Result<ArchitecturalMonumentEntity>> getMonumentById(String id);

  /// Получить каталог архитектурных стилей и школ.
  Future<Result<List<ArchitecturalStyleEntity>>> getArchitecturalStyles();

  /// Получить вопросы викторины об архитектуре и урбанистике.
  Future<Result<List<ArchitectureQuizQuestion>>> getArchitectureQuizzes();

  /// Записать изучение архитектурного памятника в историю обучения.
  Future<Result<void>> recordMonumentViewed(String monumentId);

  /// Добавить архитектурный термин в систему интервального повторения FSRS.
  Future<Result<void>> addArchitectureVocabToSrs(
    ArchitectVocabEntity vocab, {
    String dialect = 'all',
  });
}
