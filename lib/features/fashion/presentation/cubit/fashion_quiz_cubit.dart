import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fashion_repository.dart';
import 'fashion_quiz_state.dart';

class FashionQuizCubit extends Cubit<FashionQuizState> {
  final FashionRepository _repository;

  FashionQuizCubit({required FashionRepository repository})
      : _repository = repository,
        super(const FashionQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: FashionQuizStatus.loading));

    final result = await _repository.getFashionQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: FashionQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: FashionQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Erro ao carregar questionário de moda',
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
      emit(state.copyWith(status: FashionQuizStatus.completed));
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
