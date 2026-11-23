import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/humor_entities.dart';
import '../../domain/repositories/humor_repository.dart';
import '../cubit/joke_reader_cubit.dart';
import '../cubit/joke_reader_state.dart';

class JokeDetailScreen extends StatelessWidget {
  final JokeEntity joke;

  const JokeDetailScreen({
    super.key,
    required this.joke,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => JokeReaderCubit(
        joke: joke,
        repository: ctx.read<HumorRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: const _JokeDetailView(),
    );
  }
}

class _JokeDetailView extends StatelessWidget {
  const _JokeDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<JokeReaderCubit, JokeReaderState>(
      builder: (context, state) {
        final cubit = context.read<JokeReaderCubit>();
        final joke = state.joke;

        return Scaffold(
          appBar: AppBar(
            title: Text(joke.titlePt),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(joke.dialectFlag),
                        const SizedBox(width: 4),
                        Text(
                          joke.dialectLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Directionality(
            textDirection: TextDirection.ltr,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Category Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sentiment_very_satisfied_rounded,
                        size: 20,
                        color: colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        joke.category.labelRu,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Setup Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Завязка истории (História)',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => cubit.playAudio(isPunchline: false),
                              icon: Icon(
                                state.isPlayingAudio
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_down_rounded,
                                color: colorScheme.primary,
                              ),
                              tooltip: 'Слушать завязку',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          joke.setupPt,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Text(
                          joke.setupRu,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Punchline Card
                if (!state.isPunchlineRevealed)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: FilledButton.icon(
                        onPressed: () => cubit.revealPunchline(),
                        icon: const Icon(Icons.flash_on_rounded),
                        label: const Text('Показать панчлайн! 🎉'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                else ...[
                  Card(
                    elevation: 0,
                    color: colorScheme.primaryContainer.withValues(alpha: 0.25),
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
                              Text(
                                'Развязка (Desfecho / Punchline) 💥',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => cubit.playAudio(isPunchline: true),
                                icon: const Icon(Icons.volume_up_rounded),
                                color: colorScheme.primary,
                                tooltip: 'Слушать панчлайн',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            joke.punchlinePt,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            joke.punchlineRu,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Reaction Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => cubit.rateJoke(true),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: state.userReaction == true
                                      ? colorScheme.primaryContainer
                                      : null,
                                ),
                                icon: const Icon(Icons.sentiment_very_satisfied, size: 20),
                                label: const Text('Смешно! 😂'),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: () => cubit.rateJoke(false),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: state.userReaction == false
                                      ? colorScheme.surfaceContainerHighest
                                      : null,
                                ),
                                icon: const Icon(Icons.sentiment_neutral, size: 20),
                                label: const Text('Так себе 😐'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),

                // Explanation Section
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.psychology_alt_rounded,
                              size: 20,
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'В чём соль? (Разбор юмора)',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          joke.explanationRu,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Vocabulary Section
                if (joke.vocabulary.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.style_outlined, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Слова и выражения анекдота',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...joke.vocabulary.map((vocab) {
                    final isAdded = state.addedVocabIds.contains(vocab.id);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isAdded
                            ? colorScheme.primaryContainer.withValues(alpha: 0.2)
                            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isAdded
                              ? colorScheme.primary
                              : colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vocab.termPt,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${vocab.translationRu} • ${vocab.explanationRu}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: isAdded ? null : () => cubit.addToSrs(vocab),
                            icon: Icon(
                              isAdded
                                  ? Icons.check_circle_rounded
                                  : Icons.add_circle_outline_rounded,
                              color: isAdded ? colorScheme.primary : null,
                            ),
                            tooltip: isAdded ? 'Добавлено в FSRS' : 'Добавить в словарь FSRS',
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
