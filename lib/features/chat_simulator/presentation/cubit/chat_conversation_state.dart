import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_abbreviation_entity.dart';
import '../../domain/entities/chat_dialog_step_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_scenario_entity.dart';
import '../../domain/entities/chat_user_choice_entity.dart';

class ChatConversationState extends Equatable {
  final ChatScenarioEntity scenario;
  final String currentStepId;
  final List<ChatMessageEntity> messages;
  final bool isTyping;
  final bool showTranslation;
  final int score;
  final int totalChoicesMade;
  final String? lastFeedbackNote;
  final ChatUserChoiceEntity? lastSelectedChoice;
  final ChatAbbreviation? selectedAbbreviation;
  final bool isPlayingVoiceNote;
  final String? playingVoiceMessageId;
  final bool isCompleted;
  final String? concludingNote;

  const ChatConversationState({
    required this.scenario,
    required this.currentStepId,
    this.messages = const [],
    this.isTyping = false,
    this.showTranslation = true,
    this.score = 0,
    this.totalChoicesMade = 0,
    this.lastFeedbackNote,
    this.lastSelectedChoice,
    this.selectedAbbreviation,
    this.isPlayingVoiceNote = false,
    this.playingVoiceMessageId,
    this.isCompleted = false,
    this.concludingNote,
  });

  ChatDialogStepEntity? get currentStep => scenario.getStep(currentStepId);
  List<ChatUserChoiceEntity> get currentChoices => currentStep?.choices ?? const [];
  bool get hasChoices => currentChoices.isNotEmpty && !isTyping;

  ChatConversationState copyWith({
    ChatScenarioEntity? scenario,
    String? currentStepId,
    List<ChatMessageEntity>? messages,
    bool? isTyping,
    bool? showTranslation,
    int? score,
    int? totalChoicesMade,
    String? lastFeedbackNote,
    bool clearLastFeedback = false,
    ChatUserChoiceEntity? lastSelectedChoice,
    ChatAbbreviation? selectedAbbreviation,
    bool clearSelectedAbbreviation = false,
    bool? isPlayingVoiceNote,
    String? playingVoiceMessageId,
    bool clearPlayingVoice = false,
    bool? isCompleted,
    String? concludingNote,
  }) {
    return ChatConversationState(
      scenario: scenario ?? this.scenario,
      currentStepId: currentStepId ?? this.currentStepId,
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      showTranslation: showTranslation ?? this.showTranslation,
      score: score ?? this.score,
      totalChoicesMade: totalChoicesMade ?? this.totalChoicesMade,
      lastFeedbackNote: clearLastFeedback ? null : (lastFeedbackNote ?? this.lastFeedbackNote),
      lastSelectedChoice: clearLastFeedback ? null : (lastSelectedChoice ?? this.lastSelectedChoice),
      selectedAbbreviation: clearSelectedAbbreviation
          ? null
          : (selectedAbbreviation ?? this.selectedAbbreviation),
      isPlayingVoiceNote: isPlayingVoiceNote ?? this.isPlayingVoiceNote,
      playingVoiceMessageId: clearPlayingVoice ? null : (playingVoiceMessageId ?? this.playingVoiceMessageId),
      isCompleted: isCompleted ?? this.isCompleted,
      concludingNote: concludingNote ?? this.concludingNote,
    );
  }

  @override
  List<Object?> get props => [
        scenario,
        currentStepId,
        messages,
        isTyping,
        showTranslation,
        score,
        totalChoicesMade,
        lastFeedbackNote,
        lastSelectedChoice,
        selectedAbbreviation,
        isPlayingVoiceNote,
        playingVoiceMessageId,
        isCompleted,
        concludingNote,
      ];
}
