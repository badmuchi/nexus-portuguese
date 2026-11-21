import 'package:flutter/material.dart';
import '../../domain/entities/portuguese_life_scene.dart';

class SceneChallengeCard extends StatefulWidget {
  final SceneChallenge challenge;
  final bool isInitiallySolved;
  final VoidCallback onSolved;

  const SceneChallengeCard({
    super.key,
    required this.challenge,
    this.isInitiallySolved = false,
    required this.onSolved,
  });

  @override
  State<SceneChallengeCard> createState() => _SceneChallengeCardState();
}

class _SceneChallengeCardState extends State<SceneChallengeCard> {
  int? _selectedIndex;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    if (widget.isInitiallySolved) {
      _selectedIndex = widget.challenge.correctIndex;
      _isAnswered = true;
    }
  }

  void _selectOption(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedIndex = index;
      _isAnswered = true;
    });

    if (index == widget.challenge.correctIndex) {
      widget.onSolved();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCorrect = _selectedIndex == widget.challenge.correctIndex;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: _isAnswered
              ? (isCorrect ? Colors.green : Colors.red)
              : theme.colorScheme.outlineVariant,
          width: _isAnswered ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.quiz_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ситуационный челлендж',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (_isAnswered)
                  Icon(
                    isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.challenge.question,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            ...List.generate(widget.challenge.options.length, (idx) {
              final optionText = widget.challenge.options[idx];
              final isChosen = _selectedIndex == idx;
              final isTarget = widget.challenge.correctIndex == idx;

              Color? btnBg;
              Color? borderColor;

              if (_isAnswered) {
                if (isTarget) {
                  btnBg = Colors.green.withValues(alpha: 0.12);
                  borderColor = Colors.green;
                } else if (isChosen) {
                  btnBg = Colors.red.withValues(alpha: 0.12);
                  borderColor = Colors.red;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () => _selectOption(idx),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: btnBg ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor ?? theme.colorScheme.outlineVariant,
                        width: isChosen || (_isAnswered && isTarget) ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      optionText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isChosen || (_isAnswered && isTarget)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (_isAnswered) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isCorrect ? Icons.lightbulb_rounded : Icons.info_outline_rounded,
                      size: 18,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.challenge.explanationRu,
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
    );
  }
}
