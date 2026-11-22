import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/idioms_cubit.dart';
import '../cubit/idioms_state.dart';

class IdiomQuizView extends StatelessWidget {
  const IdiomQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<IdiomsCubit, IdiomsState>(
      builder: (context, state) {
        final cubit = context.read<IdiomsCubit>();

        if (state.status == IdiomsStatus.quizFinished) {
          return _QuizFinishedCard(
            total: state.quizChallenges.length,
            correct: state.quizCorrectAnswers,
            onRestart: () => cubit.startQuiz(),
            onExit: () => cubit.exitQuiz(),
            theme: theme,
          );
        }

        final challenge = state.currentChallenge;
        if (challenge == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final isAnswered = state.selectedQuizAnswerIndex != null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _QuizHeaderBar(
                currentIndex: state.currentQuizIndex + 1,
                totalCount: state.quizChallenges.length,
                correctCount: state.quizCorrectAnswers,
                onExit: () => cubit.exitQuiz(),
                theme: theme,
              ),
              const SizedBox(height: 16),
              _QuizQuestionCard(
                challenge: challenge,
                theme: theme,
              ),
              const SizedBox(height: 20),
              ...List.generate(challenge.optionsRu.length, (index) {
                final option = challenge.optionsRu[index];
                final isSelected = state.selectedQuizAnswerIndex == index;
                final isCorrectOption = index == challenge.correctIndex;

                return _QuizOptionTile(
                  text: option,
                  isSelected: isSelected,
                  isCorrectOption: isCorrectOption,
                  isAnswered: isAnswered,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    cubit.answerQuiz(index);
                  },
                  theme: theme,
                );
              }),
              if (isAnswered) ...[
                const SizedBox(height: 16),
                _QuizAnswerFeedbackCard(
                  idiom: challenge.idiom,
                  isCorrect: state.selectedQuizAnswerIndex == challenge.correctIndex,
                  theme: theme,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    cubit.nextQuizQuestion();
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(
                    state.currentQuizIndex < state.quizChallenges.length - 1
                        ? 'Следующий вопрос'
                        : 'Завершить квиз 🏁',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _QuizHeaderBar extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final int correctCount;
  final VoidCallback onExit;
  final ThemeData theme;

  const _QuizHeaderBar({
    required this.currentIndex,
    required this.totalCount,
    required this.correctCount,
    required this.onExit,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Вопрос $currentIndex из $totalCount',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Верно: $correctCount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: onExit,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuizQuestionCard extends StatelessWidget {
  final dynamic challenge; // IdiomQuizChallenge
  final ThemeData theme;

  const _QuizQuestionCard({
    required this.challenge,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(challenge.idiom.illustrationEmoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 10),
          Text(
            challenge.idiom.expressionPt,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Дословно: «${challenge.idiom.literalTranslationRu}»',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Что на самом деле означает это выражение?',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _QuizOptionTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrectOption;
  final bool isAnswered;
  final VoidCallback onTap;
  final ThemeData theme;

  const _QuizOptionTile({
    required this.text,
    required this.isSelected,
    required this.isCorrectOption,
    required this.isAnswered,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = theme.colorScheme.surfaceContainerHighest;
    Color border = theme.colorScheme.outlineVariant;
    Color textCol = theme.colorScheme.onSurface;

    if (isAnswered) {
      if (isCorrectOption) {
        bg = Colors.green.withValues(alpha: 0.2);
        border = Colors.green.shade600;
        textCol = Colors.green.shade900;
      } else if (isSelected) {
        bg = Colors.red.withValues(alpha: 0.15);
        border = Colors.red.shade600;
        textCol = Colors.red.shade900;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isAnswered ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: isAnswered && (isCorrectOption || isSelected) ? 2 : 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textCol,
                  ),
                ),
              ),
              if (isAnswered && isCorrectOption)
                Icon(Icons.check_circle_rounded, color: Colors.green.shade700, size: 20),
              if (isAnswered && isSelected && !isCorrectOption)
                Icon(Icons.cancel_rounded, color: Colors.red.shade700, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizAnswerFeedbackCard extends StatelessWidget {
  final dynamic idiom;
  final bool isCorrect;
  final ThemeData theme;

  const _QuizAnswerFeedbackCard({
    required this.idiom,
    required this.isCorrect,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? Colors.green : Colors.orange.shade800;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isCorrect ? Icons.stars_rounded : Icons.info_outline_rounded, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Corretíssimo! Отлично!' : 'Не совсем, но теперь вы знаете!',
                style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            idiom.originStoryRu,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _QuizFinishedCard extends StatelessWidget {
  final int total;
  final int correct;
  final VoidCallback onRestart;
  final VoidCallback onExit;
  final ThemeData theme;

  const _QuizFinishedCard({
    required this.total,
    required this.correct,
    required this.onRestart,
    required this.onExit,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total > 0 ? (correct / total * 100).round() : 0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              'Квиз завершён!',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Вы правильно поняли $correct из $total идиом ($percent%)',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRestart,
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Сыграть ещё раунд'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onExit,
              child: const Text('В каталог идиом'),
            ),
          ],
        ),
      ),
    );
  }
}
