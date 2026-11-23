import 'package:equatable/equatable.dart';
import '../../domain/entities/folklore_entities.dart';

class MythDetailState extends Equatable {
  final MythicalEntity myth;
  final bool isPlayingAudio;
  final Set<String> addedVocabIds;

  const MythDetailState({
    required this.myth,
    this.isPlayingAudio = false,
    this.addedVocabIds = const {},
  });

  MythDetailState copyWith({
    MythicalEntity? myth,
    bool? isPlayingAudio,
    Set<String>? addedVocabIds,
  }) {
    return MythDetailState(
      myth: myth ?? this.myth,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [
        myth,
        isPlayingAudio,
        addedVocabIds,
      ];
}
