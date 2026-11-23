import 'package:equatable/equatable.dart';

enum FolkloreOrigin {
  indigena,      // Индейский фольклор (тупи-гуарани, амазонский)
  afroBrasileiro,// Афро-бразильские мифы и традиции
  iberico,       // Португальский фольклор и европейские корни
  urbanoMisto,   // Смешанный народный фольклор
}

class MythicalEntity extends Equatable {
  final String id;
  final String name;
  final String aliasRu;
  final FolkloreOrigin origin;
  final String region;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String accentEmoji;
  final String shortSummary;
  final String fullLegend;
  final List<String> magicalPowers;
  final String moralOrMeaning;
  final List<FolkloreVocabEntity> vocabulary;
  final String audioNarration;

  const MythicalEntity({
    required this.id,
    required this.name,
    required this.aliasRu,
    required this.origin,
    required this.region,
    required this.dialect,
    required this.shortSummary,
    required this.fullLegend,
    required this.magicalPowers,
    required this.moralOrMeaning,
    required this.vocabulary,
    required this.audioNarration,
    this.accentEmoji = '✨',
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
        aliasRu,
        origin,
        region,
        dialect,
        shortSummary,
        fullLegend,
        magicalPowers,
        moralOrMeaning,
        vocabulary,
        audioNarration,
        accentEmoji,
      ];
}

class FolkloreTaleSnippet extends Equatable {
  final String id;
  final String title;
  final String characterName;
  final String narrativePt;
  final String translationRu;
  final String grammarInsight; // Разбор времен Pretérito Perfeito vs Imperfeito
  final String icon;

  const FolkloreTaleSnippet({
    required this.id,
    required this.title,
    required this.characterName,
    required this.narrativePt,
    required this.translationRu,
    required this.grammarInsight,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        characterName,
        narrativePt,
        translationRu,
        grammarInsight,
        icon,
      ];
}

class FolkloreVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String definition;
  final String exampleSentence;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String? dialectNote;

  const FolkloreVocabEntity({
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

class FolkloreQuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String dialect;
  final String contextMyth;
  final String accentEmoji;

  const FolkloreQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.dialect,
    this.contextMyth = 'Lenda Lusófona',
    this.accentEmoji = '✨',
  });

  @override
  List<Object?> get props => [
        id,
        question,
        options,
        correctIndex,
        explanation,
        dialect,
        contextMyth,
        accentEmoji,
      ];
}
