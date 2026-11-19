import 'package:equatable/equatable.dart';

class DialogueOption extends Equatable {
  final String id;
  final String textPortuguese;
  final String textRussian;
  final String? nextNodeId;
  final String? notes;

  const DialogueOption({
    required this.id,
    required this.textPortuguese,
    required this.textRussian,
    this.nextNodeId,
    this.notes,
  });

  factory DialogueOption.fromJson(Map<String, dynamic> json) {
    return DialogueOption(
      id: json['id'] as String,
      textPortuguese: json['text_portuguese'] as String,
      textRussian: json['text_russian'] as String,
      nextNodeId: json['next_node_id'] as String?,
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, textPortuguese, textRussian, nextNodeId, notes];
}

class DialogueNodeEntity extends Equatable {
  final String id;
  final String speakerPortuguese;
  final String speakerRussian;
  final String linePortuguese;
  final String lineRussian;
  final String? audioPath;
  final String scenarioId;
  final String scenarioTitle;
  final String scenarioCategory;
  final String dialect;
  final List<DialogueOption> options;

  const DialogueNodeEntity({
    required this.id,
    required this.speakerPortuguese,
    required this.speakerRussian,
    required this.linePortuguese,
    required this.lineRussian,
    this.audioPath,
    required this.scenarioId,
    required this.scenarioTitle,
    required this.scenarioCategory,
    required this.dialect,
    required this.options,
  });

  @override
  List<Object?> get props => [
        id,
        speakerPortuguese,
        speakerRussian,
        linePortuguese,
        lineRussian,
        audioPath,
        scenarioId,
        scenarioTitle,
        scenarioCategory,
        dialect,
        options,
      ];
}

class DialogueScenarioInfo extends Equatable {
  final String id;
  final String title;
  final String category;
  final String dialect;
  final String startNodeId;

  const DialogueScenarioInfo({
    required this.id,
    required this.title,
    required this.category,
    required this.dialect,
    required this.startNodeId,
  });

  @override
  List<Object?> get props => [id, title, category, dialect, startNodeId];
}
