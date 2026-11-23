import 'package:equatable/equatable.dart';

enum ScienceField {
  oceanografia, // Исследования океана, гидротермальные жерла, морская биология
  biomedicina,  // Вакцины, сыворотки, Институт Бутантан, Fiocruz, нейробиология
  energiaVerde, // Энергия волн, плавучие ветрогенераторы, биоэтанол
  aeroespacial, // Космический порт Алькантара, астрофизика, спутники
}

class ScienceTopicEntity extends Equatable {
  final String id;
  final String title;
  final ScienceField field;
  final String institution;
  final String region;
  final String country; // Brasil, Portugal
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String accentEmoji;
  final String shortSummary;
  final String fullDescription;
  final List<String> keyDiscoveries;
  final String scientificImpact;
  final List<ScienceVocabEntity> vocabulary;
  final String audioNarration;

  const ScienceTopicEntity({
    required this.id,
    required this.title,
    required this.field,
    required this.institution,
    required this.region,
    required this.country,
    required this.dialect,
    required this.shortSummary,
    required this.fullDescription,
    required this.keyDiscoveries,
    required this.scientificImpact,
    required this.vocabulary,
    required this.audioNarration,
    this.accentEmoji = '🔬',
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
        field,
        institution,
        region,
        country,
        dialect,
        shortSummary,
        fullDescription,
        keyDiscoveries,
        scientificImpact,
        vocabulary,
        audioNarration,
        accentEmoji,
      ];
}

class LabExperimentEntity extends Equatable {
  final String id;
  final String title;
  final ScienceField field;
  final String objectivePt;
  final String objectiveRu;
  final String hypothesisPt;
  final List<String> procedureSteps;
  final String conclusionInsight;
  final String passiveVoiceGrammarNote; // Разбор пассивного залога (Voz Passiva)
  final String icon;

  const LabExperimentEntity({
    required this.id,
    required this.title,
    required this.field,
    required this.objectivePt,
    required this.objectiveRu,
    required this.hypothesisPt,
    required this.procedureSteps,
    required this.conclusionInsight,
    required this.passiveVoiceGrammarNote,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        field,
        objectivePt,
        objectiveRu,
        hypothesisPt,
        procedureSteps,
        conclusionInsight,
        passiveVoiceGrammarNote,
        icon,
      ];
}

class ScienceVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String definition;
  final String exampleSentence;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String? dialectNote;

  const ScienceVocabEntity({
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

class ScienceQuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String dialect;
  final String contextField;
  final String accentEmoji;

  const ScienceQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.dialect,
    this.contextField = 'Ciência & Tecnologia',
    this.accentEmoji = '🧪',
  });

  @override
  List<Object?> get props => [
        id,
        question,
        options,
        correctIndex,
        explanation,
        dialect,
        contextField,
        accentEmoji,
      ];
}
