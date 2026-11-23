import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/art_entities.dart';

abstract class ArtRepository {
  /// Получить список произведений искусства с опциональной фильтрацией по эпохе и диалекту.
  Future<Result<List<ArtworkEntity>>> getArtworks({
    ArtPeriod? period,
    String? dialect,
  });

  /// Получить произведение по идентификатору.
  Future<Result<ArtworkEntity>> getArtworkById(String id);

  /// Получить каталог художественных направлений и техник.
  Future<Result<List<ArtStyleEntity>>> getArtStyles();

  /// Получить вопросы викторины об искусстве.
  Future<Result<List<ArtQuizQuestion>>> getArtQuizzes();

  /// Записать просмотр произведения и аудиоэкскурсии в историю обучения.
  Future<Result<void>> recordArtworkViewed(String artworkId);

  /// Добавить искусствоведческий термин в интервальное повторение FSRS.
  Future<Result<void>> addArtVocabToSrs(ArtVocabEntity vocab, {String dialect = 'all'});
}
