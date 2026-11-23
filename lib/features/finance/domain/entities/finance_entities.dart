import 'package:equatable/equatable.dart';

enum FinanceCategory {
  fintech,
  startups,
  personalFinance,
  business,
}

class FinanceTopicEntity extends Equatable {
  final String id;
  final String title;
  final FinanceCategory category;
  final String region;
  final String country;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String shortDescription;
  final String fullDescription;
  final List<String> keyMechanisms;
  final List<String> culturalTips;
  final List<FinanceVocabEntity> vocabulary;
  final String accentEmoji;
  final String audioSnippet;

  const FinanceTopicEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.region,
    required this.country,
    required this.dialect,
    required this.shortDescription,
    required this.fullDescription,
    required this.keyMechanisms,
    required this.culturalTips,
    required this.vocabulary,
    required this.audioSnippet,
    this.accentEmoji = '💳',
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
        shortDescription,
        fullDescription,
        keyMechanisms,
        culturalTips,
        vocabulary,
        accentEmoji,
        audioSnippet,
      ];
}

class FintechSimulatorEntity extends Equatable {
  final String id;
  final String title;
  final String platform;
  final String dialect;
  final String scenario;
  final List<String> steps;
  final String practicalAdvice;
  final String icon;

  const FintechSimulatorEntity({
    required this.id,
    required this.title,
    required this.platform,
    required this.dialect,
    required this.scenario,
    required this.steps,
    required this.practicalAdvice,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        platform,
        dialect,
        scenario,
        steps,
        practicalAdvice,
        icon,
      ];
}

class FinanceVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String definition;
  final String exampleSentence;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String? dialectNote;

  const FinanceVocabEntity({
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

class FinanceQuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String dialect;

  const FinanceQuizQuestion({
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
