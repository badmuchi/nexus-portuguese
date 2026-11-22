import 'package:equatable/equatable.dart';
import '../../domain/entities/football_entities.dart';

class FootballQuizState extends Equatable {
  final List<FootballQuizQuestion> questions;
  final int currentIndex;
  final int? selectedOptionIndex;
  final bool isAnswered;
  final int score;
  final bool isCompleted;

  const FootballQuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedOptionIndex,
    this.isAnswered = false,
    this.score = 0,
    this.isCompleted = false,
  });

  FootballQuizQuestion get currentQuestion => questions[currentIndex];

  bool get isLastQuestion => currentIndex == questions.length - 1;

  double get progress =>
      questions.isNotEmpty ? (currentIndex + 1) / questions.length : 0.0;

  FootballQuizState copyWith({
    List<FootballQuizQuestion>? questions,
    int? currentIndex,
    int? selectedOptionIndex,
    bool clearSelectedOption = false,
    bool? isAnswered,
    int? score,
    bool? isCompleted,
  }) {
    return FootballQuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionIndex: clearSelectedOption
          ? null
          : (selectedOptionIndex ?? this.selectedOptionIndex),
      isAnswered: isAnswered ?? this.isAnswered,
      score: score ?? this.score,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        currentIndex,
        selectedOptionIndex,
        isAnswered,
        score,
        isCompleted,
      ];
}
