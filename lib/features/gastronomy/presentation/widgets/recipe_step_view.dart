import 'package:flutter/material.dart';
import '../../domain/entities/recipe_entity.dart';

class RecipeStepView extends StatelessWidget {
  final RecipeStepEntity step;
  final int stepNumber;
  final int totalSteps;
  final VoidCallback onPlayAudio;
  final bool isTimerRunning;
  final int remainingTimerSeconds;
  final bool isTimerFinished;
  final VoidCallback onStartTimer;
  final VoidCallback onPauseTimer;
  final VoidCallback onResetTimer;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;

  const RecipeStepView({
    super.key,
    required this.step,
    required this.stepNumber,
    required this.totalSteps,
    required this.onPlayAudio,
    required this.isTimerRunning,
    required this.remainingTimerSeconds,
    required this.isTimerFinished,
    required this.onStartTimer,
    required this.onPauseTimer,
    required this.onResetTimer,
    required this.onNext,
    this.onPrevious,
  });

  String _formatSeconds(int secs) {
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasTimer = step.timerSeconds != null && step.timerSeconds! > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Шаг $stepNumber из $totalSteps',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on_rounded, size: 14, color: Colors.deepOrange),
                    const SizedBox(width: 4),
                    Text(
                      '${step.actionVerbPt} (${step.actionVerbRu})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        step.instructionPt,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.35,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded),
                      tooltip: 'Озвучить шаг',
                      color: theme.colorScheme.primary,
                      onPressed: onPlayAudio,
                    ),
                  ],
                ),
                const Divider(height: 20),
                Text(
                  step.instructionRu,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (hasTimer) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isTimerFinished
                    ? Colors.green.withValues(alpha: 0.12)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isTimerFinished ? Colors.green : theme.colorScheme.outlineVariant,
                  width: isTimerFinished ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isTimerFinished ? Icons.alarm_on_rounded : Icons.timer_rounded,
                        color: isTimerFinished ? Colors.green : theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isTimerFinished
                            ? 'Готово! Время вышло 🔔'
                            : 'Кулинарный таймер',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isTimerFinished ? Colors.green : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _formatSeconds(remainingTimerSeconds),
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: isTimerFinished ? Colors.green : theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isTimerRunning && !isTimerFinished)
                        FilledButton.icon(
                          onPressed: onStartTimer,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Запустить таймер'),
                        )
                      else if (isTimerRunning)
                        FilledButton.icon(
                          onPressed: onPauseTimer,
                          style: FilledButton.styleFrom(backgroundColor: Colors.amber.shade800),
                          icon: const Icon(Icons.pause_rounded),
                          label: const Text('Пауза'),
                        )
                      else if (isTimerFinished)
                        FilledButton.icon(
                          onPressed: onResetTimer,
                          style: FilledButton.styleFrom(backgroundColor: Colors.green),
                          icon: const Icon(Icons.replay_rounded),
                          label: const Text('Сбросить'),
                        ),
                      const SizedBox(width: 8),
                      if (isTimerRunning || (!isTimerFinished && remainingTimerSeconds != step.timerSeconds))
                        OutlinedButton(
                          onPressed: onResetTimer,
                          child: const Text('Сброс'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              if (onPrevious != null) ...[
                OutlinedButton.icon(
                  onPressed: onPrevious,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Назад'),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: FilledButton.icon(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: Icon(
                    stepNumber < totalSteps ? Icons.arrow_forward_rounded : Icons.check_circle_rounded,
                  ),
                  label: Text(
                    stepNumber < totalSteps ? 'Следующий шаг' : 'Завершить рецепт 👨‍🍳',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
