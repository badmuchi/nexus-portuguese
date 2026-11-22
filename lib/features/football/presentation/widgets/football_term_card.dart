import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/football_entities.dart';

class FootballTermCard extends StatefulWidget {
  final FootballTermEntity term;

  const FootballTermCard({
    super.key,
    required this.term,
  });

  @override
  State<FootballTermCard> createState() => _FootballTermCardState();
}

class _FootballTermCardState extends State<FootballTermCard> {
  bool _isAddedToSrs = false;

  void _playAudio(String text, PortugueseDialect dialect) {
    HapticFeedback.lightImpact();
    context.read<HybridAudioPlaybackService>().playAudioOrSpeak(
          fallbackText: text,
          dialect: dialect,
        );
  }

  Future<void> _addToSrs() async {
    HapticFeedback.mediumImpact();
    try {
      final srsRepo = context.read<SrsRepository>();
      final card = SrsCardEntity(
        id: 'foot_${widget.term.id}_${DateTime.now().millisecondsSinceEpoch}',
        portuguese: '${widget.term.termPtBr} (BR) / ${widget.term.termPtPt} (PT)',
        russianTranslation: widget.term.translationRu,
        partOfSpeech: widget.term.category.labelPt,
        category: 'futebol',
        dialect: 'both',
        examplePortuguese: 'BR: ${widget.term.examplePtBr}\nPT: ${widget.term.examplePtPt}',
        exampleRussian: widget.term.translationRu,
        notes: widget.term.explanationRu,
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
              'Термин «${widget.term.termPtBr} / ${widget.term.termPtPt}» добавлен в FSRS! ⚽',
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
    final term = widget.term;

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
                Text(term.category.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    term.translationRu,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isAddedToSrs ? null : _addToSrs,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    backgroundColor: _isAddedToSrs
                        ? Colors.green.shade50
                        : theme.colorScheme.primaryContainer,
                    foregroundColor: _isAddedToSrs
                        ? Colors.green.shade800
                        : theme.colorScheme.onPrimaryContainer,
                    elevation: 0,
                  ),
                  icon: Icon(
                    _isAddedToSrs ? Icons.check_circle_rounded : Icons.add_rounded,
                    size: 16,
                  ),
                  label: Text(
                    _isAddedToSrs ? 'В FSRS' : '+ FSRS',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Two-column comparison banner
            Row(
              children: [
                // Portugal column
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '🇵🇹 Portugal',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () => _playAudio(term.termPtPt, PortugueseDialect.european),
                              child: const Icon(Icons.volume_up_rounded, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          term.termPtPt,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '«${term.examplePtPt}»',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Brazil column
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '🇧🇷 Brasil',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () => _playAudio(term.termPtBr, PortugueseDialect.brazilian),
                              child: const Icon(Icons.volume_up_rounded, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          term.termPtBr,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '«${term.examplePtBr}»',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.sports_soccer_rounded,
                  size: 15,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    term.explanationRu,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
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
