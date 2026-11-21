import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../morphology/presentation/widgets/sentence_xray_sheet.dart';
import '../../domain/entities/portuguese_life_scene.dart';
import '../cubit/scenes_cubit.dart';

class ScenePhraseTile extends StatelessWidget {
  final ScenePhrase phrase;

  const ScenePhraseTile({super.key, required this.phrase});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncoming = phrase.role == PhraseRole.theySay;

    final badgeColor = isIncoming
        ? theme.colorScheme.tertiaryContainer
        : theme.colorScheme.primaryContainer;
    final onBadgeColor = isIncoming
        ? theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.onPrimaryContainer;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    phrase.role.labelRu,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: onBadgeColor,
                    ),
                  ),
                ),
                if (phrase.dialectTag != 'all') ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      phrase.dialectTag == 'pt-PT' ? '🇵🇹 PT-PT' : '🇧🇷 PT-BR',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                IconButton(
                  tooltip: 'Слушать',
                  icon: const Icon(Icons.volume_up_rounded, size: 22),
                  onPressed: () {
                    context.read<ScenesCubit>().playAudio(
                          phrase.portuguese,
                          dialectTag: phrase.dialectTag,
                        );
                  },
                ),
                IconButton(
                  tooltip: 'Морфологический X-Ray',
                  icon: const Icon(Icons.psychology_alt_rounded, size: 22),
                  color: theme.colorScheme.secondary,
                  onPressed: () {
                    SentenceXRaySheet.show(
                      context,
                      sentencePortuguese: phrase.portuguese,
                      translationRussian: phrase.russianTranslation,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              phrase.portuguese,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              phrase.russianTranslation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (phrase.pronunciationTip != null) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.tips_and_updates_rounded,
                    size: 16,
                    color: Colors.amber.shade800,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      phrase.pronunciationTip!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
