import 'package:equatable/equatable.dart';
import '../../domain/entities/folklore_entities.dart';

enum FolkloreQuizStatus { initial, loading, inProgress, completed, error }

class FolkloreQuizState extends Equatable {
  final FolkloreQuizStatus status;
  final List<FolkloreQuizQuestion> quizzes;
  final int currentIndex;
  final int? selectedOption;
  final bool isAnswerChecked;
  final int score;
  final String? errorMessage;

  const FolkloreQuizState({
    this.status = FolkloreQuizStatus.initial,
    this.quizzes = const [],
    this.currentIndex = 0,
    this.selectedOption,
    this.isAnswerChecked = false,
    this.score = 0,
    this.errorMessage,
  });

  FolkloreQuizQuestion? get currentQuiz =>
      currentIndex < quizzes.length ? quizzes[currentIndex] : null;

  int get totalQuestions => quizzes.length;

  bool get isLastQuestion => currentIndex >= quizzes.length - 1;

  bool get isCorrect =>
      isAnswerChecked &&
      selectedOption != null &&
      currentQuiz != null &&
      selectedOption == currentQuiz!.correctIndex;

  FolkloreQuizState copyWith({
    FolkloreQuizStatus? status,
    List<FolkloreQuizQuestion>? quizzes,
    int? currentIndex,
    int? selectedOption,
    bool clearSelection = false,
    bool? isAnswerChecked,
    int? score,
    String? errorMessage,
  }) {
    return FolkloreQuizState(
      status: status ?? this.status,
      quizzes: quizzes ?? this.quizzes,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOption:
          clearSelection ? null : (selectedOption ?? this.selectedOption),
      isAnswerChecked: isAnswerChecked ?? this.isAnswerChecked,
      score: score ?? this.score,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        quizzes,
        currentIndex,
        selectedOption,
        isAnswerChecked,
        score,
        errorMessage,
      ];
}
