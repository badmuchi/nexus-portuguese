import 'package:equatable/equatable.dart';
import '../../domain/entities/architecture_entities.dart';

class MonumentDetailState extends Equatable {
  final ArchitecturalMonumentEntity monument;
  final bool isPlayingAudio;
  final bool showArchitectureDetails;
  final Set<String> addedVocabIds;

  const MonumentDetailState({
    required this.monument,
    this.isPlayingAudio = false,
    this.showArchitectureDetails = true,
    this.addedVocabIds = const {},
  });

  MonumentDetailState copyWith({
    ArchitecturalMonumentEntity? monument,
    bool? isPlayingAudio,
    bool? showArchitectureDetails,
    Set<String>? addedVocabIds,
  }) {
    return MonumentDetailState(
      monument: monument ?? this.monument,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      showArchitectureDetails:
          showArchitectureDetails ?? this.showArchitectureDetails,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [
        monument,
        isPlayingAudio,
        showArchitectureDetails,
        addedVocabIds,
      ];
}
