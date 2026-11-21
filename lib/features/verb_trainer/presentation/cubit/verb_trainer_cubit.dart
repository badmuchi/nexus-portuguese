import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../srs/data/repositories/srs_repository_impl.dart';
import '../../../srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/verb_exercise.dart';
import '../../domain/entities/verb_trainer_config.dart';
import '../../domain/entities/verb_trainer_session_result.dart';
import '../../domain/repositories/verb_trainer_repository.dart';
import 'verb_trainer_state.dart';

class VerbTrainerCubit extends Cubit<VerbTrainerState> {
  final VerbTrainerRepository repository;
  final HybridAudioPlaybackService? audioService;
  final SrsRepository? srsRepository;

  Timer? _sprintTimer;

  VerbTrainerCubit({
    required this.repository,
    this.audioService,
    this.srsRepository,
  }) : super(const VerbTrainerInitial());

  Future<void> startSession(VerbTrainerConfig config) async {
    _sprintTimer?.cancel();
    emit(const VerbTrainerLoading());

    try {
      final int count;
      switch (config.mode) {
        case TrainerMode.sprint60:
          count = 40; // generous pool for 60s
          break;
        case TrainerMode.drill15:
          count = 15;
          break;
        case TrainerMode.marathon30:
          count = 30;
          break;
      }

      final exercisesResult = await repository.generateExercises(
        config: config,
        count: count,
      );

      if (!exercisesResult.isOk || exercisesResult.value.isEmpty) {
        emit(const VerbTrainerError('Не удалось сформировать упражнения для выбранных настроек'));
        return;
      }

      final isSprint = config.mode == TrainerMode.sprint60;
      final remaining = isSprint ? 60 : null;

      emit(
        VerbTrainerActive(
          exercises: exercisesResult.value,
          currentIndex: 0,
          scorePoints: 0,
          currentStreak: 0,
          maxStreak: 0,
          correctCount: 0,
          totalAttempts: 0,
          remainingSeconds: remaining,
          selectedOption: null,
          isChecked: false,
          mistakes: const [],
          config: config,
        ),
      );

      if (isSprint) {
        _startSprintTimer();
      }
    } catch (e) {
      emit(VerbTrainerError('Ошибка при запуске тренажёра: $e'));
    }
  }

  void _startSprintTimer() {
    _sprintTimer?.cancel();
    _sprintTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final s = state;
      if (s is! VerbTrainerActive) {
        timer.cancel();
        return;
      }

      final currentSec = s.remainingSeconds ?? 0;
      if (currentSec <= 1) {
        timer.cancel();
        finishSession();
      } else {
        emit(s.copyWith(remainingSeconds: currentSec - 1));
      }
    });
  }

  void selectOption(String option) {
    final s = state;
    if (s is! VerbTrainerActive || s.isChecked) return;

    final isCorrect = s.currentExercise.isCorrect(option);
    final newAttempts = s.totalAttempts + 1;
    final newCorrect = isCorrect ? s.correctCount + 1 : s.correctCount;
    final newStreak = isCorrect ? s.currentStreak + 1 : 0;
    final newMaxStreak = max(s.maxStreak, newStreak);

    // Combo points multiplier: 1x to 5x based on streak
    final comboMultiplier = isCorrect ? min(newStreak, 5) : 0;
    final pointsGained = isCorrect ? (10 * comboMultiplier) : 0;
    final newScore = s.scorePoints + pointsGained;

    final newMistakes = List<VerbExercise>.from(s.mistakes);
    if (!isCorrect) {
      newMistakes.add(s.currentExercise);
    }

    emit(
      s.copyWith(
        selectedOption: option,
        isChecked: true,
        totalAttempts: newAttempts,
        correctCount: newCorrect,
        currentStreak: newStreak,
        maxStreak: newMaxStreak,
        scorePoints: newScore,
        mistakes: newMistakes,
      ),
    );

    // Record attempt asynchronously in background
    repository.recordAttempt(
      verbId: s.currentExercise.verbId,
      tense: s.currentExercise.tense.id,
      person: s.currentExercise.person.raw,
      isCorrect: isCorrect,
    );
  }

  Future<void> playCurrentAudio() async {
    final s = state;
    if (s is! VerbTrainerActive) return;

    emit(s.copyWith(isPlayingAudio: true));
    try {
      await audioService?.playAudioOrSpeak(fallbackText: s.currentExercise.audioPhrase);
    } finally {
      if (state is VerbTrainerActive) {
        emit((state as VerbTrainerActive).copyWith(isPlayingAudio: false));
      }
    }
  }

  void nextExercise() {
    final s = state;
    if (s is! VerbTrainerActive) return;

    if (s.isLastQuestion) {
      finishSession();
    } else {
      emit(
        s.copyWith(
          currentIndex: s.currentIndex + 1,
          isChecked: false,
          clearSelectedOption: true,
        ),
      );
    }
  }

  void finishSession() {
    _sprintTimer?.cancel();
    final s = state;
    if (s is! VerbTrainerActive) return;

    final sessionResult = VerbTrainerSessionResult.evaluate(
      totalAttempts: s.totalAttempts,
      correctCount: s.correctCount,
      maxStreak: s.maxStreak,
      scorePoints: s.scorePoints,
      mistakes: s.mistakes,
      mode: s.config.mode,
    );

    emit(VerbTrainerCompleted(result: sessionResult));
  }

  Future<void> saveMistakesToFsrs() async {
    final s = state;
    if (s is! VerbTrainerCompleted || s.isSavingToFsrs || srsRepository == null) return;

    emit(s.copyWith(isSavingToFsrs: true));
    try {
      int addedCount = 0;
      final now = DateTime.now();

      for (int i = 0; i < s.result.mistakes.length; i++) {
        final mistake = s.result.mistakes[i];
        final card = SrsCardEntity(
          id: 'verb_${mistake.id}_${now.millisecondsSinceEpoch}_$i',
          portuguese: mistake.audioPhrase,
          russianTranslation:
              '${mistake.infinitive} (${mistake.russianMeaning}) — ${mistake.tense.titleRu}',
          partOfSpeech: 'verb',
          category: 'verb_trainer',
          dialect: 'all',
          examplePortuguese: '${mistake.person.pronounDisplay} ${mistake.correctForm}',
          exampleRussian: mistake.explanationRu,
          fsrsState: 'newCard',
          stability: 0.0,
          difficulty: 0.0,
          reps: 0,
          lapses: 0,
          dueAt: now,
        );

        await srsRepository!.addCard(card);
        addedCount++;
      }

      emit(s.copyWith(isSavingToFsrs: false, addedToFsrsCount: addedCount));
    } catch (_) {
      emit(s.copyWith(isSavingToFsrs: false));
    }
  }

  @override
  Future<void> close() {
    _sprintTimer?.cancel();
    return super.close();
  }
}
