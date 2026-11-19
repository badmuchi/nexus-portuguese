import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/utils/portuguese_normalizer.dart';
import '../../data/repositories/listening_repository_impl.dart';
import 'listening_state.dart';

class ListeningCubit extends Cubit<ListeningState> {
  final ListeningRepository _repository;
  final HybridAudioPlaybackService _audioService;

  ListeningCubit({
    required ListeningRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(ListeningInitial());

  Future<void> loadExercises() async {
    emit(ListeningLoading());
    try {
      final list = await _repository.getAllExercises();
      if (list.isEmpty) {
        emit(const ListeningError('Упражнения по аудированию не найдены.'));
        return;
      }
      emit(
        ListeningLoaded(
          exercises: list,
          currentIndex: 0,
        ),
      );
      playAudio();
    } catch (e) {
      emit(ListeningError('Ошибка загрузки аудирования: $e'));
    }
  }

  void playAudio({double? speed}) {
    final s = state;
    if (s is ListeningLoaded) {
      final rate = speed ?? s.playbackRate;
      final ex = s.currentExercise;
      final dialect = PortugueseDialect.fromCode(ex.dialect);

      _audioService.playAudioOrSpeak(
        audioPathOrUrl: ex.audioUrl,
        fallbackText: ex.transcript,
        dialect: dialect,
        rate: rate * 0.5,
      );
    }
  }

  void setPlaybackRate(double rate) {
    final s = state;
    if (s is ListeningLoaded) {
      emit(s.copyWith(playbackRate: rate));
      playAudio(speed: rate);
    }
  }

  void checkDictation(String userInput) {
    final s = state;
    if (s is ListeningLoaded) {
      final target = s.currentExercise.transcript;
      final result = PortugueseNormalizer.evaluateAnswer(
        userInput: userInput,
        targetText: target,
      );

      final isExact = result == PortugueseMatchResult.exact;
      final accuracy = switch (result) {
        PortugueseMatchResult.exact => 1.0,
        PortugueseMatchResult.accentMissing => 0.85,
        PortugueseMatchResult.mismatch => 0.0,
      };

      _repository.recordAttempt(
        exerciseId: s.currentExercise.id,
        wordAccuracy: accuracy,
        isExactMatch: isExact,
      );

      emit(
        s.copyWith(
          isRevealed: true,
          userDictation: userInput,
          matchResult: result,
        ),
      );
    }
  }

  void revealTranscript() {
    final s = state;
    if (s is ListeningLoaded) {
      emit(s.copyWith(isRevealed: true));
    }
  }

  void nextExercise() {
    final s = state;
    if (s is ListeningLoaded) {
      final next = (s.currentIndex + 1) % s.exercises.length;
      emit(
        s.copyWith(
          currentIndex: next,
          isRevealed: false,
          clearInput: true,
        ),
      );
      playAudio();
    }
  }
}
