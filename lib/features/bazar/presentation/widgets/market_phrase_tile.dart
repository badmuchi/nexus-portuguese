import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/bazar_entities.dart';

class MarketPhraseTile extends StatefulWidget {
  final MarketPhraseEntity phrase;

  const MarketPhraseTile({
    super.key,
    required this.phrase,
  });

  @override
  State<MarketPhraseTile> createState() => _MarketPhraseTileState();
}

class _MarketPhraseTileState extends State<MarketPhraseTile> {
  bool _isAddedToSrs = false;

  void _playAudio() {
    HapticFeedback.lightImpact();
    final targetDialect = widget.phrase.isPtPt
        ? PortugueseDialect.european
        : widget.phrase.isPtBr
            ? PortugueseDialect.brazilian
            : null;

    context.read<HybridAudioPlaybackService>().playAudioOrSpeak(
          fallbackText: widget.phrase.phrasePt,
          dialect: targetDialect,
        );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.phrase.phrasePt));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Фраза скопирована в буфер обмена! 🛒'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addToSrs() async {
    HapticFeedback.mediumImpact();
    try {
      final srsRepo = context.read<SrsRepository>();
      final card = SrsCardEntity(
        id: 'bazar_${widget.phrase.id}_${DateTime.now().millisecondsSinceEpoch}',
        portuguese: widget.phrase.phrasePt,
        russianTranslation: widget.phrase.translationRu,
        partOfSpeech: 'expressão de feira',
        category: 'bazar',
        dialect: widget.phrase.dialect,
        examplePortuguese: widget.phrase.phrasePt,
        exampleRussian: widget.phrase.translationRu,
        notes: widget.phrase.contextTipRu,
        fsrsState: 'newCard',
        stability: 0.0,
        difficulty: 0.0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      );

      await srsRepo.addCard(card);
      if (mounted) {
        setState(() => _isAddedToSrs = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Фраза «${widget.phrase.phrasePt}» добавлена в FSRS! 🗂️',
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phrase = widget.phrase;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(phrase.dialectFlag, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    phrase.phrasePt,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                  tooltip: 'Слушать',
                  onPressed: _playAudio,
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  tooltip: 'Копировать',
                  onPressed: _copyToClipboard,
                ),
                IconButton(
                  icon: Icon(
                    _isAddedToSrs ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined,
                    size: 20,
                    color: _isAddedToSrs ? Colors.green : null,
                  ),
                  tooltip: _isAddedToSrs ? 'В колоде FSRS' : 'Добавить в FSRS',
                  onPressed: _isAddedToSrs ? null : _addToSrs,
                ),
              ],
            ),
            const SizedBox(height: 4),
            SelectableText(
              phrase.translationRu,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (phrase.contextTipRu.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      phrase.contextTipRu,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
