import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/geography_quiz_entity.dart';
import '../../domain/repositories/travel_guide_repository.dart';
import 'geography_quiz_state.dart';

class GeographyQuizCubit extends Cubit<GeographyQuizState> {
  final TravelGuideRepository _repository;
  final HybridAudioPlaybackService _audioService;

  GeographyQuizCubit({
    required TravelGuideRepository repository,
    required HybridAudioPlaybackService audioService,
    List<GeographyQuizQuestion>? initialQuestions,
  })  : _repository = repository,
        _audioService = audioService,
        super(GeographyQuizState(questions: initialQuestions ?? const []));

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
        earnedCountryIds: {},
      ));
    }
  }

  void selectOption(int optionIndex) {
    if (state.isAnswered || state.questions.isEmpty) return;

    final q = state.currentQuestion;
    final isCorrect = optionIndex == q.correctOptionIndex;
    final newScore = isCorrect ? state.score + 1 : state.score;
    final updatedEarned = Set<String>.from(state.earnedCountryIds);
    if (isCorrect) {
      updatedEarned.add(q.countryId);
    }

    emit(state.copyWith(
      selectedOptionIndex: optionIndex,
      isAnswered: true,
      score: newScore,
      earnedCountryIds: updatedEarned,
    ));
  }

  void nextQuestion() {
    if (!state.isAnswered || state.questions.isEmpty) return;

    if (state.isLastQuestion) {
      emit(state.copyWith(isCompleted: true));
      _repository.recordQuizCompleted(
        score: state.score,
        totalQuestions: state.questions.length,
        earnedCountryIds: state.earnedCountryIds.toList(),
      );
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
    _audioService.playAudioOrSpeak(
      fallbackText: state.currentQuestion.questionPt,
    );
  }

  void restart() {
    emit(state.copyWith(
      currentIndex: 0,
      score: 0,
      isAnswered: false,
      isCompleted: false,
      clearSelectedOption: true,
      earnedCountryIds: {},
    ));
  }
}
