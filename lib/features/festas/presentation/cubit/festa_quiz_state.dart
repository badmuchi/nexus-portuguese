import 'package:equatable/equatable.dart';
import '../../domain/entities/festas_entities.dart';

enum FestaQuizStatus { initial, loading, inProgress, completed, error }

class FestaQuizState extends Equatable {
  final FestaQuizStatus status;
  final List<FestaQuizQuestion> quizzes;
  final int currentIndex;
  final int? selectedOption;
  final bool isAnswerChecked;
  final int score;
  final String? errorMessage;

  const FestaQuizState({
    this.status = FestaQuizStatus.initial,
    this.quizzes = const [],
    this.currentIndex = 0,
    this.selectedOption,
    this.isAnswerChecked = false,
    this.score = 0,
    this.errorMessage,
  });

  FestaQuizQuestion? get currentQuiz =>
      currentIndex < quizzes.length ? quizzes[currentIndex] : null;

  bool get isLastQuestion => currentIndex >= quizzes.length - 1;

  bool get isCorrect =>
      isAnswerChecked &&
      selectedOption != null &&
      currentQuiz != null &&
      selectedOption == currentQuiz!.correctIndex;

  FestaQuizState copyWith({
    FestaQuizStatus? status,
    List<FestaQuizQuestion>? quizzes,
    int? currentIndex,
    int? selectedOption,
    bool clearSelection = false,
    bool? isAnswerChecked,
    int? score,
    String? errorMessage,
  }) {
    return FestaQuizState(
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
