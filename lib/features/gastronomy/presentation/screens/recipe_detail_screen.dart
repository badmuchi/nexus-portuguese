import 'package:flutter/material.dart';
import '../../domain/entities/recipe_entity.dart';
import '../widgets/recipe_ingredients_view.dart';
import 'recipe_cooking_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeEntity recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  static Route<void> route({required RecipeEntity recipe}) {
    return MaterialPageRoute(
      builder: (_) => RecipeDetailScreen(recipe: recipe),
    );
  }

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final Set<String> _checkedIngredientIds = {};

  void _toggleIngredient(String id) {
    setState(() {
      if (_checkedIngredientIds.contains(id)) {
        _checkedIngredientIds.remove(id);
      } else {
        _checkedIngredientIds.add(id);
      }
    });
  }

  void _checkAll() {
    setState(() {
      if (_checkedIngredientIds.length == widget.recipe.ingredients.length) {
        _checkedIngredientIds.clear();
      } else {
        _checkedIngredientIds.addAll(widget.recipe.ingredients.map((i) => i.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recipe = widget.recipe;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.titlePt,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: recipe.isPtPt
                  ? Colors.red.withValues(alpha: 0.15)
                  : Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              recipe.isPtPt ? '🇵🇹 PT-PT' : '🇧🇷 PT-BR',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: recipe.isPtPt ? Colors.red.shade700 : Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
                    theme.colorScheme.surfaceContainerHighest,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Text(recipe.iconEmoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text(
                    recipe.titlePt,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    recipe.titleRu,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPill(theme, Icons.location_on_rounded, recipe.region),
                      const SizedBox(width: 8),
                      _buildPill(theme, Icons.timer_outlined, '${recipe.prepTimeMinutes} мин'),
                      const SizedBox(width: 8),
                      _buildPill(theme, Icons.restaurant_outlined, '${recipe.servings} порций'),
                      const SizedBox(width: 8),
                      _buildPill(theme, Icons.bar_chart_rounded, recipe.difficulty),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cultural Story
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.history_edu_rounded, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'История и культура блюда',
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.culturalStoryRu,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Secret Tip
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Секрет шефа',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          recipe.secretTipRu,
                          style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Ingredients checklist
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: RecipeIngredientsView(
                recipe: recipe,
                checkedIngredientIds: _checkedIngredientIds,
                onToggle: _toggleIngredient,
                onCheckAll: _checkAll,
              ),
            ),
            const SizedBox(height: 24),

            // Cook Button
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  RecipeCookingScreen.route(recipe: recipe),
                );
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.soup_kitchen_rounded),
              label: const Text(
                'Начать готовить! 👩‍🍳',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(ThemeData theme, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
