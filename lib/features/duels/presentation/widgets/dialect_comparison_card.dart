import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/duel_question_entity.dart';

class DialectComparisonCard extends StatelessWidget {
  final DuelQuestion question;
  final VoidCallback onPlayPtPt;
  final VoidCallback onPlayPtBr;

  const DialectComparisonCard({
    super.key,
    required this.question,
    required this.onPlayPtPt,
    required this.onPlayPtBr,
  });

  Future<void> _addBothToSrs(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final srsRepo = context.read<SrsRepository>();

    final card = SrsCardEntity(
      id: 'duel_srs_${question.id}_${DateTime.now().millisecondsSinceEpoch}',
      portuguese: '${question.ptPtEquivalent} (PT) / ${question.ptBrEquivalent} (BR)',
      russianTranslation: question.promptRu,
      partOfSpeech: 'substantivo',
      category: 'duelos',
      dialect: 'all',
      examplePortuguese: '${question.ptPtEquivalent} em Portugal vs ${question.ptBrEquivalent} no Brasil.',
      exampleRussian: question.culturalNoteRu,
      notes: question.culturalNotePt,
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
          content: Text('Пара слов добавлена в карточки FSRS!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('⚖️', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    'Сопоставление двух берегов',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.bookmark_add_rounded, size: 18),
                tooltip: 'Добавить в FSRS',
                visualDensity: VisualDensity.compact,
                onPressed: () => _addBothToSrs(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DialectPill(
                  flag: '🇵🇹',
                  label: 'Portugal',
                  text: question.ptPtEquivalent,
                  onPlay: onPlayPtPt,
                  theme: theme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DialectPill(
                  flag: '🇧🇷',
                  label: 'Brasil',
                  text: question.ptBrEquivalent,
                  onPlay: onPlayPtBr,
                  theme: theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question.culturalNoteRu,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialectPill extends StatelessWidget {
  final String flag;
  final String label;
  final String text;
  final VoidCallback onPlay;
  final ThemeData theme;

  const _DialectPill({
    required this.flag,
    required this.label,
    required this.text,
    required this.onPlay,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(flag),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onPlay,
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(Icons.volume_up_rounded, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
