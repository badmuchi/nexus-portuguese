import 'package:equatable/equatable.dart';
import 'chat_dialog_step_entity.dart';

/// Сценарий реалистичной переписки в мессенджере.
class ChatScenarioEntity extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final String channelName;
  final String contactName;
  final String contactStatus;
  final String avatarEmoji;
  final String dialect; // 'pt_BR' или 'pt_PT'
  final String cefrLevel; // 'A2', 'B1', 'B2'
  final String scenarioContextRu;
  final String initialStepId;
  final Map<String, ChatDialogStepEntity> steps;

  const ChatScenarioEntity({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.channelName,
    required this.contactName,
    this.contactStatus = 'online',
    required this.avatarEmoji,
    required this.dialect,
    required this.cefrLevel,
    required this.scenarioContextRu,
    required this.initialStepId,
    required this.steps,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : '🇧🇷';
  String get dialectLabel => isPtPt ? 'Portugal' : 'Brasil';

  ChatDialogStepEntity? getStep(String stepId) => steps[stepId];

  @override
  List<Object?> get props => [
        id,
        titlePt,
        titleRu,
        channelName,
        contactName,
        contactStatus,
        avatarEmoji,
        dialect,
        cefrLevel,
        scenarioContextRu,
        initialStepId,
        steps,
      ];
}
