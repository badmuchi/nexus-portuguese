import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/business_phrase_entity.dart';
import '../entities/cv_guide_item_entity.dart';
import '../entities/interview_question_entity.dart';
import '../entities/interview_scenario_entity.dart';

abstract class CareerRepository {
  /// Получить список сценариев собеседований с опциональными фильтрами.
  Future<Result<List<InterviewScenarioEntity>>> getScenarios({
    CareerCategory? category,
    String? dialect,
  });

  /// Получить сценарий собеседования по идентификатору.
  Future<Result<InterviewScenarioEntity>> getScenarioById(String id);

  /// Получить профессиональные фразы, глаголы и шаблоны писем.
  Future<Result<List<BusinessPhraseEntity>>> getPhrases({
    BusinessPhraseType? phraseType,
    CareerCategory? category,
    String? dialect,
  });

  /// Получить руководство по составлению резюме и трудовым режимам.
  Future<Result<List<CvGuideItemEntity>>> getCvGuides({
    String? dialect,
  });

  /// Сохранить прохождение собеседования в историю активности базы данных Drift.
  Future<Result<void>> recordInterviewCompleted({
    required String scenarioId,
    required int score,
    required int maxScore,
  });
}
