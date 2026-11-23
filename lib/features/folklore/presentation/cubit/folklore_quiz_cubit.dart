import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/folklore_repository.dart';
import 'folklore_quiz_state.dart';

class FolkloreQuizCubit extends Cubit<FolkloreQuizState> {
  final FolkloreRepository _repository;

  FolkloreQuizCubit({required FolkloreRepository repository})
      : _repository = repository,
        super(const FolkloreQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: FolkloreQuizStatus.loading));

    final result = await _repository.getFolkloreQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: FolkloreQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: FolkloreQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Ошибка загрузки викторины по фольклору',
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
      emit(state.copyWith(status: FolkloreQuizStatus.completed));
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
