import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/survival_quest_entity.dart';
import '../../domain/repositories/survival_guide_repository.dart';
import 'survival_quest_state.dart';

class SurvivalQuestCubit extends Cubit<SurvivalQuestState> {
  final SurvivalGuideRepository _repository;
  final HybridAudioPlaybackService _audioService;

  SurvivalQuestCubit({
    required SurvivalQuestEntity quest,
    required SurvivalGuideRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(SurvivalQuestState(quest: quest));

  void selectOption(int optionIndex) {
    if (state.isAnswered) return;

    final step = state.currentStep;
    if (optionIndex < 0 || optionIndex >= step.options.length) return;

    final option = step.options[optionIndex];
    final newScore = option.isOptimal ? state.score + 1 : state.score;

    emit(state.copyWith(
      selectedOptionIndex: optionIndex,
      isAnswered: true,
      score: newScore,
    ));
  }

  void nextStep() {
    if (!state.isAnswered) return;

    if (state.isLastStep) {
      emit(state.copyWith(isCompleted: true));
      _repository.recordQuestCompleted(
        questId: state.quest.id,
        score: state.score,
        totalSteps: state.quest.steps.length,
      );
    } else {
      emit(state.copyWith(
        currentStepIndex: state.currentStepIndex + 1,
        isAnswered: false,
        clearSelectedOption: true,
      ));
    }
  }

  void playPromptAudio() {
    final dialect = state.quest.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    _audioService.playAudioOrSpeak(
      fallbackText: state.currentStep.promptPt,
      dialect: dialect,
    );
  }

  void playOptionAudio(String text) {
    final dialect = state.quest.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    _audioService.playAudioOrSpeak(
      fallbackText: text,
      dialect: dialect,
    );
  }

  void restart() {
    emit(SurvivalQuestState(quest: state.quest));
  }
}
