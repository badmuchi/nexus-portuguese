import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/movie_scene_entity.dart';

class CinemaDialogueBubble extends StatelessWidget {
  final CinemaDialogueLineEntity line;
  final int lineNumber;
  final int totalLines;
  final bool isSelected;
  final bool isPlaying;
  final bool isDubbingMode;
  final String dialect;
  final String movieTitle;
  final VoidCallback onPlayAudio;
  final VoidCallback onTap;

  const CinemaDialogueBubble({
    super.key,
    required this.line,
    required this.lineNumber,
    required this.totalLines,
    required this.isSelected,
    required this.isPlaying,
    required this.isDubbingMode,
    required this.dialect,
    required this.movieTitle,
    required this.onPlayAudio,
    required this.onTap,
  });

  void _copyLine(BuildContext context) {
    Clipboard.setData(ClipboardData(text: line.textPt));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Реплика скопирована в буфер обмена! 🎬'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addToSrs(BuildContext context) async {
    HapticFeedback.mediumImpact();
    try {
      final srsRepo = context.read<SrsRepository>();
      final card = SrsCardEntity(
        id: 'cinema_${line.id}_${DateTime.now().millisecondsSinceEpoch}',
        portuguese: line.textPt,
        russianTranslation: line.translationRu,
        partOfSpeech: 'Cinema',
        category: 'cinema',
        dialect: dialect,
        examplePortuguese: '${line.speakerName}: "${line.textPt}" ($movieTitle)',
        exampleRussian: '${line.speakerRoleRu}: «${line.translationRu}»',
        notes: line.slangNoteRu != null
            ? 'Сленг/контекст: ${line.slangNoteRu}'
            : 'Цитата из фильма $movieTitle',
        fsrsState: 'newCard',
        stability: 0.0,
        difficulty: 0.0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      );

      await srsRepo.addCard(card);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Фраза из кино добавлена в карточки FSRS! 🍿'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.25)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      line.speakerName.isNotEmpty ? line.speakerName[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.speakerName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          line.speakerRoleRu,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$lineNumber / $totalLines',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                      color: isPlaying ? Colors.green : theme.colorScheme.primary,
                      size: 20,
                    ),
                    tooltip: 'Озвучить',
                    onPressed: onPlayAudio,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    tooltip: 'Копировать',
                    onPressed: () => _copyLine(context),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                    tooltip: 'В карточки FSRS',
                    onPressed: () => _addToSrs(context),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                line.textPt,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                line.translationRu,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
              if (line.slangNoteRu != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepOrange.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💬 ', style: TextStyle(fontSize: 13)),
                      Expanded(
                        child: Text(
                          line.slangNoteRu!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: Colors.deepOrange.shade900,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (line.culturalSubtextRu != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🎭 ', style: TextStyle(fontSize: 13)),
                      Expanded(
                        child: Text(
                          line.culturalSubtextRu!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (isDubbingMode) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.indigo.withValues(alpha: 0.25)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.mic_rounded, size: 18, color: Colors.indigo),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Режим дубляжа: повторите реплику вслух с той же интонацией!',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
