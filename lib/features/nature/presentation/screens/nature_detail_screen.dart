import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/nature_entities.dart';
import '../../domain/repositories/nature_repository.dart';
import '../cubit/nature_reserve_cubit.dart';
import '../cubit/nature_reserve_state.dart';
import '../widgets/species_card.dart';
import '../widgets/trail_card.dart';

class NatureDetailScreen extends StatelessWidget {
  final NatureReserveEntity reserve;

  const NatureDetailScreen({
    super.key,
    required this.reserve,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => NatureReserveCubit(
        reserve: reserve,
        repository: ctx.read<NatureRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: const _NatureDetailView(),
    );
  }
}

class _NatureDetailView extends StatelessWidget {
  const _NatureDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<NatureReserveCubit, NatureReserveState>(
      builder: (context, state) {
        final cubit = context.read<NatureReserveCubit>();
        final reserve = state.reserve;

        return Scaffold(
          appBar: AppBar(
            title: Text(reserve.namePt),
            actions: [
              IconButton(
                onPressed: () {
                  if (state.isPlayingAudio) {
                    cubit.stopAudio();
                  } else {
                    cubit.playDescription();
                  }
                },
                icon: Icon(
                  state.isPlayingAudio
                      ? Icons.volume_up_rounded
                      : Icons.volume_down_rounded,
                  color: state.isPlayingAudio ? colorScheme.primary : null,
                ),
                tooltip: 'Слушать описание заповедника',
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
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Colors.green.withValues(alpha: 0.25),
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
                            color: Colors.green.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            reserve.coverEmoji,
                            style: const TextStyle(fontSize: 42),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          reserve.namePt,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${reserve.nameRu} • ${reserve.region}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            '${reserve.dialectFlag} ${reserve.country} • ${reserve.biomeRu}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          reserve.descriptionRu,
                          style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Highlights Section
                if (reserve.highlightsRu.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber.shade800),
                      const SizedBox(width: 8),
                      Text(
                        'Главные природные чудеса (Destaques)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...reserve.highlightsRu.map(
                    (hl) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🌿', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              hl,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Trails Section
                Row(
                  children: [
                    Icon(Icons.hiking_rounded, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Маршруты и треки (${reserve.trails.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...reserve.trails.map(
                  (trail) => TrailCard(
                    trail: trail,
                    isCompleted: state.completedTrailIds.contains(trail.id),
                    onComplete: () {
                      cubit.completeTrail(trail);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Маршрут «${trail.namePt}» пройден! 🥾'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Species Section
                if (reserve.faunaFlora.isNotEmpty) ...[
                  Row(
                    children: [
                      const Text('🐾', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'Флора и фауна парка (${reserve.faunaFlora.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...reserve.faunaFlora.map(
                    (species) => SpeciesCard(
                      species: species,
                      isAddedToSrs: state.addedSpeciesIds.contains(species.id),
                      onAddToSrs: () {
                        cubit.addSpeciesToSrs(species);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '«${species.commonNamePt}» добавлено в FSRS словарь!',
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
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
