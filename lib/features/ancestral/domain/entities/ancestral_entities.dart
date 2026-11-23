import 'package:equatable/equatable.dart';

enum CommunityCategory {
  ribeirinhos,   // Речные сообщества Амазонии
  caicaras,      // Прибрежные рыбаки Юга/Юго-Востока
  sertanejos,    // Жители Сертана и ковбои Каатинги
  quilombolas,   // Сообщества потомков киломбуш
  pastores,      // Пастухи-перегонщики Португалии
  mariscadores,  // Сборщицы моллюсков и рыбаки лагун
}

class TraditionalCommunityEntity extends Equatable {
  final String id;
  final String title;
  final CommunityCategory category;
  final String region;
  final String country; // Brasil, Portugal
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String emoji;
  final String shortSummary;
  final String fullDescription;
  final List<String> lifestyleHighlights;
  final List<AncestralVocabEntity> vocabulary;
  final String audioNarration;

  const TraditionalCommunityEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.region,
    required this.country,
    required this.dialect,
    required this.shortSummary,
    required this.fullDescription,
    required this.lifestyleHighlights,
    required this.vocabulary,
    required this.audioNarration,
    this.emoji = '🌿',
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
        lifestyleHighlights,
        vocabulary,
        audioNarration,
        emoji,
      ];
}

class HerbalRemedyEntity extends Equatable {
  final String id;
  final String plantNamePt;
  final String nameRu;
  final String scientificName;
  final String traditionalUsePt;
  final String preparationInstructionsPt;
  final String imperativeGrammarNote; // Разбор повелительного наклонения (Imperativo)
  final String precautionsRu;
  final String icon;

  const HerbalRemedyEntity({
    required this.id,
    required this.plantNamePt,
    required this.nameRu,
    required this.scientificName,
    required this.traditionalUsePt,
    required this.preparationInstructionsPt,
    required this.imperativeGrammarNote,
    required this.precautionsRu,
    this.icon = '🌱',
  });

  @override
  List<Object?> get props => [
        id,
        plantNamePt,
        nameRu,
        scientificName,
        traditionalUsePt,
        preparationInstructionsPt,
        imperativeGrammarNote,
        precautionsRu,
        icon,
      ];
}

class AncestralVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String definition;
  final String exampleSentence;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String? dialectNote;

  const AncestralVocabEntity({
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

class AncestralQuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const AncestralQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  @override
  List<Object?> get props => [
        id,
        question,
        options,
        correctIndex,
        explanation,
      ];
}
