import 'package:equatable/equatable.dart';
import 'chat_abbreviation_entity.dart';

/// Вариант ответа пользователя в симуляторе переписки.
class ChatUserChoiceEntity extends Equatable {
  final String id;
  final String textPt;
  final String translationRu;
  final bool isNaturalChoice;
  final String feedbackNoteRu;
  final String nextStepId;
  final List<ChatAbbreviation> abbreviations;

  const ChatUserChoiceEntity({
    required this.id,
    required this.textPt,
    required this.translationRu,
    required this.isNaturalChoice,
    required this.feedbackNoteRu,
    required this.nextStepId,
    this.abbreviations = const [],
  });

  @override
  List<Object?> get props => [
        id,
        textPt,
        translationRu,
        isNaturalChoice,
        feedbackNoteRu,
        nextStepId,
        abbreviations,
      ];
}
