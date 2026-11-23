import 'package:equatable/equatable.dart';
import '../../domain/entities/nature_entities.dart';

enum EcoQuizStatus { initial, loading, inProgress, completed, error }

class EcoQuizState extends Equatable {
  final EcoQuizStatus status;
  final List<EcoQuizQuestion> quizzes;
  final int currentIndex;
  final int? selectedOption;
  final bool isAnswerChecked;
  final int score;
  final String? errorMessage;

  const EcoQuizState({
    this.status = EcoQuizStatus.initial,
    this.quizzes = const [],
    this.currentIndex = 0,
    this.selectedOption,
    this.isAnswerChecked = false,
    this.score = 0,
    this.errorMessage,
  });

  EcoQuizQuestion? get currentQuiz =>
      currentIndex < quizzes.length ? quizzes[currentIndex] : null;

  bool get isLastQuestion => currentIndex >= quizzes.length - 1;

  bool get isCorrect =>
      isAnswerChecked &&
      selectedOption != null &&
      currentQuiz != null &&
      selectedOption == currentQuiz!.correctOptionIndex;

  EcoQuizState copyWith({
    EcoQuizStatus? status,
    List<EcoQuizQuestion>? quizzes,
    int? currentIndex,
    int? selectedOption,
    bool clearSelection = false,
    bool? isAnswerChecked,
    int? score,
    String? errorMessage,
  }) {
    return EcoQuizState(
      status: status ?? this.status,
      quizzes: quizzes ?? this.quizzes,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOption: clearSelection ? null : (selectedOption ?? this.selectedOption),
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
