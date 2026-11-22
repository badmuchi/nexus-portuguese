import 'package:flutter/material.dart';
import '../../domain/entities/recipe_entity.dart';

class RecipeCard extends StatelessWidget {
  final RecipeEntity recipe;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  Color _getDifficultyColor(String diff) {
    switch (diff.toLowerCase()) {
      case 'fácil':
        return Colors.green;
      case 'médio':
        return Colors.amber.shade800;
      case 'avançado':
        return Colors.deepOrange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diffColor = _getDifficultyColor(recipe.difficulty);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: recipe.isPtPt
                          ? Colors.red.withValues(alpha: 0.12)
                          : Colors.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        recipe.iconEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: recipe.isPtPt
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${recipe.dialectFlag} ${recipe.region}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: recipe.isPtPt ? Colors.red.shade700 : Colors.green.shade700,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: diffColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                recipe.difficulty,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: diffColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          recipe.titlePt,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          recipe.titleRu,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                recipe.culturalStoryRu,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
              const Divider(height: 20),
              Row(
                children: [
                  Icon(Icons.timer_outlined, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.prepTimeMinutes} мин',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.restaurant_outlined, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.servings} порций',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.format_list_numbered_rounded, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.steps.length} шагов',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
