import 'package:equatable/equatable.dart';

class DictionaryEntryEntity extends Equatable {
  final String id;
  final String word;
  final String partOfSpeech;
  final String translationRu;
  final int frequencyRank;
  final String dialect;
  final String? examplePt;
  final String? exampleRu;
  final String? notes;
  final bool isCustom;

  const DictionaryEntryEntity({
    required this.id,
    required this.word,
    required this.partOfSpeech,
    required this.translationRu,
    required this.frequencyRank,
    required this.dialect,
    this.examplePt,
    this.exampleRu,
    this.notes,
    this.isCustom = false,
  });

  @override
  List<Object?> get props => [
        id,
        word,
        partOfSpeech,
        translationRu,
        frequencyRank,
        dialect,
        examplePt,
        exampleRu,
        notes,
        isCustom,
      ];
}
