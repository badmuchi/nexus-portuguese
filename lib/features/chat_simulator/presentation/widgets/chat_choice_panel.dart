import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/chat_user_choice_entity.dart';

class ChatChoicePanel extends StatelessWidget {
  final List<ChatUserChoiceEntity> choices;
  final String? lastFeedbackNote;
  final bool isCompleted;
  final String? concludingNote;
  final int score;
  final int totalChoicesMade;
  final ValueChanged<ChatUserChoiceEntity> onSelectChoice;
  final VoidCallback onDismissFeedback;
  final VoidCallback onRestart;
  final VoidCallback onFinish;

  const ChatChoicePanel({
    super.key,
    required this.choices,
    required this.lastFeedbackNote,
    required this.isCompleted,
    required this.concludingNote,
    required this.score,
    required this.totalChoicesMade,
    required this.onSelectChoice,
    required this.onDismissFeedback,
    required this.onRestart,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (lastFeedbackNote != null && !isCompleted) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Text(
                      lastFeedbackNote!,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.25),
                    ),
                  ),
                  InkWell(
                    onTap: onDismissFeedback,
                    child: const Icon(Icons.close_rounded, size: 16),
                  ),
                ],
              ),
            ),
          ],
          if (isCompleted) ...[
            _CompletedSummary(
              concludingNote: concludingNote,
              score: score,
              totalChoicesMade: totalChoicesMade,
              onRestart: onRestart,
              onFinish: onFinish,
              theme: theme,
            ),
          ] else ...[
            Text(
              'Выбери свой ответ:',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            ...choices.map((choice) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onSelectChoice(choice);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                choice.textPt,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.send_rounded,
                              size: 18,
                              color: Colors.teal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          choice.translationRu,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _CompletedSummary extends StatelessWidget {
  final String? concludingNote;
  final int score;
  final int totalChoicesMade;
  final VoidCallback onRestart;
  final VoidCallback onFinish;
  final ThemeData theme;

  const _CompletedSummary({
    required this.concludingNote,
    required this.score,
    required this.totalChoicesMade,
    required this.onRestart,
    required this.onFinish,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final accuracyPercent = totalChoicesMade > 0
        ? ((score / totalChoicesMade) * 100).round()
        : 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('🎉 ', style: TextStyle(fontSize: 22)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Диалог успешно завершен!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Естественность ответов: $accuracyPercent% ($score/$totalChoicesMade)',
                    style: TextStyle(
                      fontSize: 12,
                      color: accuracyPercent >= 80 ? Colors.green.shade700 : Colors.amber.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (concludingNote != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              concludingNote!,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
            ),
          ),
        ],
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Сначала'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onFinish,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Готово'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
