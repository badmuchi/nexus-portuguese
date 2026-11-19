import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/utils/portuguese_normalizer.dart';
import '../../data/repositories/srs_repository_impl.dart';
import '../../domain/services/fsrs_engine.dart';
import 'srs_state.dart';

class SrsCubit extends Cubit<SrsState> {
  final SrsRepository _repository;
  final HybridAudioPlaybackService _audioService;

  SrsCubit({
    required SrsRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(SrsInitial());

  Future<void> loadDueCards() async {
    emit(SrsLoading());
    try {
      final cards = await _repository.getDueCards();
      if (cards.isEmpty) {
        final all = await _repository.getAllCards();
        emit(SrsEmpty(totalCards: all.length));
      } else {
        emit(
          SrsReviewing(
            queue: cards,
            currentIndex: 0,
            isFrontRevealed: false,
          ),
        );
      }
    } catch (e) {
      emit(SrsError('Ошибка загрузки карточек: $e'));
    }
  }

  void toggleFlip() {
    final s = state;
    if (s is SrsReviewing) {
      final willReveal = !s.isFrontRevealed;
      emit(s.copyWith(isFrontRevealed: willReveal));
      if (willReveal) {
        playCurrentCardAudio();
      }
    }
  }

  void switchReviewMode(SrsReviewMode mode) {
    final s = state;
    if (s is SrsReviewing) {
      emit(s.copyWith(reviewMode: mode, clearTyping: true, isFrontRevealed: false));
    }
  }

  void submitTypedAnswer(String typedText) {
    final s = state;
    if (s is SrsReviewing) {
      final target = s.currentCard.portuguese;
      final result = PortugueseNormalizer.evaluateAnswer(
        userInput: typedText,
        targetText: target,
      );

      emit(
        s.copyWith(
          isFrontRevealed: true,
          typedText: typedText,
          typingResult: result,
        ),
      );
      playCurrentCardAudio();
    }
  }

  Future<void> rateCurrentCard(SrsRating rating) async {
    final s = state;
    if (s is SrsReviewing) {
      final card = s.currentCard;
      final wasTyped = s.reviewMode == SrsReviewMode.typing;
      final wasExact = s.typingResult == PortugueseMatchResult.exact;

      await _repository.reviewCard(
        card: card,
        rating: rating,
        wasTypedCheck: wasTyped,
        wasTypedExact: wasExact,
      );

      final nextIndex = s.currentIndex + 1;
      if (nextIndex < s.queue.length) {
        emit(
          s.copyWith(
            currentIndex: nextIndex,
            isFrontRevealed: false,
            clearTyping: true,
          ),
        );
      } else {
        final all = await _repository.getAllCards();
        emit(SrsEmpty(totalCards: all.length));
      }
    }
  }

  void playCurrentCardAudio() {
    final s = state;
    if (s is SrsReviewing) {
      final card = s.currentCard;
      _audioService.playAudioOrSpeak(
        audioPathOrUrl: card.audioUrl,
        fallbackText: card.portuguese,
      );
    }
  }
}
