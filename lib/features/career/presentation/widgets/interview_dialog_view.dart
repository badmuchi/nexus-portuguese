import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/interview_question_entity.dart';

class InterviewDialogView extends StatelessWidget {
  final InterviewQuestionEntity question;
  final int questionNumber;
  final int totalQuestions;
  final int? selectedOptionIndex;
  final bool isAnswered;
  final ValueChanged<int> onSelectOption;
  final VoidCallback onNext;
  final VoidCallback onPlayQuestion;
  final Color categoryColor;

  const InterviewDialogView({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.selectedOptionIndex,
    required this.isAnswered,
    required this.onSelectOption,
    required this.onNext,
    required this.onPlayQuestion,
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
                  'Вопрос $questionNumber из $totalQuestions',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.person_pin_rounded, size: 16, color: categoryColor),
                  const SizedBox(width: 4),
                  Text(
                    question.interviewerRole,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
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
                        question.questionPt,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.35,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded),
                      color: categoryColor,
                      tooltip: 'Озвучить вопрос',
                      onPressed: onPlayQuestion,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  question.questionRu,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          if (question.hrInsightRu.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: categoryColor.withValues(alpha: 0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🎯 ', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: Text(
                      'Взгляд HR: ${question.hrInsightRu}',
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.25),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Ваш ответ на собеседовании:',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          ...question.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final opt = entry.value;
            final isSelected = selectedOptionIndex == idx;

            Color? bgColor;
            BorderSide border = BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
            );

            if (isAnswered) {
              if (isSelected) {
                if (opt.isStrong) {
                  bgColor = Colors.green.withValues(alpha: 0.15);
                  border = const BorderSide(color: Colors.green, width: 2);
                } else {
                  bgColor = Colors.amber.withValues(alpha: 0.15);
                  border = BorderSide(color: Colors.amber.shade800, width: 2);
                }
              } else if (opt.isStrong) {
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
                          if (isAnswered && isSelected) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              margin: const EdgeInsets.only(left: 6),
                              decoration: BoxDecoration(
                                color: opt.isStrong ? Colors.green : Colors.amber.shade800,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '+${opt.points} pts',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
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
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(opt.isStrong ? '✅ ' : '⚠️ '),
                              Expanded(
                                child: Text(
                                  opt.hrFeedbackRu,
                                  style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
                                ),
                              ),
                            ],
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
                questionNumber < totalQuestions ? 'Следующий вопрос' : 'Завершить интервью 🤝',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
