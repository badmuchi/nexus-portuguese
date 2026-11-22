import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/morphology/presentation/widgets/sentence_xray_sheet.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/portuguese_idiom_entity.dart';

class IdiomDetailSheet extends StatelessWidget {
  final PortugueseIdiom idiom;

  const IdiomDetailSheet({
    super.key,
    required this.idiom,
  });

  static void show(BuildContext context, {required PortugueseIdiom idiom}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IdiomDetailSheet(idiom: idiom),
    );
  }

  Future<void> _addToSrs(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final srsRepo = context.read<SrsRepository>();

    final card = SrsCardEntity(
      id: 'idiom_srs_${idiom.id}_${DateTime.now().millisecondsSinceEpoch}',
      portuguese: idiom.expressionPt,
      russianTranslation: idiom.meaningRu,
      partOfSpeech: 'expressao',
      category: 'idiomas',
      dialect: idiom.dialect,
      examplePortuguese: idiom.examplePt,
      exampleRussian: idiom.exampleRu,
      notes: 'Дословно: ${idiom.literalTranslationRu}. ${idiom.originStoryRu}',
      fsrsState: 'newCard',
      stability: 0.0,
      difficulty: 0.0,
      reps: 0,
      lapses: 0,
      dueAt: DateTime.now(),
    );

    await srsRepo.addCard(card);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Идиома «${idiom.expressionPt}» добавлена в FSRS!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audio = context.read<HybridAudioPlaybackService>();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DragHandle(theme: theme),
            _SheetHeader(
              idiom: idiom,
              onPlayAudio: () {
                final dialect = idiom.isPtPt
                    ? PortugueseDialect.european
                    : PortugueseDialect.brazilian;
                audio.playAudioOrSpeak(
                  fallbackText: idiom.expressionPt,
                  dialect: dialect,
                );
              },
              theme: theme,
            ),
            const SizedBox(height: 14),
            _MeaningCard(
              literalRu: idiom.literalTranslationRu,
              meaningRu: idiom.meaningRu,
              meaningPt: idiom.meaningPt,
              theme: theme,
            ),
            const SizedBox(height: 14),
            _OriginStoryCard(
              story: idiom.originStoryRu,
              theme: theme,
            ),
            const SizedBox(height: 14),
            _ExampleSentenceCard(
              examplePt: idiom.examplePt,
              exampleRu: idiom.exampleRu,
              onPlayAudio: () {
                final dialect = idiom.isPtPt
                    ? PortugueseDialect.european
                    : PortugueseDialect.brazilian;
                audio.playAudioOrSpeak(
                  fallbackText: idiom.examplePt,
                  dialect: dialect,
                );
              },
              onOpenXRay: () {
                SentenceXRaySheet.show(
                  context,
                  sentencePortuguese: idiom.examplePt,
                  translationRussian: idiom.exampleRu,
                );
              },
              theme: theme,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => _addToSrs(context),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.bookmark_add_rounded),
              label: const Text('Добавить идиому в FSRS-карточки'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  final ThemeData theme;
  const _DragHandle({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final PortugueseIdiom idiom;
  final VoidCallback onPlayAudio;
  final ThemeData theme;

  const _SheetHeader({
    required this.idiom,
    required this.onPlayAudio,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(idiom.illustrationEmoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      idiom.expressionPt,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, size: 20),
                      onPressed: onPlayAudio,
                    ),
                  ],
                ),
                Text(
                  '${idiom.dialectFlag} ${idiom.dialectLabel} • ${idiom.category.emoji} ${idiom.category.labelRu}',
                  style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MeaningCard extends StatelessWidget {
  final String literalRu;
  final String meaningRu;
  final String meaningPt;
  final ThemeData theme;

  const _MeaningCard({
    required this.literalRu,
    required this.meaningRu,
    required this.meaningPt,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.translate_rounded, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'Дословно: «$literalRu»',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meaningRu,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            meaningPt,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _OriginStoryCard extends StatelessWidget {
  final String story;
  final ThemeData theme;

  const _OriginStoryCard({
    required this.story,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories_rounded, size: 16, color: Colors.amber.shade900),
              const SizedBox(width: 6),
              Text(
                'История происхождения',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            story,
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.35,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleSentenceCard extends StatelessWidget {
  final String examplePt;
  final String exampleRu;
  final VoidCallback onPlayAudio;
  final VoidCallback onOpenXRay;
  final ThemeData theme;

  const _ExampleSentenceCard({
    required this.examplePt,
    required this.exampleRu,
    required this.onPlayAudio,
    required this.onOpenXRay,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Пример в речи:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Row(
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.volume_up_rounded, size: 16),
                    visualDensity: VisualDensity.compact,
                    onPressed: onPlayAudio,
                  ),
                  const SizedBox(width: 4),
                  FilledButton.tonal(
                    onPressed: onOpenXRay,
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Text('X-Ray', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            examplePt,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            exampleRu,
            style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
