import 'package:equatable/equatable.dart';
import 'survival_phrase_entity.dart';

/// Сущность практического совета по выживанию и этикету в португалоязычной среде.
class CulturalTipEntity extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final String contentRu;
  final SurvivalCategory category;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String iconEmoji;
  final List<String> bulletPointsRu;

  const CulturalTipEntity({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.contentRu,
    required this.category,
    this.dialect = 'all',
    required this.iconEmoji,
    this.bulletPointsRu = const [],
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
        titlePt,
        titleRu,
        contentRu,
        category,
        dialect,
        iconEmoji,
        bulletPointsRu,
      ];
}
