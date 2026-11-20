import 'package:flutter/material.dart';
import '../../../../core/speech/pronunciation_accuracy_evaluator.dart';

class PronunciationResultCard extends StatelessWidget {
  final PronunciationResult result;
  final VoidCallback onRetry;
  final VoidCallback? onAddToSrs;

  const PronunciationResultCard({
    super.key,
    required this.result,
    required this.onRetry,
    this.onAddToSrs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scorePercent = (result.score * 100).round();
    final isPass = result.isPass;

    final statusColor = isPass ? Colors.green.shade700 : Colors.orange.shade800;
    final bgColor = isPass
        ? Colors.green.withValues(alpha: 0.12)
        : Colors.orange.withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isPass ? Icons.stars_rounded : Icons.replay_rounded,
                    color: statusColor,
                    size: 26,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Точность произношения: $scorePercent%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPass ? 'ОТЛИЧНО' : 'ТРЕНИРОВАТЬ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            result.feedback,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          if (result.words.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              'Анализ слов:',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: result.words.map((w) {
                final isWordGood = w.isCorrect;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isWordGood
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.redAccent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isWordGood ? Colors.green : Colors.redAccent,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isWordGood ? Icons.check_rounded : Icons.close_rounded,
                        size: 14,
                        color: isWordGood ? Colors.green.shade800 : Colors.redAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        w.targetWord,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isWordGood ? Colors.green.shade900 : Colors.redAccent.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.mic_rounded),
                  label: const Text('Повторить'),
                ),
              ),
              if (onAddToSrs != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onAddToSrs,
                    icon: const Icon(Icons.style_rounded),
                    label: const Text('В карточки'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
