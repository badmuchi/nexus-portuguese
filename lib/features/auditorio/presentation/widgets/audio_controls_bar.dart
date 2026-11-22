import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioControlsBar extends StatelessWidget {
  final bool isPlaying;
  final double playbackSpeed;
  final bool isLoopSnippet;
  final bool showTranslation;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onPreviousSnippet;
  final VoidCallback onNextSnippet;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onToggleLoop;
  final VoidCallback onToggleTranslation;

  const AudioControlsBar({
    super.key,
    required this.isPlaying,
    required this.playbackSpeed,
    required this.isLoopSnippet,
    required this.showTranslation,
    required this.onTogglePlayPause,
    required this.onPreviousSnippet,
    required this.onNextSnippet,
    required this.onSpeedChanged,
    required this.onToggleLoop,
    required this.onToggleTranslation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SpeedSelectorButton(
                  playbackSpeed: playbackSpeed,
                  onSpeedChanged: onSpeedChanged,
                  theme: theme,
                ),
                _LoopButton(
                  isLoop: isLoopSnippet,
                  onToggle: onToggleLoop,
                  theme: theme,
                ),
                _TranslationToggleButton(
                  showTranslation: showTranslation,
                  onToggle: onToggleTranslation,
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, size: 32),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    onPreviousSnippet();
                  },
                ),
                const SizedBox(width: 16),
                _PlayPauseButton(
                  isPlaying: isPlaying,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    onTogglePlayPause();
                  },
                  theme: theme,
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded, size: 32),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    onNextSnippet();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedSelectorButton extends StatelessWidget {
  final double playbackSpeed;
  final ValueChanged<double> onSpeedChanged;
  final ThemeData theme;

  const _SpeedSelectorButton({
    required this.playbackSpeed,
    required this.onSpeedChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      initialValue: playbackSpeed,
      onSelected: (speed) {
        HapticFeedback.selectionClick();
        onSpeedChanged(speed);
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 0.75, child: Text('0.75x Медленно')),
        PopupMenuItem(value: 1.0, child: Text('1.0x Стандарт')),
        PopupMenuItem(value: 1.25, child: Text('1.25x Быстро')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.speed_rounded, size: 16),
            const SizedBox(width: 4),
            Text(
              '${playbackSpeed}x',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoopButton extends StatelessWidget {
  final bool isLoop;
  final VoidCallback onToggle;
  final ThemeData theme;

  const _LoopButton({
    required this.isLoop,
    required this.onToggle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        HapticFeedback.selectionClick();
        onToggle();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isLoop
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.repeat_one_rounded,
              size: 16,
              color: isLoop ? theme.colorScheme.primary : theme.colorScheme.outline,
            ),
            const SizedBox(width: 4),
            Text(
              'Зациклить',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isLoop ? theme.colorScheme.primary : theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TranslationToggleButton extends StatelessWidget {
  final bool showTranslation;
  final VoidCallback onToggle;
  final ThemeData theme;

  const _TranslationToggleButton({
    required this.showTranslation,
    required this.onToggle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        HapticFeedback.selectionClick();
        onToggle();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: showTranslation
              ? theme.colorScheme.secondaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.translate_rounded,
              size: 16,
              color: showTranslation
                  ? theme.colorScheme.onSecondaryContainer
                  : theme.colorScheme.outline,
            ),
            const SizedBox(width: 4),
            Text(
              showTranslation ? 'Перевод вкл' : 'Перевод выкл',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: showTranslation
                    ? theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;
  final ThemeData theme;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        iconSize: 42,
        color: theme.colorScheme.onPrimary,
        icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
        onPressed: onPressed,
      ),
    );
  }
}
