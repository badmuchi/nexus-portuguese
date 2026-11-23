import 'package:equatable/equatable.dart';
import '../../domain/entities/humor_entities.dart';

class JokeReaderState extends Equatable {
  final JokeEntity joke;
  final bool isPunchlineRevealed;
  final bool isPlayingAudio;
  final bool showExplanation;
  final bool? userReaction; // true = funny, false = not funny, null = none
  final Set<String> addedVocabIds;

  const JokeReaderState({
    required this.joke,
    this.isPunchlineRevealed = false,
    this.isPlayingAudio = false,
    this.showExplanation = false,
    this.userReaction,
    this.addedVocabIds = const {},
  });

  JokeReaderState copyWith({
    JokeEntity? joke,
    bool? isPunchlineRevealed,
    bool? isPlayingAudio,
    bool? showExplanation,
    bool? userReaction,
    Set<String>? addedVocabIds,
  }) {
    return JokeReaderState(
      joke: joke ?? this.joke,
      isPunchlineRevealed: isPunchlineRevealed ?? this.isPunchlineRevealed,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      showExplanation: showExplanation ?? this.showExplanation,
      userReaction: userReaction ?? this.userReaction,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [
        joke,
        isPunchlineRevealed,
        isPlayingAudio,
        showExplanation,
        userReaction,
        addedVocabIds,
      ];
}
