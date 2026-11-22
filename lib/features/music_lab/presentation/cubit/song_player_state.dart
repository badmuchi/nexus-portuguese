import 'package:equatable/equatable.dart';
import '../../domain/entities/portuguese_song_entity.dart';
import '../../domain/entities/song_lyric_line_entity.dart';

class SongPlayerState extends Equatable {
  final PortugueseSong song;
  final int currentLineIndex;
  final bool isPlaying;
  final double playbackSpeed;
  final bool showTranslation;
  final bool isQuizMode;
  final Set<int> completedLineIndices;
  final String? selectedQuizOption;
  final bool? isOptionCorrect;
  final int quizScore;
  final bool isSongCompleted;

  const SongPlayerState({
    required this.song,
    this.currentLineIndex = 0,
    this.isPlaying = false,
    this.playbackSpeed = 1.0,
    this.showTranslation = true,
    this.isQuizMode = false,
    this.completedLineIndices = const {},
    this.selectedQuizOption,
    this.isOptionCorrect,
    this.quizScore = 0,
    this.isSongCompleted = false,
  });

  SongLyricLine get currentLine {
    if (song.lyrics.isEmpty) {
      return const SongLyricLine(
        id: 'empty',
        index: 0,
        startTimeMs: 0,
        endTimeMs: 0,
        textPt: '',
        translationRu: '',
      );
    }
    final idx = currentLineIndex.clamp(0, song.lyrics.length - 1);
    return song.lyrics[idx];
  }

  double get progress {
    if (song.lyrics.isEmpty) return 0.0;
    return (completedLineIndices.length / song.lyrics.length).clamp(0.0, 1.0);
  }

  SongPlayerState copyWith({
    PortugueseSong? song,
    int? currentLineIndex,
    bool? isPlaying,
    double? playbackSpeed,
    bool? showTranslation,
    bool? isQuizMode,
    Set<int>? completedLineIndices,
    String? selectedQuizOption,
    bool clearQuizSelection = false,
    bool? isOptionCorrect,
    int? quizScore,
    bool? isSongCompleted,
  }) {
    return SongPlayerState(
      song: song ?? this.song,
      currentLineIndex: currentLineIndex ?? this.currentLineIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      showTranslation: showTranslation ?? this.showTranslation,
      isQuizMode: isQuizMode ?? this.isQuizMode,
      completedLineIndices: completedLineIndices ?? this.completedLineIndices,
      selectedQuizOption: clearQuizSelection ? null : (selectedQuizOption ?? this.selectedQuizOption),
      isOptionCorrect: clearQuizSelection ? null : (isOptionCorrect ?? this.isOptionCorrect),
      quizScore: quizScore ?? this.quizScore,
      isSongCompleted: isSongCompleted ?? this.isSongCompleted,
    );
  }

  @override
  List<Object?> get props => [
        song,
        currentLineIndex,
        isPlaying,
        playbackSpeed,
        showTranslation,
        isQuizMode,
        completedLineIndices,
        selectedQuizOption,
        isOptionCorrect,
        quizScore,
        isSongCompleted,
      ];
}
