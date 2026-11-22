import 'package:equatable/equatable.dart';

enum IdiomCategory {
  animais('Животные', 'Animais', '🐾'),
  comida('Еда & Кухня', 'Comida & Cozinha', '🥘'),
  corpo('Тело & Чувства', 'Corpo & Sentidos', '👁️'),
  vida('Жизнь & Ситуации', 'Vida Cotidiana', '⚡');

  final String labelRu;
  final String labelPt;
  final String emoji;
  const IdiomCategory(this.labelRu, this.labelPt, this.emoji);
}

/// Сущность португальской идиомы или фразеологизма.
class PortugueseIdiom extends Equatable {
  final String id;
  final String expressionPt;
  final String literalTranslationRu;
  final String meaningRu;
  final String meaningPt;
  final String originStoryRu;
  final String examplePt;
  final String exampleRu;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final IdiomCategory category;
  final String illustrationEmoji;

  const PortugueseIdiom({
    required this.id,
    required this.expressionPt,
    required this.literalTranslationRu,
    required this.meaningRu,
    required this.meaningPt,
    required this.originStoryRu,
    required this.examplePt,
    required this.exampleRu,
    required this.dialect,
    required this.category,
    required this.illustrationEmoji,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';
  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : (isPtBr ? '🇧🇷' : '🌐');
  String get dialectLabel => isPtPt ? 'Portugal' : (isPtBr ? 'Brasil' : 'Pan-lusófono');

  @override
  List<Object?> get props => [
        id,
        expressionPt,
        literalTranslationRu,
        meaningRu,
        meaningPt,
        originStoryRu,
        examplePt,
        exampleRu,
        dialect,
        category,
        illustrationEmoji,
      ];
}
