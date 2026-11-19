import 'package:equatable/equatable.dart';
import '../../domain/entities/srs_card_entity.dart';
import '../../../../core/utils/portuguese_normalizer.dart';

enum SrsReviewMode {
  flashcard,
  typing,
}

abstract class SrsState extends Equatable {
  const SrsState();

  @override
  List<Object?> get props => [];
}

class SrsInitial extends SrsState {}

class SrsLoading extends SrsState {}

class SrsEmpty extends SrsState {
  final int totalCards;
  const SrsEmpty({required this.totalCards});

  @override
  List<Object?> get props => [totalCards];
}

class SrsReviewing extends SrsState {
  final List<SrsCardEntity> queue;
  final int currentIndex;
  final bool isFrontRevealed;
  final SrsReviewMode reviewMode;
  final PortugueseMatchResult? typingResult;
  final String? typedText;

  const SrsReviewing({
    required this.queue,
    required this.currentIndex,
    required this.isFrontRevealed,
    this.reviewMode = SrsReviewMode.flashcard,
    this.typingResult,
    this.typedText,
  });

  SrsCardEntity get currentCard => queue[currentIndex];
  int get remainingCount => queue.length - currentIndex;

  SrsReviewing copyWith({
    List<SrsCardEntity>? queue,
    int? currentIndex,
    bool? isFrontRevealed,
    SrsReviewMode? reviewMode,
    PortugueseMatchResult? typingResult,
    String? typedText,
    bool clearTyping = false,
  }) {
    return SrsReviewing(
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isFrontRevealed: isFrontRevealed ?? this.isFrontRevealed,
      reviewMode: reviewMode ?? this.reviewMode,
      typingResult: clearTyping ? null : (typingResult ?? this.typingResult),
      typedText: clearTyping ? null : (typedText ?? this.typedText),
    );
  }

  @override
  List<Object?> get props => [
        queue,
        currentIndex,
        isFrontRevealed,
        reviewMode,
        typingResult,
        typedText,
      ];
}

class SrsError extends SrsState {
  final String message;
  const SrsError(this.message);

  @override
  List<Object?> get props => [message];
}
