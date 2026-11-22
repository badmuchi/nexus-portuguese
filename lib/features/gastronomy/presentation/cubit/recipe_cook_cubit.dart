import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/gastronomy_repository.dart';
import 'recipe_cook_state.dart';

class RecipeCookCubit extends Cubit<RecipeCookState> {
  final GastronomyRepository _repository;
  final HybridAudioPlaybackService _audioService;
  Timer? _countdownTimer;

  RecipeCookCubit({
    required RecipeEntity recipe,
    required GastronomyRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(RecipeCookState(
          recipe: recipe,
          remainingTimerSeconds: recipe.steps.isNotEmpty && recipe.steps.first.timerSeconds != null
              ? recipe.steps.first.timerSeconds!
              : 0,
        ));

  void toggleIngredient(String id) {
    final updated = Set<String>.from(state.checkedIngredientIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    emit(state.copyWith(checkedIngredientIds: updated));
  }

  void checkAllIngredients() {
    final allIds = state.recipe.ingredients.map((i) => i.id).toSet();
    emit(state.copyWith(checkedIngredientIds: allIds));
  }

  void nextStep() {
    _cancelTimer();

    if (state.isLastStep) {
      emit(state.copyWith(
        isRecipeCompleted: true,
        isTimerRunning: false,
      ));
      _repository.recordRecipeCompleted(
        recipeId: state.recipe.id,
        timeSpentMinutes: state.recipe.prepTimeMinutes,
      );
    } else {
      final nextIdx = state.currentStepIndex + 1;
      final nextTimerSecs = state.recipe.steps[nextIdx].timerSeconds ?? 0;
      emit(state.copyWith(
        currentStepIndex: nextIdx,
        remainingTimerSeconds: nextTimerSecs,
        isTimerRunning: false,
        isTimerFinished: false,
      ));
    }
  }

  void previousStep() {
    if (state.currentStepIndex == 0) return;
    _cancelTimer();

    final prevIdx = state.currentStepIndex - 1;
    final prevTimerSecs = state.recipe.steps[prevIdx].timerSeconds ?? 0;
    emit(state.copyWith(
      currentStepIndex: prevIdx,
      remainingTimerSeconds: prevTimerSecs,
      isTimerRunning: false,
      isTimerFinished: false,
    ));
  }

  void startTimer() {
    if (state.isTimerRunning) return;
    final initialSeconds = state.remainingTimerSeconds > 0
        ? state.remainingTimerSeconds
        : (state.currentStep.timerSeconds ?? 0);

    if (initialSeconds <= 0) return;

    emit(state.copyWith(
      isTimerRunning: true,
      remainingTimerSeconds: initialSeconds,
      isTimerFinished: false,
    ));

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTimerSeconds <= 1) {
        timer.cancel();
        emit(state.copyWith(
          remainingTimerSeconds: 0,
          isTimerRunning: false,
          isTimerFinished: true,
        ));
        _playAlertAudio();
      } else {
        emit(state.copyWith(
          remainingTimerSeconds: state.remainingTimerSeconds - 1,
        ));
      }
    });
  }

  void pauseTimer() {
    _countdownTimer?.cancel();
    emit(state.copyWith(isTimerRunning: false));
  }

  void resetTimer() {
    _cancelTimer();
    final defaultSecs = state.currentStep.timerSeconds ?? 0;
    emit(state.copyWith(
      remainingTimerSeconds: defaultSecs,
      isTimerRunning: false,
      isTimerFinished: false,
    ));
  }

  void playStepAudio() {
    final dialect = state.recipe.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    _audioService.playAudioOrSpeak(
      fallbackText: state.currentStep.instructionPt,
      dialect: dialect,
    );
  }

  void playIngredientAudio(String text) {
    final dialect = state.recipe.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    _audioService.playAudioOrSpeak(
      fallbackText: text,
      dialect: dialect,
    );
  }

  void restartCooking() {
    _cancelTimer();
    final defaultSecs = state.recipe.steps.isNotEmpty && state.recipe.steps.first.timerSeconds != null
        ? state.recipe.steps.first.timerSeconds!
        : 0;

    emit(RecipeCookState(
      recipe: state.recipe,
      checkedIngredientIds: state.checkedIngredientIds,
      remainingTimerSeconds: defaultSecs,
    ));
  }

  void _playAlertAudio() {
    final dialect = state.recipe.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    _audioService.playAudioOrSpeak(
      fallbackText: 'O tempo terminou! Muito bem!',
      dialect: dialect,
    );
  }

  void _cancelTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
