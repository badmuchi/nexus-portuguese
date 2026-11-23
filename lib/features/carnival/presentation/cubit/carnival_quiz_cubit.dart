import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/carnival_repository.dart';
import 'carnival_quiz_state.dart';

class CarnivalQuizCubit extends Cubit<CarnivalQuizState> {
  final CarnivalRepository _repository;

  CarnivalQuizCubit({required CarnivalRepository repository})
      : _repository = repository,
        super(const CarnivalQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: CarnivalQuizStatus.loading));

    final result = await _repository.getCarnivalQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: CarnivalQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: CarnivalQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Erro ao carregar questionário de carnaval',
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
      emit(state.copyWith(status: CarnivalQuizStatus.completed));
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
