import 'package:equatable/equatable.dart';
import '../../domain/entities/football_entities.dart';

class MatchSimulatorState extends Equatable {
  final FootballMatchEntity match;
  final int currentMomentIndex;
  final bool isPlayingAudio;
  final bool isCompleted;

  const MatchSimulatorState({
    required this.match,
    this.currentMomentIndex = 0,
    this.isPlayingAudio = false,
    this.isCompleted = false,
  });

  MatchMomentEntity get currentMoment => match.moments[currentMomentIndex];

  bool get isFirstMoment => currentMomentIndex == 0;
  bool get isLastMoment => currentMomentIndex == match.moments.length - 1;

  double get progress =>
      match.moments.isNotEmpty
          ? (currentMomentIndex + 1) / match.moments.length
          : 0.0;

  int get currentScoreHome => currentMoment.scoreHome;
  int get currentScoreAway => currentMoment.scoreAway;

  MatchSimulatorState copyWith({
    FootballMatchEntity? match,
    int? currentMomentIndex,
    bool? isPlayingAudio,
    bool? isCompleted,
  }) {
    return MatchSimulatorState(
      match: match ?? this.match,
      currentMomentIndex: currentMomentIndex ?? this.currentMomentIndex,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        match,
        currentMomentIndex,
        isPlayingAudio,
        isCompleted,
      ];
}
