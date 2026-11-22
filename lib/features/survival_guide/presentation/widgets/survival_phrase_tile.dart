import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/survival_phrase_entity.dart';

class SurvivalPhraseTile extends StatelessWidget {
  final SurvivalPhraseEntity phrase;

  const SurvivalPhraseTile({super.key, required this.phrase});

  void _playAudio(BuildContext context) {
    final audio = context.read<HybridAudioPlaybackService>();
    final dialect = phrase.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    audio.playAudioOrSpeak(
      fallbackText: phrase.textPt,
      dialect: dialect,
    );
  }

  void _copyPhrase(BuildContext context) {
    Clipboard.setData(ClipboardData(text: phrase.textPt));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Фраза скопирована в буфер обмена! 📋'),
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
        id: 'surv_${phrase.id}_${DateTime.now().millisecondsSinceEpoch}',
        portuguese: phrase.textPt,
        russianTranslation: phrase.translationRu,
        partOfSpeech: 'frase de sobrevivência',
        category: 'sobrevivência',
        dialect: phrase.dialect,
        examplePortuguese: phrase.textPt,
        exampleRussian: phrase.translationRu,
        notes: '${phrase.category.labelPt} • ${phrase.contextNoteRu}',
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
            content: Text('Фраза сохранена в карточки FSRS! 🗂️'),
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
    final categoryColor = Color(phrase.category.colorHex);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: phrase.isEmergency ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: phrase.isEmergency
              ? Colors.red.shade400
              : categoryColor.withValues(alpha: 0.25),
          width: phrase.isEmergency ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${phrase.category.emoji} ${phrase.category.labelPt}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                if (phrase.dialect != 'all')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      phrase.dialectFlag,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                if (phrase.isEmergency) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'SOS 🚨',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Прослушать произношение',
                  onPressed: () => _playAudio(context),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Скопировать',
                  onPressed: () => _copyPhrase(context),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_add_outlined, size: 19),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Сохранить в FSRS',
                  onPressed: () => _addToSrs(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              phrase.textPt,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              phrase.translationRu,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            if (phrase.contextNoteRu.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '💡 ${phrase.contextNoteRu}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
