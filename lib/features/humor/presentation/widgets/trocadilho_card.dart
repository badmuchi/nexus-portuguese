import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/humor_entities.dart';

class TrocadilhoCard extends StatefulWidget {
  final TrocadilhoEntity trocadilho;

  const TrocadilhoCard({
    super.key,
    required this.trocadilho,
  });

  @override
  State<TrocadilhoCard> createState() => _TrocadilhoCardState();
}

class _TrocadilhoCardState extends State<TrocadilhoCard> {
  bool _isAnswerRevealed = false;
  bool _isPlaying = false;

  Future<void> _speak(String text) async {
    final audio = context.read<HybridAudioPlaybackService>();
    if (_isPlaying) {
      await audio.stop();
      if (mounted) setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isPlaying = true);
    final dialect = widget.trocadilho.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    await audio.playAudioOrSpeak(
      fallbackText: text,
      dialect: dialect,
      rate: 0.95,
    );

    if (mounted) {
      setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final trocadilho = widget.trocadilho;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🧩', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trocadilho.questionPt,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        trocadilho.questionRu,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _speak(trocadilho.questionPt),
                  icon: Icon(
                    _isPlaying ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                    color: _isPlaying ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Слушать вопрос',
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Answer or Reveal Button
            if (!_isAnswerRevealed)
              Center(
                child: FilledButton.tonalIcon(
                  onPressed: () => setState(() => _isAnswerRevealed = true),
                  icon: const Icon(Icons.visibility_rounded, size: 18),
                  label: const Text('Узнать ответ и игру слов'),
                ),
              )
            else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trocadilho.answerPt,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _speak(trocadilho.answerPt),
                          icon: const Icon(Icons.volume_up_rounded, size: 18),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Слушать ответ',
                        ),
                      ],
                    ),
                    Text(
                      trocadilho.answerRu,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 16,
                          color: Colors.amber.shade800,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            trocadilho.wordplayExplanationRu,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
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
