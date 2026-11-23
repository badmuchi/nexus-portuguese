import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/festas_entities.dart';
import '../../domain/repositories/festas_repository.dart';
import '../cubit/festa_detail_cubit.dart';
import '../cubit/festa_detail_state.dart';

class FestaDetailScreen extends StatelessWidget {
  final FestaEntity festa;

  const FestaDetailScreen({
    super.key,
    required this.festa,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => FestaDetailCubit(
        festa: festa,
        repository: ctx.read<FestasRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: const _FestaDetailView(),
    );
  }
}

class _FestaDetailView extends StatelessWidget {
  const _FestaDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<FestaDetailCubit, FestaDetailState>(
      builder: (context, state) {
        final cubit = context.read<FestaDetailCubit>();
        final festa = state.festa;
        final dialectFlag =
            festa.isPtPt ? '🇵🇹' : (festa.isPtBr ? '🇧🇷' : '🌐');

        return Scaffold(
          appBar: AppBar(
            title: Text(festa.title),
            actions: [
              IconButton(
                onPressed: () {
                  if (state.isPlayingAudio) {
                    cubit.stopAudio();
                  } else {
                    cubit.playAudio();
                  }
                },
                icon: Icon(
                  state.isPlayingAudio
                      ? Icons.volume_up_rounded
                      : Icons.volume_down_rounded,
                  color: state.isPlayingAudio ? colorScheme.primary : null,
                ),
                tooltip: 'Слушать аудио',
              ),
            ],
          ),
          body: Directionality(
            textDirection: TextDirection.ltr,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Hero Banner
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            festa.accentEmoji,
                            style: const TextStyle(fontSize: 42),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                festa.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(dialectFlag,
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          festa.region,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '📅 ${festa.seasonDate}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Audio Snippet Card
                Card(
                  elevation: 0,
                  color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.headphones_rounded,
                                color: colorScheme.primary, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Атмосфера праздника',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            const Spacer(),
                            FilledButton.tonalIcon(
                              onPressed: () {
                                if (state.isPlayingAudio) {
                                  cubit.stopAudio();
                                } else {
                                  cubit.playAudio();
                                }
                              },
                              icon: Icon(
                                state.isPlayingAudio
                                    ? Icons.stop_rounded
                                    : Icons.play_arrow_rounded,
                                size: 18,
                              ),
                              label: Text(
                                state.isPlayingAudio ? 'Остановить' : 'Слушать',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '"${festa.audioSnippet}"',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Full Description
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.menu_book_rounded,
                                size: 20, color: colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'О празднике',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          festa.fullDescription,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Rituals and Traditions
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.stars_rounded,
                                size: 20, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text(
                              'Главные обряды и кульминации',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...festa.ritualsAndTraditions.map((ritual) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('✨ ',
                                    style: TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    ritual,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Foods and Drinks
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.restaurant_menu_rounded,
                                size: 20, color: colorScheme.secondary),
                            const SizedBox(width: 8),
                            Text(
                              'Праздничные угощения & напитки',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...festa.foodsAndDrinks.map((food) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('🍽️ ',
                                    style: TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    food,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Vocabulary Section
                if (festa.vocabulary.isNotEmpty) ...[
                  Text(
                    'Праздничный сленг & лексика',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...festa.vocabulary.map((vocab) {
                    final isSaved = state.addedVocabIds.contains(vocab.id);

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isSaved
                              ? colorScheme.primary.withValues(alpha: 0.5)
                              : colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vocab.termPt,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                      Text(
                                        vocab.translationRu,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton.filledTonal(
                                  icon: Icon(
                                    isSaved
                                        ? Icons.bookmark_added_rounded
                                        : Icons.bookmark_add_outlined,
                                    size: 18,
                                  ),
                                  onPressed: isSaved
                                      ? null
                                      : () {
                                          cubit.addVocabToSrs(vocab);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '«${vocab.termPt}» добавлен в повторение FSRS',
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                  tooltip: 'Добавить в FSRS',
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              vocab.definition,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '"${vocab.exampleSentence}"',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            if (vocab.dialectNote != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                '💡 ${vocab.dialectNote}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
