import 'package:equatable/equatable.dart';

enum TravelPhraseCategory {
  airportCustoms('Aeroporto & Alfândega', 'Аэропорт и таможня', '✈️'),
  transport('Transportes & Cidade', 'Транспорт и навигация', '🚕'),
  hotelLodging('Hospedagem & Hotel', 'Отель и проживание', '🏨'),
  restaurantDining('Restaurante & Comida', 'Кафе и рестораны', '🍽️'),
  emergencies('Emergência & Saúde', 'Аптека и помощь', '🆘'),
  localCourtesies('Cortesia & Dia a Dia', 'Вежливость и этикет', '🤝');

  final String labelPt;
  final String labelRu;
  final String emoji;

  const TravelPhraseCategory(this.labelPt, this.labelRu, this.emoji);
}

/// Фраза для путешественника с контекстной подсказкой и регионом.
class TravelPhraseEntity extends Equatable {
  final String id;
  final String phrasePt;
  final String translationRu;
  final TravelPhraseCategory category;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String contextTipRu;
  final bool isEssential;

  const TravelPhraseEntity({
    required this.id,
    required this.phrasePt,
    required this.translationRu,
    required this.category,
    this.dialect = 'all',
    required this.contextTipRu,
    this.isEssential = true,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : isPtBr ? '🇧🇷' : '🌐';

  @override
  List<Object?> get props => [
        id,
        phrasePt,
        translationRu,
        category,
        dialect,
        contextTipRu,
        isEssential,
      ];
}
