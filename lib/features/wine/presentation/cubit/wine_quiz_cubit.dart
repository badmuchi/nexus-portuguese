import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/wine_repository.dart';
import 'wine_quiz_state.dart';

class WineQuizCubit extends Cubit<WineQuizState> {
  final WineRepository _repository;

  WineQuizCubit({required WineRepository repository})
      : _repository = repository,
        super(const WineQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: WineQuizStatus.loading));

    final result = await _repository.getWineQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: WineQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: WineQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Erro ao carregar questionário de enologia',
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
      emit(state.copyWith(status: WineQuizStatus.completed));
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
