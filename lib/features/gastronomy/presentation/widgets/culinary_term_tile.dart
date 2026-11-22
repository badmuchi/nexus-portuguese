import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/culinary_vocabulary_entity.dart';

class CulinaryTermTile extends StatelessWidget {
  final CulinaryTermEntity term;

  const CulinaryTermTile({super.key, required this.term});

  void _playAudio(BuildContext context) {
    final audio = context.read<HybridAudioPlaybackService>();
    final dialect = term.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    audio.playAudioOrSpeak(
      fallbackText: term.termPt,
      dialect: dialect,
    );
  }

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: term.termPt));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Термин скопирован в буфер обмена! 🍳'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addToSrs(BuildContext context) async {
    HapticFeedback.mediumImpact();
    try {
      final srsRepo = context.read<SrsRepository>();
      final card = SrsCardEntity(
        id: 'gastro_${term.id}_${DateTime.now().millisecondsSinceEpoch}',
        portuguese: term.termPt,
        russianTranslation: term.translationRu,
        partOfSpeech: term.type.labelPt,
        category: 'culinaria',
        dialect: term.dialect,
        examplePortuguese: term.usageExamplePt,
        exampleRussian: term.usageExampleRu,
        notes: term.culturalNoteRu != null
            ? '${term.type.labelRu} • ${term.culturalNoteRu}'
            : term.type.labelRu,
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
          const SnackBar(
            content: Text('Кулинарный термин добавлен в FSRS! 🥑'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${term.type.emoji} ${term.type.labelRu}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    term.dialectFlag,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                  tooltip: 'Озвучить',
                  onPressed: () => _playAudio(context),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  tooltip: 'Копировать',
                  onPressed: () => _copy(context),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                  tooltip: 'В карточки FSRS',
                  onPressed: () => _addToSrs(context),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              term.termPt,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              term.translationRu,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (term.culturalNoteRu != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡 ', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Text(
                        term.culturalNoteRu!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    term.usageExamplePt,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    term.usageExampleRu,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
