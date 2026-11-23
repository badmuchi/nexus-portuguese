import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/humor_entities.dart';
import '../../domain/repositories/humor_repository.dart';
import 'joke_reader_state.dart';

class JokeReaderCubit extends Cubit<JokeReaderState> {
  final HumorRepository _repository;
  final HybridAudioPlaybackService _audioService;

  JokeReaderCubit({
    required JokeEntity joke,
    required HumorRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(JokeReaderState(joke: joke));

  void revealPunchline() {
    emit(state.copyWith(isPunchlineRevealed: true));
  }

  void toggleExplanation() {
    emit(state.copyWith(showExplanation: !state.showExplanation));
  }

  Future<void> playAudio({bool isPunchline = false}) async {
    final text = isPunchline ? state.joke.punchlinePt : state.joke.setupPt;
    emit(state.copyWith(isPlayingAudio: true));

    final targetDialect = state.joke.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    await _audioService.playAudioOrSpeak(
      fallbackText: text,
      dialect: targetDialect,
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

  Future<void> rateJoke(bool liked) async {
    emit(state.copyWith(userReaction: liked));
    await _repository.recordJokeReaction(jokeId: state.joke.id, liked: liked);
  }

  Future<void> addToSrs(JokeVocabEntity vocab) async {
    final updated = Set<String>.from(state.addedVocabIds)..add(vocab.id);
    emit(state.copyWith(addedVocabIds: updated));

    await _repository.addWordToSrs(vocab, dialect: state.joke.dialect);
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
