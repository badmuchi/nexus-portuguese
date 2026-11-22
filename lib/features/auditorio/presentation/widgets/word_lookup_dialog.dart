import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/features/morphology/domain/entities/morphology_models.dart';
import 'package:nexus_portuguese_app/features/morphology/domain/services/portuguese_morphology_engine.dart';
import 'package:nexus_portuguese_app/features/morphology/presentation/widgets/sentence_xray_sheet.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class WordLookupDialog extends StatelessWidget {
  final String word;
  final String fullSentencePt;
  final String fullTranslationRu;

  const WordLookupDialog({
    super.key,
    required this.word,
    required this.fullSentencePt,
    required this.fullTranslationRu,
  });

  static void show(
    BuildContext context, {
    required String word,
    required String fullSentencePt,
    required String fullTranslationRu,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WordLookupDialog(
        word: word,
        fullSentencePt: fullSentencePt,
        fullTranslationRu: fullTranslationRu,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audio = context.read<HybridAudioPlaybackService>();

    // Морфологический анализ всего предложения для нахождения контекстного слова
    final analysis = PortugueseMorphologyEngine.analyzeSentence(
      sentence: fullSentencePt,
      translationRu: fullTranslationRu,
    );

    final clean = word.replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '').toLowerCase();
    final matchedWord = analysis.words.firstWhere(
      (w) => w.cleanWord.toLowerCase() == clean,
      orElse: () => WordMorphology(
        rawWord: word,
        cleanWord: clean,
        partOfSpeech: PartOfSpeech.desconhecido,
        lemma: clean,
        translationRu: 'Слово из подкаста',
      ),
    );

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DragHandle(theme: theme),
          _WordHeader(
            word: matchedWord,
            audio: audio,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _WordDetailsCard(word: matchedWord, theme: theme),
          const SizedBox(height: 16),
          _DialogActions(
            word: matchedWord,
            fullSentencePt: fullSentencePt,
            fullTranslationRu: fullTranslationRu,
            theme: theme,
          ),
        ],
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

class _WordHeader extends StatelessWidget {
  final WordMorphology word;
  final HybridAudioPlaybackService audio;
  final ThemeData theme;

  const _WordHeader({
    required this.word,
    required this.audio,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              word.cleanWord,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.volume_up_rounded),
              onPressed: () {
                audio.playAudioOrSpeak(fallbackText: word.cleanWord);
              },
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            word.partOfSpeech.labelRu,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}

class _WordDetailsCard extends StatelessWidget {
  final WordMorphology word;
  final ThemeData theme;

  const _WordDetailsCard({
    required this.word,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (word.contraction != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade700),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Слияние: ${word.contraction!.formula}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
          Text(
            'Лемма: ${word.lemma}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Значение: ${word.translationRu}',
            style: theme.textTheme.bodyMedium,
          ),
          if (word.grammarNotes != null) ...[
            const SizedBox(height: 6),
            Text(
              word.grammarNotes!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  final WordMorphology word;
  final String fullSentencePt;
  final String fullTranslationRu;
  final ThemeData theme;

  const _DialogActions({
    required this.word,
    required this.fullSentencePt,
    required this.fullTranslationRu,
    required this.theme,
  });

  Future<void> _addToSrs(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final srsRepo = context.read<SrsRepository>();

    final newCard = SrsCardEntity(
      id: 'auditorio_srs_${word.cleanWord}_${DateTime.now().millisecondsSinceEpoch}',
      portuguese: word.cleanWord,
      russianTranslation: word.translationRu,
      partOfSpeech: word.partOfSpeech.code,
      category: 'auditorio',
      dialect: 'all',
      examplePortuguese: fullSentencePt,
      exampleRussian: fullTranslationRu,
      notes: word.grammarNotes,
      fsrsState: 'newCard',
      stability: 0.0,
      difficulty: 0.0,
      reps: 0,
      lapses: 0,
      dueAt: DateTime.now(),
    );

    await srsRepo.addCard(newCard);

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Слово «${word.cleanWord}» добавлено в FSRS-карточки!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              SentenceXRaySheet.show(
                context,
                sentencePortuguese: fullSentencePt,
                translationRussian: fullTranslationRu,
              );
            },
            icon: const Icon(Icons.biotech_rounded, size: 18),
            label: const Text('X-Ray фразы'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _addToSrs(context),
            icon: const Icon(Icons.bookmark_add_rounded, size: 18),
            label: const Text('В карточки'),
          ),
        ),
      ],
    );
  }
}
