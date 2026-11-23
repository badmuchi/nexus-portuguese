import 'package:equatable/equatable.dart';
import '../../domain/entities/nature_entities.dart';

class NatureReserveState extends Equatable {
  final NatureReserveEntity reserve;
  final Set<String> completedTrailIds;
  final Set<String> addedSpeciesIds;
  final bool isPlayingAudio;
  final NatureTrailEntity? activeTrail;

  const NatureReserveState({
    required this.reserve,
    this.completedTrailIds = const {},
    this.addedSpeciesIds = const {},
    this.isPlayingAudio = false,
    this.activeTrail,
  });

  NatureReserveState copyWith({
    NatureReserveEntity? reserve,
    Set<String>? completedTrailIds,
    Set<String>? addedSpeciesIds,
    bool? isPlayingAudio,
    NatureTrailEntity? activeTrail,
  }) {
    return NatureReserveState(
      reserve: reserve ?? this.reserve,
      completedTrailIds: completedTrailIds ?? this.completedTrailIds,
      addedSpeciesIds: addedSpeciesIds ?? this.addedSpeciesIds,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      activeTrail: activeTrail ?? this.activeTrail,
    );
  }

  @override
  List<Object?> get props => [
        reserve,
        completedTrailIds,
        addedSpeciesIds,
        isPlayingAudio,
        activeTrail,
      ];
}
