import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/shadowing_evaluation_entity.dart';
import '../../domain/entities/transcript_snippet_entity.dart';
import '../cubit/podcast_player_cubit.dart';
import '../cubit/podcast_player_state.dart';

class ShadowingRecorderSheet extends StatefulWidget {
  final TranscriptSnippet snippet;
  final bool isPtPt;

  const ShadowingRecorderSheet({
    super.key,
    required this.snippet,
    required this.isPtPt,
  });

  static void show(
    BuildContext context, {
    required TranscriptSnippet snippet,
    required bool isPtPt,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PodcastPlayerCubit>(),
        child: ShadowingRecorderSheet(
          snippet: snippet,
          isPtPt: isPtPt,
        ),
      ),
    );
  }

  @override
  State<ShadowingRecorderSheet> createState() => _ShadowingRecorderSheetState();
}

class _ShadowingRecorderSheetState extends State<ShadowingRecorderSheet> {
  final _manualInputController = TextEditingController();
  bool _showManualInput = false;

  @override
  void dispose() {
    _manualInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audio = context.read<HybridAudioPlaybackService>();
    final cubit = context.read<PodcastPlayerCubit>();
    final dialect = widget.isPtPt ? PortugueseDialect.european : PortugueseDialect.brazilian;

    return BlocBuilder<PodcastPlayerCubit, PodcastPlayerState>(
      builder: (context, state) {
        final result = state.shadowingResult;

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 14,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SheetDragHandle(theme: theme),
                _ShadowingHeader(
                  dialectFlag: widget.isPtPt ? '🇵🇹 PT-PT' : '🇧🇷 PT-BR',
                  theme: theme,
                ),
                const SizedBox(height: 12),
                _TargetPhraseCard(
                  targetText: widget.snippet.textPt,
                  translation: widget.snippet.translationRu,
                  onPlayNormal: () {
                    audio.playAudioOrSpeak(
                      fallbackText: widget.snippet.textPt,
                      dialect: dialect,
                      rate: 1.0,
                    );
                  },
                  onPlaySlow: () {
                    audio.playAudioOrSpeak(
                      fallbackText: widget.snippet.textPt,
                      dialect: dialect,
                      rate: 0.75,
                    );
                  },
                  theme: theme,
                ),
                const SizedBox(height: 16),
                if (result != null) ...[
                  _EvaluationResultCard(
                    result: result,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                ],
                _RecordingControls(
                  isRecording: state.isRecording,
                  hasResult: result != null,
                  onStartRecording: () {
                    HapticFeedback.heavyImpact();
                    cubit.startShadowingRecording();
                  },
                  onStopRecording: () {
                    HapticFeedback.mediumImpact();
                    cubit.stopShadowingRecording();
                  },
                  onSimulateNative: () {
                    HapticFeedback.lightImpact();
                    cubit.evaluateShadowing(widget.snippet.textPt);
                  },
                  onToggleManualInput: () {
                    setState(() => _showManualInput = !_showManualInput);
                  },
                  theme: theme,
                ),
                if (_showManualInput) ...[
                  const SizedBox(height: 12),
                  _ManualInputSection(
                    controller: _manualInputController,
                    onSubmit: (text) {
                      if (text.trim().isNotEmpty) {
                        cubit.evaluateShadowing(text);
                        _manualInputController.clear();
                        setState(() => _showManualInput = false);
                      }
                    },
                    theme: theme,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SheetDragHandle extends StatelessWidget {
  final ThemeData theme;
  const _SheetDragHandle({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _ShadowingHeader extends StatelessWidget {
  final String dialectFlag;
  final ThemeData theme;

  const _ShadowingHeader({
    required this.dialectFlag,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.mic_rounded, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Теневое повторение (Shadowing)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Слушайте диктора и повторяйте вслух',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            dialectFlag,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _TargetPhraseCard extends StatelessWidget {
  final String targetText;
  final String translation;
  final VoidCallback onPlayNormal;
  final VoidCallback onPlaySlow;
  final ThemeData theme;

  const _TargetPhraseCard({
    required this.targetText,
    required this.translation,
    required this.onPlayNormal,
    required this.onPlaySlow,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            targetText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              height: 1.3,
            ),
          ),
          if (translation.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              translation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.tonalIcon(
                onPressed: onPlayNormal,
                icon: const Icon(Icons.volume_up_rounded, size: 18),
                label: const Text('1.0x Нормально'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onPlaySlow,
                icon: const Icon(Icons.slow_motion_video_rounded, size: 18),
                label: const Text('0.75x Медленно'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EvaluationResultCard extends StatelessWidget {
  final ShadowingEvaluationEntity result;
  final ThemeData theme;

  const _EvaluationResultCard({
    required this.result,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final scorePercent = result.scorePercent;
    final isGood = scorePercent >= 75;
    final badgeColor = isGood ? Colors.green.shade600 : Colors.orange.shade700;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isGood ? Icons.stars_rounded : Icons.info_outline_rounded,
                    color: badgeColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Точность произношения: $scorePercent%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: badgeColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isGood ? 'Ótimo' : 'Pratique mais',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            result.feedback,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          if (result.wordEvaluations.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Слова по отдельности:',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: result.wordEvaluations.map((w) {
                final wordPassed = w.isCorrect;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: wordPassed
                        ? Colors.green.withValues(alpha: 0.15)
                        : Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: wordPassed ? Colors.green.shade400 : Colors.red.shade400,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        wordPassed ? Icons.check : Icons.close,
                        size: 12,
                        color: wordPassed ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        w.targetWord,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: wordPassed ? Colors.green.shade900 : Colors.red.shade900,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecordingControls extends StatelessWidget {
  final bool isRecording;
  final bool hasResult;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback onSimulateNative;
  final VoidCallback onToggleManualInput;
  final ThemeData theme;

  const _RecordingControls({
    required this.isRecording,
    required this.hasResult,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onSimulateNative,
    required this.onToggleManualInput,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: isRecording ? onStopRecording : onStartRecording,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isRecording ? Colors.red.shade600 : theme.colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isRecording ? Colors.red : theme.colorScheme.primary)
                        .withValues(alpha: 0.35),
                    blurRadius: isRecording ? 18 : 8,
                    spreadRadius: isRecording ? 4 : 0,
                  ),
                ],
              ),
              child: Icon(
                isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isRecording
              ? 'Слушаю вас... Говорите фразу'
              : (hasResult ? 'Нажмите для повторной записи' : 'Нажмите на микрофон и повторите фразу'),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isRecording ? Colors.red : theme.colorScheme.outline,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: onSimulateNative,
              icon: const Icon(Icons.flash_on_rounded, size: 16),
              label: const Text('Тест эталона'),
            ),
            TextButton.icon(
              onPressed: onToggleManualInput,
              icon: const Icon(Icons.keyboard_rounded, size: 16),
              label: const Text('Ввод текстом'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ManualInputSection extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmit;
  final ThemeData theme;

  const _ManualInputSection({
    required this.controller,
    required this.onSubmit,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Введите произнесенное...',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () => onSubmit(controller.text),
          child: const Text('Оценить'),
        ),
      ],
    );
  }
}
