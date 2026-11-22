import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/idiom_quiz_challenge_entity.dart';
import '../entities/portuguese_idiom_entity.dart';

abstract class IdiomsRepository {
  /// Получить каталог идиом с опциональной фильтрацией по категории и диалекту.
  Future<Result<List<PortugueseIdiom>>> getIdioms({
    IdiomCategory? category,
    String? dialect,
  });

  /// Получить идиому по id.
  Future<Result<PortugueseIdiom>> getIdiomById(String id);

  /// Сгенерировать набор вопросов для квиза по идиомам.
  Future<Result<List<IdiomQuizChallenge>>> getQuizChallenges({int count = 5});

  /// Зафиксировать результат квиза в истории базы данных.
  Future<Result<void>> recordQuizResult({required int total, required int correct});
}
