import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/recipe_entity.dart';

class RecipeIngredientsView extends StatelessWidget {
  final RecipeEntity recipe;
  final Set<String> checkedIngredientIds;
  final ValueChanged<String> onToggle;
  final VoidCallback onCheckAll;

  const RecipeIngredientsView({
    super.key,
    required this.recipe,
    required this.checkedIngredientIds,
    required this.onToggle,
    required this.onCheckAll,
  });

  void _playAudio(BuildContext context, String text) {
    final audio = context.read<HybridAudioPlaybackService>();
    final dialect = recipe.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    audio.playAudioOrSpeak(
      fallbackText: text,
      dialect: dialect,
    );
  }

  Future<void> _addIngredientToSrs(BuildContext context, RecipeIngredient ing) async {
    HapticFeedback.mediumImpact();
    try {
      final srsRepo = context.read<SrsRepository>();
      final card = SrsCardEntity(
        id: 'ing_${ing.id}_${DateTime.now().millisecondsSinceEpoch}',
        portuguese: ing.namePt,
        russianTranslation: ing.nameRu,
        partOfSpeech: 'Ingrediente',
        category: 'culinaria',
        dialect: recipe.dialect,
        examplePortuguese: '${ing.namePt} (${ing.amount}) na receita de ${recipe.titlePt}',
        exampleRussian: '${ing.nameRu} в рецепте ${recipe.titleRu}',
        notes: ing.dialectNoteRu ?? 'Ингредиент рецепта',
        fsrsState: 'newCard',
        stability: 0.0,
        difficulty: 0.0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      );

      await srsRepo.addCard(card);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('«${ing.namePt}» добавлен в FSRS! 🥕'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allChecked = checkedIngredientIds.length == recipe.ingredients.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Ингредиенты (${checkedIngredientIds.length}/${recipe.ingredients.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onCheckAll,
              child: Text(allChecked ? 'Сбросить' : 'Собрано всё ✅'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recipe.ingredients.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final ing = recipe.ingredients[index];
            final isChecked = checkedIngredientIds.contains(ing.id);

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              leading: Checkbox(
                value: isChecked,
                onChanged: (_) => onToggle(ing.id),
              ),
              title: Text(
                ing.namePt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                  color: isChecked ? theme.colorScheme.outline : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ing.nameRu} • ${ing.amount}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isChecked ? theme.colorScheme.outline : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (ing.dialectNoteRu != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      ing.dialectNoteRu!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.amber.shade900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                    tooltip: 'Озвучить',
                    onPressed: () => _playAudio(context, ing.namePt),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                    tooltip: 'В карточки FSRS',
                    onPressed: () => _addIngredientToSrs(context, ing),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              onTap: () => onToggle(ing.id),
            );
          },
        ),
      ],
    );
  }
}
