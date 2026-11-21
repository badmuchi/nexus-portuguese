import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/assessment_cubit.dart';
import '../cubit/assessment_state.dart';
import '../widgets/level_certificate_card.dart';

class LevelAssessmentScreen extends StatelessWidget {
  const LevelAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Диагностика CEFR'),
      ),
      body: BlocBuilder<AssessmentCubit, AssessmentState>(
        builder: (context, state) {
          if (state is AssessmentLoading || state is AssessmentInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssessmentError) {
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
                      onPressed: () => context.read<AssessmentCubit>().loadAssessment(),
                      child: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is AssessmentCompleted) {
            return LevelCertificateCard(
              result: state.result,
              onRetake: () => context.read<AssessmentCubit>().startNewAssessment(),
            );
          }

          if (state is AssessmentActive) {
            return _ActiveQuizView(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ActiveQuizView extends StatelessWidget {
  final AssessmentActive state;

  const _ActiveQuizView({required this.state});

  @override
  Widget build(BuildContext context) {
    final q = state.currentQuestion;

    return Column(
      children: [
        _QuestionProgressHeader(
          currentIndex: state.currentIndex,
          totalQuestions: state.totalQuestions,
          progressPercent: state.progressPercent,
          skillTitleRu: q.skill.titleRu,
          levelLabel: q.level.label,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _QuestionCard(
                  prompt: q.prompt,
                  audioText: q.audioText,
                  dialect: q.dialect,
                  isPlayingAudio: state.isPlayingAudio,
                  onPlayAudio: q.audioText != null
                      ? () => context.read<AssessmentCubit>().playAudio(q.audioText!)
                      : null,
                ),
                const SizedBox(height: 20),
                ...List.generate(q.options.length, (index) {
                  final optionText = q.options[index];
                  final isSelected = state.selectedOptionIndex == index;
                  final isCorrectOption = index == q.correctOptionIndex;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _OptionTile(
                      index: index,
                      text: optionText,
                      isSelected: isSelected,
                      isSubmitted: state.isSubmitted,
                      isCorrectOption: isCorrectOption,
                      onTap: () {
                        if (!state.isSubmitted) {
                          context.read<AssessmentCubit>().selectOption(index);
                        }
                      },
                    ),
                  );
                }),
                if (state.isSubmitted) ...[
                  const SizedBox(height: 12),
                  _ExplanationBox(
                    isCorrect: state.isCurrentCorrect ?? false,
                    explanationRu: q.explanationRu,
                  ),
                ],
              ],
            ),
          ),
        ),
        _BottomActionBar(
          isSubmitted: state.isSubmitted,
          isLastQuestion: state.isLastQuestion,
          canSubmit: state.selectedOptionIndex != null,
          onSubmit: () => context.read<AssessmentCubit>().submitAnswer(),
          onNext: () => context.read<AssessmentCubit>().nextQuestion(),
        ),
      ],
    );
  }
}

class _QuestionProgressHeader extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final double progressPercent;
  final String skillTitleRu;
  final String levelLabel;

  const _QuestionProgressHeader({
    required this.currentIndex,
    required this.totalQuestions,
    required this.progressPercent,
    required this.skillTitleRu,
    required this.levelLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        LinearProgressIndicator(
          value: progressPercent,
          minHeight: 6,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Вопрос ${currentIndex + 1} из $totalQuestions',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      skillTitleRu,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      levelLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final String prompt;
  final String? audioText;
  final String dialect;
  final bool isPlayingAudio;
  final VoidCallback? onPlayAudio;

  const _QuestionCard({
    required this.prompt,
    this.audioText,
    required this.dialect,
    required this.isPlayingAudio,
    this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dialect != 'all') ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                dialect == 'pt-PT' ? '🇵🇹 PT-PT (Европейский)' : '🇧🇷 PT-BR (Бразильский)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            prompt,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          if (audioText != null) ...[
            const SizedBox(height: 14),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: isPlayingAudio ? null : onPlayAudio,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPlayingAudio ? Icons.volume_up_rounded : Icons.play_circle_fill_rounded,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Прослушать фразу',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isSubmitted;
  final bool isCorrectOption;
  final VoidCallback onTap;

  const _OptionTile({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isSubmitted,
    required this.isCorrectOption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const letters = ['A', 'B', 'C', 'D'];
    final letter = index < letters.length ? letters[index] : '${index + 1}';

    Color borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.7);
    Color backgroundColor = theme.colorScheme.surface;
    Widget? trailingIcon;

    if (isSubmitted) {
      if (isCorrectOption) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withValues(alpha: 0.12);
        trailingIcon = const Icon(Icons.check_circle_rounded, color: Colors.green);
      } else if (isSelected && !isCorrectOption) {
        borderColor = Colors.redAccent;
        backgroundColor = Colors.redAccent.withValues(alpha: 0.12);
        trailingIcon = const Icon(Icons.cancel_rounded, color: Colors.redAccent);
      }
    } else if (isSelected) {
      borderColor = theme.colorScheme.primary;
      backgroundColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.4);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected || (isSubmitted && isCorrectOption) ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );
  }
}

class _ExplanationBox extends StatelessWidget {
  final bool isCorrect;
  final String explanationRu;

  const _ExplanationBox({
    required this.isCorrect,
    required this.explanationRu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isCorrect ? Colors.green : Colors.deepOrange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.info_outline_rounded,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Верно!' : 'Правило:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  explanationRu,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.35,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final bool isSubmitted;
  final bool isLastQuestion;
  final bool canSubmit;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  const _BottomActionBar({
    required this.isSubmitted,
    required this.isLastQuestion,
    required this.canSubmit,
    required this.onSubmit,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: isSubmitted
              ? FilledButton(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    isLastQuestion ? 'Завершить тест и узнать уровень' : 'Следующий вопрос',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              : FilledButton(
                  onPressed: canSubmit ? onSubmit : null,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Проверить ответ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
        ),
      ),
    );
  }
}
