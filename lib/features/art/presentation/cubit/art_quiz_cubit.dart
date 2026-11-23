import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/art_repository.dart';
import 'art_quiz_state.dart';

class ArtQuizCubit extends Cubit<ArtQuizState> {
  final ArtRepository _repository;

  ArtQuizCubit({required ArtRepository repository})
      : _repository = repository,
        super(const ArtQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: ArtQuizStatus.loading));

    final result = await _repository.getArtQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: ArtQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: ArtQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Ошибка загрузки арт-викторины',
      ));
    }
  }

  void selectOption(int index) {
    if (state.isAnswerChecked) return;
    emit(state.copyWith(selectedOption: index));
  }

  void checkAnswer() {
    if (state.selectedOption == null || state.isAnswerChecked) return;

    final isCorrect =
        state.selectedOption == state.currentQuiz?.correctOptionIndex;
    final newScore = isCorrect ? state.score + 1 : state.score;

    emit(state.copyWith(
      isAnswerChecked: true,
      score: newScore,
    ));
  }

  void nextQuestion() {
    if (!state.isAnswerChecked) return;

    if (state.isLastQuestion) {
      emit(state.copyWith(status: ArtQuizStatus.completed));
    } else {
      emit(state.copyWith(
        currentIndex: state.currentIndex + 1,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    }
  }

  void restart() {
    emit(state.copyWith(
      status: ArtQuizStatus.inProgress,
      currentIndex: 0,
      score: 0,
      clearSelection: true,
      isAnswerChecked: false,
    ));
  }
}
