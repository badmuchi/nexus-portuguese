import 'package:equatable/equatable.dart';
import '../../domain/entities/podcast_track_entity.dart';
import '../../domain/entities/shadowing_evaluation_entity.dart';
import '../../domain/entities/transcript_snippet_entity.dart';

class PodcastPlayerState extends Equatable {
  final PodcastTrack track;
  final int currentSnippetIndex;
  final bool isPlaying;
  final double playbackSpeed; // 0.75, 1.0, 1.25
  final bool isLoopSnippet;
  final bool showTranslation;
  final bool isRecording;
  final ShadowingEvaluationEntity? shadowingResult;
  final Set<int> completedSnippetIndices;
  final bool isCompleted;

  const PodcastPlayerState({
    required this.track,
    this.currentSnippetIndex = 0,
    this.isPlaying = false,
    this.playbackSpeed = 1.0,
    this.isLoopSnippet = false,
    this.showTranslation = true,
    this.isRecording = false,
    this.shadowingResult,
    this.completedSnippetIndices = const {},
    this.isCompleted = false,
  });

  TranscriptSnippet get currentSnippet {
    if (track.transcript.isEmpty) {
      return const TranscriptSnippet(
        id: 'empty',
        index: 0,
        startTimeMs: 0,
        endTimeMs: 0,
        textPt: '',
        translationRu: '',
      );
    }
    final index = currentSnippetIndex.clamp(0, track.transcript.length - 1);
    return track.transcript[index];
  }

  double get overallProgress {
    if (track.transcript.isEmpty) return 0.0;
    return (completedSnippetIndices.length / track.transcript.length).clamp(0.0, 1.0);
  }

  PodcastPlayerState copyWith({
    PodcastTrack? track,
    int? currentSnippetIndex,
    bool? isPlaying,
    double? playbackSpeed,
    bool? isLoopSnippet,
    bool? showTranslation,
    bool? isRecording,
    ShadowingEvaluationEntity? shadowingResult,
    bool clearShadowingResult = false,
    Set<int>? completedSnippetIndices,
    bool? isCompleted,
  }) {
    return PodcastPlayerState(
      track: track ?? this.track,
      currentSnippetIndex: currentSnippetIndex ?? this.currentSnippetIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      isLoopSnippet: isLoopSnippet ?? this.isLoopSnippet,
      showTranslation: showTranslation ?? this.showTranslation,
      isRecording: isRecording ?? this.isRecording,
      shadowingResult: clearShadowingResult ? null : (shadowingResult ?? this.shadowingResult),
      completedSnippetIndices: completedSnippetIndices ?? this.completedSnippetIndices,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        track,
        currentSnippetIndex,
        isPlaying,
        playbackSpeed,
        isLoopSnippet,
        showTranslation,
        isRecording,
        shadowingResult,
        completedSnippetIndices,
        isCompleted,
      ];
}
