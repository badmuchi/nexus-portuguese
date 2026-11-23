import 'package:equatable/equatable.dart';
import '../../domain/entities/finance_entities.dart';

class FinanceTopicDetailState extends Equatable {
  final FinanceTopicEntity topic;
  final bool isPlayingAudio;
  final Set<String> addedVocabIds;

  const FinanceTopicDetailState({
    required this.topic,
    this.isPlayingAudio = false,
    this.addedVocabIds = const {},
  });

  FinanceTopicDetailState copyWith({
    FinanceTopicEntity? topic,
    bool? isPlayingAudio,
    Set<String>? addedVocabIds,
  }) {
    return FinanceTopicDetailState(
      topic: topic ?? this.topic,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [
        topic,
        isPlayingAudio,
        addedVocabIds,
      ];
}
