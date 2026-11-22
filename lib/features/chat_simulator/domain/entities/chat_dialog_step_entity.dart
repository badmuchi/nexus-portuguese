import 'package:equatable/equatable.dart';
import 'chat_message_entity.dart';
import 'chat_user_choice_entity.dart';

/// Шаг диалога в ветвящейся переписке.
class ChatDialogStepEntity extends Equatable {
  final String stepId;
  final List<ChatMessageEntity> incomingMessages;
  final List<ChatUserChoiceEntity> choices;
  final bool isFinal;
  final String? concludingNoteRu;

  const ChatDialogStepEntity({
    required this.stepId,
    required this.incomingMessages,
    this.choices = const [],
    this.isFinal = false,
    this.concludingNoteRu,
  });

  @override
  List<Object?> get props => [
        stepId,
        incomingMessages,
        choices,
        isFinal,
        concludingNoteRu,
      ];
}
