import 'package:equatable/equatable.dart';

enum SpeciesCategory { fauna, flora }

/// Вид флоры или фауны природного заповедника.
class SpeciesEntity extends Equatable {
  final String id;
  final String commonNamePt;
  final String scientificName;
  final String nameRu;
  final String emoji;
  final SpeciesCategory category;
  final String statusRu; // 'Эндемик', 'Охраняемый вид', 'Символ региона'
  final String curiosityRu;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'

  const SpeciesEntity({
    required this.id,
    required this.commonNamePt,
    required this.scientificName,
    required this.nameRu,
    required this.emoji,
    required this.category,
    required this.statusRu,
    required this.curiosityRu,
    this.dialect = 'all',
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

  @override
  List<Object?> get props => [
        id,
        commonNamePt,
        scientificName,
        nameRu,
        emoji,
        category,
        statusRu,
        curiosityRu,
        dialect,
      ];
}

/// Пешеходный или экологический маршрут (trilha / percurso pedestre).
class NatureTrailEntity extends Equatable {
  final String id;
  final String namePt;
  final String nameRu;
  final String difficultyRu; // 'Легкий', 'Средний', 'Сложный'
  final double distanceKm;
  final double durationHours;
  final int elevationGainMeters;
  final String descriptionRu;
  final List<String> safetyTipsRu;

  const NatureTrailEntity({
    required this.id,
    required this.namePt,
    required this.nameRu,
    required this.difficultyRu,
    required this.distanceKm,
    required this.durationHours,
    required this.elevationGainMeters,
    required this.descriptionRu,
    required this.safetyTipsRu,
  });

  @override
  List<Object?> get props => [
        id,
        namePt,
        nameRu,
        difficultyRu,
        distanceKm,
        durationHours,
        elevationGainMeters,
        descriptionRu,
        safetyTipsRu,
      ];
}

/// Природный заповедник или национальный парк (Parque Nacional / Reserva Natural).
class NatureReserveEntity extends Equatable {
  final String id;
  final String namePt;
  final String nameRu;
  final String region;
  final String country; // 'Brasil' or 'Portugal'
  final String dialect; // 'pt_BR' or 'pt_PT'
  final String coverEmoji;
  final String biomeRu;
  final String descriptionRu;
  final List<String> highlightsRu;
  final List<NatureTrailEntity> trails;
  final List<SpeciesEntity> faunaFlora;

  const NatureReserveEntity({
    required this.id,
    required this.namePt,
    required this.nameRu,
    required this.region,
    required this.country,
    required this.dialect,
    required this.coverEmoji,
    required this.biomeRu,
    required this.descriptionRu,
    required this.highlightsRu,
    required this.trails,
    required this.faunaFlora,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      (dialect.toLowerCase().contains('pt') && !dialect.toLowerCase().contains('br'));

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : '🇧🇷';
  String get dialectLabel => isPtPt ? 'Portugal' : 'Brasil';

  @override
  List<Object?> get props => [
        id,
        namePt,
        nameRu,
        region,
        country,
        dialect,
        coverEmoji,
        biomeRu,
        descriptionRu,
        highlightsRu,
        trails,
        faunaFlora,
      ];
}

/// Вопрос викторины по экологии, флоре и фауне.
class EcoQuizQuestion extends Equatable {
  final String id;
  final String questionPt;
  final String questionRu;
  final List<String> optionsPt;
  final int correctOptionIndex;
  final String explanationRu;
  final String dialect;

  const EcoQuizQuestion({
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
