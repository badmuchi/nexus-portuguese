import 'package:flutter/material.dart';
import 'package:nexus_portuguese_app/features/assessment/presentation/screens/level_assessment_screen.dart';

class FluencyScoreCard extends StatelessWidget {
  final double fluencyScore;
  final String? cefrLevel;
  final double cefrScorePercentage;
  final double phoneticMasteryAvg;
  final int scenesCompletedCount;
  final int grammarLogsCount;

  const FluencyScoreCard({
    super.key,
    required this.fluencyScore,
    required this.cefrLevel,
    required this.cefrScorePercentage,
    required this.phoneticMasteryAvg,
    required this.scenesCompletedCount,
    required this.grammarLogsCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreClamped = (fluencyScore / 100.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Индекс беглости (Fluência)',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LevelAssessmentScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    cefrLevel != null ? 'CEFR: $cefrLevel' : 'Тест CEFR ➔',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: scoreClamped,
                      strokeWidth: 7,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                    Center(
                      child: Text(
                        '${fluencyScore.round()}%',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cefrLevel != null
                          ? 'Подтверждён уровень $cefrLevel'
                          : 'Пройдите диагностику CEFR',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Комплексный индекс владения речью, слухом, грамматикой и словарным запасом.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _FluencySubMetric(
                label: 'Фонетика',
                value: '${phoneticMasteryAvg.round()}%',
                icon: Icons.graphic_eq_rounded,
                color: Colors.deepOrange,
              ),
              _FluencySubMetric(
                label: 'Сцены жизни',
                value: '$scenesCompletedCount / 6',
                icon: Icons.theater_comedy_rounded,
                color: Colors.teal,
              ),
              _FluencySubMetric(
                label: 'Спряжения',
                value: '$grammarLogsCount форм',
                icon: Icons.bolt_rounded,
                color: Colors.amber.shade800,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FluencySubMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _FluencySubMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.outline),
        ),
      ],
    );
  }
}
