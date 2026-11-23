import 'package:flutter/material.dart';
import '../../domain/entities/nature_entities.dart';

class TrailCard extends StatelessWidget {
  final NatureTrailEntity trail;
  final bool isCompleted;
  final VoidCallback onComplete;

  const TrailCard({
    super.key,
    required this.trail,
    required this.isCompleted,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (difficultyBg, difficultyText) = switch (trail.difficultyRu) {
      'Легкий' => (Colors.green.withValues(alpha: 0.15), Colors.green.shade800),
      'Средний' => (Colors.orange.withValues(alpha: 0.15), Colors.orange.shade800),
      'Сложный' => (Colors.red.withValues(alpha: 0.15), Colors.red.shade800),
      _ => (colorScheme.primaryContainer.withValues(alpha: 0.3), colorScheme.primary),
    };

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCompleted
              ? Colors.green.shade400
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: isCompleted ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              trail.namePt,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: difficultyBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              trail.difficultyRu,
                              style: TextStyle(
                                color: difficultyText,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        trail.nameRu,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Trail Metrics Chips
            Row(
              children: [
                _buildMetricChip(
                  context,
                  icon: Icons.straighten_rounded,
                  label: '${trail.distanceKm} км',
                ),
                const SizedBox(width: 8),
                _buildMetricChip(
                  context,
                  icon: Icons.timer_outlined,
                  label: '${trail.durationHours} ч',
                ),
                const SizedBox(width: 8),
                _buildMetricChip(
                  context,
                  icon: Icons.trending_up_rounded,
                  label: '+${trail.elevationGainMeters} м',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              trail.descriptionRu,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // Safety Tips Box
            if (trail.safetyTipsRu.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.security_rounded,
                          size: 15,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Безопасность на маршруте:',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ...trail.safetyTipsRu.map(
                      (tip) => Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '• $tip',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Action / Completion button
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: isCompleted ? null : onComplete,
                icon: Icon(
                  isCompleted ? Icons.check_circle_rounded : Icons.flag_rounded,
                  size: 18,
                ),
                label: Text(
                  isCompleted ? 'Маршрут пройден! 🥾' : 'Отметить прохождение',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
