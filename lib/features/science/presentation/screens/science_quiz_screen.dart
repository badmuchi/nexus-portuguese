import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/science_repository.dart';
import '../cubit/science_quiz_cubit.dart';
import '../cubit/science_quiz_state.dart';

class ScienceQuizScreen extends StatelessWidget {
  const ScienceQuizScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ScienceQuizScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ScienceQuizCubit(
        repository: ctx.read<ScienceRepository>(),
      )..loadQuizzes(),
      child: const _ScienceQuizView(),
    );
  }
}

class _ScienceQuizView extends StatelessWidget {
  const _ScienceQuizView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Квиз: Наука & Океанография'),
          centerTitle: false,
        ),
        body: BlocBuilder<ScienceQuizCubit, ScienceQuizState>(
          builder: (context, state) {
            if (state.status == ScienceQuizStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ScienceQuizStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 48, color: colorScheme.error),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage ?? 'Ошибка викторины',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () =>
                            context.read<ScienceQuizCubit>().loadQuizzes(),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.status == ScienceQuizStatus.completed) {
              final percentage = (state.score / state.totalQuestions * 100).round();
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔬', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 12),
                          Text(
                            'Тестирование завершено!',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Твой результат: ${state.score} из ${state.totalQuestions} ($percentage%)',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            percentage >= 80
                                ? 'Великолепно! Ты прекрасно владеешь научной терминологией и пассивным залогом португальского языка! 🌊'
                                : 'Хороший результат! Повтори эксперименты и лексику, чтобы закрепить понимание научных конструкций.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            icon: const Icon(Icons.replay_rounded),
                            label: const Text('Пройти заново'),
                            onPressed: () =>
                                context.read<ScienceQuizCubit>().restartQuiz(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            final quiz = state.currentQuiz;
            if (quiz == null) {
              return const Center(child: Text('Нет доступных вопросов'));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator & counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Вопрос ${state.currentIndex + 1} из ${state.totalQuestions}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Очки: ${state.score}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (state.currentIndex + 1) / state.totalQuestions,
                    borderRadius: BorderRadius.circular(8),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question card
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(
                                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        quiz.accentEmoji,
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          quiz.contextField,
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    quiz.question,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Options
                          ...List.generate(quiz.options.length, (index) {
                            final isSelected = state.selectedOption == index;
                            final isCorrect = index == quiz.correctIndex;

                            Color? tileColor;
                            BorderSide side = BorderSide(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                            );

                            if (state.isAnswerChecked) {
                              if (isCorrect) {
                                tileColor = Colors.green.withValues(alpha: 0.15);
                                side = const BorderSide(color: Colors.green, width: 1.5);
                              } else if (isSelected && !isCorrect) {
                                tileColor = colorScheme.error.withValues(alpha: 0.15);
                                side = BorderSide(color: colorScheme.error, width: 1.5);
                              }
                            } else if (isSelected) {
                              tileColor = colorScheme.primaryContainer.withValues(alpha: 0.4);
                              side = BorderSide(color: colorScheme.primary, width: 1.5);
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: tileColor ?? colorScheme.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.fromBorderSide(side),
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                onTap: () => context
                                    .read<ScienceQuizCubit>()
                                    .selectOption(index),
                                leading: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.surfaceContainerHighest,
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  quiz.options[index],
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: isSelected ? FontWeight.w600 : null,
                                  ),
                                ),
                                trailing: state.isAnswerChecked
                                    ? (isCorrect
                                        ? const Icon(Icons.check_circle_rounded,
                                            color: Colors.green)
                                        : (isSelected
                                            ? Icon(Icons.cancel_rounded,
                                                color: colorScheme.error)
                                            : null))
                                    : null,
                              ),
                            );
                          }),

                          // Explanation box
                          if (state.isAnswerChecked) ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info_outline_rounded,
                                      size: 20, color: colorScheme.primary),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      quiz.explanation,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Bottom action button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: state.isAnswerChecked
                          ? FilledButton(
                              onPressed: () => context
                                  .read<ScienceQuizCubit>()
                                  .nextQuestion(),
                              child: Text(state.isLastQuestion
                                  ? 'Смотреть результат'
                                  : 'Следующий вопрос'),
                            )
                          : FilledButton(
                              onPressed: state.selectedOption == null
                                  ? null
                                  : () => context
                                      .read<ScienceQuizCubit>()
                                      .checkAnswer(),
                              child: const Text('Проверить ответ'),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
