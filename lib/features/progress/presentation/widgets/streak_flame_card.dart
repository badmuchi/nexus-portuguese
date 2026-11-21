import 'package:flutter/material.dart';

class StreakFlameCard extends StatelessWidget {
  final int currentStreak;
  final int maxStreak;
  final Map<DateTime, int> activityByDay;

  const StreakFlameCard({
    super.key,
    required this.currentStreak,
    required this.maxStreak,
    required this.activityByDay,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Find current Monday to Sunday
    final currentMonday = DateTime(now.year, now.month, now.day).subtract(
      Duration(days: now.weekday - 1),
    );

    const weekdaysRu = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange.shade600,
            Colors.amber.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withValues(alpha: 0.2),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: Colors.amber, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Стрик: $currentStreak ${_pluralizeDays(currentStreak)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Рекорд: $maxStreak дн.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '10 минут в день дают в 5 раз лучший результат, чем штурм раз в неделю.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
          ),
          const SizedBox(height: 16),
          // 7 weekday dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final dayDate = currentMonday.add(Duration(days: index));
              final isToday = dayDate.year == now.year &&
                  dayDate.month == now.month &&
                  dayDate.day == now.day;
              final isFuture = dayDate.isAfter(DateTime(now.year, now.month, now.day));
              final hasActivity = activityByDay.containsKey(dayDate) &&
                  (activityByDay[dayDate] ?? 0) > 0;

              return Column(
                children: [
                  Text(
                    weekdaysRu[index],
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: isToday ? 1.0 : 0.7),
                      fontSize: 11,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: hasActivity
                          ? Colors.white
                          : (isFuture
                              ? Colors.white.withValues(alpha: 0.15)
                              : Colors.black.withValues(alpha: 0.2)),
                      shape: BoxShape.circle,
                      border: isToday
                          ? Border.all(color: Colors.amberAccent, width: 2.5)
                          : null,
                    ),
                    child: Center(
                      child: hasActivity
                          ? const Icon(Icons.local_fire_department_rounded,
                              color: Colors.deepOrange, size: 18)
                          : (isFuture
                              ? null
                              : Icon(Icons.close_rounded,
                                  color: Colors.white.withValues(alpha: 0.3), size: 14)),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  String _pluralizeDays(int days) {
    if (days % 10 == 1 && days % 100 != 11) return 'день';
    if (days % 10 >= 2 && days % 10 <= 4 && (days % 100 < 10 || days % 100 >= 20)) {
      return 'дня';
    }
    return 'дней';
  }
}
