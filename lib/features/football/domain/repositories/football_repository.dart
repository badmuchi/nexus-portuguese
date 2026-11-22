import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/football_entities.dart';

abstract class FootballRepository {
  /// Получить матчи для симулятора комментатора.
  Future<Result<List<FootballMatchEntity>>> getMatches({
    String? dialect,
  });

  /// Получить матч по ID.
  Future<Result<FootballMatchEntity>> getMatchById(String id);

  /// Получить футбольные термины (сравнение PT-PT vs PT-BR).
  Future<Result<List<FootballTermEntity>>> getFootballTerms({
    FootballTermCategory? category,
  });

  /// Получить кричалки торсид.
  Future<Result<List<FanChantEntity>>> getFanChants({
    String? dialect,
  });

  /// Получить вопросы квиза «Quiz da Pelada».
  Future<Result<List<FootballQuizQuestion>>> getQuizQuestions();

  /// Записать результат прохождения симулятора матча.
  Future<Result<void>> recordMatchPractice({
    required String matchId,
    required int momentsPracticed,
  });
}
