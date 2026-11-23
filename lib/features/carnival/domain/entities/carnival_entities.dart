import 'package:equatable/equatable.dart';

enum CarnivalTraditionCategory {
  frevo,            // Фрево Ресифи и Олинды
  maracatu,         // Маракату Пернамбуку
  sambaEnredo,      // Самба-энреду Рио и Сан-Паулу
  bumbameuboi,      // Бумба-меу-бой Мараньяна
  entrudoPortugues, // Карнавал Торреш-Ведраш и Каретуш де Поденсе
  trioEletrico,     // Трио Элетрику и Аше Салвадора
}

class CarnivalTraditionEntity extends Equatable {
  final String id;
  final String title;
  final CarnivalTraditionCategory category;
  final String region;
  final String country; // Brasil, Portugal
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String emoji;
  final String shortSummary;
  final String fullDescription;
  final List<String> keyInstruments;
  final List<String> culturalRituals;
  final List<CarnivalVocabEntity> vocabulary;
  final String audioNarration;

  const CarnivalTraditionEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.region,
    required this.country,
    required this.dialect,
    required this.shortSummary,
    required this.fullDescription,
    required this.keyInstruments,
    required this.culturalRituals,
    required this.vocabulary,
    required this.audioNarration,
    this.emoji = '🎭',
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
        keyInstruments,
        culturalRituals,
        vocabulary,
        audioNarration,
        emoji,
      ];
}

class RhythmWorkshopEntity extends Equatable {
  final String id;
  final String title;
  final String genre;
  final String dialect;
  final int tempoBpm;
  final String rhythmicPatternRu;
  final String lyricsSamplePt;
  final String lyricsTranslationRu;
  final String continuousActionGrammarNote; // Разбор Gerúndio (BR) vs Estar a + Infinitivo (PT)
  final String icon;

  const RhythmWorkshopEntity({
    required this.id,
    required this.title,
    required this.genre,
    required this.dialect,
    required this.tempoBpm,
    required this.rhythmicPatternRu,
    required this.lyricsSamplePt,
    required this.lyricsTranslationRu,
    required this.continuousActionGrammarNote,
    this.icon = '🥁',
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
        genre,
        dialect,
        tempoBpm,
        rhythmicPatternRu,
        lyricsSamplePt,
        lyricsTranslationRu,
        continuousActionGrammarNote,
        icon,
      ];
}

class CarnivalVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String definition;
  final String exampleSentence;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String? dialectNote;

  const CarnivalVocabEntity({
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

class CarnivalQuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const CarnivalQuizQuestion({
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
