import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/ancestral_entities.dart';
import '../../domain/repositories/ancestral_repository.dart';
import '../cubit/ancestral_detail_cubit.dart';
import '../cubit/ancestral_detail_state.dart';

class CommunityDetailScreen extends StatelessWidget {
  final TraditionalCommunityEntity community;

  const CommunityDetailScreen({
    super.key,
    required this.community,
  });

  static Route<void> route({required TraditionalCommunityEntity community}) {
    return MaterialPageRoute<void>(
      builder: (_) => CommunityDetailScreen(community: community),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AncestralDetailCubit(
        community: community,
        repository: ctx.read<AncestralRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: const _CommunityDetailView(),
    );
  }
}

class _CommunityDetailView extends StatelessWidget {
  const _CommunityDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocBuilder<AncestralDetailCubit, AncestralDetailState>(
        builder: (context, state) {
          final community = state.community;
          final (catColor, catLabel) = switch (community.category) {
            CommunityCategory.ribeirinhos => (Colors.teal.shade700, 'Ribeirinhos'),
            CommunityCategory.caicaras => (Colors.blue.shade700, 'Caiçaras'),
            CommunityCategory.sertanejos => (Colors.amber.shade900, 'Sertanejos & Vaqueiros'),
            CommunityCategory.quilombolas => (Colors.green.shade800, 'Quilombolas'),
            CommunityCategory.pastores => (Colors.brown.shade700, 'Pastores Transumantes'),
            CommunityCategory.mariscadores => (Colors.cyan.shade800, 'Mariscadoras & Pescadores'),
          };

          return Scaffold(
            appBar: AppBar(
              title: Text(community.title),
              centerTitle: false,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Card
                Card(
                  elevation: 0,
                  color: catColor.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: catColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              community.emoji,
                              style: const TextStyle(fontSize: 36),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: catColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      catLabel,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: catColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    community.region,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          community.shortSummary,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () {
                            if (state.isPlayingAudio) {
                              context.read<AncestralDetailCubit>().stopAudio();
                            } else {
                              context.read<AncestralDetailCubit>().playAudio();
                            }
                          },
                          icon: Icon(
                            state.isPlayingAudio
                                ? Icons.stop_rounded
                                : Icons.volume_up_rounded,
                          ),
                          label: Text(
                            state.isPlayingAudio
                                ? 'Parar narração'
                                : 'Ouvir narração tradicional',
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: catColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Full Description
                Text(
                  'História & Relação com a Terra',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
                    child: Text(
                      community.fullDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Lifestyle Highlights
                Text(
                  'Saberes Práticos & Modo de Vida',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
                      children: community.lifestyleHighlights
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.eco_rounded,
                                    size: 18,
                                    color: catColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Vocabulary Section
                Text(
                  'Vocabulário Tradicional (${community.vocabulary.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...community.vocabulary.map((vocab) {
                  final isAdded = state.addedVocabIds.contains(vocab.id);
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                vocab.termPt,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: catColor,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.volume_up_rounded, size: 20),
                                onPressed: () {
                                  final isPt = community.isPtPt;
                                  final dialectSetting = isPt
                                      ? PortugueseDialect.european
                                      : PortugueseDialect.brazilian;
                                  context
                                      .read<HybridAudioPlaybackService>()
                                      .playAudioOrSpeak(
                                        fallbackText: vocab.termPt,
                                        dialect: dialectSetting,
                                      );
                                },
                                tooltip: 'Ouvir pronúncia',
                              ),
                              IconButton(
                                icon: Icon(
                                  isAdded
                                      ? Icons.bookmark_added_rounded
                                      : Icons.bookmark_add_outlined,
                                  color: isAdded ? Colors.green : null,
                                  size: 20,
                                ),
                                onPressed: isAdded
                                    ? null
                                    : () {
                                        context
                                            .read<AncestralDetailCubit>()
                                            .addVocabToSrs(vocab);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '«${vocab.termPt}» adicionado ao SRS!',
                                            ),
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                tooltip: 'Adicionar ao SRS',
                              ),
                            ],
                          ),
                          Text(
                            vocab.translationRu,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vocab.definition,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.format_quote_rounded,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    vocab.exampleSentence,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
