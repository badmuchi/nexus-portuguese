import 'package:equatable/equatable.dart';
import '../../domain/entities/duel_question_entity.dart';
import '../../domain/entities/duel_session_result_entity.dart';

enum DuelsStatus { lobby, loading, inProgress, answered, completed, error }

class DuelsState extends Equatable {
  final DuelsStatus status;
  final DuelCategory? selectedCategory;
  final int questionsCount;
  final List<DuelQuestion> questions;
  final int currentIndex;
  final int? selectedAnswerIndex;
  final bool isCorrect;
  final int currentStreak;
  final int maxStreak;
  final int score;
  final int correctAnswers;
  final int remainingSeconds;
  final DuelSessionResultEntity? sessionResult;
  final String? errorMessage;

  const DuelsState({
    this.status = DuelsStatus.lobby,
    this.selectedCategory,
    this.questionsCount = 10,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedAnswerIndex,
    this.isCorrect = false,
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.score = 0,
    this.correctAnswers = 0,
    this.remainingSeconds = 15,
    this.sessionResult,
    this.errorMessage,
  });

  DuelQuestion? get currentQuestion {
    if (questions.isEmpty || currentIndex < 0 || currentIndex >= questions.length) {
      return null;
    }
    return questions[currentIndex];
  }

  double get progress {
    if (questions.isEmpty) return 0.0;
    return (currentIndex / questions.length).clamp(0.0, 1.0);
  }

  int get comboMultiplier {
    if (currentStreak >= 5) return 3;
    if (currentStreak >= 3) return 2;
    return 1;
  }

  DuelsState copyWith({
    DuelsStatus? status,
    DuelCategory? selectedCategory,
    bool clearCategory = false,
    int? questionsCount,
    List<DuelQuestion>? questions,
    int? currentIndex,
    int? selectedAnswerIndex,
    bool clearSelection = false,
    bool? isCorrect,
    int? currentStreak,
    int? maxStreak,
    int? score,
    int? correctAnswers,
    int? remainingSeconds,
    DuelSessionResultEntity? sessionResult,
    String? errorMessage,
  }) {
    return DuelsState(
      status: status ?? this.status,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      questionsCount: questionsCount ?? this.questionsCount,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswerIndex: clearSelection ? null : (selectedAnswerIndex ?? this.selectedAnswerIndex),
      isCorrect: isCorrect ?? this.isCorrect,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      score: score ?? this.score,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      sessionResult: sessionResult ?? this.sessionResult,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedCategory,
        questionsCount,
        questions,
        currentIndex,
        selectedAnswerIndex,
        isCorrect,
        currentStreak,
        maxStreak,
        score,
        correctAnswers,
        remainingSeconds,
        sessionResult,
        errorMessage,
      ];
}
