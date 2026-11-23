import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/finance_entities.dart';
import '../../domain/repositories/finance_repository.dart';
import 'finance_topic_detail_state.dart';

class FinanceTopicDetailCubit extends Cubit<FinanceTopicDetailState> {
  final FinanceRepository _repository;
  final HybridAudioPlaybackService _audioService;

  FinanceTopicDetailCubit({
    required FinanceTopicEntity topic,
    required FinanceRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(FinanceTopicDetailState(topic: topic)) {
    _repository.recordTopicViewed(topic.id);
  }

  Future<void> playAudio() async {
    final text =
        '${state.topic.title}. ${state.topic.audioSnippet}';
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

  Future<void> addVocabToSrs(FinanceVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addFinanceVocabToSrs(vocab, dialect: state.topic.dialect);
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
