import 'package:flutter/material.dart';

class ScenePlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final bool isAutoPlay;
  final bool isDubbingMode;
  final bool isFirstLine;
  final bool isLastLine;
  final VoidCallback onPlayLine;
  final VoidCallback onNextLine;
  final VoidCallback? onPreviousLine;
  final VoidCallback onToggleAutoPlay;
  final VoidCallback onToggleDubbing;

  const ScenePlaybackControls({
    super.key,
    required this.isPlaying,
    required this.isAutoPlay,
    required this.isDubbingMode,
    required this.isFirstLine,
    required this.isLastLine,
    required this.onPlayLine,
    required this.onNextLine,
    required this.onPreviousLine,
    required this.onToggleAutoPlay,
    required this.onToggleDubbing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Dubbing mode toggle
            IconButton.filledTonal(
              tooltip: isDubbingMode ? 'Дубляж включен' : 'Включить режим дубляжа',
              style: IconButton.styleFrom(
                backgroundColor: isDubbingMode
                    ? Colors.indigo.withValues(alpha: 0.2)
                    : theme.colorScheme.surfaceContainerHighest,
              ),
              icon: Icon(
                Icons.mic_rounded,
                color: isDubbingMode ? Colors.indigo : null,
              ),
              onPressed: onToggleDubbing,
            ),

            // Previous line
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded, size: 28),
              onPressed: isFirstLine ? null : onPreviousLine,
            ),

            // Play line audio
            FilledButton.icon(
              onPressed: onPlayLine,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: Icon(isPlaying ? Icons.volume_up_rounded : Icons.play_arrow_rounded),
              label: Text(
                isPlaying ? 'Слушаем...' : 'Слушать',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // Next line
            IconButton(
              icon: Icon(
                isLastLine ? Icons.check_circle_rounded : Icons.skip_next_rounded,
                size: 28,
                color: isLastLine ? Colors.green : null,
              ),
              onPressed: onNextLine,
            ),

            // Autoplay toggle
            IconButton.filledTonal(
              tooltip: isAutoPlay ? 'Автопроигрывание вкл.' : 'Автопроигрывание',
              style: IconButton.styleFrom(
                backgroundColor: isAutoPlay
                    ? Colors.green.withValues(alpha: 0.2)
                    : theme.colorScheme.surfaceContainerHighest,
              ),
              icon: Icon(
                Icons.autorenew_rounded,
                color: isAutoPlay ? Colors.green : null,
              ),
              onPressed: onToggleAutoPlay,
            ),
          ],
        ),
      ),
    );
  }
}
