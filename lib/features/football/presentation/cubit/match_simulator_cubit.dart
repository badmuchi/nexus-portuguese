import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/football_entities.dart';
import '../../domain/repositories/football_repository.dart';
import 'match_simulator_state.dart';

class MatchSimulatorCubit extends Cubit<MatchSimulatorState> {
  final FootballRepository _repository;
  final HybridAudioPlaybackService _audioService;

  MatchSimulatorCubit({
    required FootballMatchEntity match,
    required FootballRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(MatchSimulatorState(match: match));

  void nextMoment() {
    if (state.isLastMoment) {
      if (!state.isCompleted) {
        emit(state.copyWith(isCompleted: true));
        _repository.recordMatchPractice(
          matchId: state.match.id,
          momentsPracticed: state.match.moments.length,
        );
      }
    } else {
      stopAudio();
      emit(state.copyWith(
        currentMomentIndex: state.currentMomentIndex + 1,
      ));
    }
  }

  void previousMoment() {
    if (!state.isFirstMoment) {
      stopAudio();
      emit(state.copyWith(
        currentMomentIndex: state.currentMomentIndex - 1,
      ));
    }
  }

  Future<void> playCommentary() async {
    final moment = state.currentMoment;
    emit(state.copyWith(isPlayingAudio: true));

    final targetDialect = state.match.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    await _audioService.playAudioOrSpeak(
      fallbackText: moment.commentaryPt,
      dialect: targetDialect,
      rate: 1.05, // High-tempo authentic football commentator energy
    );

    if (!isClosed) {
      emit(state.copyWith(isPlayingAudio: false));
    }
  }

  Future<void> stopAudio() async {
    await _audioService.stop();
    if (!isClosed) {
      emit(state.copyWith(isPlayingAudio: false));
    }
  }

  void restart() {
    stopAudio();
    emit(state.copyWith(
      currentMomentIndex: 0,
      isCompleted: false,
    ));
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
