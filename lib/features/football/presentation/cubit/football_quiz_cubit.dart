import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/football_entities.dart';
import '../../domain/repositories/football_repository.dart';
import 'football_quiz_state.dart';

class FootballQuizCubit extends Cubit<FootballQuizState> {
  final FootballRepository _repository;
  final HybridAudioPlaybackService _audioService;

  FootballQuizCubit({
    required FootballRepository repository,
    required HybridAudioPlaybackService audioService,
    List<FootballQuizQuestion>? initialQuestions,
  })  : _repository = repository,
        _audioService = audioService,
        super(FootballQuizState(questions: initialQuestions ?? const []));

  Future<void> loadQuestions() async {
    final res = await _repository.getQuizQuestions();
    if (res.isOk && res.value.isNotEmpty) {
      emit(state.copyWith(
        questions: res.value,
        currentIndex: 0,
        score: 0,
        isAnswered: false,
        isCompleted: false,
        clearSelectedOption: true,
      ));
    }
  }

  void selectOption(int optionIndex) {
    if (state.isAnswered || state.questions.isEmpty) return;

    final q = state.currentQuestion;
    final isCorrect = optionIndex == q.correctOptionIndex;
    final newScore = isCorrect ? state.score + 1 : state.score;

    emit(state.copyWith(
      selectedOptionIndex: optionIndex,
      isAnswered: true,
      score: newScore,
    ));
  }

  void nextQuestion() {
    if (!state.isAnswered || state.questions.isEmpty) return;

    if (state.isLastQuestion) {
      emit(state.copyWith(isCompleted: true));
    } else {
      emit(state.copyWith(
        currentIndex: state.currentIndex + 1,
        isAnswered: false,
        clearSelectedOption: true,
      ));
    }
  }

  void playQuestionAudio() {
    if (state.questions.isEmpty) return;
    final q = state.currentQuestion;
    final targetDialect = q.dialectFlag.contains('🇵🇹')
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    _audioService.playAudioOrSpeak(
      fallbackText: q.questionPt,
      dialect: targetDialect,
    );
  }

  void restart() {
    emit(state.copyWith(
      currentIndex: 0,
      score: 0,
      isAnswered: false,
      isCompleted: false,
      clearSelectedOption: true,
    ));
  }
}
