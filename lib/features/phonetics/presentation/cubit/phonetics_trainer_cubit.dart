import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/speech/pronunciation_accuracy_evaluator.dart';
import '../../../../core/speech/speech_recognition_service.dart';
import '../../domain/entities/phonetic_trainer_models.dart';
import '../../domain/repositories/phonetics_repository.dart';
import 'phonetics_trainer_state.dart';

class PhoneticsTrainerCubit extends Cubit<PhoneticsTrainerState> {
  final PhoneticsRepository repository;
  final HybridAudioPlaybackService audioService;
  final SpeechRecognitionService speechService;
  final Random _random = Random();
  StreamSubscription<String>? _textSub;

  PhoneticsTrainerCubit({
    required this.repository,
    required this.audioService,
    required this.speechService,
  }) : super(const PhoneticsTrainerState()) {
    _textSub = speechService.textStream.listen((text) {
      emit(state.copyWith(spokenText: text));
    });
  }

  Future<void> loadTrainer() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final exResult = await repository.getTrainerExercises();
    final masteryResult = await repository.getMasteryList();

    if (exResult.isOk) {
      final exercises = exResult.value;
      final masteryMap = <String, PhoneticMastery>{};
      if (masteryResult.isOk) {
        for (final m in masteryResult.value) {
          masteryMap[m.soundId] = m;
        }
      }

      emit(state.copyWith(
        isLoading: false,
        exercises: exercises,
        masteryMap: masteryMap,
        currentExerciseIndex: 0,
        currentPairIndex: 0,
        step: TrainerStep.theory,
        isTargetWordA: _random.nextBool(),
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: exResult.failure?.message ?? 'Ошибка загрузки тренажера',
      ));
    }
  }

  void selectExercise(int index) {
    if (index >= 0 && index < state.exercises.length) {
      emit(state.copyWith(
        currentExerciseIndex: index,
        currentPairIndex: 0,
        step: TrainerStep.theory,
        isTargetWordA: _random.nextBool(),
        clearEarSelection: true,
        clearMouthScore: true,
      ));
    }
  }

  void setStep(TrainerStep step) {
    emit(state.copyWith(
      step: step,
      clearEarSelection: true,
      clearMouthScore: true,
      isTargetWordA: _random.nextBool(),
    ));
  }

  void nextPair() {
    final ex = state.currentExercise;
    if (ex == null || ex.contrastPairs.isEmpty) return;

    final nextIdx = (state.currentPairIndex + 1) % ex.contrastPairs.length;
    emit(state.copyWith(
      currentPairIndex: nextIdx,
      isTargetWordA: _random.nextBool(),
      clearEarSelection: true,
      clearMouthScore: true,
    ));
  }

  Future<void> playWord(String word, {String locale = 'pt-BR'}) async {
    emit(state.copyWith(isPlayingAudio: true));
    try {
      final dialect = locale == 'pt-PT'
          ? PortugueseDialect.european
          : PortugueseDialect.brazilian;
      await audioService.playAudioOrSpeak(
        fallbackText: word,
        dialect: dialect,
      );
    } finally {
      emit(state.copyWith(isPlayingAudio: false));
    }
  }

  Future<void> playTargetAudio({String locale = 'pt-BR'}) async {
    final target = state.targetWord;
    if (target.isNotEmpty) {
      await playWord(target, locale: locale);
    }
  }

  Future<void> answerEarChoice(String selectedWord) async {
    if (state.earSelectedWord != null) return; // Already answered

    final isCorrect = selectedWord == state.targetWord;
    emit(state.copyWith(
      earSelectedWord: selectedWord,
      earIsCorrect: isCorrect,
    ));

    final ex = state.currentExercise;
    if (ex != null) {
      await repository.recordEarAnswer(
        soundId: ex.soundId,
        isCorrect: isCorrect,
        soundCategory: ex.soundCategory,
        title: ex.title,
      );

      // Refresh mastery
      final masteryResult = await repository.getMasteryList();
      if (masteryResult.isOk) {
        final updatedMap = <String, PhoneticMastery>{};
        for (final m in masteryResult.value) {
          updatedMap[m.soundId] = m;
        }
        emit(state.copyWith(masteryMap: updatedMap));
      }
    }
  }

  Future<void> startMouthRecording() async {
    emit(state.copyWith(
      isRecording: true,
      clearMouthScore: true,
    ));

    await speechService.startListening(localeId: 'pt-BR');
  }

  Future<void> stopMouthRecording() async {
    await speechService.stopListening();
    emit(state.copyWith(isRecording: false));

    final spoken = state.spokenText ?? '';
    final target = state.targetWord;
    final ex = state.currentExercise;

    if (target.isNotEmpty && ex != null) {
      final evalResult = PronunciationAccuracyEvaluator.evaluate(
        spokenText: spoken.isNotEmpty ? spoken : target,
        targetText: target,
      );

      final scorePercent = evalResult.score * 100.0;
      emit(state.copyWith(mouthScore: scorePercent));

      await repository.recordMouthScore(
        soundId: ex.soundId,
        scorePercent: scorePercent,
        soundCategory: ex.soundCategory,
        title: ex.title,
      );

      // Refresh mastery
      final masteryResult = await repository.getMasteryList();
      if (masteryResult.isOk) {
        final updatedMap = <String, PhoneticMastery>{};
        for (final m in masteryResult.value) {
          updatedMap[m.soundId] = m;
        }
        emit(state.copyWith(masteryMap: updatedMap));
      }
    }
  }

  @override
  Future<void> close() {
    _textSub?.cancel();
    return super.close();
  }
}
