import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/radio_novela_entities.dart';
import '../../domain/repositories/radio_novela_repository.dart';
import 'radio_player_state.dart';

class RadioPlayerCubit extends Cubit<RadioPlayerState> {
  final RadioNovelaRepository _repository;
  final HybridAudioPlaybackService _audioService;
  final SrsRepository? _srsRepository;

  RadioPlayerCubit({
    required AudioDramaEntity drama,
    required RadioNovelaRepository repository,
    required HybridAudioPlaybackService audioService,
    SrsRepository? srsRepository,
  })  : _repository = repository,
        _audioService = audioService,
        _srsRepository = srsRepository,
        super(RadioPlayerState(drama: drama));

  void nextLine() {
    if (state.isLastLineInScene) {
      if (state.isLastScene) {
        if (!state.isCompleted) {
          emit(state.copyWith(isCompleted: true));
          _repository.recordDramaCompleted(
            dramaId: state.drama.id,
            scenesFinished: state.drama.scenes.length,
          );
        }
      } else {
        stopAudio();
        emit(state.copyWith(
          currentSceneIndex: state.currentSceneIndex + 1,
          currentLineIndex: 0,
        ));
        if (state.isAutoPlay) {
          playCurrentLine();
        }
      }
    } else {
      stopAudio();
      emit(state.copyWith(
        currentLineIndex: state.currentLineIndex + 1,
      ));
      if (state.isAutoPlay) {
        playCurrentLine();
      }
    }
  }

  void previousLine() {
    if (state.currentLineIndex > 0) {
      stopAudio();
      emit(state.copyWith(
        currentLineIndex: state.currentLineIndex - 1,
      ));
    } else if (state.currentSceneIndex > 0) {
      stopAudio();
      final prevSceneIdx = state.currentSceneIndex - 1;
      emit(state.copyWith(
        currentSceneIndex: prevSceneIdx,
        currentLineIndex: state.drama.scenes[prevSceneIdx].lines.length - 1,
      ));
    }
  }

  Future<void> playCurrentLine() async {
    final line = state.currentLine;
    emit(state.copyWith(isPlayingAudio: true));

    final targetDialect = state.drama.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    await _audioService.playAudioOrSpeak(
      fallbackText: line.audioSnippetText,
      dialect: targetDialect,
      rate: state.speechRate,
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

  void toggleAutoPlay() {
    emit(state.copyWith(isAutoPlay: !state.isAutoPlay));
  }

  void setSpeechRate(double rate) {
    emit(state.copyWith(speechRate: rate));
  }

  void toggleTranslation() {
    emit(state.copyWith(showTranslation: !state.showTranslation));
  }

  void toggleStageDirection() {
    emit(state.copyWith(showStageDirection: !state.showStageDirection));
  }

  void selectChoice(String choiceId) {
    emit(state.copyWith(chosenOptionId: choiceId));
  }

  Future<bool> addToFsrs(DramaLineEntity line) async {
    if (_srsRepository == null) return false;

    final targetDialect = state.drama.dialect;
    final card = SrsCardEntity(
      id: 'drama_${line.id}_${DateTime.now().millisecondsSinceEpoch}',
      portuguese: line.textPt,
      russianTranslation: line.translationRu,
      partOfSpeech: 'frase dramática',
      category: 'radionovela',
      dialect: targetDialect,
      examplePortuguese: line.textPt,
      exampleRussian: line.translationRu,
      notes: '${state.drama.titlePt} (${line.characterName}) • ${line.slangOrIdiomNoteRu}',
      fsrsState: 'newCard',
      stability: 0.0,
      difficulty: 0.0,
      reps: 0,
      lapses: 0,
      dueAt: DateTime.now(),
    );

    await _srsRepository.addCard(card);
    return true;
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
