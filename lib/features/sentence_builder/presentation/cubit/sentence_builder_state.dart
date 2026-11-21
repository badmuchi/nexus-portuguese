import 'package:equatable/equatable.dart';
import '../../domain/entities/sentence_builder_result.dart';
import '../../domain/entities/sentence_puzzle.dart';

abstract class SentenceBuilderState extends Equatable {
  const SentenceBuilderState();

  @override
  List<Object?> get props => [];
}

class SentenceBuilderInitial extends SentenceBuilderState {
  const SentenceBuilderInitial();
}

class SentenceBuilderLoading extends SentenceBuilderState {
  const SentenceBuilderLoading();
}

class SentenceBuilderActive extends SentenceBuilderState {
  final List<SentencePuzzle> puzzles;
  final int currentIndex;
  final List<String> availableTokens;
  final List<String> assembledTokens;
  final bool isChecked;
  final bool? isCorrect;
  final int scorePoints;
  final int streak;
  final int solvedCount;
  final bool isPlayingAudio;
  final List<SentencePuzzle> mistakes;

  const SentenceBuilderActive({
    required this.puzzles,
    this.currentIndex = 0,
    required this.availableTokens,
    this.assembledTokens = const [],
    this.isChecked = false,
    this.isCorrect,
    this.scorePoints = 0,
    this.streak = 0,
    this.solvedCount = 0,
    this.isPlayingAudio = false,
    this.mistakes = const [],
  });

  SentencePuzzle get currentPuzzle => puzzles[currentIndex];
  int get totalPuzzles => puzzles.length;
  bool get isLastPuzzle => currentIndex == puzzles.length - 1;
  double get progressPercent => (currentIndex + 1) / puzzles.length;

  SentenceBuilderActive copyWith({
    List<SentencePuzzle>? puzzles,
    int? currentIndex,
    List<String>? availableTokens,
    List<String>? assembledTokens,
    bool? isChecked,
    bool? isCorrect,
    int? scorePoints,
    int? streak,
    int? solvedCount,
    bool? isPlayingAudio,
    List<SentencePuzzle>? mistakes,
  }) {
    return SentenceBuilderActive(
      puzzles: puzzles ?? this.puzzles,
      currentIndex: currentIndex ?? this.currentIndex,
      availableTokens: availableTokens ?? this.availableTokens,
      assembledTokens: assembledTokens ?? this.assembledTokens,
      isChecked: isChecked ?? this.isChecked,
      isCorrect: isCorrect ?? this.isCorrect,
      scorePoints: scorePoints ?? this.scorePoints,
      streak: streak ?? this.streak,
      solvedCount: solvedCount ?? this.solvedCount,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      mistakes: mistakes ?? this.mistakes,
    );
  }

  @override
  List<Object?> get props => [
        puzzles,
        currentIndex,
        availableTokens,
        assembledTokens,
        isChecked,
        isCorrect,
        scorePoints,
        streak,
        solvedCount,
        isPlayingAudio,
        mistakes,
      ];
}

class SentenceBuilderCompleted extends SentenceBuilderState {
  final SentenceBuilderResult result;
  final bool isSavingToFsrs;
  final int addedToFsrsCount;

  const SentenceBuilderCompleted({
    required this.result,
    this.isSavingToFsrs = false,
    this.addedToFsrsCount = 0,
  });

  SentenceBuilderCompleted copyWith({
    SentenceBuilderResult? result,
    bool? isSavingToFsrs,
    int? addedToFsrsCount,
  }) {
    return SentenceBuilderCompleted(
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

class SentenceBuilderError extends SentenceBuilderState {
  final String message;

  const SentenceBuilderError(this.message);

  @override
  List<Object?> get props => [message];
}
