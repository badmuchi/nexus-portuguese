import 'package:equatable/equatable.dart';

enum CaveCategory {
  calcario,   // Известняковые карстовые пещеры
  vulcanico,  // Вулканические лавовые трубки и кратеры
  aquatica,   // Затопленные пещеры и подземные озера
  abismo,     // Вертикальные провалы и шахты
}

class CaveEntity extends Equatable {
  final String id;
  final String title;
  final CaveCategory category;
  final String region;
  final String country; // Brasil, Portugal
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String emoji;
  final String shortSummary;
  final String fullDescription;
  final List<String> geologicalFormations;
  final List<String> safetyTips;
  final List<CaveVocabEntity> vocabulary;
  final String audioNarration;

  const CaveEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.region,
    required this.country,
    required this.dialect,
    required this.shortSummary,
    required this.fullDescription,
    required this.geologicalFormations,
    required this.safetyTips,
    required this.vocabulary,
    required this.audioNarration,
    this.emoji = '🦇',
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
        geologicalFormations,
        safetyTips,
        vocabulary,
        audioNarration,
        emoji,
      ];
}

class SpeleoProtocolEntity extends Equatable {
  final String id;
  final String title;
  final String targetCave;
  final String difficultyLevel;
  final List<String> equipmentList;
  final String explorationStepsPt;
  final String conditionalGrammarNote; // Разбор Se + Imperfeito do Subjuntivo + Futuro do Pretérito
  final String icon;

  const SpeleoProtocolEntity({
    required this.id,
    required this.title,
    required this.targetCave,
    required this.difficultyLevel,
    required this.equipmentList,
    required this.explorationStepsPt,
    required this.conditionalGrammarNote,
    this.icon = '🔦',
  });

  @override
  List<Object?> get props => [
        id,
        title,
        targetCave,
        difficultyLevel,
        equipmentList,
        explorationStepsPt,
        conditionalGrammarNote,
        icon,
      ];
}

class CaveVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String definition;
  final String exampleSentence;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String? dialectNote;

  const CaveVocabEntity({
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

class CaveQuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const CaveQuizQuestion({
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
