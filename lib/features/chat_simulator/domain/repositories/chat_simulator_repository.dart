import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/chat_scenario_entity.dart';

abstract class ChatSimulatorRepository {
  /// Получить список всех сценариев переписки с опциональным фильтром по диалекту.
  Future<Result<List<ChatScenarioEntity>>> getScenarios({String? dialect});

  /// Получить конкретный сценарий по идентификатору.
  Future<Result<ChatScenarioEntity>> getScenarioById(String id);

  /// Сохранить результат прохождения сценария в историю активности Drift.
  Future<Result<void>> recordScenarioCompleted({
    required String scenarioId,
    required int score,
    required int totalChoices,
  });
}
