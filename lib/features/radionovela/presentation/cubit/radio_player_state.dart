import 'package:equatable/equatable.dart';
import '../../domain/entities/radio_novela_entities.dart';

class RadioPlayerState extends Equatable {
  final AudioDramaEntity drama;
  final int currentSceneIndex;
  final int currentLineIndex;
  final bool isPlayingAudio;
  final bool isAutoPlay;
  final double speechRate;
  final bool showTranslation;
  final bool showStageDirection;
  final String? chosenOptionId;
  final bool isCompleted;

  const RadioPlayerState({
    required this.drama,
    this.currentSceneIndex = 0,
    this.currentLineIndex = 0,
    this.isPlayingAudio = false,
    this.isAutoPlay = true,
    this.speechRate = 1.0,
    this.showTranslation = true,
    this.showStageDirection = true,
    this.chosenOptionId,
    this.isCompleted = false,
  });

  DramaSceneEntity get currentScene => drama.scenes[currentSceneIndex];

  DramaLineEntity get currentLine => currentScene.lines[currentLineIndex];

  bool get isFirstLine => currentSceneIndex == 0 && currentLineIndex == 0;

  bool get isLastLineInScene => currentLineIndex == currentScene.lines.length - 1;

  bool get isLastScene => currentSceneIndex == drama.scenes.length - 1;

  bool get isEpisodeFinished => isLastScene && isLastLineInScene;

  double get progress {
    if (drama.scenes.isEmpty) return 0.0;
    int linesBefore = 0;
    for (int i = 0; i < currentSceneIndex; i++) {
      linesBefore += drama.scenes[i].lines.length;
    }
    final currentTotal = linesBefore + currentLineIndex + 1;
    return (currentTotal / drama.totalLines).clamp(0.0, 1.0);
  }

  DramaCharacterEntity? get currentCharacter {
    final charId = currentLine.characterId;
    return drama.characters.firstWhere(
      (c) => c.id == charId,
      orElse: () => DramaCharacterEntity(
        id: charId,
        namePt: currentLine.characterName,
        roleRu: '',
        voiceEmoji: '🎙️',
        accentNoteRu: '',
      ),
    );
  }

  RadioPlayerState copyWith({
    AudioDramaEntity? drama,
    int? currentSceneIndex,
    int? currentLineIndex,
    bool? isPlayingAudio,
    bool? isAutoPlay,
    double? speechRate,
    bool? showTranslation,
    bool? showStageDirection,
    String? chosenOptionId,
    bool? isCompleted,
  }) {
    return RadioPlayerState(
      drama: drama ?? this.drama,
      currentSceneIndex: currentSceneIndex ?? this.currentSceneIndex,
      currentLineIndex: currentLineIndex ?? this.currentLineIndex,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      isAutoPlay: isAutoPlay ?? this.isAutoPlay,
      speechRate: speechRate ?? this.speechRate,
      showTranslation: showTranslation ?? this.showTranslation,
      showStageDirection: showStageDirection ?? this.showStageDirection,
      chosenOptionId: chosenOptionId ?? this.chosenOptionId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        drama,
        currentSceneIndex,
        currentLineIndex,
        isPlayingAudio,
        isAutoPlay,
        speechRate,
        showTranslation,
        showStageDirection,
        chosenOptionId,
        isCompleted,
      ];
}
