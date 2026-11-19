import 'dart:convert';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/conversation/domain/entities/dialogue_models.dart';

abstract class ConversationRepository {
  Future<List<DialogueScenarioInfo>> getScenarios();
  Future<DialogueNodeEntity?> getNode(String id);
  Future<void> recordChoice(String nodeId, String optionId);
}

class ConversationRepositoryImpl implements ConversationRepository {
  final AppDatabase _db;

  ConversationRepositoryImpl(this._db);

  @override
  Future<List<DialogueScenarioInfo>> getScenarios() async {
    final rows = await _db.getAllDialogueNodes();
    final scenarioMap = <String, DialogueScenarioInfo>{};

    for (final row in rows) {
      if (!scenarioMap.containsKey(row.scenarioId)) {
        scenarioMap[row.scenarioId] = DialogueScenarioInfo(
          id: row.scenarioId,
          title: row.scenarioTitle,
          category: row.scenarioCategory,
          dialect: row.dialect,
          startNodeId: row.id,
        );
      }
    }
    return scenarioMap.values.toList();
  }

  @override
  Future<DialogueNodeEntity?> getNode(String id) async {
    final row = await _db.getDialogueNodeById(id);
    if (row == null) return null;

    final optionsList = (jsonDecode(row.optionsJson) as List<dynamic>?)
            ?.map((e) => DialogueOption.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return DialogueNodeEntity(
      id: row.id,
      speakerPortuguese: row.speakerPortuguese,
      speakerRussian: row.speakerRussian,
      linePortuguese: row.linePortuguese,
      lineRussian: row.lineRussian,
      audioPath: row.audioPath,
      scenarioId: row.scenarioId,
      scenarioTitle: row.scenarioTitle,
      scenarioCategory: row.scenarioCategory,
      dialect: row.dialect,
      options: optionsList,
    );
  }

  @override
  Future<void> recordChoice(String nodeId, String optionId) async {
    await _db.insertDialogueHistory(
      nodeId: nodeId,
      selectedOptionId: optionId,
      answeredAt: DateTime.now(),
    );
  }
}
