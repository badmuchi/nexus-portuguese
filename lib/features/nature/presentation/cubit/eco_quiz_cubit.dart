import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/nature_repository.dart';
import 'eco_quiz_state.dart';

class EcoQuizCubit extends Cubit<EcoQuizState> {
  final NatureRepository _repository;

  EcoQuizCubit({required NatureRepository repository})
      : _repository = repository,
        super(const EcoQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: EcoQuizStatus.loading));

    final result = await _repository.getEcoQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: EcoQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: EcoQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Ошибка загрузки эко-викторины',
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
      emit(state.copyWith(status: EcoQuizStatus.completed));
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
      status: EcoQuizStatus.inProgress,
      currentIndex: 0,
      score: 0,
      clearSelection: true,
      isAnswerChecked: false,
    ));
  }
}
