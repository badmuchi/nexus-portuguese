import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe_entity.dart';

class RecipeCookState extends Equatable {
  final RecipeEntity recipe;
  final int currentStepIndex;
  final Set<String> checkedIngredientIds;
  final bool isTimerRunning;
  final int remainingTimerSeconds;
  final bool isTimerFinished;
  final bool isRecipeCompleted;

  const RecipeCookState({
    required this.recipe,
    this.currentStepIndex = 0,
    this.checkedIngredientIds = const {},
    this.isTimerRunning = false,
    this.remainingTimerSeconds = 0,
    this.isTimerFinished = false,
    this.isRecipeCompleted = false,
  });

  RecipeStepEntity get currentStep => recipe.steps[currentStepIndex];

  bool get isLastStep => currentStepIndex == recipe.steps.length - 1;

  bool get allIngredientsChecked =>
      recipe.ingredients.isNotEmpty &&
      checkedIngredientIds.length == recipe.ingredients.length;

  RecipeCookState copyWith({
    RecipeEntity? recipe,
    int? currentStepIndex,
    Set<String>? checkedIngredientIds,
    bool? isTimerRunning,
    int? remainingTimerSeconds,
    bool? isTimerFinished,
    bool? isRecipeCompleted,
  }) {
    return RecipeCookState(
      recipe: recipe ?? this.recipe,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      checkedIngredientIds: checkedIngredientIds ?? this.checkedIngredientIds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      remainingTimerSeconds: remainingTimerSeconds ?? this.remainingTimerSeconds,
      isTimerFinished: isTimerFinished ?? this.isTimerFinished,
      isRecipeCompleted: isRecipeCompleted ?? this.isRecipeCompleted,
    );
  }

  @override
  List<Object?> get props => [
        recipe,
        currentStepIndex,
        checkedIngredientIds,
        isTimerRunning,
        remainingTimerSeconds,
        isTimerFinished,
        isRecipeCompleted,
      ];
}
