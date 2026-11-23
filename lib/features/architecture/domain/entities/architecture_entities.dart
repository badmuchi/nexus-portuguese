import 'package:equatable/equatable.dart';

enum ArchitectureCategory {
  monument,
  modernUrban,
  contemporary,
  colonial,
}

class ArchitecturalMonumentEntity extends Equatable {
  final String id;
  final String title;
  final String city;
  final String country;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String yearCompleted;
  final String architect;
  final String styleId;
  final String styleName;
  final ArchitectureCategory category;
  final String shortDescription;
  final String fullDescription;
  final List<String> architecturalFeatures;
  final String historicalSignificance;
  final List<ArchitectVocabEntity> vocabulary;
  final String audioSnippet;
  final String accentEmoji;

  const ArchitecturalMonumentEntity({
    required this.id,
    required this.title,
    required this.city,
    required this.country,
    required this.dialect,
    required this.yearCompleted,
    required this.architect,
    required this.styleId,
    required this.styleName,
    required this.category,
    required this.shortDescription,
    required this.fullDescription,
    required this.architecturalFeatures,
    required this.historicalSignificance,
    required this.vocabulary,
    required this.audioSnippet,
    this.accentEmoji = '🏛️',
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      (dialect.toLowerCase().contains('pt') && !dialect.toLowerCase().contains('br'));

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  @override
  List<Object?> get props => [
        id,
        title,
        city,
        country,
        dialect,
        yearCompleted,
        architect,
        styleId,
        styleName,
        category,
        shortDescription,
        fullDescription,
        architecturalFeatures,
        historicalSignificance,
        vocabulary,
        audioSnippet,
        accentEmoji,
      ];
}

class ArchitecturalStyleEntity extends Equatable {
  final String id;
  final String name;
  final String period;
  final String description;
  final List<String> keyCharacteristics;
  final List<String> prominentExamples;
  final String icon;

  const ArchitecturalStyleEntity({
    required this.id,
    required this.name,
    required this.period,
    required this.description,
    required this.keyCharacteristics,
    required this.prominentExamples,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        period,
        description,
        keyCharacteristics,
        prominentExamples,
        icon,
      ];
}

class ArchitectVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String definition;
  final String exampleSentence;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String? dialectNote;

  const ArchitectVocabEntity({
    required this.id,
    required this.termPt,
    required this.translationRu,
    required this.definition,
    required this.exampleSentence,
    required this.dialect,
    this.dialectNote,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      (dialect.toLowerCase().contains('pt') && !dialect.toLowerCase().contains('br'));

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  @override
  List<Object?> get props => [
        id,
        termPt,
        translationRu,
        definition,
        exampleSentence,
        dialect,
        dialectNote,
      ];
}

class ArchitectureQuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String dialect;

  const ArchitectureQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.dialect,
  });

  @override
  List<Object?> get props => [
        id,
        question,
        options,
        correctIndex,
        explanation,
        dialect,
      ];
}
