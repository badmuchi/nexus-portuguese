import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/literary_work_entity.dart';

class LiteraryQuoteCard extends StatelessWidget {
  final LiteraryQuoteEntity quote;

  const LiteraryQuoteCard({
    super.key,
    required this.quote,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: '${quote.quotePt}\n— ${quote.authorName}'));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Цитата скопирована в буфер обмена! 📜'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _playAudio(BuildContext context) {
    final audio = context.read<HybridAudioPlaybackService>();
    final targetDialect = quote.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;
    audio.playAudioOrSpeak(
      fallbackText: quote.quotePt,
      dialect: targetDialect,
      rate: 0.88,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  quote.dialectFlag,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quote.authorName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '«${quote.workTitle}» (${quote.publicationYear})',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded),
                  tooltip: 'Озвучить цитату',
                  onPressed: () => _playAudio(context),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  tooltip: 'Копировать',
                  onPressed: () => _copyToClipboard(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.secondary,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '«${quote.quotePt}»',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'serif',
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quote.translationRu,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 16,
                  color: Colors.amber.shade800,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    quote.philosophicalInsightRu,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
