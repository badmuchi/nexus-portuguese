import 'package:flutter/material.dart';
import '../../domain/entities/song_lyric_line_entity.dart';

class KaraokeLyricTile extends StatelessWidget {
  final SongLyricLine line;
  final bool isActive;
  final bool isCompleted;
  final bool showTranslation;
  final Color primaryColor;
  final Color accentColor;
  final VoidCallback onPlay;
  final VoidCallback onAddToSrs;

  const KaraokeLyricTile({
    super.key,
    required this.line,
    required this.isActive,
    required this.isCompleted,
    required this.showTranslation,
    required this.primaryColor,
    required this.accentColor,
    required this.onPlay,
    required this.onAddToSrs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isActive ? 14 : 10,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? primaryColor.withValues(alpha: 0.16)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? primaryColor
              : isCompleted
                  ? theme.colorScheme.outlineVariant.withValues(alpha: 0.4)
                  : Colors.transparent,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? primaryColor
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  line.formattedTime,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isActive ? Colors.white : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (isCompleted)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: Colors.green,
                ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  isActive ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
                  size: 20,
                  color: isActive ? primaryColor : theme.colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Прослушать строку',
                onPressed: onPlay,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(
                  Icons.bookmark_add_outlined,
                  size: 18,
                ),
                tooltip: 'Сохранить строку в карточки FSRS',
                onPressed: onAddToSrs,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            line.textPt,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              fontSize: isActive ? 18 : 15,
              color: isActive
                  ? (theme.brightness == Brightness.dark ? Colors.white : primaryColor)
                  : theme.colorScheme.onSurface,
              height: 1.3,
            ),
          ),
          if (showTranslation) ...[
            const SizedBox(height: 4),
            Text(
              line.translationRu,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (line.poeticNoteRu != null && line.poeticNoteRu!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _PoeticNoteBadge(note: line.poeticNoteRu!, accentColor: accentColor),
          ],
        ],
      ),
    );
  }
}

class _PoeticNoteBadge extends StatelessWidget {
  final String note;
  final Color accentColor;

  const _PoeticNoteBadge({
    required this.note,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡 ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(
              note,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: 12,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
