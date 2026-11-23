import 'package:equatable/equatable.dart';
import '../../domain/entities/ancestral_entities.dart';

enum AncestralQuizStatus { initial, loading, inProgress, completed, error }

class AncestralQuizState extends Equatable {
  final AncestralQuizStatus status;
  final List<AncestralQuizQuestion> quizzes;
  final int currentIndex;
  final int? selectedOption;
  final bool isAnswerChecked;
  final int score;
  final String? errorMessage;

  const AncestralQuizState({
    this.status = AncestralQuizStatus.initial,
    this.quizzes = const [],
    this.currentIndex = 0,
    this.selectedOption,
    this.isAnswerChecked = false,
    this.score = 0,
    this.errorMessage,
  });

  AncestralQuizQuestion? get currentQuiz =>
      (quizzes.isNotEmpty && currentIndex < quizzes.length)
          ? quizzes[currentIndex]
          : null;

  int get totalQuestions => quizzes.length;
  bool get isLastQuestion => currentIndex >= quizzes.length - 1;

  AncestralQuizState copyWith({
    AncestralQuizStatus? status,
    List<AncestralQuizQuestion>? quizzes,
    int? currentIndex,
    int? selectedOption,
    bool clearSelection = false,
    bool? isAnswerChecked,
    int? score,
    String? errorMessage,
  }) {
    return AncestralQuizState(
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
