import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/art_entities.dart';
import '../../domain/repositories/art_repository.dart';
import 'artwork_detail_state.dart';

class ArtworkDetailCubit extends Cubit<ArtworkDetailState> {
  final ArtRepository _repository;
  final HybridAudioPlaybackService _audioService;

  ArtworkDetailCubit({
    required ArtworkEntity artwork,
    required ArtRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(ArtworkDetailState(artwork: artwork)) {
    _repository.recordArtworkViewed(artwork.id);
  }

  void toggleCuratorNotes() {
    emit(state.copyWith(showCuratorNotes: !state.showCuratorNotes));
  }

  Future<void> playAudio() async {
    final text =
        '${state.artwork.titlePt}, de ${state.artwork.artistName}. ${state.artwork.techniquePt}. ${state.artwork.descriptionRu}';
    emit(state.copyWith(isPlayingAudio: true));

    final dialect = state.artwork.isPtPt
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

  Future<void> addVocabToSrs(ArtVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addArtVocabToSrs(vocab, dialect: state.artwork.dialect);
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
