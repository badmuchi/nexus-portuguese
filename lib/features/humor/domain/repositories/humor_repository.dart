import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/humor_entities.dart';

abstract class HumorRepository {
  /// Получить все анекдоты с опциональной фильтрацией по категории и диалекту.
  Future<Result<List<JokeEntity>>> getJokes({
    JokeCategory? category,
    String? dialect,
  });

  /// Получить анекдот по идентификатору.
  Future<Result<JokeEntity>> getJokeById(String id);

  /// Получить список каламбуров и загадок-трокадилью.
  Future<Result<List<TrocadilhoEntity>>> getTrocadilhos({String? dialect});

  /// Получить список вопросов викторины "Закончи шутку".
  Future<Result<List<HumorQuizEntity>>> getHumorQuizzes();

  /// Записать реакцию пользователя на шутку (смешно / не смешно) для прогресса.
  Future<Result<void>> recordJokeReaction({
    required String jokeId,
    required bool liked,
  });

  /// Сохранить термин из шутки в интервальное повторение FSRS.
  Future<Result<void>> addWordToSrs(JokeVocabEntity vocab, {String dialect = 'all'});
}
