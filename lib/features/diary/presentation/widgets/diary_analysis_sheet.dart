import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/morphology/domain/entities/morphology_models.dart';
import 'package:nexus_portuguese_app/features/morphology/domain/services/portuguese_morphology_engine.dart';
import 'package:nexus_portuguese_app/features/morphology/presentation/widgets/sentence_xray_sheet.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/diary_analysis_entity.dart';
import '../../domain/entities/diary_entry_entity.dart';
import '../../domain/services/portuguese_diary_analyzer.dart';

class DiaryAnalysisSheet extends StatelessWidget {
  final DiaryEntryEntity entry;

  const DiaryAnalysisSheet({
    super.key,
    required this.entry,
  });

  static void show(BuildContext context, {required DiaryEntryEntity entry}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DiaryAnalysisSheet(entry: entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audio = context.read<HybridAudioPlaybackService>();

    final analysis = PortugueseDiaryAnalyzer.analyze(entry.contentPt);

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
            _DragHandle(theme: theme),
            _SheetHeader(
              formattedDate: entry.formattedDate,
              dialectFlag: entry.dialectFlag,
              dialectLabel: entry.dialectLabel,
              theme: theme,
            ),
            const SizedBox(height: 12),
            _TextContentCard(
              contentPt: entry.contentPt,
              onPlayAudio: () {
                final dialect = entry.isPtPt
                    ? PortugueseDialect.european
                    : PortugueseDialect.brazilian;
                audio.playAudioOrSpeak(
                  fallbackText: entry.contentPt,
                  dialect: dialect,
                );
              },
              onOpenXRay: () {
                SentenceXRaySheet.show(
                  context,
                  sentencePortuguese: entry.contentPt,
                  translationRussian: 'Запись из личного дневника',
                );
              },
              theme: theme,
            ),
            const SizedBox(height: 14),
            _AiVerdictCard(
              feedbackSummary: entry.feedbackSummaryRu,
              estimatedLevel: entry.estimatedLevel,
              dialectNotes: analysis.dialectNotesRu,
              wordCount: entry.wordCount,
              theme: theme,
            ),
            const SizedBox(height: 14),
            if (entry.mistakes.isNotEmpty) ...[
              _MistakesSection(mistakes: entry.mistakes, theme: theme),
              const SizedBox(height: 14),
            ],
            if (analysis.suggestedSrsWords.isNotEmpty) ...[
              _SuggestedWordsSection(
                words: analysis.suggestedSrsWords,
                fullContent: entry.contentPt,
                theme: theme,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  final ThemeData theme;
  const _DragHandle({required this.theme});

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

class _SheetHeader extends StatelessWidget {
  final String formattedDate;
  final String dialectFlag;
  final String dialectLabel;
  final ThemeData theme;

  const _SheetHeader({
    required this.formattedDate,
    required this.dialectFlag,
    required this.dialectLabel,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Анализ записи дневника',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            Text(dialectFlag),
            const SizedBox(width: 4),
            Text(
              dialectLabel,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class _TextContentCard extends StatelessWidget {
  final String contentPt;
  final VoidCallback onPlayAudio;
  final VoidCallback onOpenXRay;
  final ThemeData theme;

  const _TextContentCard({
    required this.contentPt,
    required this.onPlayAudio,
    required this.onOpenXRay,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contentPt,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.4, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton.filledTonal(
                icon: const Icon(Icons.volume_up_rounded, size: 18),
                tooltip: 'Озвучить диктором',
                visualDensity: VisualDensity.compact,
                onPressed: onPlayAudio,
              ),
              const SizedBox(width: 8),
              FilledButton.tonalIcon(
                onPressed: onOpenXRay,
                icon: const Icon(Icons.biotech_rounded, size: 16),
                label: const Text('Морфологический X-Ray', style: TextStyle(fontSize: 12)),
                style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AiVerdictCard extends StatelessWidget {
  final String feedbackSummary;
  final String estimatedLevel;
  final String dialectNotes;
  final int wordCount;
  final ThemeData theme;

  const _AiVerdictCard({
    required this.feedbackSummary,
    required this.estimatedLevel,
    required this.dialectNotes,
    required this.wordCount,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.psychology_rounded, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Вердикт AI-тьютора',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Уровень CEFR $estimatedLevel',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedbackSummary,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
          ),
          const SizedBox(height: 6),
          Text(
            dialectNotes,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _MistakesSection extends StatelessWidget {
  final List<DiaryMistakeItem> mistakes;
  final ThemeData theme;

  const _MistakesSection({
    required this.mistakes,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.spellcheck_rounded, color: Colors.orange.shade800, size: 18),
            const SizedBox(width: 6),
            Text(
              'Подсказки и рекомендации (${mistakes.length}):',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...mistakes.map((m) => _MistakeTile(item: m, theme: theme)),
      ],
    );
  }
}

class _MistakeTile extends StatelessWidget {
  final DiaryMistakeItem item;
  final ThemeData theme;

  const _MistakeTile({
    required this.item,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item.originalText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                item.suggestedText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.ruleExplanationRu,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _SuggestedWordsSection extends StatelessWidget {
  final List<String> words;
  final String fullContent;
  final ThemeData theme;

  const _SuggestedWordsSection({
    required this.words,
    required this.fullContent,
    required this.theme,
  });

  Future<void> _addWordToSrs(BuildContext context, String word) async {
    HapticFeedback.mediumImpact();
    final srsRepo = context.read<SrsRepository>();

    final analysis = PortugueseMorphologyEngine.analyzeSentence(
      sentence: fullContent,
      translationRu: 'Личный дневник',
    );

    final clean = word.toLowerCase();
    final matched = analysis.words.firstWhere(
      (w) => w.cleanWord.toLowerCase() == clean,
      orElse: () => WordMorphology(
        rawWord: word,
        cleanWord: clean,
        partOfSpeech: PartOfSpeech.desconhecido,
        lemma: clean,
        translationRu: 'Слово из дневника',
      ),
    );

    final newCard = SrsCardEntity(
      id: 'diary_srs_${clean}_${DateTime.now().millisecondsSinceEpoch}',
      portuguese: matched.cleanWord,
      russianTranslation: matched.translationRu,
      partOfSpeech: matched.partOfSpeech.code,
      category: 'diario',
      dialect: 'all',
      examplePortuguese: fullContent,
      exampleRussian: 'Запись из дневника',
      notes: matched.grammarNotes,
      fsrsState: 'newCard',
      stability: 0.0,
      difficulty: 0.0,
      reps: 0,
      lapses: 0,
      dueAt: DateTime.now(),
    );

    await srsRepo.addCard(newCard);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Слово «$word» добавлено в FSRS-карточки!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bookmark_add_rounded, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 6),
            Text(
              'Слова из вашей записи для повторения (FSRS):',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: words.map((w) {
            return ActionChip(
              avatar: const Icon(Icons.add_rounded, size: 16),
              label: Text(w),
              onPressed: () => _addWordToSrs(context, w),
            );
          }).toList(),
        ),
      ],
    );
  }
}
