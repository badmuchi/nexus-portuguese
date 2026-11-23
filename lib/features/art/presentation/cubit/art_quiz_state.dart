import 'package:equatable/equatable.dart';
import '../../domain/entities/art_entities.dart';

enum ArtQuizStatus { initial, loading, inProgress, completed, error }

class ArtQuizState extends Equatable {
  final ArtQuizStatus status;
  final List<ArtQuizQuestion> quizzes;
  final int currentIndex;
  final int? selectedOption;
  final bool isAnswerChecked;
  final int score;
  final String? errorMessage;

  const ArtQuizState({
    this.status = ArtQuizStatus.initial,
    this.quizzes = const [],
    this.currentIndex = 0,
    this.selectedOption,
    this.isAnswerChecked = false,
    this.score = 0,
    this.errorMessage,
  });

  ArtQuizQuestion? get currentQuiz =>
      currentIndex < quizzes.length ? quizzes[currentIndex] : null;

  bool get isLastQuestion => currentIndex >= quizzes.length - 1;

  bool get isCorrect =>
      isAnswerChecked &&
      selectedOption != null &&
      currentQuiz != null &&
      selectedOption == currentQuiz!.correctOptionIndex;

  ArtQuizState copyWith({
    ArtQuizStatus? status,
    List<ArtQuizQuestion>? quizzes,
    int? currentIndex,
    int? selectedOption,
    bool clearSelection = false,
    bool? isAnswerChecked,
    int? score,
    String? errorMessage,
  }) {
    return ArtQuizState(
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
