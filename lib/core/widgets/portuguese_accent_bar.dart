import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PortugueseAccentBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmitted;

  const PortugueseAccentBar({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  @override
  State<PortugueseAccentBar> createState() => _PortugueseAccentBarState();
}

class _PortugueseAccentBarState extends State<PortugueseAccentBar> {
  bool _isUppercase = false;

  static const List<String> _lowerAccents = [
    'á', 'à', 'â', 'ã',
    'é', 'ê',
    'í',
    'ó', 'ô', 'õ',
    'ú',
    'ç',
  ];

  void _insertChar(String char) {
    HapticFeedback.lightImpact();
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;

    final newText = text.replaceRange(start, end, char);
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + char.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accents = _isUppercase
        ? _lowerAccents.map((c) => c.toUpperCase()).toList()
        : _lowerAccents;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Shift (Case Toggle)
          IconButton(
            icon: Icon(
              _isUppercase ? Icons.arrow_circle_up_rounded : Icons.arrow_circle_up_outlined,
              size: 20,
              color: _isUppercase ? theme.colorScheme.primary : theme.colorScheme.outline,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            tooltip: _isUppercase ? 'Строчные буквы' : 'Заглавные буквы',
            onPressed: () {
              setState(() => _isUppercase = !_isUppercase);
            },
          ),
          const VerticalDivider(width: 8, thickness: 1),
          // Accent buttons list
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: accents.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final char = accents[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _insertChar(char),
                  child: Container(
                    width: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      char,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
