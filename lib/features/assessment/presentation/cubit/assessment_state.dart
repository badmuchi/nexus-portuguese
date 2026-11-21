import 'package:equatable/equatable.dart';
import '../../domain/entities/level_quiz_question.dart';
import '../../domain/entities/level_quiz_result.dart';

abstract class AssessmentState extends Equatable {
  const AssessmentState();

  @override
  List<Object?> get props => [];
}

class AssessmentInitial extends AssessmentState {
  const AssessmentInitial();
}

class AssessmentLoading extends AssessmentState {
  const AssessmentLoading();
}

class AssessmentActive extends AssessmentState {
  final List<LevelQuizQuestion> questions;
  final int currentIndex;
  final Map<String, int> userAnswers;
  final int? selectedOptionIndex;
  final bool isSubmitted;
  final bool isPlayingAudio;

  const AssessmentActive({
    required this.questions,
    this.currentIndex = 0,
    this.userAnswers = const {},
    this.selectedOptionIndex,
    this.isSubmitted = false,
    this.isPlayingAudio = false,
  });

  LevelQuizQuestion get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  double get progressPercent => (currentIndex + 1) / questions.length;
  bool get isLastQuestion => currentIndex == questions.length - 1;

  bool? get isCurrentCorrect {
    if (!isSubmitted || selectedOptionIndex == null) return null;
    return currentQuestion.isCorrect(selectedOptionIndex!);
  }

  AssessmentActive copyWith({
    List<LevelQuizQuestion>? questions,
    int? currentIndex,
    Map<String, int>? userAnswers,
    int? selectedOptionIndex,
    bool? isSubmitted,
    bool? isPlayingAudio,
    bool clearSelectedOption = false,
  }) {
    return AssessmentActive(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      selectedOptionIndex:
          clearSelectedOption ? null : (selectedOptionIndex ?? this.selectedOptionIndex),
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        currentIndex,
        userAnswers,
        selectedOptionIndex,
        isSubmitted,
        isPlayingAudio,
      ];
}

class AssessmentCompleted extends AssessmentState {
  final LevelQuizResult result;
  final bool isSavingToFsrs;
  final int addedToFsrsCount;

  const AssessmentCompleted({
    required this.result,
    this.isSavingToFsrs = false,
    this.addedToFsrsCount = 0,
  });

  AssessmentCompleted copyWith({
    LevelQuizResult? result,
    bool? isSavingToFsrs,
    int? addedToFsrsCount,
  }) {
    return AssessmentCompleted(
      result: result ?? this.result,
      isSavingToFsrs: isSavingToFsrs ?? this.isSavingToFsrs,
      addedToFsrsCount: addedToFsrsCount ?? this.addedToFsrsCount,
    );
  }

  @override
  List<Object?> get props => [
        result,
        isSavingToFsrs,
        addedToFsrsCount,
      ];
}

class AssessmentError extends AssessmentState {
  final String message;

  const AssessmentError(this.message);

  @override
  List<Object?> get props => [message];
}
