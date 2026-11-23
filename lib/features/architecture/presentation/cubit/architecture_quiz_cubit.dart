import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/architecture_repository.dart';
import 'architecture_quiz_state.dart';

class ArchitectureQuizCubit extends Cubit<ArchitectureQuizState> {
  final ArchitectureRepository _repository;

  ArchitectureQuizCubit({required ArchitectureRepository repository})
      : _repository = repository,
        super(const ArchitectureQuizState());

  Future<void> loadQuizzes() async {
    emit(state.copyWith(status: ArchitectureQuizStatus.loading));

    final result = await _repository.getArchitectureQuizzes();
    if (result.isOk && result.value.isNotEmpty) {
      emit(state.copyWith(
        status: ArchitectureQuizStatus.inProgress,
        quizzes: result.value,
        currentIndex: 0,
        score: 0,
        clearSelection: true,
        isAnswerChecked: false,
      ));
    } else {
      emit(state.copyWith(
        status: ArchitectureQuizStatus.error,
        errorMessage: result.errorOrNull ?? 'Ошибка загрузки архитектурной викторины',
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
      emit(state.copyWith(status: ArchitectureQuizStatus.completed));
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
