import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../speech_lab/presentation/widgets/speech_waveform_indicator.dart';
import '../../domain/entities/phonetic_trainer_models.dart';
import '../cubit/phonetics_trainer_cubit.dart';
import '../cubit/phonetics_trainer_state.dart';

class PhoneticsTrainerScreen extends StatelessWidget {
  const PhoneticsTrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneticsTrainerCubit, PhoneticsTrainerState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null && state.exercises.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Тренажёр фонетики')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage!),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.read<PhoneticsTrainerCubit>().loadTrainer(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          );
        }

        final exercise = state.currentExercise;
        final mastery = exercise != null ? state.masteryMap[exercise.soundId] : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Тренажёр носовых и гласных'),
            actions: [
              IconButton(
                tooltip: 'Обновить данные',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => context.read<PhoneticsTrainerCubit>().loadTrainer(),
              ),
            ],
          ),
          body: exercise == null
              ? const Center(child: Text('Нет доступных упражнений'))
              : Column(
                  children: [
                    _SoundChipsSelector(
                      exercises: state.exercises,
                      currentIndex: state.currentExerciseIndex,
                      masteryMap: state.masteryMap,
                    ),
                    _MasteryHeaderCard(
                      exercise: exercise,
                      mastery: mastery,
                    ),
                    _StepSegmentedBar(currentStep: state.step),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: switch (state.step) {
                          TrainerStep.theory => _TheorySection(exercise: exercise),
                          TrainerStep.ear => _EarSection(state: state),
                          TrainerStep.mouth => _MouthSection(state: state),
                          TrainerStep.dialect => _DialectSection(exercise: exercise),
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _SoundChipsSelector extends StatelessWidget {
  final List<PhoneticExercise> exercises;
  final int currentIndex;
  final Map<String, PhoneticMastery> masteryMap;

  const _SoundChipsSelector({
    required this.exercises,
    required this.currentIndex,
    required this.masteryMap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: exercises.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final item = exercises[idx];
          final isSelected = idx == currentIndex;
          final itemMastery = masteryMap[item.soundId]?.masteryScore ?? 0.0;

          return FilterChip(
            selected: isSelected,
            avatar: itemMastery >= 70
                ? const Icon(Icons.check_circle_rounded, size: 16, color: Colors.green)
                : null,
            label: Text('${item.title} (${itemMastery.toStringAsFixed(0)}%)'),
            onSelected: (_) {
              context.read<PhoneticsTrainerCubit>().selectExercise(idx);
            },
          );
        },
      ),
    );
  }
}

class _MasteryHeaderCard extends StatelessWidget {
  final PhoneticExercise exercise;
  final PhoneticMastery? mastery;

  const _MasteryHeaderCard({
    required this.exercise,
    this.mastery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = mastery?.masteryScore ?? 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    exercise.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      exercise.ipa,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${score.toStringAsFixed(0)}% мастерство',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (score / 100.0).clamp(0.0, 1.0),
                minHeight: 6,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '👂 Слух: ${(mastery?.earAccuracyPercent ?? 0.0).toStringAsFixed(0)}% (${mastery?.earCorrect ?? 0}/${mastery?.earAttempts ?? 0})',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '🎙️ Речь: ${(mastery?.mouthAccuracyAverage ?? 0.0).toStringAsFixed(0)}% (${mastery?.mouthAttempts ?? 0} попыток)',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepSegmentedBar extends StatelessWidget {
  final TrainerStep currentStep;

  const _StepSegmentedBar({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: SegmentedButton<TrainerStep>(
        segments: const [
          ButtonSegment(
            value: TrainerStep.theory,
            label: Text('Теория'),
            icon: Icon(Icons.school_rounded, size: 16),
          ),
          ButtonSegment(
            value: TrainerStep.ear,
            label: Text('Слух'),
            icon: Icon(Icons.hearing_rounded, size: 16),
          ),
          ButtonSegment(
            value: TrainerStep.mouth,
            label: Text('Речь'),
            icon: Icon(Icons.mic_rounded, size: 16),
          ),
          ButtonSegment(
            value: TrainerStep.dialect,
            label: Text('Контраст'),
            icon: Icon(Icons.compare_arrows_rounded, size: 16),
          ),
        ],
        selected: {currentStep},
        onSelectionChanged: (set) {
          context.read<PhoneticsTrainerCubit>().setStep(set.first);
        },
      ),
    );
  }
}

class _TheorySection extends StatelessWidget {
  final PhoneticExercise exercise;

  const _TheorySection({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<PhoneticsTrainerCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.record_voice_over_rounded, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Как правильно произносить',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  exercise.tipRu,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          exercise.tipPt,
                          style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Примеры контрастных пар:',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...exercise.contrastPairs.map((pair) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Row(
                children: [
                  Text(
                    pair.wordA,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(pair.ipaA, style: TextStyle(color: theme.colorScheme.outline, fontSize: 12)),
                  const Text('  vs  '),
                  Text(
                    pair.wordB,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(pair.ipaB, style: TextStyle(color: theme.colorScheme.outline, fontSize: 12)),
                ],
              ),
              subtitle: Text(
                '${pair.meaningARu} vs ${pair.meaningBRu}\n${pair.distinctionNote}',
                style: theme.textTheme.bodySmall,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.volume_up_rounded),
                onPressed: () => cubit.playWord(pair.wordA),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => cubit.setStep(TrainerStep.ear),
            icon: const Icon(Icons.hearing_rounded),
            label: const Text('Перейти к тренировке слуха'),
          ),
        ),
      ],
    );
  }
}

class _EarSection extends StatelessWidget {
  final PhoneticsTrainerState state;

  const _EarSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<PhoneticsTrainerCubit>();
    final pair = state.currentPair;

    if (pair == null) {
      return const Center(child: Text('Нет доступных пар для тренировки'));
    }

    final isAnswered = state.earSelectedWord != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Минимальная пара ${state.currentPairIndex + 1} из ${state.currentExercise?.contrastPairs.length ?? 0}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
            ),
            TextButton.icon(
              onPressed: () => cubit.nextPair(),
              icon: const Icon(Icons.skip_next_rounded, size: 16),
              label: const Text('Другая пара'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
            child: Column(
              children: [
                IconButton.filled(
                  iconSize: 44,
                  icon: state.isPlayingAudio
                      ? const SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : const Icon(Icons.volume_up_rounded),
                  onPressed: () => cubit.playTargetAudio(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Нажми, чтобы послушать звук',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Какое слово из пары прозвучало?',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _ChoiceCard(
          word: pair.wordA,
          ipa: pair.ipaA,
          meaning: pair.meaningARu,
          isSelected: state.earSelectedWord == pair.wordA,
          isTarget: state.targetWord == pair.wordA,
          isAnswered: isAnswered,
          onTap: () => cubit.answerEarChoice(pair.wordA),
        ),
        const SizedBox(height: 12),
        _ChoiceCard(
          word: pair.wordB,
          ipa: pair.ipaB,
          meaning: pair.meaningBRu,
          isSelected: state.earSelectedWord == pair.wordB,
          isTarget: state.targetWord == pair.wordB,
          isAnswered: isAnswered,
          onTap: () => cubit.answerEarChoice(pair.wordB),
        ),
        if (isAnswered) ...[
          const SizedBox(height: 16),
          Card(
            color: state.earIsCorrect == true
                ? Colors.green.withValues(alpha: 0.15)
                : Colors.red.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        state.earIsCorrect == true
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: state.earIsCorrect == true ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.earIsCorrect == true ? 'Точно! Отличный слух.' : 'Не совсем!',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: state.earIsCorrect == true ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pair.distinctionNote,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => cubit.nextPair(),
                  child: const Text('Следующая пара'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => cubit.setStep(TrainerStep.mouth),
                  child: const Text('Попробовать сказать'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final String word;
  final String ipa;
  final String meaning;
  final bool isSelected;
  final bool isTarget;
  final bool isAnswered;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.word,
    required this.ipa,
    required this.meaning,
    required this.isSelected,
    required this.isTarget,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color? borderColor;
    Color? backgroundColor;

    if (isAnswered) {
      if (isTarget) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withValues(alpha: 0.1);
      } else if (isSelected) {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withValues(alpha: 0.1);
      }
    }

    return InkWell(
      onTap: isAnswered ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor ?? theme.colorScheme.outlineVariant,
            width: isSelected || (isAnswered && isTarget) ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$ipa • $meaning',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up_rounded),
              onPressed: () => context.read<PhoneticsTrainerCubit>().playWord(word),
            ),
          ],
        ),
      ),
    );
  }
}

class _MouthSection extends StatelessWidget {
  final PhoneticsTrainerState state;

  const _MouthSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<PhoneticsTrainerCubit>();
    final target = state.targetWord;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Произнеси слово вслух:',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 8),
                Text(
                  target,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => cubit.playTargetAudio(),
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text('Послушать эталон'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              SpeechWaveformIndicator(
                isActive: state.isRecording,
                height: 48,
                barCount: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTapDown: (_) => cubit.startMouthRecording(),
                onTapUp: (_) => cubit.stopMouthRecording(),
                onTapCancel: () => cubit.stopMouthRecording(),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.isRecording ? Colors.red : theme.colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: (state.isRecording ? Colors.red : theme.colorScheme.primary)
                            .withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    state.isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                state.isRecording ? 'Слушаю... Отпусти, чтобы завершить' : 'Зажми микрофон и говори',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: state.isRecording ? Colors.red : theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (state.spokenText != null && state.spokenText!.isNotEmpty) ...[
          Text(
            'Распознано: "${state.spokenText}"',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
        ],
        if (state.mouthScore != null) ...[
          Card(
            color: state.mouthScore! >= 70
                ? Colors.green.withValues(alpha: 0.15)
                : Colors.amber.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    '${state.mouthScore!.toStringAsFixed(0)}%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: state.mouthScore! >= 70 ? Colors.green : Colors.amber.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.mouthScore! >= 80
                        ? 'Отличный носовой резонанс!'
                        : state.mouthScore! >= 60
                            ? 'Хорошо! Попробуй направить чуть больше воздуха в нос.'
                            : 'Попробуй ещё раз, послушав эталон.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => cubit.nextPair(),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Следующая пара слов'),
          ),
        ],
      ],
    );
  }
}

class _DialectSection extends StatelessWidget {
  final PhoneticExercise exercise;

  const _DialectSection({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<PhoneticsTrainerCubit>();
    final dialect = exercise.dialectComparison;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Диалектный баттл: PT-BR vs PT-PT',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Слово: "${dialect.word}" (${dialect.meaningRu})',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🇧🇷', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      'Бразильский португальский (PT-BR)',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.volume_up_rounded),
                      onPressed: () => cubit.playWord(dialect.word, locale: 'pt-BR'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  dialect.noteBr,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🇵🇹', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      'Европейский португальский (PT-PT)',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.volume_up_rounded),
                      onPressed: () => cubit.playWord(dialect.word, locale: 'pt-PT'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  dialect.notePt,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
