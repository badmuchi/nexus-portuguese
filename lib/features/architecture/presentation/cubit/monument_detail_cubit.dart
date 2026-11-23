import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/architecture_entities.dart';
import '../../domain/repositories/architecture_repository.dart';
import 'monument_detail_state.dart';

class MonumentDetailCubit extends Cubit<MonumentDetailState> {
  final ArchitectureRepository _repository;
  final HybridAudioPlaybackService _audioService;

  MonumentDetailCubit({
    required ArchitecturalMonumentEntity monument,
    required ArchitectureRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(MonumentDetailState(monument: monument)) {
    _repository.recordMonumentViewed(monument.id);
  }

  void toggleArchitectureDetails() {
    emit(state.copyWith(
      showArchitectureDetails: !state.showArchitectureDetails,
    ));
  }

  Future<void> playAudio() async {
    final text =
        '${state.monument.title}, em ${state.monument.city}. Arquiteto ${state.monument.architect}. ${state.monument.audioSnippet}';
    emit(state.copyWith(isPlayingAudio: true));

    final dialect = state.monument.isPtPt
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

  Future<void> addVocabToSrs(ArchitectVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addArchitectureVocabToSrs(vocab,
        dialect: state.monument.dialect);
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
