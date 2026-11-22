import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/movie_scene_entity.dart';
import '../../domain/repositories/cinema_repository.dart';
import 'scene_player_state.dart';

class ScenePlayerCubit extends Cubit<ScenePlayerState> {
  final CinemaRepository _repository;
  final HybridAudioPlaybackService _audioService;
  Timer? _autoPlayTimer;

  ScenePlayerCubit({
    required MovieSceneEntity scene,
    required CinemaRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(ScenePlayerState(scene: scene));

  void selectLine(int index) {
    if (index < 0 || index >= state.scene.dialogueLines.length) return;
    _stopAutoPlayTimer();
    emit(state.copyWith(currentLineIndex: index, isPlaying: false));
  }

  void nextLine() {
    _stopAutoPlayTimer();
    final updatedPracticed = Set<int>.from(state.practicedLineIndices)..add(state.currentLineIndex);

    if (state.isLastLine) {
      emit(state.copyWith(
        isSceneCompleted: true,
        practicedLineIndices: updatedPracticed,
        isPlaying: false,
      ));
      _repository.recordSceneCompleted(
        sceneId: state.scene.id,
        linesPracticed: updatedPracticed.length,
      );
    } else {
      emit(state.copyWith(
        currentLineIndex: state.currentLineIndex + 1,
        practicedLineIndices: updatedPracticed,
        isPlaying: false,
      ));
    }
  }

  void previousLine() {
    if (state.currentLineIndex == 0) return;
    _stopAutoPlayTimer();
    emit(state.copyWith(
      currentLineIndex: state.currentLineIndex - 1,
      isPlaying: false,
    ));
  }

  void toggleAutoPlay() {
    final nextAutoPlay = !state.isAutoPlay;
    emit(state.copyWith(isAutoPlay: nextAutoPlay));

    if (nextAutoPlay) {
      playCurrentLineAudio();
      _scheduleAutoPlayAdvance();
    } else {
      _stopAutoPlayTimer();
    }
  }

  void toggleDubbingMode() {
    emit(state.copyWith(isDubbingMode: !state.isDubbingMode));
  }

  void playCurrentLineAudio() {
    final dialect = state.scene.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    emit(state.copyWith(isPlaying: true));

    _audioService.playAudioOrSpeak(
      fallbackText: state.currentLine.textPt,
      dialect: dialect,
    );

    // After brief delay, reset isPlaying flag
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!isClosed) {
        emit(state.copyWith(isPlaying: false));
      }
    });
  }

  void restart() {
    _stopAutoPlayTimer();
    emit(ScenePlayerState(
      scene: state.scene,
      isDubbingMode: state.isDubbingMode,
    ));
  }

  void _scheduleAutoPlayAdvance() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer(const Duration(seconds: 4), () {
      if (!isClosed && state.isAutoPlay) {
        if (!state.isLastLine) {
          nextLine();
          playCurrentLineAudio();
          _scheduleAutoPlayAdvance();
        } else {
          emit(state.copyWith(isAutoPlay: false));
        }
      }
    });
  }

  void _stopAutoPlayTimer() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  @override
  Future<void> close() {
    _stopAutoPlayTimer();
    return super.close();
  }
}
