import 'package:flutter/material.dart';

class ActivityHeatmapWidget extends StatelessWidget {
  final Map<DateTime, int> activityByDay;

  const ActivityHeatmapWidget({
    super.key,
    required this.activityByDay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 12 weeks = 84 days
    const totalDays = 84;
    final startDate = today.subtract(const Duration(days: totalDays - 1));

    // Group into 12 columns of 7 days
    final weeks = <List<DateTime>>[];
    var currentWeek = <DateTime>[];

    for (int i = 0; i < totalDays; i++) {
      final date = startDate.add(Duration(days: i));
      currentWeek.add(date);
      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
    }
    if (currentWeek.isNotEmpty) {
      weeks.add(currentWeek);
    }

    int totalActiveDays = 0;
    int totalEvents = 0;

    for (final count in activityByDay.values) {
      if (count > 0) {
        totalActiveDays++;
        totalEvents += count;
      }
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Активность (последние 12 недель)',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$totalEvents действий / $totalActiveDays дн.',
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: weeks.map((week) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 3.0),
                    child: Column(
                      children: week.map((date) {
                        final key = DateTime(date.year, date.month, date.day);
                        final count = activityByDay[key] ?? 0;
                        return Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.only(bottom: 3.0),
                          decoration: BoxDecoration(
                            color: _getCellColor(count, theme),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Меньше', style: theme.textTheme.labelSmall?.copyWith(fontSize: 10)),
                const SizedBox(width: 4),
                _legendBox(theme.colorScheme.surfaceContainerHighest),
                const SizedBox(width: 3),
                _legendBox(Colors.green.shade200),
                const SizedBox(width: 3),
                _legendBox(Colors.green.shade400),
                const SizedBox(width: 3),
                _legendBox(Colors.green.shade700),
                const SizedBox(width: 4),
                Text('Больше', style: theme.textTheme.labelSmall?.copyWith(fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendBox(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Color _getCellColor(int count, ThemeData theme) {
    if (count == 0) return theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6);
    if (count <= 2) return Colors.green.shade200;
    if (count <= 5) return Colors.green.shade400;
    return Colors.green.shade700;
  }
}
