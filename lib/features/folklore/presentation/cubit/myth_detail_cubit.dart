import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/folklore_entities.dart';
import '../../domain/repositories/folklore_repository.dart';
import 'myth_detail_state.dart';

class MythDetailCubit extends Cubit<MythDetailState> {
  final FolkloreRepository _repository;
  final HybridAudioPlaybackService _audioService;

  MythDetailCubit({
    required MythicalEntity myth,
    required FolkloreRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(MythDetailState(myth: myth)) {
    _repository.recordMythViewed(myth.id);
  }

  Future<void> playAudio() async {
    final text =
        '${state.myth.name}. ${state.myth.audioNarration}';
    emit(state.copyWith(isPlayingAudio: true));

    final dialect = state.myth.isPtPt
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

  Future<void> addVocabToSrs(FolkloreVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addFolkloreVocabToSrs(vocab, dialect: state.myth.dialect);
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
