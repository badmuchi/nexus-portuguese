import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/duel_question_entity.dart';
import '../../domain/entities/duel_session_result_entity.dart';
import '../../domain/repositories/duels_repository.dart';
import 'duels_state.dart';

class DuelsCubit extends Cubit<DuelsState> {
  final DuelsRepository _repository;
  final HybridAudioPlaybackService _audioService;
  Timer? _questionTimer;

  DuelsCubit({
    required DuelsRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(const DuelsState());

  void setCategory(DuelCategory? category) {
    if (category == null) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategory: category));
    }
  }

  void setQuestionsCount(int count) {
    emit(state.copyWith(questionsCount: count));
  }

  Future<void> startDuel() async {
    _questionTimer?.cancel();
    emit(state.copyWith(status: DuelsStatus.loading));

    final result = await _repository.getQuestions(
      category: state.selectedCategory,
      count: state.questionsCount,
    );

    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: DuelsStatus.inProgress,
        questions: result.value,
        currentIndex: 0,
        score: 0,
        correctAnswers: 0,
        currentStreak: 0,
        maxStreak: 0,
        clearSelection: true,
        remainingSeconds: 15,
      ));
      _startQuestionTimer();
    } else {
      emit(state.copyWith(
        status: DuelsStatus.error,
        errorMessage: result.failure?.message ?? 'Не удалось загрузить вопросы',
      ));
    }
  }

  void selectAnswer(int optionIndex) {
    if (state.status != DuelsStatus.inProgress) return;
    _questionTimer?.cancel();

    final question = state.currentQuestion;
    if (question == null) return;

    final isCorrect = question.checkAnswer(optionIndex);
    final newStreak = isCorrect ? state.currentStreak + 1 : 0;
    final maxStreak = newStreak > state.maxStreak ? newStreak : state.maxStreak;
    final points = isCorrect ? (100 * state.comboMultiplier + state.remainingSeconds * 10) : 0;
    final newScore = state.score + points;
    final newCorrect = state.correctAnswers + (isCorrect ? 1 : 0);

    emit(state.copyWith(
      status: DuelsStatus.answered,
      selectedAnswerIndex: optionIndex,
      isCorrect: isCorrect,
      currentStreak: newStreak,
      maxStreak: maxStreak,
      score: newScore,
      correctAnswers: newCorrect,
    ));

    // Озвучиваем правильный ответ
    playOptionPronunciation(question.correctAnswer, isPtPt: question.isTargetPtPt);
  }

  void _onTimeExpired() {
    if (state.status != DuelsStatus.inProgress) return;
    _questionTimer?.cancel();

    emit(state.copyWith(
      status: DuelsStatus.answered,
      selectedAnswerIndex: -1, // тайм-аут
      isCorrect: false,
      currentStreak: 0,
    ));
  }

  void nextQuestion() {
    _questionTimer?.cancel();

    if (state.currentIndex < state.questions.length - 1) {
      emit(state.copyWith(
        status: DuelsStatus.inProgress,
        currentIndex: state.currentIndex + 1,
        clearSelection: true,
        remainingSeconds: 15,
      ));
      _startQuestionTimer();
    } else {
      _finishDuel();
    }
  }

  Future<void> _finishDuel() async {
    _questionTimer?.cancel();

    final sessionResult = DuelSessionResultEntity.evaluate(
      total: state.questions.length,
      correct: state.correctAnswers,
      score: state.score,
      maxStreak: state.maxStreak,
    );

    emit(state.copyWith(
      status: DuelsStatus.completed,
      sessionResult: sessionResult,
    ));

    await _repository.saveDuelResult(sessionResult);
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
      } else {
        timer.cancel();
        _onTimeExpired();
      }
    });
  }

  void playOptionPronunciation(String text, {required bool isPtPt}) {
    final dialect = isPtPt ? PortugueseDialect.european : PortugueseDialect.brazilian;
    _audioService.playAudioOrSpeak(
      fallbackText: text,
      dialect: dialect,
    );
  }

  void resetToLobby() {
    _questionTimer?.cancel();
    emit(state.copyWith(
      status: DuelsStatus.lobby,
      clearSelection: true,
    ));
  }

  @override
  Future<void> close() {
    _questionTimer?.cancel();
    return super.close();
  }
}
