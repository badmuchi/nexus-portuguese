import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/nature_entities.dart';

class SpeciesCard extends StatefulWidget {
  final SpeciesEntity species;
  final bool isAddedToSrs;
  final VoidCallback onAddToSrs;

  const SpeciesCard({
    super.key,
    required this.species,
    required this.isAddedToSrs,
    required this.onAddToSrs,
  });

  @override
  State<SpeciesCard> createState() => _SpeciesCardState();
}

class _SpeciesCardState extends State<SpeciesCard> {
  bool _isPlaying = false;

  Future<void> _speak() async {
    final audio = context.read<HybridAudioPlaybackService>();
    if (_isPlaying) {
      await audio.stop();
      if (mounted) setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isPlaying = true);
    final dialect = widget.species.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    await audio.playAudioOrSpeak(
      fallbackText: widget.species.commonNamePt,
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
    final species = widget.species;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    species.emoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              species.commonNamePt,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _speak,
                            icon: Icon(
                              _isPlaying
                                  ? Icons.volume_up_rounded
                                  : Icons.volume_down_rounded,
                              size: 20,
                              color: _isPlaying
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Слушать название',
                          ),
                        ],
                      ),
                      Text(
                        '${species.nameRu} • ${species.scientificName}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: species.category == SpeciesCategory.fauna
                    ? Colors.amber.withValues(alpha: 0.15)
                    : Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                species.statusRu,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: species.category == SpeciesCategory.fauna
                      ? Colors.amber.shade900
                      : Colors.green.shade800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              species.curiosityRu,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.isAddedToSrs ? null : widget.onAddToSrs,
                icon: Icon(
                  widget.isAddedToSrs
                      ? Icons.check_circle_rounded
                      : Icons.add_circle_outline_rounded,
                  size: 18,
                ),
                label: Text(
                  widget.isAddedToSrs ? 'В словаре FSRS' : '+ В словарь FSRS',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
