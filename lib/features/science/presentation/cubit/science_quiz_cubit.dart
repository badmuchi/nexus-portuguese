import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/science_repository.dart';
import 'science_quiz_state.dart';

class ScienceQuizCubit extends Cubit<ScienceQuizState> {
  final ScienceRepository _repository;

  ScienceQuizCubit({required ScienceRepository repository})
      : _repository = repository,
        super(const ScienceQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: ScienceQuizStatus.loading));

    final result = await _repository.getScienceQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: ScienceQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: ScienceQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Erro ao carregar questionário científico',
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
      emit(state.copyWith(status: ScienceQuizStatus.completed));
    } else {
      emit(state.copyWith(
        currentIndex: state.currentIndex + 1,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    }
  }

  Future<void> restartQuiz() async {
    await loadQuizzes();
  }
}
