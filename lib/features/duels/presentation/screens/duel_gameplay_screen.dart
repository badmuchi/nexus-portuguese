import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/duels_cubit.dart';
import '../cubit/duels_state.dart';
import '../widgets/dialect_comparison_card.dart';
import '../widgets/duel_option_button.dart';
import '../widgets/duel_timer_bar.dart';
import 'duel_result_screen.dart';

class DuelGameplayScreen extends StatelessWidget {
  const DuelGameplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<DuelsCubit, DuelsState>(
      listener: (context, state) {
        if (state.status == DuelsStatus.completed && state.sessionResult != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<DuelsCubit>(),
                child: DuelResultScreen(result: state.sessionResult!),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<DuelsCubit>();
        final question = state.currentQuestion;

        if (question == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isAnswered = state.status == DuelsStatus.answered;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: _GameplayHeader(
              currentIndex: state.currentIndex + 1,
              totalCount: state.questions.length,
              score: state.score,
              streak: state.currentStreak,
              comboMultiplier: state.comboMultiplier,
              theme: theme,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  cubit.resetToLobby();
                  Navigator.pop(context);
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(6),
              child: LinearProgressIndicator(
                value: state.progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isAnswered)
                  DuelTimerBar(remainingSeconds: state.remainingSeconds),
                const SizedBox(height: 14),
                _QuestionHeaderCard(
                  categoryLabel: '${question.category.emoji} ${question.category.labelRu}',
                  targetFlag: question.targetDialectFlag,
                  targetLabel: question.targetDialectLabel,
                  questionTitle: question.questionTitle,
                  promptRu: question.promptRu,
                  theme: theme,
                ),
                const SizedBox(height: 20),
                ...List.generate(question.options.length, (index) {
                  final optionText = question.options[index];
                  final isSelected = state.selectedAnswerIndex == index;
                  final isCorrectOption = index == question.correctIndex;

                  return DuelOptionButton(
                    index: index,
                    text: optionText,
                    isSelected: isSelected,
                    isAnswered: isAnswered,
                    isCorrectOption: isCorrectOption,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      cubit.selectAnswer(index);
                    },
                  );
                }),
                if (isAnswered) ...[
                  DialectComparisonCard(
                    question: question,
                    onPlayPtPt: () => cubit.playOptionPronunciation(question.ptPtEquivalent, isPtPt: true),
                    onPlayPtBr: () => cubit.playOptionPronunciation(question.ptBrEquivalent, isPtPt: false),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      cubit.nextQuestion();
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      state.currentIndex < state.questions.length - 1
                          ? 'Следующий вопрос'
                          : 'Посмотреть итоги дуэли 🏆',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GameplayHeader extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final int score;
  final int streak;
  final int comboMultiplier;
  final ThemeData theme;

  const _GameplayHeader({
    required this.currentIndex,
    required this.totalCount,
    required this.score,
    required this.streak,
    required this.comboMultiplier,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Раунд $currentIndex / $totalCount',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            if (streak >= 3) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${comboMultiplier}x 🔥',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '⚡ $score',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuestionHeaderCard extends StatelessWidget {
  final String categoryLabel;
  final String targetFlag;
  final String targetLabel;
  final String questionTitle;
  final String promptRu;
  final ThemeData theme;

  const _QuestionHeaderCard({
    required this.categoryLabel,
    required this.targetFlag,
    required this.targetLabel,
    required this.questionTitle,
    required this.promptRu,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(targetFlag, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      targetLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            promptRu,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
