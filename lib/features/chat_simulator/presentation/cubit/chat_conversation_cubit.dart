import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/chat_abbreviation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_scenario_entity.dart';
import '../../domain/entities/chat_user_choice_entity.dart';
import '../../domain/repositories/chat_simulator_repository.dart';
import 'chat_conversation_state.dart';

class ChatConversationCubit extends Cubit<ChatConversationState> {
  final ChatSimulatorRepository _repository;
  final HybridAudioPlaybackService _audioService;
  Timer? _typingTimer;

  ChatConversationCubit({
    required ChatScenarioEntity scenario,
    required ChatSimulatorRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(ChatConversationState(
          scenario: scenario,
          currentStepId: scenario.initialStepId,
        )) {
    _initConversation();
  }

  void _initConversation() {
    final firstStep = state.scenario.getStep(state.scenario.initialStepId);
    if (firstStep != null) {
      emit(state.copyWith(
        messages: List<ChatMessageEntity>.from(firstStep.incomingMessages),
      ));
    }
  }

  void selectChoice(ChatUserChoiceEntity choice) {
    _typingTimer?.cancel();

    // 1. Создаем сообщение пользователя
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final userMsg = ChatMessageEntity(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user',
      senderName: 'Você',
      textPt: choice.textPt,
      translationRu: choice.translationRu,
      isUser: true,
      timestampStr: timeStr,
      abbreviations: choice.abbreviations,
    );

    final updatedMessages = List<ChatMessageEntity>.from(state.messages)..add(userMsg);
    final newScore = choice.isNaturalChoice ? state.score + 1 : state.score;
    final newTotal = state.totalChoicesMade + 1;

    emit(state.copyWith(
      messages: updatedMessages,
      score: newScore,
      totalChoicesMade: newTotal,
      lastFeedbackNote: choice.feedbackNoteRu,
      lastSelectedChoice: choice,
      isTyping: true,
    ));

    // 2. Симулируем задержку набора текста собеседником
    _typingTimer = Timer(const Duration(milliseconds: 700), () {
      _advanceToStep(choice.nextStepId);
    });
  }

  void _advanceToStep(String stepId) {
    final nextStep = state.scenario.getStep(stepId);
    if (nextStep == null) {
      emit(state.copyWith(isTyping: false));
      return;
    }

    final updatedMessages = List<ChatMessageEntity>.from(state.messages)
      ..addAll(nextStep.incomingMessages);

    final isDone = nextStep.isFinal;

    emit(state.copyWith(
      currentStepId: stepId,
      messages: updatedMessages,
      isTyping: false,
      isCompleted: isDone,
      concludingNote: nextStep.concludingNoteRu,
    ));

    if (isDone) {
      _repository.recordScenarioCompleted(
        scenarioId: state.scenario.id,
        score: state.score,
        totalChoices: state.totalChoicesMade,
      );
    }
  }

  void playVoiceNote(ChatMessageEntity message) {
    final dialect = state.scenario.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    emit(state.copyWith(
      isPlayingVoiceNote: true,
      playingVoiceMessageId: message.id,
    ));

    _audioService.playAudioOrSpeak(
      fallbackText: message.textPt,
      dialect: dialect,
    );

    // Авто-сброс статуса через длительность сообщения
    final durationSeconds = message.voiceDurationSeconds > 0 ? message.voiceDurationSeconds : 5;
    Timer(Duration(seconds: durationSeconds), () {
      if (state.playingVoiceMessageId == message.id) {
        emit(state.copyWith(
          isPlayingVoiceNote: false,
          clearPlayingVoice: true,
        ));
      }
    });
  }

  void stopVoiceNote() {
    _audioService.stop();
    emit(state.copyWith(
      isPlayingVoiceNote: false,
      clearPlayingVoice: true,
    ));
  }

  void showAbbreviation(ChatAbbreviation abbr) {
    emit(state.copyWith(selectedAbbreviation: abbr));
  }

  void clearAbbreviation() {
    emit(state.copyWith(clearSelectedAbbreviation: true));
  }

  void toggleTranslation() {
    emit(state.copyWith(showTranslation: !state.showTranslation));
  }

  void dismissFeedback() {
    emit(state.copyWith(clearLastFeedback: true));
  }

  void restartScenario() {
    _typingTimer?.cancel();
    _audioService.stop();

    final firstStep = state.scenario.getStep(state.scenario.initialStepId);
    emit(ChatConversationState(
      scenario: state.scenario,
      currentStepId: state.scenario.initialStepId,
      messages: firstStep != null ? List<ChatMessageEntity>.from(firstStep.incomingMessages) : const [],
      showTranslation: state.showTranslation,
    ));
  }

  @override
  Future<void> close() {
    _typingTimer?.cancel();
    _audioService.stop();
    return super.close();
  }
}
