import 'package:flutter/material.dart';
import '../../domain/entities/song_lyric_line_entity.dart';

class SongQuizTile extends StatelessWidget {
  final SongLyricLine line;
  final String? selectedOption;
  final bool? isOptionCorrect;
  final ValueChanged<String> onSelectOption;
  final VoidCallback onNextLine;
  final Color primaryColor;

  const SongQuizTile({
    super.key,
    required this.line,
    required this.selectedOption,
    required this.isOptionCorrect,
    required this.onSelectOption,
    required this.onNextLine,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetWord = line.targetMissingWord?.trim().toLowerCase();
    final hasAnswered = selectedOption != null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Строка #${line.index + 1}',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  '🧩 Вставь пропущенное слово',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              hasAnswered && isOptionCorrect == true
                  ? line.textPt
                  : line.maskedTextPt,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              line.translationRu,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: line.quizOptions.map((option) {
                final isSelected = selectedOption == option;
                final isThisCorrect = targetWord != null && option.trim().toLowerCase() == targetWord;

                Color? backgroundColor;
                Color? textColor;
                BorderSide borderSide = BorderSide(
                  color: theme.colorScheme.outlineVariant,
                );

                if (hasAnswered) {
                  if (isSelected) {
                    if (isOptionCorrect == true) {
                      backgroundColor = Colors.green.shade600;
                      textColor = Colors.white;
                      borderSide = const BorderSide(color: Colors.green, width: 2);
                    } else {
                      backgroundColor = Colors.red.shade600;
                      textColor = Colors.white;
                      borderSide = const BorderSide(color: Colors.red, width: 2);
                    }
                  } else if (isThisCorrect && isOptionCorrect == false) {
                    // Highlight the right answer after mistake
                    backgroundColor = Colors.green.withValues(alpha: 0.2);
                    borderSide = const BorderSide(color: Colors.green, width: 1.5);
                  }
                }

                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 80) / 2,
                  child: OutlinedButton(
                    onPressed: hasAnswered ? null : () => onSelectOption(option),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      side: borderSide,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor ?? theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (hasAnswered) ...[
              const SizedBox(height: 16),
              if (line.poeticNoteRu != null && line.poeticNoteRu!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '💡 ${line.poeticNoteRu!}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              FilledButton.icon(
                onPressed: onNextLine,
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text(
                  'Следующая строка',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
