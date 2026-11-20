import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/features/morphology/domain/entities/morphology_models.dart';
import 'package:nexus_portuguese_app/features/morphology/domain/services/portuguese_morphology_engine.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class SentenceXRaySheet extends StatefulWidget {
  final String sentencePortuguese;
  final String translationRussian;

  const SentenceXRaySheet({
    super.key,
    required this.sentencePortuguese,
    required this.translationRussian,
  });

  static void show(
    BuildContext context, {
    required String sentencePortuguese,
    required String translationRussian,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SentenceXRaySheet(
        sentencePortuguese: sentencePortuguese,
        translationRussian: translationRussian,
      ),
    );
  }

  @override
  State<SentenceXRaySheet> createState() => _SentenceXRaySheetState();
}

class _SentenceXRaySheetState extends State<SentenceXRaySheet> {
  late final SentenceXRayEntity _analyzed;
  int _selectedWordIndex = 0;

  @override
  void initState() {
    super.initState();
    _analyzed = PortugueseMorphologyEngine.analyzeSentence(
      sentence: widget.sentencePortuguese,
      translationRu: widget.translationRussian,
    );
  }

  WordMorphology get _selectedWord {
    if (_analyzed.words.isEmpty) {
      return const WordMorphology(
        rawWord: '',
        cleanWord: '',
        partOfSpeech: PartOfSpeech.desconhecido,
        lemma: '',
        translationRu: '',
      );
    }
    return _analyzed.words[_selectedWordIndex];
  }

  Future<void> _addWordToSrs(WordMorphology word) async {
    HapticFeedback.mediumImpact();
    final srsRepo = context.read<SrsRepository>();

    final newCard = SrsCardEntity(
      id: 'morph_srs_${word.cleanWord}_${DateTime.now().millisecondsSinceEpoch}',
      portuguese: word.cleanWord,
      russianTranslation: word.translationRu,
      partOfSpeech: word.partOfSpeech.code,
      category: 'xray',
      dialect: 'all',
      examplePortuguese: widget.sentencePortuguese,
      exampleRussian: widget.translationRussian,
      notes: word.grammarNotes,
      fsrsState: 'newCard',
      stability: 0.0,
      difficulty: 0.0,
      reps: 0,
      lapses: 0,
      dueAt: DateTime.now(),
    );

    await srsRepo.addCard(newCard);

    if (mounted) {
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
    final theme = Theme.of(context);
    final audio = context.read<HybridAudioPlaybackService>();
    final word = _selectedWord;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.search_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Морфологический X-Ray',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Sentence Banner with TTS
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.sentencePortuguese,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded),
                      onPressed: () {
                        audio.playAudioOrSpeak(fallbackText: widget.sentencePortuguese);
                      },
                    ),
                  ],
                ),
                if (widget.translationRussian.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.translationRussian,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Word Selector Pills
          Text(
            'Выберите слово для грамматического анатомирования:',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_analyzed.words.length, (index) {
                final w = _analyzed.words[index];
                final isSelected = index == _selectedWordIndex;
                final isContraction = w.partOfSpeech == PartOfSpeech.contracao;

                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                    avatar: isContraction
                        ? const Icon(Icons.link_rounded, size: 16)
                        : null,
                    label: Text(w.rawWord),
                    selected: isSelected,
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedWordIndex = index);
                    },
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // Word Breakdown Card
          if (_analyzed.words.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            word.cleanWord,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, size: 20),
                            onPressed: () {
                              audio.playAudioOrSpeak(fallbackText: word.cleanWord);
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPosColor(word.partOfSpeech).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getPosColor(word.partOfSpeech)),
                        ),
                        child: Text(
                          word.partOfSpeech.labelRu,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _getPosColor(word.partOfSpeech),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Contraction Formula Box if applicable
                  if (word.contraction != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.amber.shade700),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.hub_rounded, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Слияние: ${word.contraction!.formula}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Lemma & Translation
                  Text(
                    'Словарная форма (лемма): ${word.lemma}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Значение: ${word.translationRu}',
                    style: theme.textTheme.bodyMedium,
                  ),

                  if (word.grammarNotes != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      word.grammarNotes!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.tonalIcon(
                      onPressed: () => _addWordToSrs(word),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Добавить в FSRS'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getPosColor(PartOfSpeech pos) {
    return switch (pos) {
      PartOfSpeech.substantivo => Colors.blue.shade700,
      PartOfSpeech.verbo => Colors.red.shade700,
      PartOfSpeech.adjetivo => Colors.green.shade700,
      PartOfSpeech.pronome => Colors.purple.shade700,
      PartOfSpeech.artigo => Colors.teal.shade700,
      PartOfSpeech.preposicao => Colors.indigo.shade700,
      PartOfSpeech.contracao => Colors.amber.shade900,
      PartOfSpeech.adverbio => Colors.deepOrange.shade700,
      PartOfSpeech.conjuncao => Colors.brown.shade700,
      _ => Colors.blueGrey,
    };
  }
}
