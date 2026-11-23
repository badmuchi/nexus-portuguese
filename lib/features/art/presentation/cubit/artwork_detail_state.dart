import 'package:equatable/equatable.dart';
import '../../domain/entities/art_entities.dart';

class ArtworkDetailState extends Equatable {
  final ArtworkEntity artwork;
  final bool isPlayingAudio;
  final bool showCuratorNotes;
  final Set<String> addedVocabIds;

  const ArtworkDetailState({
    required this.artwork,
    this.isPlayingAudio = false,
    this.showCuratorNotes = true,
    this.addedVocabIds = const {},
  });

  ArtworkDetailState copyWith({
    ArtworkEntity? artwork,
    bool? isPlayingAudio,
    bool? showCuratorNotes,
    Set<String>? addedVocabIds,
  }) {
    return ArtworkDetailState(
      artwork: artwork ?? this.artwork,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      showCuratorNotes: showCuratorNotes ?? this.showCuratorNotes,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [
        artwork,
        isPlayingAudio,
        showCuratorNotes,
        addedVocabIds,
      ];
}
