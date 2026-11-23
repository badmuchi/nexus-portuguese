import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/art_entities.dart';
import '../../domain/repositories/art_repository.dart';
import '../cubit/artwork_detail_cubit.dart';
import '../cubit/artwork_detail_state.dart';

class ArtworkDetailScreen extends StatelessWidget {
  final ArtworkEntity artwork;

  const ArtworkDetailScreen({
    super.key,
    required this.artwork,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ArtworkDetailCubit(
        artwork: artwork,
        repository: ctx.read<ArtRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: const _ArtworkDetailView(),
    );
  }
}

class _ArtworkDetailView extends StatelessWidget {
  const _ArtworkDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ArtworkDetailCubit, ArtworkDetailState>(
      builder: (context, state) {
        final cubit = context.read<ArtworkDetailCubit>();
        final artwork = state.artwork;

        return Scaffold(
          appBar: AppBar(
            title: Text(artwork.titlePt),
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
                            artwork.coverEmoji,
                            style: const TextStyle(fontSize: 42),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          artwork.titlePt,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${artwork.titleRu} • ${artwork.yearRu}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          artwork.artistName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
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
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${artwork.techniquePt} (${artwork.techniqueRu})',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    size: 14,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      artwork.locationRu,
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                Text(
                  'Описание шедевра',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  artwork.descriptionRu,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),

                // Curatorial Analysis Card
                Card(
                  elevation: 0,
                  color: Colors.amber.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.amber.shade300,
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
                              Icons.auto_stories_rounded,
                              size: 20,
                              color: Colors.amber.shade900,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Анализ куратора (Significado Artístico)',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          artwork.curatorAnalysisRu,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Key Vocabulary
                if (artwork.keyVocabulary.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.palette_outlined, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Термины и понятия произведения',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...artwork.keyVocabulary.map((vocab) {
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
                                  '${vocab.translationRu} • ${vocab.contextRu}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: isAdded ? null : () => cubit.addVocabToSrs(vocab),
                            icon: Icon(
                              isAdded
                                  ? Icons.check_circle_rounded
                                  : Icons.add_circle_outline_rounded,
                              color: isAdded ? colorScheme.primary : null,
                            ),
                            tooltip: isAdded ? 'Добавлено в FSRS' : '+ В словарь FSRS',
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
