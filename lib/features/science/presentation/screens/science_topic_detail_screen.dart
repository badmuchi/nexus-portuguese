import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/science_entities.dart';
import '../../domain/repositories/science_repository.dart';
import '../cubit/science_detail_cubit.dart';
import '../cubit/science_detail_state.dart';

class ScienceTopicDetailScreen extends StatelessWidget {
  final ScienceTopicEntity topic;

  const ScienceTopicDetailScreen({
    super.key,
    required this.topic,
  });

  static Route<void> route({required ScienceTopicEntity topic}) {
    return MaterialPageRoute<void>(
      builder: (_) => ScienceTopicDetailScreen(topic: topic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ScienceDetailCubit(
        topic: topic,
        repository: ctx.read<ScienceRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: const _ScienceTopicDetailView(),
    );
  }
}

class _ScienceTopicDetailView extends StatelessWidget {
  const _ScienceTopicDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocBuilder<ScienceDetailCubit, ScienceDetailState>(
        builder: (context, state) {
          final topic = state.topic;
          final (fieldColor, fieldLabel) = switch (topic.field) {
            ScienceField.oceanografia => (Colors.blue.shade800, 'Океанография'),
            ScienceField.biomedicina => (Colors.teal.shade700, 'Биомедицина'),
            ScienceField.energiaVerde => (Colors.green.shade700, 'Зелёная энергия'),
            ScienceField.aeroespacial => (Colors.deepPurple.shade700, 'Аэрокосмос'),
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
                    final cubit = context.read<ScienceDetailCubit>();
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
                          fieldColor.withValues(alpha: 0.18),
                          colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: fieldColor.withValues(alpha: 0.35),
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
                          topic.institution,
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
                              label: Text(fieldLabel),
                              avatar: const Icon(Icons.science_rounded, size: 16),
                              visualDensity: VisualDensity.compact,
                              side: BorderSide.none,
                              backgroundColor: fieldColor.withValues(alpha: 0.15),
                            ),
                            Chip(
                              label: Text(topic.region),
                              avatar: const Icon(Icons.location_on_outlined, size: 16),
                              visualDensity: VisualDensity.compact,
                              side: BorderSide.none,
                            ),
                            Chip(
                              label: Text(topic.isPtPt ? 'Португалия 🇵🇹' : 'Бразилия 🇧🇷'),
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
                            final cubit = context.read<ScienceDetailCubit>();
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

                  // Key Discoveries
                  Text(
                    'Ключевые открытия & Достижения',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...topic.keyDiscoveries.map((discovery) {
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
                              size: 18, color: fieldColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              discovery,
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
                    'Научный обзор на португальском',
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

                  // Scientific Impact
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade900.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.green.shade700.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.public_rounded,
                                color: Colors.green.shade700, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Глобальное влияние и наследие',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          topic.scientificImpact,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Scientific Vocabulary
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Научный словарь (${topic.vocabulary.length})',
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
                                      .read<ScienceDetailCubit>()
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
