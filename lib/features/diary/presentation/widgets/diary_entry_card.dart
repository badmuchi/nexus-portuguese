import 'package:flutter/material.dart';
import '../../domain/entities/diary_entry_entity.dart';

class DiaryEntryCard extends StatelessWidget {
  final DiaryEntryEntity entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const DiaryEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EntryHeader(
                formattedDate: entry.formattedDate,
                dialectFlag: entry.dialectFlag,
                dialectLabel: entry.dialectLabel,
                estimatedLevel: entry.estimatedLevel,
                onDelete: onDelete,
                theme: theme,
              ),
              if (entry.promptQuestionPt != null) ...[
                const SizedBox(height: 8),
                _PromptBadge(
                  questionPt: entry.promptQuestionPt!,
                  questionRu: entry.promptQuestionRu,
                  theme: theme,
                ),
              ],
              const SizedBox(height: 10),
              Text(
                entry.contentPt,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _EntryFooter(
                wordCount: entry.wordCount,
                mistakesCount: entry.mistakes.length,
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryHeader extends StatelessWidget {
  final String formattedDate;
  final String dialectFlag;
  final String dialectLabel;
  final String estimatedLevel;
  final VoidCallback onDelete;
  final ThemeData theme;

  const _EntryHeader({
    required this.formattedDate,
    required this.dialectFlag,
    required this.dialectLabel,
    required this.estimatedLevel,
    required this.onDelete,
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(dialectFlag, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    dialectLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
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
                'CEFR $estimatedLevel',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              formattedDate,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              visualDensity: VisualDensity.compact,
              color: theme.colorScheme.outline,
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }
}

class _PromptBadge extends StatelessWidget {
  final String questionPt;
  final String? questionRu;
  final ThemeData theme;

  const _PromptBadge({
    required this.questionPt,
    required this.questionRu,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 16, color: theme.colorScheme.secondary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionPt,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                if (questionRu != null)
                  Text(
                    questionRu!,
                    style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryFooter extends StatelessWidget {
  final int wordCount;
  final int mistakesCount;
  final ThemeData theme;

  const _EntryFooter({
    required this.wordCount,
    required this.mistakesCount,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.notes_rounded, size: 14, color: theme.colorScheme.outline),
            const SizedBox(width: 4),
            Text(
              '$wordCount слов',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: mistakesCount == 0
                ? Colors.green.withValues(alpha: 0.15)
                : Colors.orange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                mistakesCount == 0 ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                size: 14,
                color: mistakesCount == 0 ? Colors.green.shade700 : Colors.orange.shade800,
              ),
              const SizedBox(width: 4),
              Text(
                mistakesCount == 0 ? 'Без ошибок ✨' : '$mistakesCount подсказок',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: mistakesCount == 0 ? Colors.green.shade800 : Colors.orange.shade900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
