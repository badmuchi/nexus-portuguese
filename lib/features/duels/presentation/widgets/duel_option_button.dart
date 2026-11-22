import 'package:flutter/material.dart';

class DuelOptionButton extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrectOption;
  final VoidCallback onTap;

  const DuelOptionButton({
    super.key,
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.isCorrectOption,
    required this.onTap,
  });

  String get _letter => ['A', 'B', 'C', 'D'][index.clamp(0, 3)];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor = theme.colorScheme.surfaceContainerHighest;
    Color borderColor = theme.colorScheme.outlineVariant;
    Color textColor = theme.colorScheme.onSurface;
    IconData? trailingIcon;

    if (isAnswered) {
      if (isCorrectOption) {
        backgroundColor = Colors.green.withValues(alpha: 0.2);
        borderColor = Colors.green.shade600;
        textColor = Colors.green.shade900;
        trailingIcon = Icons.check_circle_rounded;
      } else if (isSelected) {
        backgroundColor = Colors.red.withValues(alpha: 0.15);
        borderColor = Colors.red.shade600;
        textColor = Colors.red.shade900;
        trailingIcon = Icons.cancel_rounded;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isAnswered ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: isAnswered && (isCorrectOption || isSelected) ? 2 : 1),
            ),
            child: Row(
              children: [
                _OptionLetterBadge(
                  letter: _letter,
                  isAnswered: isAnswered,
                  isCorrectOption: isCorrectOption,
                  isSelected: isSelected,
                  theme: theme,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    trailingIcon,
                    color: isCorrectOption ? Colors.green.shade700 : Colors.red.shade700,
                    size: 22,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionLetterBadge extends StatelessWidget {
  final String letter;
  final bool isAnswered;
  final bool isCorrectOption;
  final bool isSelected;
  final ThemeData theme;

  const _OptionLetterBadge({
    required this.letter,
    required this.isAnswered,
    required this.isCorrectOption,
    required this.isSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = theme.colorScheme.surface;
    Color fg = theme.colorScheme.primary;

    if (isAnswered) {
      if (isCorrectOption) {
        bg = Colors.green.shade600;
        fg = Colors.white;
      } else if (isSelected) {
        bg = Colors.red.shade600;
        fg = Colors.white;
      }
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: fg,
        ),
      ),
    );
  }
}
