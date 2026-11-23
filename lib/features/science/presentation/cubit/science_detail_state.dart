import 'package:equatable/equatable.dart';
import '../../domain/entities/science_entities.dart';

class ScienceDetailState extends Equatable {
  final ScienceTopicEntity topic;
  final bool isPlayingAudio;
  final Set<String> addedVocabIds;

  const ScienceDetailState({
    required this.topic,
    this.isPlayingAudio = false,
    this.addedVocabIds = const {},
  });

  ScienceDetailState copyWith({
    ScienceTopicEntity? topic,
    bool? isPlayingAudio,
    Set<String>? addedVocabIds,
  }) {
    return ScienceDetailState(
      topic: topic ?? this.topic,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [topic, isPlayingAudio, addedVocabIds];
}
