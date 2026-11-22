import 'package:equatable/equatable.dart';

enum CulinaryTermType {
  cookingVerb('Verbos Culinários', 'Глаголы приготовления', '🔪'),
  utensil('Utensílios de Cozinha', 'Кухонная утварь', '🍳'),
  measurement('Medidas & Quantidades', 'Меры и порции', '⚖️'),
  dialectFood('Diferenças PT-BR vs PT-PT', 'Продукты: PT-BR vs PT-PT', '🔄');

  final String labelPt;
  final String labelRu;
  final String emoji;

  const CulinaryTermType(this.labelPt, this.labelRu, this.emoji);
}

/// Сущность кулинарного термина, глагола или диалектного различия в еде.
class CulinaryTermEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final CulinaryTermType type;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String usageExamplePt;
  final String usageExampleRu;
  final String? culturalNoteRu;

  const CulinaryTermEntity({
    required this.id,
    required this.termPt,
    required this.translationRu,
    required this.type,
    this.dialect = 'all',
    required this.usageExamplePt,
    required this.usageExampleRu,
    this.culturalNoteRu,
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
  String get dialectLabel => isPtPt ? 'Portugal' : isPtBr ? 'Brasil' : 'Geral';

  @override
  List<Object?> get props => [
        id,
        termPt,
        translationRu,
        type,
        dialect,
        usageExamplePt,
        usageExampleRu,
        culturalNoteRu,
      ];
}
