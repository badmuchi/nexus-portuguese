import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/transcript_snippet_entity.dart';
import 'word_lookup_dialog.dart';

class TranscriptSnippetTile extends StatelessWidget {
  final TranscriptSnippet snippet;
  final bool isCurrent;
  final bool isCompleted;
  final bool showTranslation;
  final VoidCallback onPlaySnippet;
  final VoidCallback onOpenShadowing;
  final VoidCallback onOpenXRay;

  const TranscriptSnippetTile({
    super.key,
    required this.snippet,
    required this.isCurrent,
    required this.isCompleted,
    required this.showTranslation,
    required this.onPlaySnippet,
    required this.onOpenShadowing,
    required this.onOpenXRay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrent
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
            : theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: isCurrent ? 2.0 : 1.0,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SnippetHeader(
            formattedStartTime: snippet.formattedStartTime,
            speaker: snippet.speaker,
            isCurrent: isCurrent,
            isCompleted: isCompleted,
            theme: theme,
          ),
          const SizedBox(height: 8),
          _InteractiveTextPt(
            textPt: snippet.textPt,
            fullSentencePt: snippet.textPt,
            fullTranslationRu: snippet.translationRu,
            isCurrent: isCurrent,
            theme: theme,
          ),
          if (showTranslation && snippet.translationRu.isNotEmpty) ...[
            const SizedBox(height: 6),
            _SnippetTranslation(
              translationRu: snippet.translationRu,
              theme: theme,
            ),
          ],
          if (snippet.culturalNote != null && snippet.culturalNote!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _CulturalNoteBadge(
              note: snippet.culturalNote!,
              theme: theme,
            ),
          ],
          const SizedBox(height: 10),
          _SnippetActionsBar(
            isCurrent: isCurrent,
            onPlaySnippet: onPlaySnippet,
            onOpenShadowing: onOpenShadowing,
            onOpenXRay: onOpenXRay,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _SnippetHeader extends StatelessWidget {
  final String formattedStartTime;
  final String? speaker;
  final bool isCurrent;
  final bool isCompleted;
  final ThemeData theme;

  const _SnippetHeader({
    required this.formattedStartTime,
    required this.speaker,
    required this.isCurrent,
    required this.isCompleted,
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
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isCurrent
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                formattedStartTime,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isCurrent
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.outline,
                ),
              ),
            ),
            if (speaker != null) ...[
              const SizedBox(width: 8),
              Text(
                speaker!,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
        if (isCompleted)
          Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: Colors.green.shade600,
          ),
      ],
    );
  }
}

class _InteractiveTextPt extends StatelessWidget {
  final String textPt;
  final String fullSentencePt;
  final String fullTranslationRu;
  final bool isCurrent;
  final ThemeData theme;

  const _InteractiveTextPt({
    required this.textPt,
    required this.fullSentencePt,
    required this.fullTranslationRu,
    required this.isCurrent,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // Разбиваем строку на токены с сохранением пробелов
    final tokens = textPt.split(' ');

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tokens.map((token) {
        return InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            HapticFeedback.selectionClick();
            WordLookupDialog.show(
              context,
              word: token,
              fullSentencePt: fullSentencePt,
              fullTranslationRu: fullTranslationRu,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            child: Text(
              token,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                color: isCurrent
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dotted,
                decorationColor: theme.colorScheme.outlineVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SnippetTranslation extends StatelessWidget {
  final String translationRu;
  final ThemeData theme;

  const _SnippetTranslation({
    required this.translationRu,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      translationRu,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.outline,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

class _CulturalNoteBadge extends StatelessWidget {
  final String note;
  final ThemeData theme;

  const _CulturalNoteBadge({
    required this.note,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded,
              size: 16, color: theme.colorScheme.secondary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              note,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SnippetActionsBar extends StatelessWidget {
  final bool isCurrent;
  final VoidCallback onPlaySnippet;
  final VoidCallback onOpenShadowing;
  final VoidCallback onOpenXRay;
  final ThemeData theme;

  const _SnippetActionsBar({
    required this.isCurrent,
    required this.onPlaySnippet,
    required this.onOpenShadowing,
    required this.onOpenXRay,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton.filledTonal(
          icon: Icon(
            isCurrent ? Icons.replay_rounded : Icons.play_arrow_rounded,
            size: 18,
          ),
          tooltip: 'Слушать фразу',
          visualDensity: VisualDensity.compact,
          onPressed: onPlaySnippet,
        ),
        const SizedBox(width: 6),
        IconButton.filledTonal(
          icon: const Icon(Icons.biotech_rounded, size: 18),
          tooltip: 'Морфологический X-Ray',
          visualDensity: VisualDensity.compact,
          onPressed: onOpenXRay,
        ),
        const SizedBox(width: 6),
        FilledButton.tonalIcon(
          onPressed: onOpenShadowing,
          style: FilledButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          icon: const Icon(Icons.mic_rounded, size: 16),
          label: const Text('Shadowing', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
