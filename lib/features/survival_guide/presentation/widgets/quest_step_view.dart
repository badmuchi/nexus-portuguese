import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/survival_step_entity.dart';

class QuestStepView extends StatelessWidget {
  final SurvivalStepEntity step;
  final int stepNumber;
  final int totalSteps;
  final int? selectedOptionIndex;
  final bool isAnswered;
  final ValueChanged<int> onSelectOption;
  final VoidCallback onNext;
  final VoidCallback onPlayPrompt;
  final Color categoryColor;

  const QuestStepView({
    super.key,
    required this.step,
    required this.stepNumber,
    required this.totalSteps,
    required this.selectedOptionIndex,
    required this.isAnswered,
    required this.onSelectOption,
    required this.onNext,
    required this.onPlayPrompt,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  color: categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Шаг $stepNumber из $totalSteps',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                step.speakerRole,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        step.promptPt,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.35,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded),
                      color: categoryColor,
                      tooltip: 'Озвучить реплику',
                      onPressed: onPlayPrompt,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  step.promptRu,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          if (step.culturalNoteRu != null && step.culturalNoteRu!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: Text(
                      step.culturalNoteRu!,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.25),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Как вы поступите или ответите?',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          ...step.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final opt = entry.value;
            final isSelected = selectedOptionIndex == idx;

            Color? bgColor;
            BorderSide border = BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
            );

            if (isAnswered) {
              if (isSelected) {
                if (opt.isOptimal) {
                  bgColor = Colors.green.withValues(alpha: 0.15);
                  border = const BorderSide(color: Colors.green, width: 2);
                } else {
                  bgColor = Colors.amber.withValues(alpha: 0.15);
                  border = BorderSide(color: Colors.amber.shade800, width: 2);
                }
              } else if (opt.isOptimal) {
                bgColor = Colors.green.withValues(alpha: 0.08);
                border = const BorderSide(color: Colors.green, width: 1.5);
              }
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: border,
              ),
              color: bgColor ?? theme.colorScheme.surface,
              elevation: isSelected ? 3 : 1,
              child: InkWell(
                onTap: isAnswered
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        onSelectOption(idx);
                      },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              opt.textPt,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (isAnswered && isSelected)
                            Icon(
                              opt.isOptimal
                                  ? Icons.check_circle_rounded
                                  : Icons.warning_amber_rounded,
                              color: opt.isOptimal ? Colors.green : Colors.amber.shade900,
                              size: 22,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        opt.translationRu,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (isAnswered && isSelected) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            opt.feedbackRu,
                            style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
          if (isAnswered) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                backgroundColor: categoryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(
                stepNumber < totalSteps ? 'Следующий шаг' : 'Завершить квест 🏆',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
