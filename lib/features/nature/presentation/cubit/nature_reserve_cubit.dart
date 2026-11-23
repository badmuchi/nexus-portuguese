import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/nature_entities.dart';
import '../../domain/repositories/nature_repository.dart';
import 'nature_reserve_state.dart';

class NatureReserveCubit extends Cubit<NatureReserveState> {
  final NatureRepository _repository;
  final HybridAudioPlaybackService _audioService;

  NatureReserveCubit({
    required NatureReserveEntity reserve,
    required NatureRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(NatureReserveState(reserve: reserve));

  Future<void> completeTrail(NatureTrailEntity trail) async {
    final updated = Set<String>.from(state.completedTrailIds)..add(trail.id);
    emit(state.copyWith(completedTrailIds: updated));

    await _repository.recordTrailCompleted(
      trailId: trail.id,
      distanceKm: trail.distanceKm,
    );
  }

  Future<void> addSpeciesToSrs(SpeciesEntity species) async {
    final updated = Set<String>.from(state.addedSpeciesIds)..add(species.id);
    emit(state.copyWith(addedSpeciesIds: updated));

    await _repository.addSpeciesToSrs(species);
  }

  Future<void> playDescription() async {
    final text = '${state.reserve.namePt}. ${state.reserve.descriptionRu}';
    emit(state.copyWith(isPlayingAudio: true));

    final dialect = state.reserve.isPtPt
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

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
