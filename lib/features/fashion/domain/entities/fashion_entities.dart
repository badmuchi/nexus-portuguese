import 'package:equatable/equatable.dart';

enum FashionCategory {
  altaCostura,      // Недели моды, подиум, SPFW, дизайнеры
  calcadoCouro,     // Обувная индустрия Португалии, кожевенное мастерство
  rendasTecidos,    // Кружева бильрос, ситец (chita), натуральные волокна
  ourivesariaDesign,// Филигрань, ювелирное искусство и аксессуары
}

class FashionTopicEntity extends Equatable {
  final String id;
  final String title;
  final FashionCategory category;
  final String region;
  final String country; // Brasil, Portugal
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String accentEmoji;
  final String shortSummary;
  final String fullDescription;
  final List<String> keyHighlights;
  final String culturalSignificance;
  final List<FashionVocabEntity> vocabulary;
  final String audioNarration;

  const FashionTopicEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.region,
    required this.country,
    required this.dialect,
    required this.shortSummary,
    required this.fullDescription,
    required this.keyHighlights,
    required this.culturalSignificance,
    required this.vocabulary,
    required this.audioNarration,
    this.accentEmoji = '👗',
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
        category,
        region,
        country,
        dialect,
        shortSummary,
        fullDescription,
        keyHighlights,
        culturalSignificance,
        vocabulary,
        audioNarration,
        accentEmoji,
      ];
}

class TextileCraftEntity extends Equatable {
  final String id;
  final String title;
  final String region;
  final String materialPt;
  final String techniqueDescriptionPt;
  final String techniqueDescriptionRu;
  final List<String> stepByStepGuide;
  final String grammarInsight; // Сравнительные и превосходные степени прилагательных (Graus dos Adjetivos)
  final String icon;

  const TextileCraftEntity({
    required this.id,
    required this.title,
    required this.region,
    required this.materialPt,
    required this.techniqueDescriptionPt,
    required this.techniqueDescriptionRu,
    required this.stepByStepGuide,
    required this.grammarInsight,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        region,
        materialPt,
        techniqueDescriptionPt,
        techniqueDescriptionRu,
        stepByStepGuide,
        grammarInsight,
        icon,
      ];
}

class FashionVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String definition;
  final String exampleSentence;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String? dialectNote;

  const FashionVocabEntity({
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

class FashionQuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String dialect;
  final String contextCategory;
  final String accentEmoji;

  const FashionQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.dialect,
    this.contextCategory = 'Moda & Têxtil',
    this.accentEmoji = '🧵',
  });

  @override
  List<Object?> get props => [
        id,
        question,
        options,
        correctIndex,
        explanation,
        dialect,
        contextCategory,
        accentEmoji,
      ];
}
