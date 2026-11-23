import 'package:equatable/equatable.dart';
import '../../domain/entities/fashion_entities.dart';

class FashionDetailState extends Equatable {
  final FashionTopicEntity topic;
  final bool isPlayingAudio;
  final Set<String> addedVocabIds;

  const FashionDetailState({
    required this.topic,
    this.isPlayingAudio = false,
    this.addedVocabIds = const {},
  });

  FashionDetailState copyWith({
    FashionTopicEntity? topic,
    bool? isPlayingAudio,
    Set<String>? addedVocabIds,
  }) {
    return FashionDetailState(
      topic: topic ?? this.topic,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [topic, isPlayingAudio, addedVocabIds];
}
