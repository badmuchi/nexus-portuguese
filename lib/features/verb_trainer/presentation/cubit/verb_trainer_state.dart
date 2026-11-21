import 'package:equatable/equatable.dart';
import '../../domain/entities/verb_exercise.dart';
import '../../domain/entities/verb_trainer_config.dart';
import '../../domain/entities/verb_trainer_session_result.dart';

abstract class VerbTrainerState extends Equatable {
  const VerbTrainerState();

  @override
  List<Object?> get props => [];
}

class VerbTrainerInitial extends VerbTrainerState {
  const VerbTrainerInitial();
}

class VerbTrainerLoading extends VerbTrainerState {
  const VerbTrainerLoading();
}

class VerbTrainerActive extends VerbTrainerState {
  final List<VerbExercise> exercises;
  final int currentIndex;
  final int scorePoints;
  final int currentStreak;
  final int maxStreak;
  final int correctCount;
  final int totalAttempts;
  final int? remainingSeconds;
  final String? selectedOption;
  final bool isChecked;
  final bool isPlayingAudio;
  final List<VerbExercise> mistakes;
  final VerbTrainerConfig config;

  const VerbTrainerActive({
    required this.exercises,
    this.currentIndex = 0,
    this.scorePoints = 0,
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.correctCount = 0,
    this.totalAttempts = 0,
    this.remainingSeconds,
    this.selectedOption,
    this.isChecked = false,
    this.isPlayingAudio = false,
    this.mistakes = const [],
    required this.config,
  });

  VerbExercise get currentExercise => exercises[currentIndex];
  int get totalQuestions => exercises.length;
  bool get isLastQuestion => currentIndex == exercises.length - 1;

  bool? get isCurrentCorrect {
    if (!isChecked || selectedOption == null) return null;
    return currentExercise.isCorrect(selectedOption!);
  }

  VerbTrainerActive copyWith({
    List<VerbExercise>? exercises,
    int? currentIndex,
    int? scorePoints,
    int? currentStreak,
    int? maxStreak,
    int? correctCount,
    int? totalAttempts,
    int? remainingSeconds,
    String? selectedOption,
    bool? isChecked,
    bool? isPlayingAudio,
    List<VerbExercise>? mistakes,
    VerbTrainerConfig? config,
    bool clearSelectedOption = false,
  }) {
    return VerbTrainerActive(
      exercises: exercises ?? this.exercises,
      currentIndex: currentIndex ?? this.currentIndex,
      scorePoints: scorePoints ?? this.scorePoints,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      correctCount: correctCount ?? this.correctCount,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      selectedOption:
          clearSelectedOption ? null : (selectedOption ?? this.selectedOption),
      isChecked: isChecked ?? this.isChecked,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      mistakes: mistakes ?? this.mistakes,
      config: config ?? this.config,
    );
  }

  @override
  List<Object?> get props => [
        exercises,
        currentIndex,
        scorePoints,
        currentStreak,
        maxStreak,
        correctCount,
        totalAttempts,
        remainingSeconds,
        selectedOption,
        isChecked,
        isPlayingAudio,
        mistakes,
        config,
      ];
}

class VerbTrainerCompleted extends VerbTrainerState {
  final VerbTrainerSessionResult result;
  final bool isSavingToFsrs;
  final int addedToFsrsCount;

  const VerbTrainerCompleted({
    required this.result,
    this.isSavingToFsrs = false,
    this.addedToFsrsCount = 0,
  });

  VerbTrainerCompleted copyWith({
    VerbTrainerSessionResult? result,
    bool? isSavingToFsrs,
    int? addedToFsrsCount,
  }) {
    return VerbTrainerCompleted(
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

class VerbTrainerError extends VerbTrainerState {
  final String message;

  const VerbTrainerError(this.message);

  @override
  List<Object?> get props => [message];
}
