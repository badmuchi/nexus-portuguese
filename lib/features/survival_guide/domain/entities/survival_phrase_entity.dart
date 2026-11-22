import 'package:equatable/equatable.dart';

enum SurvivalCategory {
  bureaucracy('Burocracia & Documentos', 'Бюрократия и документы', '📋', 0xFF1976D2),
  housing('Moradia & Aluguel', 'Аренда жилья и быт', '🏠', 0xFFE64A19),
  transport('Transporte & Viagens', 'Транспорт и вокзалы', '🚆', 0xFF00796B),
  health('Saúde & Emergências', 'Здоровье и экстренные службы', '🏥', 0xFFD32F2F),
  banking('Finanças & Bancos', 'Банки, карты и платежи', '💳', 0xFF388E3C);

  final String labelPt;
  final String labelRu;
  final String emoji;
  final int colorHex;

  const SurvivalCategory(this.labelPt, this.labelRu, this.emoji, this.colorHex);
}

/// Сущность экспресс-фразы из шпаргалки выживания.
class SurvivalPhraseEntity extends Equatable {
  final String id;
  final String textPt;
  final String translationRu;
  final String contextNoteRu;
  final SurvivalCategory category;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final bool isEmergency;

  const SurvivalPhraseEntity({
    required this.id,
    required this.textPt,
    required this.translationRu,
    required this.contextNoteRu,
    required this.category,
    this.dialect = 'all',
    this.isEmergency = false,
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
        textPt,
        translationRu,
        contextNoteRu,
        category,
        dialect,
        isEmergency,
      ];
}
