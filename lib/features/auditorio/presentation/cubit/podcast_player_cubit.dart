import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/core/speech/pronunciation_accuracy_evaluator.dart';
import 'package:nexus_portuguese_app/core/speech/speech_recognition_service.dart';
import '../../domain/entities/podcast_track_entity.dart';
import '../../domain/entities/shadowing_evaluation_entity.dart';
import '../../domain/repositories/auditorio_repository.dart';
import 'podcast_player_state.dart';

class PodcastPlayerCubit extends Cubit<PodcastPlayerState> {
  final AuditorioRepository _repository;
  final HybridAudioPlaybackService _audioService;
  final SpeechRecognitionService? _speechService;
  StreamSubscription<String>? _speechSubscription;
  Timer? _snippetPlaybackTimer;

  PodcastPlayerCubit({
    required PodcastTrack track,
    required AuditorioRepository repository,
    required HybridAudioPlaybackService audioService,
    SpeechRecognitionService? speechService,
  })  : _repository = repository,
        _audioService = audioService,
        _speechService = speechService,
        super(PodcastPlayerState(track: track));

  PortugueseDialect get _targetDialect {
    return state.track.isPtPt ? PortugueseDialect.european : PortugueseDialect.brazilian;
  }

  /// Начать или возобновить воспроизведение с текущего сниппета.
  Future<void> play() async {
    final snippet = state.currentSnippet;
    if (snippet.textPt.isEmpty) return;

    emit(state.copyWith(isPlaying: true));
    await _playSnippet(state.currentSnippetIndex);
  }

  /// Приостановить воспроизведение.
  Future<void> pause() async {
    _snippetPlaybackTimer?.cancel();
    await _audioService.stop();
    emit(state.copyWith(isPlaying: false));
  }

  /// Переключить play/pause.
  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  /// Переключиться на сниппет по индексу.
  Future<void> seekToSnippet(int index, {bool autoPlay = true}) async {
    if (index < 0 || index >= state.track.transcript.length) return;

    _snippetPlaybackTimer?.cancel();
    emit(state.copyWith(
      currentSnippetIndex: index,
      clearShadowingResult: true,
    ));

    if (autoPlay || state.isPlaying) {
      emit(state.copyWith(isPlaying: true));
      await _playSnippet(index);
    }
  }

  /// Следующий фрагмент.
  Future<void> nextSnippet() async {
    if (state.currentSnippetIndex < state.track.transcript.length - 1) {
      await seekToSnippet(state.currentSnippetIndex + 1);
    } else {
      await _onTrackFinished();
    }
  }

  /// Предыдущий фрагмент.
  Future<void> previousSnippet() async {
    if (state.currentSnippetIndex > 0) {
      await seekToSnippet(state.currentSnippetIndex - 1);
    }
  }

  /// Изменить скорость воспроизведения (0.75, 1.0, 1.25).
  Future<void> setPlaybackSpeed(double speed) async {
    emit(state.copyWith(playbackSpeed: speed));
    if (state.isPlaying) {
      await _playSnippet(state.currentSnippetIndex);
    }
  }

  /// Включить / выключить зацикливание одного сниппета.
  void toggleLoopSnippet() {
    emit(state.copyWith(isLoopSnippet: !state.isLoopSnippet));
  }

  /// Показать / скрыть перевод на русский язык.
  void toggleTranslation() {
    emit(state.copyWith(showTranslation: !state.showTranslation));
  }

  /// Воспроизвести один сниппет.
  Future<void> _playSnippet(int index) async {
    _snippetPlaybackTimer?.cancel();

    if (index < 0 || index >= state.track.transcript.length) {
      await _onTrackFinished();
      return;
    }

    final snippet = state.track.transcript[index];
    final updatedCompleted = Set<int>.from(state.completedSnippetIndices)..add(index);
    emit(state.copyWith(completedSnippetIndices: updatedCompleted));

    // Рассчитываем примерную длительность фрагмента с учетом скорости
    final baseDurationMs = snippet.durationMs > 0
        ? snippet.durationMs
        : (snippet.textPt.split(' ').length * 550).clamp(2500, 15000);
    final durationWithSpeed = (baseDurationMs / state.playbackSpeed).round();

    await _audioService.playAudioOrSpeak(
      fallbackText: snippet.textPt,
      dialect: _targetDialect,
      rate: state.playbackSpeed,
    );

    // Таймер перехода к следующему сниппету (или повтору, если зациклен)
    _snippetPlaybackTimer = Timer(Duration(milliseconds: durationWithSpeed), () async {
      if (!state.isPlaying) return;

      if (state.isLoopSnippet) {
        await _playSnippet(index);
      } else if (index < state.track.transcript.length - 1) {
        emit(state.copyWith(currentSnippetIndex: index + 1));
        await _playSnippet(index + 1);
      } else {
        await _onTrackFinished();
      }
    });
  }

  /// Завершение прослушивания трека целиком.
  Future<void> _onTrackFinished() async {
    _snippetPlaybackTimer?.cancel();
    emit(state.copyWith(
      isPlaying: false,
      isCompleted: true,
    ));

    await _repository.recordPodcastListenProgress(
      podcastId: state.track.id,
      completedSnippets: state.track.transcript.length,
      totalSnippets: state.track.transcript.length,
    );
  }

  /// Оценить произношение пользователя в режиме Shadowing.
  Future<void> evaluateShadowing(String spokenText) async {
    final snippet = state.currentSnippet;
    if (snippet.textPt.isEmpty) return;

    final evalResult = PronunciationAccuracyEvaluator.evaluate(
      spokenText: spokenText,
      targetText: snippet.textPt,
    );

    final evaluation = ShadowingEvaluationEntity(
      snippetId: snippet.id,
      targetText: snippet.textPt,
      spokenText: spokenText,
      accuracyScore: evalResult.score,
      isPass: evalResult.isPass,
      wordEvaluations: evalResult.words,
      feedback: evalResult.feedback,
      attemptedAt: DateTime.now(),
    );

    emit(state.copyWith(
      shadowingResult: evaluation,
      isRecording: false,
    ));

    await _repository.recordShadowingResult(
      podcastId: state.track.id,
      snippetId: snippet.id,
      accuracyScore: evalResult.score,
      isPass: evalResult.isPass,
    );
  }

  /// Начать запись голоса для Shadowing.
  Future<void> startShadowingRecording() async {
    await pause();
    emit(state.copyWith(isRecording: true, clearShadowingResult: true));

    final speech = _speechService;
    if (speech != null) {
      _speechSubscription?.cancel();
      _speechSubscription = speech.textStream.listen((text) {
        if (text.trim().isNotEmpty) {
          evaluateShadowing(text);
        }
      });

      final locale = state.track.isPtPt ? 'pt-PT' : 'pt-BR';
      await speech.startListening(localeId: locale);
    }
  }

  /// Остановить запись голоса для Shadowing.
  Future<void> stopShadowingRecording([String? manualSpokenText]) async {
    final speech = _speechService;
    if (speech != null) {
      await speech.stopListening();
      _speechSubscription?.cancel();
    }

    emit(state.copyWith(isRecording: false));

    if (manualSpokenText != null && manualSpokenText.trim().isNotEmpty) {
      await evaluateShadowing(manualSpokenText);
    }
  }

  @override
  Future<void> close() {
    _snippetPlaybackTimer?.cancel();
    _speechSubscription?.cancel();
    _audioService.stop();
    return super.close();
  }
}
