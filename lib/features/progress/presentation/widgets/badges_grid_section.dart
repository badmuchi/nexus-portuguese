import 'package:flutter/material.dart';
import '../../domain/entities/portuguese_badge.dart';

class BadgesGridSection extends StatelessWidget {
  final List<PortugueseBadge> badges;

  const BadgesGridSection({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlockedCount = badges.where((b) => b.isUnlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Достижения Португалии',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$unlockedCount из ${badges.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: badges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            return _BadgeTile(badge: badges[index]);
          },
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final PortugueseBadge badge;

  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color borderColor = badge.isUnlocked
        ? Colors.amber.shade700
        : theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
    Color bgColor = badge.isUnlocked
        ? Colors.amber.withValues(alpha: 0.08)
        : theme.colorScheme.surface;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: badge.isUnlocked ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(badge.iconEmoji, style: const TextStyle(fontSize: 26)),
              if (badge.isUnlocked)
                const Icon(Icons.check_circle_rounded, color: Colors.amber, size: 20)
              else
                Icon(Icons.lock_outline_rounded,
                    color: theme.colorScheme.outline.withValues(alpha: 0.6), size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            badge.titleRu,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            badge.titlePt,
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.outline,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            badge.descriptionRu,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, height: 1.2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: badge.progress,
              minHeight: 5,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                badge.isUnlocked ? Colors.amber.shade700 : theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
