import 'package:equatable/equatable.dart';
import '../../domain/entities/listening_models.dart';
import '../../../../core/utils/portuguese_normalizer.dart';

abstract class ListeningState extends Equatable {
  const ListeningState();

  @override
  List<Object?> get props => [];
}

class ListeningInitial extends ListeningState {}

class ListeningLoading extends ListeningState {}

class ListeningLoaded extends ListeningState {
  final List<ListeningExerciseEntity> exercises;
  final int currentIndex;
  final bool isRevealed;
  final String? userDictation;
  final PortugueseMatchResult? matchResult;
  final double playbackRate;

  const ListeningLoaded({
    required this.exercises,
    required this.currentIndex,
    this.isRevealed = false,
    this.userDictation,
    this.matchResult,
    this.playbackRate = 1.0,
  });

  ListeningExerciseEntity get currentExercise => exercises[currentIndex];

  ListeningLoaded copyWith({
    List<ListeningExerciseEntity>? exercises,
    int? currentIndex,
    bool? isRevealed,
    String? userDictation,
    PortugueseMatchResult? matchResult,
    double? playbackRate,
    bool clearInput = false,
  }) {
    return ListeningLoaded(
      exercises: exercises ?? this.exercises,
      currentIndex: currentIndex ?? this.currentIndex,
      isRevealed: isRevealed ?? this.isRevealed,
      userDictation: clearInput ? null : (userDictation ?? this.userDictation),
      matchResult: clearInput ? null : (matchResult ?? this.matchResult),
      playbackRate: playbackRate ?? this.playbackRate,
    );
  }

  @override
  List<Object?> get props => [
        exercises,
        currentIndex,
        isRevealed,
        userDictation,
        matchResult,
        playbackRate,
      ];
}

class ListeningError extends ListeningState {
  final String message;
  const ListeningError(this.message);

  @override
  List<Object?> get props => [message];
}
