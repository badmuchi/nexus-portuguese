import 'package:equatable/equatable.dart';

/// Ингредиент кулинарного рецепта с лексической заметкой.
class RecipeIngredient extends Equatable {
  final String id;
  final String namePt;
  final String nameRu;
  final String amount; // например, "500g", "2 colheres de sopa", "1 chávena"
  final String? dialectNoteRu; // например, "В Португалии chávena, в Бразилии xícara"
  final bool isKeyVocabulary;

  const RecipeIngredient({
    required this.id,
    required this.namePt,
    required this.nameRu,
    required this.amount,
    this.dialectNoteRu,
    this.isKeyVocabulary = true,
  });

  @override
  List<Object?> get props => [id, namePt, nameRu, amount, dialectNoteRu, isKeyVocabulary];
}

/// Шаг приготовления блюда с акцентом на кулинарный глагол и таймер.
class RecipeStepEntity extends Equatable {
  final int stepNumber;
  final String instructionPt;
  final String instructionRu;
  final String actionVerbPt; // например, "Picar", "Refogar", "Bater", "Ferver"
  final String actionVerbRu;
  final int? timerSeconds; // например, 600 для 10 минут варки

  const RecipeStepEntity({
    required this.stepNumber,
    required this.instructionPt,
    required this.instructionRu,
    required this.actionVerbPt,
    required this.actionVerbRu,
    this.timerSeconds,
  });

  @override
  List<Object?> get props => [
        stepNumber,
        instructionPt,
        instructionRu,
        actionVerbPt,
        actionVerbRu,
        timerSeconds,
      ];
}

/// Сущность рецепта лузофонной кухни.
class RecipeEntity extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final String region; // "Lisboa", "Minas Gerais", "Bahia", "Minho"
  final String dialect; // 'pt_BR', 'pt_PT'
  final String difficulty; // 'Fácil', 'Médio', 'Avançado'
  final int prepTimeMinutes;
  final int servings;
  final String iconEmoji;
  final String culturalStoryRu; // Историко-культурная справка о блюде
  final String secretTipRu; // Кулинарный секрет
  final List<RecipeIngredient> ingredients;
  final List<RecipeStepEntity> steps;

  const RecipeEntity({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.region,
    required this.dialect,
    required this.difficulty,
    required this.prepTimeMinutes,
    required this.servings,
    required this.iconEmoji,
    required this.culturalStoryRu,
    required this.secretTipRu,
    required this.ingredients,
    required this.steps,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : '🇧🇷';
  String get dialectLabel => isPtPt ? 'Portugal' : 'Brasil';

  @override
  List<Object?> get props => [
        id,
        titlePt,
        titleRu,
        region,
        dialect,
        difficulty,
        prepTimeMinutes,
        servings,
        iconEmoji,
        culturalStoryRu,
        secretTipRu,
        ingredients,
        steps,
      ];
}
