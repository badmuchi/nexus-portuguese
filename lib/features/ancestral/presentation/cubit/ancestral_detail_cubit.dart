import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/ancestral_entities.dart';
import '../../domain/repositories/ancestral_repository.dart';
import 'ancestral_detail_state.dart';

class AncestralDetailCubit extends Cubit<AncestralDetailState> {
  final AncestralRepository _repository;
  final HybridAudioPlaybackService _audioService;

  AncestralDetailCubit({
    required TraditionalCommunityEntity community,
    required AncestralRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(AncestralDetailState(community: community)) {
    _repository.recordCommunityViewed(community.id);
  }

  Future<void> playAudio() async {
    final text = '${state.community.title}. ${state.community.audioNarration}';
    emit(state.copyWith(isPlayingAudio: true));

    final dialect = state.community.isPtPt
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

  Future<void> addVocabToSrs(AncestralVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addAncestralVocabToSrs(
      vocab,
      dialect: state.community.dialect,
    );
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
