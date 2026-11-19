import 'package:equatable/equatable.dart';
import '../../domain/entities/dialogue_models.dart';

class DialogueMessageItem extends Equatable {
  final String speaker;
  final String textPortuguese;
  final String textRussian;
  final bool isUser;
  final String? audioPath;

  const DialogueMessageItem({
    required this.speaker,
    required this.textPortuguese,
    required this.textRussian,
    required this.isUser,
    this.audioPath,
  });

  @override
  List<Object?> get props => [speaker, textPortuguese, textRussian, isUser, audioPath];
}

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationActive extends ConversationState {
  final List<DialogueScenarioInfo> scenarios;
  final DialogueScenarioInfo activeScenario;
  final DialogueNodeEntity currentNode;
  final List<DialogueMessageItem> history;
  final bool isFinished;

  const ConversationActive({
    required this.scenarios,
    required this.activeScenario,
    required this.currentNode,
    required this.history,
    this.isFinished = false,
  });

  ConversationActive copyWith({
    List<DialogueScenarioInfo>? scenarios,
    DialogueScenarioInfo? activeScenario,
    DialogueNodeEntity? currentNode,
    List<DialogueMessageItem>? history,
    bool? isFinished,
  }) {
    return ConversationActive(
      scenarios: scenarios ?? this.scenarios,
      activeScenario: activeScenario ?? this.activeScenario,
      currentNode: currentNode ?? this.currentNode,
      history: history ?? this.history,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  List<Object?> get props => [scenarios, activeScenario, currentNode, history, isFinished];
}

class ConversationError extends ConversationState {
  final String message;
  const ConversationError(this.message);

  @override
  List<Object?> get props => [message];
}
