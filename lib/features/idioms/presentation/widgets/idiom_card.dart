import 'package:flutter/material.dart';
import '../../domain/entities/portuguese_idiom_entity.dart';

class IdiomCard extends StatelessWidget {
  final PortugueseIdiom idiom;
  final VoidCallback onTap;
  final VoidCallback onPlayAudio;

  const IdiomCard({
    super.key,
    required this.idiom,
    required this.onTap,
    required this.onPlayAudio,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EmojiBadge(
                emoji: idiom.illustrationEmoji,
                theme: theme,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _IdiomContent(
                  idiom: idiom,
                  theme: theme,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, size: 20),
                visualDensity: VisualDensity.compact,
                color: theme.colorScheme.primary,
                onPressed: onPlayAudio,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmojiBadge extends StatelessWidget {
  final String emoji;
  final ThemeData theme;

  const _EmojiBadge({
    required this.emoji,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }
}

class _IdiomContent extends StatelessWidget {
  final PortugueseIdiom idiom;
  final ThemeData theme;

  const _IdiomContent({
    required this.idiom,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${idiom.dialectFlag} ${idiom.dialectLabel}',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${idiom.category.emoji} ${idiom.category.labelRu}',
              style: TextStyle(fontSize: 10, color: theme.colorScheme.outline),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          idiom.expressionPt,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Дословно: «${idiom.literalTranslationRu}»',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          idiom.meaningRu,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
