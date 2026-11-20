import 'package:equatable/equatable.dart';
import '../../domain/entities/phonetic_trainer_models.dart';

enum TrainerStep {
  theory,
  ear,
  mouth,
  dialect,
}

class PhoneticsTrainerState extends Equatable {
  final bool isLoading;
  final List<PhoneticExercise> exercises;
  final Map<String, PhoneticMastery> masteryMap;
  final int currentExerciseIndex;
  final int currentPairIndex;
  final TrainerStep step;
  final bool isTargetWordA;
  final String? earSelectedWord;
  final bool? earIsCorrect;
  final bool isPlayingAudio;
  final bool isRecording;
  final String? spokenText;
  final double? mouthScore;
  final String? errorMessage;

  const PhoneticsTrainerState({
    this.isLoading = false,
    this.exercises = const [],
    this.masteryMap = const {},
    this.currentExerciseIndex = 0,
    this.currentPairIndex = 0,
    this.step = TrainerStep.theory,
    this.isTargetWordA = true,
    this.earSelectedWord,
    this.earIsCorrect,
    this.isPlayingAudio = false,
    this.isRecording = false,
    this.spokenText,
    this.mouthScore,
    this.errorMessage,
  });

  PhoneticExercise? get currentExercise =>
      (exercises.isNotEmpty && currentExerciseIndex < exercises.length)
          ? exercises[currentExerciseIndex]
          : null;

  MinimalPairItem? get currentPair {
    final ex = currentExercise;
    if (ex == null || ex.contrastPairs.isEmpty) return null;
    final idx = currentPairIndex < ex.contrastPairs.length ? currentPairIndex : 0;
    return ex.contrastPairs[idx];
  }

  String get targetWord {
    final pair = currentPair;
    if (pair == null) return '';
    return isTargetWordA ? pair.wordA : pair.wordB;
  }

  PhoneticsTrainerState copyWith({
    bool? isLoading,
    List<PhoneticExercise>? exercises,
    Map<String, PhoneticMastery>? masteryMap,
    int? currentExerciseIndex,
    int? currentPairIndex,
    TrainerStep? step,
    bool? isTargetWordA,
    String? earSelectedWord,
    bool? earIsCorrect,
    bool clearEarSelection = false,
    bool? isPlayingAudio,
    bool? isRecording,
    String? spokenText,
    double? mouthScore,
    bool clearMouthScore = false,
    String? errorMessage,
  }) {
    return PhoneticsTrainerState(
      isLoading: isLoading ?? this.isLoading,
      exercises: exercises ?? this.exercises,
      masteryMap: masteryMap ?? this.masteryMap,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentPairIndex: currentPairIndex ?? this.currentPairIndex,
      step: step ?? this.step,
      isTargetWordA: isTargetWordA ?? this.isTargetWordA,
      earSelectedWord: clearEarSelection ? null : (earSelectedWord ?? this.earSelectedWord),
      earIsCorrect: clearEarSelection ? null : (earIsCorrect ?? this.earIsCorrect),
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      isRecording: isRecording ?? this.isRecording,
      spokenText: clearMouthScore ? null : (spokenText ?? this.spokenText),
      mouthScore: clearMouthScore ? null : (mouthScore ?? this.mouthScore),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        exercises,
        masteryMap,
        currentExerciseIndex,
        currentPairIndex,
        step,
        isTargetWordA,
        earSelectedWord,
        earIsCorrect,
        isPlayingAudio,
        isRecording,
        spokenText,
        mouthScore,
        errorMessage,
      ];
}
