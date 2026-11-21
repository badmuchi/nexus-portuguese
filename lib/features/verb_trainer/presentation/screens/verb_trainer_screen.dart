import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/verb_exercise.dart';
import '../../domain/entities/verb_trainer_config.dart';
import '../cubit/verb_trainer_cubit.dart';
import '../cubit/verb_trainer_state.dart';
import '../widgets/verb_session_summary_card.dart';
import '../widgets/verb_trainer_config_sheet.dart';

class VerbTrainerScreen extends StatefulWidget {
  final VerbTrainerConfig initialConfig;

  const VerbTrainerScreen({
    super.key,
    this.initialConfig = const VerbTrainerConfig(mode: TrainerMode.sprint60),
  });

  @override
  State<VerbTrainerScreen> createState() => _VerbTrainerScreenState();
}

class _VerbTrainerScreenState extends State<VerbTrainerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VerbTrainerCubit>().startSession(widget.initialConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VerboSprint ⚡️'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Настройки режима',
            onPressed: () {
              VerbTrainerConfigSheet.show(
                context,
                initialConfig: widget.initialConfig,
                onStart: (newConfig) {
                  context.read<VerbTrainerCubit>().startSession(newConfig);
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<VerbTrainerCubit, VerbTrainerState>(
        builder: (context, state) {
          if (state is VerbTrainerLoading || state is VerbTrainerInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VerbTrainerError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.read<VerbTrainerCubit>().startSession(widget.initialConfig);
                      },
                      child: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is VerbTrainerCompleted) {
            return VerbSessionSummaryCard(
              result: state.result,
              onRetry: () {
                context.read<VerbTrainerCubit>().startSession(state.result.mode == TrainerMode.sprint60
                    ? const VerbTrainerConfig(mode: TrainerMode.sprint60)
                    : widget.initialConfig);
              },
              onReconfigure: () {
                VerbTrainerConfigSheet.show(
                  context,
                  initialConfig: widget.initialConfig,
                  onStart: (newConfig) {
                    context.read<VerbTrainerCubit>().startSession(newConfig);
                  },
                );
              },
            );
          }

          if (state is VerbTrainerActive) {
            return _ActiveTrainerView(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ActiveTrainerView extends StatelessWidget {
  final VerbTrainerActive state;

  const _ActiveTrainerView({required this.state});

  @override
  Widget build(BuildContext context) {
    final currentEx = state.currentExercise;

    return Column(
      children: [
        _TopStatsHeader(
          remainingSeconds: state.remainingSeconds,
          currentIndex: state.currentIndex,
          totalQuestions: state.totalQuestions,
          scorePoints: state.scorePoints,
          currentStreak: state.currentStreak,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _VerbPromptCard(
                  exercise: currentEx,
                  isPlayingAudio: state.isPlayingAudio,
                  onPlayAudio: () => context.read<VerbTrainerCubit>().playCurrentAudio(),
                ),
                const SizedBox(height: 24),
                // 4 option buttons (2x2 grid for tap efficiency)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.1,
                  children: currentEx.options.map((option) {
                    final isSelected = state.selectedOption == option;
                    final isCorrect = option == currentEx.correctForm;

                    return _OptionButton(
                      optionText: option,
                      isSelected: isSelected,
                      isChecked: state.isChecked,
                      isCorrect: isCorrect,
                      onTap: () {
                        if (!state.isChecked) {
                          context.read<VerbTrainerCubit>().selectOption(option);
                        }
                      },
                    );
                  }).toList(),
                ),
                if (state.isChecked) ...[
                  const SizedBox(height: 16),
                  _ExplanationFooter(
                    isCorrect: state.isCurrentCorrect ?? false,
                    explanationRu: currentEx.explanationRu,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (state.isChecked)
          _BottomControlBar(
            isLast: state.isLastQuestion || state.remainingSeconds == 0,
            onNext: () => context.read<VerbTrainerCubit>().nextExercise(),
          ),
      ],
    );
  }
}

class _TopStatsHeader extends StatelessWidget {
  final int? remainingSeconds;
  final int currentIndex;
  final int totalQuestions;
  final int scorePoints;
  final int currentStreak;

  const _TopStatsHeader({
    required this.remainingSeconds,
    required this.currentIndex,
    required this.totalQuestions,
    required this.scorePoints,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSprint = remainingSeconds != null;

    final timerColor = (remainingSeconds ?? 60) <= 15 ? Colors.redAccent : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isSprint)
            Row(
              children: [
                Icon(Icons.timer_outlined, color: timerColor, size: 20),
                const SizedBox(width: 6),
                Text(
                  '$remainingSeconds с',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: timerColor,
                  ),
                ),
              ],
            )
          else
            Text(
              '${currentIndex + 1} из $totalQuestions',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          Row(
            children: [
              if (currentStreak >= 2) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.deepOrange.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.deepOrange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'x$currentStreak',
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$scorePoints pts',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerbPromptCard extends StatelessWidget {
  final VerbExercise exercise;
  final bool isPlayingAudio;
  final VoidCallback onPlayAudio;

  const _VerbPromptCard({
    required this.exercise,
    required this.isPlayingAudio,
    required this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
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
                  color: exercise.isIrregular
                      ? Colors.orange.withValues(alpha: 0.15)
                      : Colors.teal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  exercise.isIrregular ? 'Неправильный' : 'Правильный',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: exercise.isIrregular ? Colors.deepOrange : Colors.teal,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlayingAudio ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                  color: theme.colorScheme.primary,
                ),
                onPressed: isPlayingAudio ? null : onPlayAudio,
                tooltip: 'Прослушать произношение',
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            exercise.infinitive.toUpperCase(),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            exercise.russianMeaning,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Местоимение',
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      exercise.person.pronounDisplay,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: theme.colorScheme.outlineVariant,
                ),
                Column(
                  children: [
                    Text(
                      'Время',
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      exercise.tense.labelPt,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final bool isChecked;
  final bool isCorrect;
  final VoidCallback onTap;

  const _OptionButton({
    required this.optionText,
    required this.isSelected,
    required this.isChecked,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.6);
    Color backgroundColor = theme.colorScheme.surface;
    Color textColor = theme.colorScheme.onSurface;

    if (isChecked) {
      if (isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withValues(alpha: 0.15);
        textColor = Colors.green.shade800;
      } else if (isSelected) {
        borderColor = Colors.redAccent;
        backgroundColor = Colors.redAccent.withValues(alpha: 0.15);
        textColor = Colors.redAccent.shade700;
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isChecked && (isCorrect || isSelected) ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            optionText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _ExplanationFooter extends StatelessWidget {
  final bool isCorrect;
  final String explanationRu;

  const _ExplanationFooter({
    required this.isCorrect,
    required this.explanationRu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isCorrect ? Colors.green : Colors.deepOrange;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.info_outline_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              explanationRu,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.3,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomControlBar extends StatelessWidget {
  final bool isLast;
  final VoidCallback onNext;

  const _BottomControlBar({
    required this.isLast,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton.icon(
            onPressed: onNext,
            icon: Icon(isLast ? Icons.done_all_rounded : Icons.arrow_forward_rounded),
            label: Text(
              isLast ? 'Завершить тренировку' : 'Следующий глагол',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ),
    );
  }
}
