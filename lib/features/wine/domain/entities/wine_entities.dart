import 'package:equatable/equatable.dart';

enum WineCategory {
  vinhoFortificado,       // Портвейн, Мадейра, Мошкател де Сетубал
  vinhoVerdeBranco,        // Винью Верде, Алваринью, Лоурейру, Дору Бранку
  azeiteVirgemExtra,       // Оливковые масла Алентежу, Траз-уж-Монтеш, Бейра
  vinhoBrasileiroAltitude, // Серра Гауша, Вале душ Виньедуш, Вале ду Сан-Франсиску
}

class WineRegionEntity extends Equatable {
  final String id;
  final String name;
  final WineCategory category;
  final String subRegion;
  final String country; // Portugal, Brasil
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String accentEmoji;
  final String shortSummary;
  final String fullDescription;
  final List<String> keyCastas; // Сорта винограда / оливок
  final String tastingProfile;
  final List<WineVocabEntity> vocabulary;
  final String audioNarration;

  const WineRegionEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.subRegion,
    required this.country,
    required this.dialect,
    required this.shortSummary,
    required this.fullDescription,
    required this.keyCastas,
    required this.tastingProfile,
    required this.vocabulary,
    required this.audioNarration,
    this.accentEmoji = '🍷',
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
        name,
        category,
        subRegion,
        country,
        dialect,
        shortSummary,
        fullDescription,
        keyCastas,
        tastingProfile,
        vocabulary,
        audioNarration,
        accentEmoji,
      ];
}

class TastingGuideEntity extends Equatable {
  final String id;
  final String title;
  final String beverageType; // Vinho Tinto, Vinho do Porto, Vinho Verde, Azeite
  final String visualStagePt;
  final String olfactoryStagePt;
  final String gustatoryStagePt;
  final String sommelierRecommendationPt; // Рекомендация сомелье
  final String subjunctiveGrammarNote;    // Разбор Presente do Subjuntivo
  final String pairingRu;                 // Гастрономическое сочетание
  final String icon;

  const TastingGuideEntity({
    required this.id,
    required this.title,
    required this.beverageType,
    required this.visualStagePt,
    required this.olfactoryStagePt,
    required this.gustatoryStagePt,
    required this.sommelierRecommendationPt,
    required this.subjunctiveGrammarNote,
    required this.pairingRu,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        beverageType,
        visualStagePt,
        olfactoryStagePt,
        gustatoryStagePt,
        sommelierRecommendationPt,
        subjunctiveGrammarNote,
        pairingRu,
        icon,
      ];
}

class WineVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String definition;
  final String exampleSentence;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String? dialectNote;

  const WineVocabEntity({
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

class WineQuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String dialect;
  final String contextCategory;
  final String accentEmoji;

  const WineQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.dialect,
    this.contextCategory = 'Vinhos & Enologia',
    this.accentEmoji = '🍇',
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
