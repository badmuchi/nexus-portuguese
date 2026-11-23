import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/wine_entities.dart';
import '../../domain/repositories/wine_repository.dart';
import 'wine_detail_state.dart';

class WineDetailCubit extends Cubit<WineDetailState> {
  final WineRepository _repository;
  final HybridAudioPlaybackService _audioService;

  WineDetailCubit({
    required WineRegionEntity region,
    required WineRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(WineDetailState(region: region)) {
    _repository.recordRegionViewed(region.id);
  }

  Future<void> playAudio() async {
    final text = '${state.region.name}. ${state.region.audioNarration}';
    emit(state.copyWith(isPlayingAudio: true));

    final dialect = state.region.isPtPt
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

  Future<void> addVocabToSrs(WineVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addWineVocabToSrs(vocab, dialect: state.region.dialect);
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
