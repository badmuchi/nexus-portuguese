import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/festas_entities.dart';
import '../../domain/repositories/festas_repository.dart';
import 'festa_detail_state.dart';

class FestaDetailCubit extends Cubit<FestaDetailState> {
  final FestasRepository _repository;
  final HybridAudioPlaybackService _audioService;

  FestaDetailCubit({
    required FestaEntity festa,
    required FestasRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(FestaDetailState(festa: festa)) {
    _repository.recordFestaViewed(festa.id);
  }

  Future<void> playAudio() async {
    final text =
        '${state.festa.title}, em ${state.festa.region}. ${state.festa.audioSnippet}';
    emit(state.copyWith(isPlayingAudio: true));

    final dialect = state.festa.isPtPt
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

  Future<void> addVocabToSrs(FestaVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addFestaVocabToSrs(vocab, dialect: state.festa.dialect);
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
