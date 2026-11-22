import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/cinema_quote_entity.dart';
import '../entities/movie_scene_entity.dart';

abstract class CinemaRepository {
  /// Получить список всех кинематографических сцен с фильтрацией.
  Future<Result<List<MovieSceneEntity>>> getScenes({
    String? dialect,
    String? genre,
  });

  /// Получить сцену по ID.
  Future<Result<MovieSceneEntity>> getSceneById(String id);

  /// Получить культовые цитаты из фильмов.
  Future<Result<List<CinemaQuoteEntity>>> getFamousQuotes({
    String? dialect,
  });

  /// Зафиксировать завершение прослушивания и разбора сцены.
  Future<Result<void>> recordSceneCompleted({
    required String sceneId,
    required int linesPracticed,
  });
}
