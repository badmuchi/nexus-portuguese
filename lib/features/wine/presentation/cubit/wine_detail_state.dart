import 'package:equatable/equatable.dart';
import '../../domain/entities/wine_entities.dart';

class WineDetailState extends Equatable {
  final WineRegionEntity region;
  final bool isPlayingAudio;
  final Set<String> addedVocabIds;

  const WineDetailState({
    required this.region,
    this.isPlayingAudio = false,
    this.addedVocabIds = const {},
  });

  WineDetailState copyWith({
    WineRegionEntity? region,
    bool? isPlayingAudio,
    Set<String>? addedVocabIds,
  }) {
    return WineDetailState(
      region: region ?? this.region,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [region, isPlayingAudio, addedVocabIds];
}
