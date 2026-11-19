import 'package:flutter/material.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/speech/pronunciation_accuracy_evaluator.dart';

class PronunciationPracticeSheet extends StatefulWidget {
  final String targetText;
  final String russianTranslation;
  final HybridAudioPlaybackService audioService;

  const PronunciationPracticeSheet({
    super.key,
    required this.targetText,
    required this.russianTranslation,
    required this.audioService,
  });

  @override
  State<PronunciationPracticeSheet> createState() => _PronunciationPracticeSheetState();
}

class _PronunciationPracticeSheetState extends State<PronunciationPracticeSheet> {
  final _inputController = TextEditingController();
  PronunciationResult? _result;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _evaluateInput(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _result = PronunciationAccuracyEvaluator.evaluate(
        spokenText: text,
        targetText: widget.targetText,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Тренировка произношения',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.targetText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded),
                      onPressed: () {
                        widget.audioService.playAudioOrSpeak(
                          fallbackText: widget.targetText,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.russianTranslation,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _inputController,
            decoration: InputDecoration(
              hintText: 'Произнесите или введите фразу для оценки...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.check_circle_rounded),
                onPressed: () => _evaluateInput(_inputController.text),
              ),
            ),
            onSubmitted: _evaluateInput,
          ),
          const SizedBox(height: 16),
          if (_result != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _result!.isPass
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _result!.isPass ? Colors.green : Colors.orange,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Точность: ${(_result!.score * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _result!.isPass ? Colors.green.shade800 : Colors.orange.shade800,
                        ),
                      ),
                      Icon(
                        _result!.isPass ? Icons.stars_rounded : Icons.replay_rounded,
                        color: _result!.isPass ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _result!.feedback,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
