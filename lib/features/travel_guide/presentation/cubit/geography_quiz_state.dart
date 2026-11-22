import 'package:equatable/equatable.dart';
import '../../domain/entities/geography_quiz_entity.dart';

class GeographyQuizState extends Equatable {
  final List<GeographyQuizQuestion> questions;
  final int currentIndex;
  final int? selectedOptionIndex;
  final bool isAnswered;
  final int score;
  final bool isCompleted;
  final Set<String> earnedCountryIds;

  const GeographyQuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedOptionIndex,
    this.isAnswered = false,
    this.score = 0,
    this.isCompleted = false,
    this.earnedCountryIds = const {},
  });

  GeographyQuizQuestion get currentQuestion => questions[currentIndex];

  bool get isLastQuestion => currentIndex == questions.length - 1;

  double get progress =>
      questions.isNotEmpty ? (currentIndex + 1) / questions.length : 0.0;

  GeographyQuizState copyWith({
    List<GeographyQuizQuestion>? questions,
    int? currentIndex,
    int? selectedOptionIndex,
    bool clearSelectedOption = false,
    bool? isAnswered,
    int? score,
    bool? isCompleted,
    Set<String>? earnedCountryIds,
  }) {
    return GeographyQuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionIndex: clearSelectedOption
          ? null
          : (selectedOptionIndex ?? this.selectedOptionIndex),
      isAnswered: isAnswered ?? this.isAnswered,
      score: score ?? this.score,
      isCompleted: isCompleted ?? this.isCompleted,
      earnedCountryIds: earnedCountryIds ?? this.earnedCountryIds,
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
        earnedCountryIds,
      ];
}
