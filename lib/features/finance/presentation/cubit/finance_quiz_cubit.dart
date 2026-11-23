import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/finance_repository.dart';
import 'finance_quiz_state.dart';

class FinanceQuizCubit extends Cubit<FinanceQuizState> {
  final FinanceRepository _repository;

  FinanceQuizCubit({required FinanceRepository repository})
      : _repository = repository,
        super(const FinanceQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: FinanceQuizStatus.loading));

    final result = await _repository.getFinanceQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: FinanceQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: FinanceQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Ошибка загрузки финансовой викторины',
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
        state.selectedOption == state.currentQuiz?.correctIndex;
    final newScore = isCorrect ? state.score + 1 : state.score;

    emit(state.copyWith(
      isAnswerChecked: true,
      score: newScore,
    ));
  }

  void nextQuestion() {
    if (!state.isAnswerChecked) return;

    if (state.isLastQuestion) {
      emit(state.copyWith(status: FinanceQuizStatus.completed));
    } else {
      emit(state.copyWith(
        currentIndex: state.currentIndex + 1,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    }
  }

  void restartQuiz() {
    loadQuizzes();
  }
}
