import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/radio_novela_entities.dart';

class DramaLineBubble extends StatelessWidget {
  final DramaLineEntity line;
  final DramaCharacterEntity? character;
  final bool isCurrent;
  final bool showTranslation;
  final bool showStageDirection;
  final VoidCallback onPlayAudio;
  final VoidCallback onAddToFsrs;

  const DramaLineBubble({
    super.key,
    required this.line,
    this.character,
    required this.isCurrent,
    this.showTranslation = true,
    this.showStageDirection = true,
    required this.onPlayAudio,
    required this.onAddToFsrs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final voiceEmoji = character?.voiceEmoji ?? '🎙️';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isCurrent
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
            : theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Character header & buttons
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  child: Text(voiceEmoji, style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line.characterName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isCurrent
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (character != null && character!.roleRu.isNotEmpty)
                        Text(
                          character!.roleRu,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                  tooltip: 'Озвучить реплику',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onPlayAudio();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                  tooltip: 'Добавить в FSRS',
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    onAddToFsrs();
                  },
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Stage Direction
            if (showStageDirection && line.stageDirectionRu.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '🎬 (${line.stageDirectionRu})',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            ],

            // Portuguese text
            SelectableText(
              line.textPt,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                height: 1.45,
              ),
            ),

            // Russian Translation
            if (showTranslation && line.translationRu.isNotEmpty) ...[
              const SizedBox(height: 8),
              SelectableText(
                line.translationRu,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                  height: 1.35,
                ),
              ),
            ],

            // Slang / Idiom note
            if (line.slangOrIdiomNoteRu.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 14,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      line.slangOrIdiomNoteRu,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w500,
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
