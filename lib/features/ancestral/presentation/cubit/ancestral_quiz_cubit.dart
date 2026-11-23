import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/ancestral_repository.dart';
import 'ancestral_quiz_state.dart';

class AncestralQuizCubit extends Cubit<AncestralQuizState> {
  final AncestralRepository _repository;

  AncestralQuizCubit({required AncestralRepository repository})
      : _repository = repository,
        super(const AncestralQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: AncestralQuizStatus.loading));

    final result = await _repository.getAncestralQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: AncestralQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: AncestralQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Erro ao carregar questionário de saberes ancestrais',
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
      emit(state.copyWith(status: AncestralQuizStatus.completed));
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
