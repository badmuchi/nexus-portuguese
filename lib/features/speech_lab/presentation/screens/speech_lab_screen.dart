import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/core/speech/pronunciation_accuracy_evaluator.dart';
import 'package:nexus_portuguese_app/core/widgets/portuguese_accent_bar.dart';
import 'package:nexus_portuguese_app/features/speech_lab/data/datasources/speech_lab_seed_data.dart';
import 'package:nexus_portuguese_app/features/speech_lab/domain/entities/speech_exercise.dart';
import 'package:nexus_portuguese_app/features/speech_lab/presentation/widgets/pronunciation_result_card.dart';
import 'package:nexus_portuguese_app/features/speech_lab/presentation/widgets/speech_waveform_indicator.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class SpeechLabScreen extends StatefulWidget {
  const SpeechLabScreen({super.key});

  @override
  State<SpeechLabScreen> createState() => _SpeechLabScreenState();
}

class _SpeechLabScreenState extends State<SpeechLabScreen> {
  SpeechCategory _selectedCategory = SpeechCategory.nasalVowels;
  int _currentIndex = 0;
  bool _isPlaying = false;
  final _textInputController = TextEditingController();
  PronunciationResult? _evaluationResult;

  List<SpeechExercise> get _filteredExercises => SpeechLabSeedData.exercises
      .where((e) => e.category == _selectedCategory)
      .toList();

  SpeechExercise get _currentExercise {
    final list = _filteredExercises;
    if (_currentIndex >= list.length) {
      return list.first;
    }
    return list[_currentIndex];
  }

  @override
  void dispose() {
    _textInputController.dispose();
    super.dispose();
  }

  void _selectCategory(SpeechCategory category) {
    setState(() {
      _selectedCategory = category;
      _currentIndex = 0;
      _evaluationResult = null;
      _textInputController.clear();
    });
  }

  Future<void> _playCurrentPhrase({double rate = 1.0}) async {
    HapticFeedback.lightImpact();
    setState(() => _isPlaying = true);
    final audio = context.read<HybridAudioPlaybackService>();
    final ex = _currentExercise;
    final dialect = PortugueseDialect.fromCode(ex.dialect);

    await audio.playAudioOrSpeak(
      fallbackText: ex.targetPortuguese,
      dialect: dialect,
      rate: rate * 0.5,
    );

    if (mounted) {
      setState(() => _isPlaying = false);
    }
  }

  void _evaluateSpokenText(String text) {
    if (text.trim().isEmpty) return;
    HapticFeedback.mediumImpact();
    final result = PronunciationAccuracyEvaluator.evaluate(
      spokenText: text,
      targetText: _currentExercise.targetPortuguese,
    );
    setState(() {
      _evaluationResult = result;
    });
  }

  Future<void> _addExerciseToSrs() async {
    HapticFeedback.mediumImpact();
    final srsRepo = context.read<SrsRepository>();
    final ex = _currentExercise;

    final newCard = SrsCardEntity(
      id: 'speech_srs_${ex.id}',
      portuguese: ex.targetPortuguese,
      russianTranslation: ex.russianTranslation,
      partOfSpeech: 'phrase',
      category: 'phonetics',
      dialect: ex.dialect,
      notes: ex.phoneticTip,
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
        const SnackBar(
          content: Text('Фраза добавлена в FSRS-карточки для повторений!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _nextExercise() {
    final list = _filteredExercises;
    setState(() {
      _currentIndex = (_currentIndex + 1) % list.length;
      _evaluationResult = null;
      _textInputController.clear();
    });
  }

  void _prevExercise() {
    final list = _filteredExercises;
    setState(() {
      _currentIndex = (_currentIndex - 1 + list.length) % list.length;
      _evaluationResult = null;
      _textInputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = _currentExercise;
    final list = _filteredExercises;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Лаборатория произношения'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category Filter Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: SpeechCategory.values.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      avatar: Icon(cat.icon, size: 16, color: isSelected ? Colors.white : cat.badgeColor),
                      label: Text(cat.labelPt),
                      selected: isSelected,
                      selectedColor: cat.badgeColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) => _selectCategory(cat),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Exercise Navigation Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory.labelRu,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _selectedCategory.badgeColor,
                  ),
                ),
                Text(
                  'Упражнение ${_currentIndex + 1} из ${list.length}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Main Drill Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _selectedCategory.badgeColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ex.dialect == 'pt_br'
                              ? 'PT-BR 🇧🇷'
                              : ex.dialect == 'pt_pt'
                                  ? 'PT-PT 🇵🇹'
                                  : 'PT 🇧🇷/🇵🇹',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        ex.difficulty.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    ex.targetPortuguese,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ex.russianTranslation,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Animated Waveform
                  SpeechWaveformIndicator(
                    isActive: _isPlaying,
                    color: _selectedCategory.badgeColor,
                  ),

                  const SizedBox(height: 14),

                  // Phonetic Tip
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ex.phoneticTip,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Native audio listen buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _playCurrentPhrase(rate: 1.0),
                        icon: const Icon(Icons.volume_up_rounded),
                        label: const Text('Слушать 1.0x'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _playCurrentPhrase(rate: 0.75),
                        icon: const Icon(Icons.slow_motion_video_rounded),
                        label: const Text('Медленно 0.75x'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Speech Evaluation / Input Section
            PortugueseAccentBar(
              controller: _textInputController,
              onSubmitted: () => _evaluateSpokenText(_textInputController.text),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textInputController,
              decoration: InputDecoration(
                labelText: 'Произнесите или введите фразу для оценки',
                hintText: 'Проверьте точность вашего португальского...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check_circle_rounded),
                  tooltip: 'Оценить произношение',
                  onPressed: () => _evaluateSpokenText(_textInputController.text),
                ),
              ),
              onSubmitted: _evaluateSpokenText,
            ),

            if (_evaluationResult != null) ...[
              const SizedBox(height: 16),
              PronunciationResultCard(
                result: _evaluationResult!,
                onRetry: () {
                  setState(() {
                    _evaluationResult = null;
                    _textInputController.clear();
                  });
                },
                onAddToSrs: _addExerciseToSrs,
              ),
            ],

            const SizedBox(height: 20),

            // Prev / Next Navigation buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: list.length > 1 ? _prevExercise : null,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Предыдущее'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: list.length > 1 ? _nextExercise : null,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Следующее'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
