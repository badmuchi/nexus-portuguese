import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_scene_entity.dart';

class ScenePlayerState extends Equatable {
  final MovieSceneEntity scene;
  final int currentLineIndex;
  final bool isPlaying;
  final bool isAutoPlay;
  final bool isDubbingMode;
  final bool isSceneCompleted;
  final Set<int> practicedLineIndices;

  const ScenePlayerState({
    required this.scene,
    this.currentLineIndex = 0,
    this.isPlaying = false,
    this.isAutoPlay = false,
    this.isDubbingMode = false,
    this.isSceneCompleted = false,
    this.practicedLineIndices = const {},
  });

  CinemaDialogueLineEntity get currentLine => scene.dialogueLines[currentLineIndex];

  bool get isLastLine => currentLineIndex == scene.dialogueLines.length - 1;

  double get progress =>
      scene.dialogueLines.isNotEmpty ? (currentLineIndex + 1) / scene.dialogueLines.length : 0.0;

  ScenePlayerState copyWith({
    MovieSceneEntity? scene,
    int? currentLineIndex,
    bool? isPlaying,
    bool? isAutoPlay,
    bool? isDubbingMode,
    bool? isSceneCompleted,
    Set<int>? practicedLineIndices,
  }) {
    return ScenePlayerState(
      scene: scene ?? this.scene,
      currentLineIndex: currentLineIndex ?? this.currentLineIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isAutoPlay: isAutoPlay ?? this.isAutoPlay,
      isDubbingMode: isDubbingMode ?? this.isDubbingMode,
      isSceneCompleted: isSceneCompleted ?? this.isSceneCompleted,
      practicedLineIndices: practicedLineIndices ?? this.practicedLineIndices,
    );
  }

  @override
  List<Object?> get props => [
        scene,
        currentLineIndex,
        isPlaying,
        isAutoPlay,
        isDubbingMode,
        isSceneCompleted,
        practicedLineIndices,
      ];
}
