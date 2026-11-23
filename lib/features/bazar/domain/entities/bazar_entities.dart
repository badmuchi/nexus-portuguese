import 'package:equatable/equatable.dart';

/// Товар на рынке или ярмарке.
class MarketItemEntity extends Equatable {
  final String id;
  final String namePt;
  final String nameRu;
  final String unitRu; // 'кг', 'дюжина', 'шт', '100 г'
  final double defaultPrice;
  final String currencySymbol; // '€' or 'R$'
  final String itemEmoji;
  final String descriptionRu;

  const MarketItemEntity({
    required this.id,
    required this.namePt,
    required this.nameRu,
    required this.unitRu,
    required this.defaultPrice,
    required this.currencySymbol,
    required this.itemEmoji,
    required this.descriptionRu,
  });

  @override
  List<Object?> get props => [
        id,
        namePt,
        nameRu,
        unitRu,
        defaultPrice,
        currencySymbol,
        itemEmoji,
        descriptionRu,
      ];
}

/// Лавка (banca / barraca) на рынке.
class MarketStallEntity extends Equatable {
  final String id;
  final String vendorName;
  final String stallNamePt;
  final String stallNameRu;
  final String vendorEmoji;
  final String catchphrasePt; // Зазывная кричалка торговца
  final String catchphraseRu;
  final List<MarketItemEntity> items;

  const MarketStallEntity({
    required this.id,
    required this.vendorName,
    required this.stallNamePt,
    required this.stallNameRu,
    required this.vendorEmoji,
    required this.catchphrasePt,
    required this.catchphraseRu,
    required this.items,
  });

  @override
  List<Object?> get props => [
        id,
        vendorName,
        stallNamePt,
        stallNameRu,
        vendorEmoji,
        catchphrasePt,
        catchphraseRu,
        items,
      ];
}

/// Аутентичный рынок или ярмарка (Feira Livre / Mercado).
class MarketplaceEntity extends Equatable {
  final String id;
  final String namePt;
  final String nameRu;
  final String city;
  final String dialect; // 'pt_PT' or 'pt_BR'
  final String coverEmoji;
  final String atmosphereRu;
  final String historicalContextRu;
  final List<MarketStallEntity> stalls;

  const MarketplaceEntity({
    required this.id,
    required this.namePt,
    required this.nameRu,
    required this.city,
    required this.dialect,
    required this.coverEmoji,
    required this.atmosphereRu,
    required this.historicalContextRu,
    required this.stalls,
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
        city,
        dialect,
        coverEmoji,
        atmosphereRu,
        historicalContextRu,
        stalls,
      ];
}

/// Фраза покупателя или торговца на рынке.
class MarketPhraseEntity extends Equatable {
  final String id;
  final String phrasePt;
  final String translationRu;
  final String category; // 'greeting', 'weightAndQty', 'tasting', 'bargaining'
  final String dialect;
  final String contextTipRu;

  const MarketPhraseEntity({
    required this.id,
    required this.phrasePt,
    required this.translationRu,
    required this.category,
    this.dialect = 'all',
    required this.contextTipRu,
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
        phrasePt,
        translationRu,
        category,
        dialect,
        contextTipRu,
      ];
}

/// Шаг в симуляторе торга (Pechinchar / Regatear).
class BargainStepEntity extends Equatable {
  final String id;
  final String buyerTacticRu;
  final String buyerPhrasePt;
  final String buyerPhraseRu;
  final String vendorResponsePt;
  final String vendorResponseRu;
  final double offeredPrice;

  const BargainStepEntity({
    required this.id,
    required this.buyerTacticRu,
    required this.buyerPhrasePt,
    required this.buyerPhraseRu,
    required this.vendorResponsePt,
    required this.vendorResponseRu,
    required this.offeredPrice,
  });

  @override
  List<Object?> get props => [
        id,
        buyerTacticRu,
        buyerPhrasePt,
        buyerPhraseRu,
        vendorResponsePt,
        vendorResponseRu,
        offeredPrice,
      ];
}

/// Сценарий торга за товар.
class BargainScenarioEntity extends Equatable {
  final String id;
  final String itemNamePt;
  final String itemNameRu;
  final String itemEmoji;
  final String marketName;
  final String vendorName;
  final String dialect;
  final double initialPrice;
  final double targetFairPrice;
  final String currencySymbol;
  final List<BargainStepEntity> steps;

  const BargainScenarioEntity({
    required this.id,
    required this.itemNamePt,
    required this.itemNameRu,
    required this.itemEmoji,
    required this.marketName,
    required this.vendorName,
    required this.dialect,
    required this.initialPrice,
    required this.targetFairPrice,
    required this.currencySymbol,
    required this.steps,
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
        itemNamePt,
        itemNameRu,
        itemEmoji,
        marketName,
        vendorName,
        dialect,
        initialPrice,
        targetFairPrice,
        currencySymbol,
        steps,
      ];
}
