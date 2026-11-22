import 'package:flutter/material.dart';

class MusicControlsBar extends StatelessWidget {
  final bool isPlaying;
  final bool isQuizMode;
  final bool showTranslation;
  final double playbackSpeed;
  final double progress;
  final Color primaryColor;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToggleQuizMode;
  final VoidCallback onToggleTranslation;
  final ValueChanged<double> onSpeedChanged;

  const MusicControlsBar({
    super.key,
    required this.isPlaying,
    required this.isQuizMode,
    required this.showTranslation,
    required this.playbackSpeed,
    required this.progress,
    required this.primaryColor,
    required this.onTogglePlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onToggleQuizMode,
    required this.onToggleTranslation,
    required this.onSpeedChanged,
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
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.filledTonal(
                icon: Text(
                  '${playbackSpeed.toStringAsFixed(playbackSpeed % 1 == 0 ? 0 : 2)}x',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                tooltip: 'Скорость воспроизведения',
                onPressed: () {
                  final nextSpeed = playbackSpeed == 1.0
                      ? 0.75
                      : playbackSpeed == 0.75
                          ? 1.25
                          : 1.0;
                  onSpeedChanged(nextSpeed);
                },
              ),
              IconButton(
                icon: Icon(
                  showTranslation ? Icons.translate_rounded : Icons.g_translate_outlined,
                  color: showTranslation ? primaryColor : theme.colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Перевод на русский',
                onPressed: onToggleTranslation,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded, size: 28),
                    onPressed: onPrevious,
                  ),
                  const SizedBox(width: 4),
                  FilledButton(
                    onPressed: onTogglePlayPause,
                    style: FilledButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: primaryColor,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded, size: 28),
                    onPressed: onNext,
                  ),
                ],
              ),
              IconButton.filledTonal(
                icon: Icon(
                  isQuizMode ? Icons.mic_rounded : Icons.extension_rounded,
                  color: isQuizMode ? primaryColor : null,
                ),
                tooltip: isQuizMode ? 'Режим караоке' : 'Режим квиза (вставка слов)',
                onPressed: onToggleQuizMode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
