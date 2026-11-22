import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/portuguese_song_entity.dart';
import '../../domain/repositories/music_repository.dart';
import 'song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final MusicRepository _repository;
  final HybridAudioPlaybackService _audioService;
  Timer? _lineTimer;

  SongPlayerCubit({
    required PortugueseSong song,
    required MusicRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(SongPlayerState(song: song));

  void togglePlayPause() {
    if (state.isPlaying) {
      pause();
    } else {
      playLine(state.currentLineIndex);
    }
  }

  void playLine(int index) {
    if (state.song.lyrics.isEmpty) return;

    final targetIndex = index.clamp(0, state.song.lyrics.length - 1);
    final line = state.song.lyrics[targetIndex];

    _lineTimer?.cancel();

    emit(state.copyWith(
      currentLineIndex: targetIndex,
      isPlaying: true,
      clearQuizSelection: true,
    ));

    final dialect = state.song.isPtPt ? PortugueseDialect.european : PortugueseDialect.brazilian;
    _audioService.playAudioOrSpeak(
      fallbackText: line.textPt,
      dialect: dialect,
      rate: (state.playbackSpeed * 0.45).clamp(0.2, 1.0),
    );

    final durationMs = ((line.durationMs > 0 ? line.durationMs : 4500) / state.playbackSpeed).round();
    _lineTimer = Timer(Duration(milliseconds: durationMs), () {
      _onLineFinished(targetIndex);
    });
  }

  void _onLineFinished(int finishedIndex) {
    final updatedCompleted = Set<int>.from(state.completedLineIndices)..add(finishedIndex);
    final isLast = finishedIndex >= state.song.lyrics.length - 1;

    if (isLast) {
      emit(state.copyWith(
        completedLineIndices: updatedCompleted,
        isPlaying: false,
        isSongCompleted: true,
      ));
      _recordProgress(updatedCompleted.length);
    } else if (state.isPlaying) {
      emit(state.copyWith(
        completedLineIndices: updatedCompleted,
      ));
      playLine(finishedIndex + 1);
    }
  }

  void pause() {
    _lineTimer?.cancel();
    _audioService.stop();
    emit(state.copyWith(isPlaying: false));
  }

  void stop() {
    pause();
  }

  void seekToLine(int index) {
    final targetIndex = index.clamp(0, state.song.lyrics.length - 1);
    playLine(targetIndex);
  }

  void nextLine() {
    if (state.currentLineIndex < state.song.lyrics.length - 1) {
      if (state.isPlaying) {
        playLine(state.currentLineIndex + 1);
      } else {
        emit(state.copyWith(
          currentLineIndex: state.currentLineIndex + 1,
          clearQuizSelection: true,
        ));
      }
    }
  }

  void previousLine() {
    if (state.currentLineIndex > 0) {
      if (state.isPlaying) {
        playLine(state.currentLineIndex - 1);
      } else {
        emit(state.copyWith(
          currentLineIndex: state.currentLineIndex - 1,
          clearQuizSelection: true,
        ));
      }
    }
  }

  void setPlaybackSpeed(double speed) {
    emit(state.copyWith(playbackSpeed: speed));
    if (state.isPlaying) {
      playLine(state.currentLineIndex);
    }
  }

  void toggleTranslation() {
    emit(state.copyWith(showTranslation: !state.showTranslation));
  }

  void toggleQuizMode() {
    emit(state.copyWith(
      isQuizMode: !state.isQuizMode,
      clearQuizSelection: true,
    ));
  }

  void selectQuizOption(String option) {
    final current = state.currentLine;
    final targetWord = current.targetMissingWord?.trim().toLowerCase();
    final isCorrect = targetWord != null && option.trim().toLowerCase() == targetWord;

    final newScore = isCorrect ? state.quizScore + 10 : state.quizScore;
    final updatedCompleted = isCorrect
        ? (Set<int>.from(state.completedLineIndices)..add(state.currentLineIndex))
        : state.completedLineIndices;

    final isAllDone = updatedCompleted.length >= state.song.lyrics.length;

    emit(state.copyWith(
      selectedQuizOption: option,
      isOptionCorrect: isCorrect,
      quizScore: newScore,
      completedLineIndices: updatedCompleted,
      isSongCompleted: isAllDone ? true : state.isSongCompleted,
    ));

    if (isCorrect) {
      final dialect = state.song.isPtPt ? PortugueseDialect.european : PortugueseDialect.brazilian;
      _audioService.playAudioOrSpeak(
        fallbackText: current.textPt,
        dialect: dialect,
      );
      _recordProgress(updatedCompleted.length);
    }
  }

  void markCurrentLineCompleted() {
    final updated = Set<int>.from(state.completedLineIndices)..add(state.currentLineIndex);
    final isAllDone = updated.length >= state.song.lyrics.length;
    emit(state.copyWith(
      completedLineIndices: updated,
      isSongCompleted: isAllDone ? true : state.isSongCompleted,
    ));
    _recordProgress(updated.length);
  }

  void resetProgress() {
    _lineTimer?.cancel();
    _audioService.stop();
    emit(state.copyWith(
      currentLineIndex: 0,
      isPlaying: false,
      completedLineIndices: const {},
      clearQuizSelection: true,
      quizScore: 0,
      isSongCompleted: false,
    ));
  }

  Future<void> _recordProgress(int completedCount) async {
    await _repository.recordSongPractice(
      songId: state.song.id,
      linesCompleted: completedCount,
      totalLines: state.song.lyrics.length,
    );
  }

  @override
  Future<void> close() {
    _lineTimer?.cancel();
    _audioService.stop();
    return super.close();
  }
}
