import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/architecture_entities.dart';
import '../../domain/repositories/architecture_repository.dart';
import '../cubit/monument_detail_cubit.dart';
import '../cubit/monument_detail_state.dart';

class MonumentDetailScreen extends StatelessWidget {
  final ArchitecturalMonumentEntity monument;

  const MonumentDetailScreen({
    super.key,
    required this.monument,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => MonumentDetailCubit(
        monument: monument,
        repository: ctx.read<ArchitectureRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: const _MonumentDetailView(),
    );
  }
}

class _MonumentDetailView extends StatelessWidget {
  const _MonumentDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<MonumentDetailCubit, MonumentDetailState>(
      builder: (context, state) {
        final cubit = context.read<MonumentDetailCubit>();
        final monument = state.monument;
        final dialectFlag =
            monument.isPtPt ? '🇵🇹' : (monument.isPtBr ? '🇧🇷' : '🌐');

        return Scaffold(
          appBar: AppBar(
            title: Text(monument.title),
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
                tooltip: 'Слушать аудиогид',
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
                            monument.accentEmoji,
                            style: const TextStyle(fontSize: 42),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                monument.title,
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
                          '${monument.city} • ${monument.yearCompleted}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Архитектор: ${monument.architect}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            monument.styleName,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Audio Guide Player Card
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
                            Icon(Icons.headset_mic_rounded,
                                color: colorScheme.primary, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Аудиогид архитектора',
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
                          '"${monument.audioSnippet}"',
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

                // Historical Significance
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
                            const Icon(Icons.history_edu_rounded,
                                size: 20, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text(
                              'Историческое значение',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          monument.historicalSignificance,
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

                // Architectural Description
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
                              'Архитектурный анализ',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          monument.fullDescription,
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

                // Architectural Features
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
                            Icon(Icons.architecture_rounded,
                                size: 20, color: colorScheme.secondary),
                            const SizedBox(width: 8),
                            Text(
                              'Конструктивные особенности',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...monument.architecturalFeatures.map((feat) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ',
                                    style: TextStyle(
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                                Expanded(
                                  child: Text(
                                    feat,
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
                if (monument.vocabulary.isNotEmpty) ...[
                  Text(
                    'Термины и понятия урбанистики',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...monument.vocabulary.map((vocab) {
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
