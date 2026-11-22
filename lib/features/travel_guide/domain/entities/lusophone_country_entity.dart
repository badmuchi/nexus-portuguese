import 'package:equatable/equatable.dart';

/// Локальное слово, выражение или диалектизм конкретной страны.
class CountryLinguisticFeature extends Equatable {
  final String termPt;
  final String translationRu;
  final String explanationRu;
  final String examplePt;

  const CountryLinguisticFeature({
    required this.termPt,
    required this.translationRu,
    required this.explanationRu,
    required this.examplePt,
  });

  @override
  List<Object?> get props => [termPt, translationRu, explanationRu, examplePt];
}

/// Сущность страны или региона португалоязычного пространства (CPLP).
class LusophoneCountryEntity extends Equatable {
  final String id;
  final String namePt;
  final String nameRu;
  final String flagEmoji;
  final String capitalPt;
  final String capitalRu;
  final String continentRu;
  final String currency;
  final String population;
  final String dialectOverviewRu;
  final String culturalOverviewRu;
  final List<String> topAttractionsRu;
  final String nationalDishRu;
  final List<CountryLinguisticFeature> localExpressions;

  const LusophoneCountryEntity({
    required this.id,
    required this.namePt,
    required this.nameRu,
    required this.flagEmoji,
    required this.capitalPt,
    required this.capitalRu,
    required this.continentRu,
    required this.currency,
    required this.population,
    required this.dialectOverviewRu,
    required this.culturalOverviewRu,
    required this.topAttractionsRu,
    required this.nationalDishRu,
    required this.localExpressions,
  });

  @override
  List<Object?> get props => [
        id,
        namePt,
        nameRu,
        flagEmoji,
        capitalPt,
        capitalRu,
        continentRu,
        currency,
        population,
        dialectOverviewRu,
        culturalOverviewRu,
        topAttractionsRu,
        nationalDishRu,
        localExpressions,
      ];
}
