import 'package:flutter/material.dart';

class DuelTimerBar extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;

  const DuelTimerBar({
    super.key,
    required this.remainingSeconds,
    this.totalSeconds = 15,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (remainingSeconds / totalSeconds).clamp(0.0, 1.0);
    final color = remainingSeconds > 7
        ? Colors.green
        : (remainingSeconds > 3 ? Colors.orange : Colors.red);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  '$remainingSeconds сек',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
