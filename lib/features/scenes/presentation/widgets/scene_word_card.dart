import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/portuguese_life_scene.dart';
import '../cubit/scenes_cubit.dart';

class SceneWordCard extends StatelessWidget {
  final SceneWord word;

  const SceneWordCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        word.portuguese,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        word.ipa,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      if (word.dialectTag != 'all') ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            word.dialectTag == 'pt-PT' ? '🇵🇹 PT' : '🇧🇷 BR',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word.russianMeaning,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (word.contextNote != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      word.contextNote!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              tooltip: 'Послушать произношение',
              icon: const Icon(Icons.volume_up_rounded),
              onPressed: () {
                context.read<ScenesCubit>().playAudio(
                      word.portuguese,
                      dialectTag: word.dialectTag,
                    );
              },
            ),
            IconButton(
              tooltip: 'Добавить в карточки FSRS',
              icon: const Icon(Icons.add_card_rounded),
              color: theme.colorScheme.primary,
              onPressed: () async {
                final success = await context.read<ScenesCubit>().addWordToSrs(word);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        success
                            ? '«${word.portuguese}» добавлено в колоду FSRS!'
                            : 'Не удалось добавить карточку',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
