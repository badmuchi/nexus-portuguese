import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/fashion_entities.dart';
import '../../domain/repositories/fashion_repository.dart';
import '../cubit/fashion_detail_cubit.dart';
import '../cubit/fashion_detail_state.dart';

class FashionTopicDetailScreen extends StatelessWidget {
  final FashionTopicEntity topic;

  const FashionTopicDetailScreen({
    super.key,
    required this.topic,
  });

  static Route<void> route({required FashionTopicEntity topic}) {
    return MaterialPageRoute<void>(
      builder: (_) => FashionTopicDetailScreen(topic: topic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => FashionDetailCubit(
        topic: topic,
        repository: ctx.read<FashionRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: const _FashionTopicDetailView(),
    );
  }
}

class _FashionTopicDetailView extends StatelessWidget {
  const _FashionTopicDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocBuilder<FashionDetailCubit, FashionDetailState>(
        builder: (context, state) {
          final topic = state.topic;
          final (catColor, catLabel) = switch (topic.category) {
            FashionCategory.altaCostura => (Colors.pink.shade700, 'Alta-Costura'),
            FashionCategory.calcadoCouro => (Colors.brown.shade700, 'Calçado & Couro'),
            FashionCategory.rendasTecidos => (Colors.teal.shade700, 'Rendas & Tecidos'),
            FashionCategory.ourivesariaDesign => (Colors.amber.shade900, 'Ourivesaria & Filigrana'),
          };

          return Scaffold(
            appBar: AppBar(
              title: Text(topic.title),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: Icon(
                    state.isPlayingAudio
                        ? Icons.stop_circle_rounded
                        : Icons.volume_up_rounded,
                    color: state.isPlayingAudio ? colorScheme.error : null,
                  ),
                  tooltip: state.isPlayingAudio ? 'Остановить' : 'Слушать аудиогид',
                  onPressed: () {
                    final cubit = context.read<FashionDetailCubit>();
                    if (state.isPlayingAudio) {
                      cubit.stopAudio();
                    } else {
                      cubit.playAudio();
                    }
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          catColor.withValues(alpha: 0.18),
                          colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: catColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          topic.accentEmoji,
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          topic.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          topic.region,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: [
                            Chip(
                              label: Text(catLabel),
                              avatar: const Icon(Icons.style_rounded, size: 16),
                              visualDensity: VisualDensity.compact,
                              side: BorderSide.none,
                              backgroundColor: catColor.withValues(alpha: 0.15),
                            ),
                            Chip(
                              label: Text(topic.country),
                              avatar: const Icon(Icons.location_on_outlined, size: 16),
                              visualDensity: VisualDensity.compact,
                              side: BorderSide.none,
                            ),
                            Chip(
                              label: Text(topic.isPtPt ? 'Португалия 🇵🇹' : (topic.isPtBr ? 'Бразилия 🇧🇷' : 'Лузофония 🌐')),
                              visualDensity: VisualDensity.compact,
                              side: BorderSide.none,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        FilledButton.tonalIcon(
                          icon: Icon(
                            state.isPlayingAudio
                                ? Icons.stop_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          label: Text(
                            state.isPlayingAudio ? 'Остановить аудио' : 'Слушать аудиогид',
                          ),
                          onPressed: () {
                            final cubit = context.read<FashionDetailCubit>();
                            if (state.isPlayingAudio) {
                              cubit.stopAudio();
                            } else {
                              cubit.playAudio();
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Highlights
                  Text(
                    'Ключевые особенности & Достижения',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...topic.keyHighlights.map((highlight) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              size: 18, color: catColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              highlight,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Full Description
                  Text(
                    'История и контекст на португальском',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      topic.fullDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.55,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Cultural Significance
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade900.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.amber.shade700.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome_rounded,
                                color: Colors.amber.shade800, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Культурная ценность и самобытность',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          topic.culturalSignificance,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Thematic Vocabulary
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Словарь моды и дизайна (${topic.vocabulary.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'FSRS карточки',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...topic.vocabulary.map((vocab) {
                    final isAdded = state.addedVocabIds.contains(vocab.id);
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        vocab.termPt,
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          vocab.dialectNote ?? (vocab.isPtPt ? 'PT-PT' : 'PT-BR'),
                                          style: theme.textTheme.labelSmall?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    vocab.translationRu,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    vocab.exampleSentence,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                isAdded
                                    ? Icons.check_circle_rounded
                                    : Icons.bookmark_add_outlined,
                                color: isAdded ? Colors.green : colorScheme.primary,
                              ),
                              tooltip: isAdded ? 'Добавлено в SRS' : 'Учить термин',
                              onPressed: isAdded
                                  ? null
                                  : () => context
                                      .read<FashionDetailCubit>()
                                      .addVocabToSrs(vocab),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
