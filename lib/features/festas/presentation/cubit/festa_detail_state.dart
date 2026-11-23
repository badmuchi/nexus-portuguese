import 'package:equatable/equatable.dart';
import '../../domain/entities/festas_entities.dart';

class FestaDetailState extends Equatable {
  final FestaEntity festa;
  final bool isPlayingAudio;
  final Set<String> addedVocabIds;

  const FestaDetailState({
    required this.festa,
    this.isPlayingAudio = false,
    this.addedVocabIds = const {},
  });

  FestaDetailState copyWith({
    FestaEntity? festa,
    bool? isPlayingAudio,
    Set<String>? addedVocabIds,
  }) {
    return FestaDetailState(
      festa: festa ?? this.festa,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      addedVocabIds: addedVocabIds ?? this.addedVocabIds,
    );
  }

  @override
  List<Object?> get props => [
        festa,
        isPlayingAudio,
        addedVocabIds,
      ];
}
