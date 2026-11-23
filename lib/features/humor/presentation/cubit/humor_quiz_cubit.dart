import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/humor_repository.dart';
import 'humor_quiz_state.dart';

class HumorQuizCubit extends Cubit<HumorQuizState> {
  final HumorRepository _repository;

  HumorQuizCubit({required HumorRepository repository})
      : _repository = repository,
        super(const HumorQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: HumorQuizStatus.loading));

    final result = await _repository.getHumorQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: HumorQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: HumorQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Ошибка загрузки викторины',
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
      emit(state.copyWith(status: HumorQuizStatus.completed));
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
      status: HumorQuizStatus.inProgress,
      currentIndex: 0,
      score: 0,
      clearSelection: true,
      isAnswerChecked: false,
    ));
  }
}
