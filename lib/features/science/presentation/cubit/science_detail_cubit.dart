import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/science_entities.dart';
import '../../domain/repositories/science_repository.dart';
import 'science_detail_state.dart';

class ScienceDetailCubit extends Cubit<ScienceDetailState> {
  final ScienceRepository _repository;
  final HybridAudioPlaybackService _audioService;

  ScienceDetailCubit({
    required ScienceTopicEntity topic,
    required ScienceRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(ScienceDetailState(topic: topic)) {
    _repository.recordTopicViewed(topic.id);
  }

  Future<void> playAudio() async {
    final text = '${state.topic.title}. ${state.topic.audioNarration}';
    emit(state.copyWith(isPlayingAudio: true));

    final dialect = state.topic.isPtPt
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

  Future<void> addVocabToSrs(ScienceVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addScienceVocabToSrs(vocab, dialect: state.topic.dialect);
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
