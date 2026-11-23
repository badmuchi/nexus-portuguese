import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/carnival_entities.dart';
import '../../domain/repositories/carnival_repository.dart';
import 'carnival_detail_state.dart';

class CarnivalDetailCubit extends Cubit<CarnivalDetailState> {
  final CarnivalRepository _repository;
  final HybridAudioPlaybackService _audioService;

  CarnivalDetailCubit({
    required CarnivalTraditionEntity tradition,
    required CarnivalRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(CarnivalDetailState(tradition: tradition)) {
    _repository.recordTraditionViewed(tradition.id);
  }

  Future<void> playAudio() async {
    final text = '${state.tradition.title}. ${state.tradition.audioNarration}';
    emit(state.copyWith(isPlayingAudio: true));

    final dialect = state.tradition.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    await _audioService.playAudioOrSpeak(
      fallbackText: text,
      dialect: dialect,
      rate: 0.95,
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

  Future<void> addVocabToSrs(CarnivalVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addCarnivalVocabToSrs(
      vocab,
      dialect: state.tradition.dialect,
    );
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
