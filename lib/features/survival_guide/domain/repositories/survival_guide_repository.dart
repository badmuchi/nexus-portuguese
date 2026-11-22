import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/cultural_tip_entity.dart';
import '../entities/survival_phrase_entity.dart';
import '../entities/survival_quest_entity.dart';

abstract class SurvivalGuideRepository {
  /// Получить интерактивные квесты с фильтрами по категории и диалекту.
  Future<Result<List<SurvivalQuestEntity>>> getQuests({
    SurvivalCategory? category,
    String? dialect,
  });

  /// Получить конкретный квест по ID.
  Future<Result<SurvivalQuestEntity>> getQuestById(String id);

  /// Получить экспресс-фразы из шпаргалок.
  Future<Result<List<SurvivalPhraseEntity>>> getPhrases({
    SurvivalCategory? category,
    String? dialect,
    bool? emergencyOnly,
  });

  /// Получить практические советы по выживанию и этикету.
  Future<Result<List<CulturalTipEntity>>> getTips({
    SurvivalCategory? category,
    String? dialect,
  });

  /// Записать результат прохождения квеста в историю базы данных Drift.
  Future<Result<void>> recordQuestCompleted({
    required String questId,
    required int score,
    required int totalSteps,
  });
}
