import 'package:equatable/equatable.dart';

enum FestaCategory {
  carnaval,
  santosPopulares,
  junina,
  folclore,
}

class FestaEntity extends Equatable {
  final String id;
  final String title;
  final String region;
  final String country;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String seasonDate;
  final FestaCategory category;
  final String shortDescription;
  final String fullDescription;
  final List<String> ritualsAndTraditions;
  final List<String> foodsAndDrinks;
  final List<FestaVocabEntity> vocabulary;
  final String accentEmoji;
  final String audioSnippet;

  const FestaEntity({
    required this.id,
    required this.title,
    required this.region,
    required this.country,
    required this.dialect,
    required this.seasonDate,
    required this.category,
    required this.shortDescription,
    required this.fullDescription,
    required this.ritualsAndTraditions,
    required this.foodsAndDrinks,
    required this.vocabulary,
    required this.audioSnippet,
    this.accentEmoji = '🎉',
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
        region,
        country,
        dialect,
        seasonDate,
        category,
        shortDescription,
        fullDescription,
        ritualsAndTraditions,
        foodsAndDrinks,
        vocabulary,
        accentEmoji,
        audioSnippet,
      ];
}

class FestaTraditionEntity extends Equatable {
  final String id;
  final String title;
  final String festaName;
  final String region;
  final String description;
  final List<String> instructions;
  final String curiousFact;
  final String icon;

  const FestaTraditionEntity({
    required this.id,
    required this.title,
    required this.festaName,
    required this.region,
    required this.description,
    required this.instructions,
    required this.curiousFact,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        festaName,
        region,
        description,
        instructions,
        curiousFact,
        icon,
      ];
}

class FestaVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String definition;
  final String exampleSentence;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String? dialectNote;

  const FestaVocabEntity({
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

class FestaQuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String dialect;

  const FestaQuizQuestion({
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
