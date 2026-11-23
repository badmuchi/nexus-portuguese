import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/fashion_entities.dart';
import '../../domain/repositories/fashion_repository.dart';
import 'fashion_detail_state.dart';

class FashionDetailCubit extends Cubit<FashionDetailState> {
  final FashionRepository _repository;
  final HybridAudioPlaybackService _audioService;

  FashionDetailCubit({
    required FashionTopicEntity topic,
    required FashionRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(FashionDetailState(topic: topic)) {
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

  Future<void> addVocabToSrs(FashionVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addFashionVocabToSrs(vocab, dialect: state.topic.dialect);
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
