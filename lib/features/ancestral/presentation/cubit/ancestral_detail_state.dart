import 'package:equatable/equatable.dart';
import '../../domain/entities/ancestral_entities.dart';

class AncestralDetailState extends Equatable {
  final TraditionalCommunityEntity community;
  final bool isPlayingAudio;
  final Set<String> addedVocabIds;

  const AncestralDetailState({
    required this.community,
    this.isPlayingAudio = false,
    this.addedVocabIds = const {},
  });

  AncestralDetailState copyWith({
    TraditionalCommunityEntity? community,
    bool? isPlayingAudio,
    Set<String>? addedVocabIds,
  }) {
    return AncestralDetailState(
      community: community ?? this.community,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [
        community,
        isPlayingAudio,
        addedVocabIds,
      ];
}
