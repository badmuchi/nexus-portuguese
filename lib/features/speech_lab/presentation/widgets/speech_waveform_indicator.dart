import 'dart:math' as math;
import 'package:flutter/material.dart';

class SpeechWaveformIndicator extends StatefulWidget {
  final bool isActive;
  final Color? color;
  final double height;
  final int barCount;

  const SpeechWaveformIndicator({
    super.key,
    required this.isActive,
    this.color,
    this.height = 36.0,
    this.barCount = 18,
  });

  @override
  State<SpeechWaveformIndicator> createState() => _SpeechWaveformIndicatorState();
}

class _SpeechWaveformIndicatorState extends State<SpeechWaveformIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SpeechWaveformIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final waveColor = widget.color ?? theme.colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.barCount, (index) {
              final phase = (index / widget.barCount) * 2 * math.pi;
              final t = _controller.value * 2 * math.pi;
              final sinValue = widget.isActive
                  ? (math.sin(t + phase).abs() * 0.75 + 0.25)
                  : 0.2;

              final barHeight = widget.height * sinValue;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: 3.5,
                height: barHeight,
                decoration: BoxDecoration(
                  color: waveColor.withValues(
                    alpha: widget.isActive ? 0.85 : 0.25,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
