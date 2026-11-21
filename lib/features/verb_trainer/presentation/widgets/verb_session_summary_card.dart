import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/verb_exercise.dart';
import '../../domain/entities/verb_trainer_session_result.dart';
import '../cubit/verb_trainer_cubit.dart';
import '../cubit/verb_trainer_state.dart';

class VerbSessionSummaryCard extends StatelessWidget {
  final VerbTrainerSessionResult result;
  final VoidCallback onRetry;
  final VoidCallback onReconfigure;

  const VerbSessionSummaryCard({
    super.key,
    required this.result,
    required this.onRetry,
    required this.onReconfigure,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerbTrainerCubit, VerbTrainerState>(
      builder: (context, state) {
        final isSavingToFsrs = state is VerbTrainerCompleted && state.isSavingToFsrs;
        final addedCount = state is VerbTrainerCompleted ? state.addedToFsrsCount : 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SummaryHeader(result: result),
              const SizedBox(height: 24),
              _MistakesFsrsList(
                mistakes: result.mistakes,
                isSavingToFsrs: isSavingToFsrs,
                addedCount: addedCount,
                onSaveToFsrs: () => context.read<VerbTrainerCubit>().saveMistakesToFsrs(),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReconfigure,
                      icon: const Icon(Icons.tune_rounded),
                      label: const Text('Настройки'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Ещё раз!'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final VerbTrainerSessionResult result;

  const _SummaryHeader({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHighScore = result.accuracyPercentage >= 80;
    final color = isHighScore ? Colors.amber.shade800 : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            theme.colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isHighScore ? Icons.emoji_events_rounded : Icons.check_circle_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            isHighScore ? 'Превосходная серия!' : 'Тренировка завершена!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Набрано: ${result.scorePoints} очков',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatBadge(
                label: 'Точность',
                value: '${result.accuracyPercentage.round()}%',
                icon: Icons.track_changes_rounded,
              ),
              _StatBadge(
                label: 'Правильно',
                value: '${result.correctCount} / ${result.totalAttempts}',
                icon: Icons.check_rounded,
              ),
              _StatBadge(
                label: 'Макс. стрик',
                value: '🔥 x${result.maxStreak}',
                icon: Icons.local_fire_department_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _MistakesFsrsList extends StatelessWidget {
  final List<VerbExercise> mistakes;
  final bool isSavingToFsrs;
  final int addedCount;
  final VoidCallback onSaveToFsrs;

  const _MistakesFsrsList({
    required this.mistakes,
    required this.isSavingToFsrs,
    required this.addedCount,
    required this.onSaveToFsrs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (mistakes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: const Row(
          children: [
            Icon(Icons.stars_rounded, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Блестяще! Вы правильно проспрягали все глаголы сессии.',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.style_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ошибок в спряжениях: ${mistakes.length}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Закрепите слабые формы в интервальных повторениях FSRS, чтобы довести спряжение до автоматизма.',
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: (isSavingToFsrs || addedCount > 0) ? null : onSaveToFsrs,
                icon: isSavingToFsrs
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(addedCount > 0 ? Icons.check_circle_rounded : Icons.add_card_rounded),
                label: Text(
                  addedCount > 0
                      ? 'Добавлено в FSRS ($addedCount)'
                      : 'Добавить ${mistakes.length} форм в FSRS',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Разбор сложных форм:',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...mistakes.map((m) => _MistakeVerbTile(exercise: m)),
      ],
    );
  }
}

class _MistakeVerbTile extends StatelessWidget {
  final VerbExercise exercise;

  const _MistakeVerbTile({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                exercise.infinitive.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(width: 8),
              Text(
                '(${exercise.russianMeaning})',
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  exercise.tense.labelPt,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${exercise.person.pronounDisplay}: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  exercise.correctForm,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            exercise.explanationRu,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
