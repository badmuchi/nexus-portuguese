import 'package:equatable/equatable.dart';
import '../../domain/entities/carnival_entities.dart';

class CarnivalDetailState extends Equatable {
  final CarnivalTraditionEntity tradition;
  final bool isPlayingAudio;
  final Set<String> addedVocabIds;

  const CarnivalDetailState({
    required this.tradition,
    this.isPlayingAudio = false,
    this.addedVocabIds = const {},
  });

  CarnivalDetailState copyWith({
    CarnivalTraditionEntity? tradition,
    bool? isPlayingAudio,
    Set<String>? addedVocabIds,
  }) {
    return CarnivalDetailState(
      tradition: tradition ?? this.tradition,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [
        tradition,
        isPlayingAudio,
        addedVocabIds,
      ];
}
