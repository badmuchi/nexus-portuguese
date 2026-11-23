import 'package:equatable/equatable.dart';

enum ArtPeriod {
  azulejaria, // Искусство керамических панно (Португалия)
  colonialBaroque, // Колониальное барокко и рококо (Алейжадинью)
  modernism, // Модернизм и антропофагия (Тарсила ду Амарал, Портинари)
  contemporaryAndStreetArt, // Современное искусство и мурализм (Кобра, Бордало II, Vhils)
}

extension ArtPeriodExtension on ArtPeriod {
  String get labelRu => switch (this) {
        ArtPeriod.azulejaria => 'Azulejaria (Керамика) 🟦',
        ArtPeriod.colonialBaroque => 'Barroco Colonial ⚜️',
        ArtPeriod.modernism => 'Modernismo 🎨',
        ArtPeriod.contemporaryAndStreetArt => 'Street Art & Мурализм 🏙️',
      };

  String get shortName => switch (this) {
        ArtPeriod.azulejaria => 'Азулежу',
        ArtPeriod.colonialBaroque => 'Барокко',
        ArtPeriod.modernism => 'Модернизм',
        ArtPeriod.contemporaryAndStreetArt => 'Стрит-арт',
      };
}

/// Термин искусствоведения или живописи для FSRS.
class ArtVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String contextRu;

  const ArtVocabEntity({
    required this.id,
    required this.termPt,
    required this.translationRu,
    required this.contextRu,
  });

  @override
  List<Object?> get props => [id, termPt, translationRu, contextRu];
}

/// Произведение искусства (картина, скульптура, мурал, изразцовое панно).
class ArtworkEntity extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final String artistName;
  final String yearRu;
  final ArtPeriod period;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String techniquePt;
  final String techniqueRu;
  final String locationRu; // Где находится оригинал
  final String coverEmoji;
  final String descriptionRu;
  final String curatorAnalysisRu; // Искусствоведческий разбор смысла
  final List<ArtVocabEntity> keyVocabulary;

  const ArtworkEntity({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.artistName,
    required this.yearRu,
    required this.period,
    this.dialect = 'all',
    required this.techniquePt,
    required this.techniqueRu,
    required this.locationRu,
    required this.coverEmoji,
    required this.descriptionRu,
    required this.curatorAnalysisRu,
    this.keyVocabulary = const [],
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      (dialect.toLowerCase().contains('pt') && !dialect.toLowerCase().contains('br'));

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : isPtBr ? '🇧🇷' : '🌐';
  String get dialectLabel => isPtPt ? 'Portugal' : isPtBr ? 'Brasil' : 'Luso';

  @override
  List<Object?> get props => [
        id,
        titlePt,
        titleRu,
        artistName,
        yearRu,
        period,
        dialect,
        techniquePt,
        techniqueRu,
        locationRu,
        coverEmoji,
        descriptionRu,
        curatorAnalysisRu,
        keyVocabulary,
      ];
}

/// Направление или техника искусства (Azulejos, Antropofagia, etc.).
class ArtStyleEntity extends Equatable {
  final String id;
  final String namePt;
  final String nameRu;
  final String coverEmoji;
  final String country; // 'Brasil', 'Portugal', 'Luso'
  final String periodRu;
  final String descriptionRu;
  final List<String> hallmarksRu;

  const ArtStyleEntity({
    required this.id,
    required this.namePt,
    required this.nameRu,
    required this.coverEmoji,
    required this.country,
    required this.periodRu,
    required this.descriptionRu,
    required this.hallmarksRu,
  });

  @override
  List<Object?> get props => [
        id,
        namePt,
        nameRu,
        coverEmoji,
        country,
        periodRu,
        descriptionRu,
        hallmarksRu,
      ];
}

/// Вопрос викторины ценителя искусства.
class ArtQuizQuestion extends Equatable {
  final String id;
  final String questionPt;
  final String questionRu;
  final List<String> optionsPt;
  final int correctOptionIndex;
  final String explanationRu;
  final String dialect;

  const ArtQuizQuestion({
    required this.id,
    required this.questionPt,
    required this.questionRu,
    required this.optionsPt,
    required this.correctOptionIndex,
    required this.explanationRu,
    this.dialect = 'all',
  });

  String get correctOptionText => optionsPt[correctOptionIndex];

  @override
  List<Object?> get props => [
        id,
        questionPt,
        questionRu,
        optionsPt,
        correctOptionIndex,
        explanationRu,
        dialect,
      ];
}
