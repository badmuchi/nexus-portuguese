import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/folklore_entities.dart';
import '../../domain/repositories/folklore_repository.dart';
import '../cubit/myth_detail_cubit.dart';
import '../cubit/myth_detail_state.dart';

class MythDetailScreen extends StatelessWidget {
  final MythicalEntity myth;

  const MythDetailScreen({
    super.key,
    required this.myth,
  });

  static Route<void> route({required MythicalEntity myth}) {
    return MaterialPageRoute<void>(
      builder: (_) => MythDetailScreen(myth: myth),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => MythDetailCubit(
        myth: myth,
        repository: ctx.read<FolkloreRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: const _MythDetailView(),
    );
  }
}

class _MythDetailView extends StatelessWidget {
  const _MythDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocBuilder<MythDetailCubit, MythDetailState>(
        builder: (context, state) {
          final myth = state.myth;
          final (originColor, originLabel) = switch (myth.origin) {
            FolkloreOrigin.indigena => (Colors.green.shade800, 'Индейские корни'),
            FolkloreOrigin.afroBrasileiro => (Colors.deepOrange.shade800, 'Афро-мифология'),
            FolkloreOrigin.iberico => (Colors.indigo.shade800, 'Иберийские корни'),
            FolkloreOrigin.urbanoMisto => (Colors.purple.shade700, 'Народные сказания'),
          };

          return Scaffold(
            appBar: AppBar(
              title: Text(myth.name),
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
                    final cubit = context.read<MythDetailCubit>();
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
                          originColor.withValues(alpha: 0.18),
                          colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: originColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          myth.accentEmoji,
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          myth.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          myth.aliasRu,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
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
                              label: Text(originLabel),
                              avatar: const Icon(Icons.nature_people_rounded, size: 16),
                              visualDensity: VisualDensity.compact,
                              side: BorderSide.none,
                              backgroundColor: originColor.withValues(alpha: 0.15),
                            ),
                            Chip(
                              label: Text(myth.region),
                              avatar: const Icon(Icons.location_on_outlined, size: 16),
                              visualDensity: VisualDensity.compact,
                              side: BorderSide.none,
                            ),
                            Chip(
                              label: Text(myth.isPtPt ? 'Португалия 🇵🇹' : 'Бразилия 🇧🇷'),
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
                            state.isPlayingAudio ? 'Остановить аудио' : 'Слушать легенду',
                          ),
                          onPressed: () {
                            final cubit = context.read<MythDetailCubit>();
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

                  // Magical Powers
                  Text(
                    'Магические силы & Особенности',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: myth.magicalPowers.map((power) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.flash_on_rounded, size: 16, color: Colors.amber.shade700),
                            const SizedBox(width: 6),
                            Text(
                              power,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Full Legend
                  Text(
                    'Легенда на португальском',
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
                      myth.fullLegend,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.55,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Moral / Cultural Meaning
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade900.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.teal.shade700.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline_rounded,
                                color: Colors.teal.shade700, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Культурный смысл и мораль',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          myth.moralOrMeaning,
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
                        'Фольклорный словарь (${myth.vocabulary.length})',
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
                  ...myth.vocabulary.map((vocab) {
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
                              tooltip: isAdded ? 'Добавлено в SRS' : 'Учить слово',
                              onPressed: isAdded
                                  ? null
                                  : () => context
                                      .read<MythDetailCubit>()
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
