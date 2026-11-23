import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/festas_repository.dart';
import 'festa_quiz_state.dart';

class FestaQuizCubit extends Cubit<FestaQuizState> {
  final FestasRepository _repository;

  FestaQuizCubit({required FestasRepository repository})
      : _repository = repository,
        super(const FestaQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: FestaQuizStatus.loading));

    final result = await _repository.getFestaQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: FestaQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: FestaQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Ошибка загрузки праздничной викторины',
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
      emit(state.copyWith(status: FestaQuizStatus.completed));
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
