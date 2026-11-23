import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/wine_repository.dart';
import '../cubit/wine_quiz_cubit.dart';
import '../cubit/wine_quiz_state.dart';

class WineQuizScreen extends StatelessWidget {
  const WineQuizScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const WineQuizScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => WineQuizCubit(
        repository: ctx.read<WineRepository>(),
      )..loadQuizzes(),
      child: const _WineQuizView(),
    );
  }
}

class _WineQuizView extends StatelessWidget {
  const _WineQuizView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Квиз: Вина, Оливки & Эногастрономия'),
          centerTitle: false,
        ),
        body: BlocBuilder<WineQuizCubit, WineQuizState>(
          builder: (context, state) {
            if (state.status == WineQuizStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == WineQuizStatus.error) {
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
                            context.read<WineQuizCubit>().loadQuizzes(),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.status == WineQuizStatus.completed) {
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
                          const Text('🍷', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 12),
                          Text(
                            'Викторина завершена!',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Твой результат: ${state.score} из ${state.totalQuestions} ($percentage%)',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: state.score / state.totalQuestions,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            percentage >= 80
                                ? 'Sensacional! Parabéns, você tem o paladar e conhecimento de um verdadeiro Sommelier lusófono!'
                                : percentage >= 50
                                    ? 'Muito bem! Bom conhecimento de terroirs, castas e Subjuntivo enológico.'
                                    : 'Vale a pena degustar mais: reveja os terroirs do Douro, Alentejo e Vale dos Vinhedos!',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () =>
                                context.read<WineQuizCubit>().restartQuiz(),
                            icon: const Icon(Icons.replay_rounded),
                            label: const Text('Пройти заново'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            final currentQuiz = state.currentQuiz;
            if (currentQuiz == null) {
              return const Center(child: Text('Нет доступных вопросов'));
            }

            final progress = (state.currentIndex + 1) / state.totalQuestions;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Вопрос ${state.currentIndex + 1} из ${state.totalQuestions}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Баллы: ${state.score}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade800.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.wine_bar_rounded,
                                  size: 20,
                                  color: Colors.purple.shade800,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Enogastronomia & Terroir',
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
                            currentQuiz.question,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(currentQuiz.options.length, (index) {
                    final isSelected = state.selectedOption == index;
                    final isCorrect = index == currentQuiz.correctIndex;

                    Color? tileColor;
                    BorderSide borderSide = BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                    );

                    if (state.isAnswerChecked) {
                      if (isCorrect) {
                        tileColor = Colors.green.shade50;
                        borderSide = const BorderSide(color: Colors.green, width: 2);
                      } else if (isSelected) {
                        tileColor = Colors.red.shade50;
                        borderSide = const BorderSide(color: Colors.red, width: 2);
                      }
                    } else if (isSelected) {
                      tileColor = colorScheme.primaryContainer.withValues(alpha: 0.4);
                      borderSide = BorderSide(color: colorScheme.primary, width: 2);
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: state.isAnswerChecked
                            ? null
                            : () =>
                                context.read<WineQuizCubit>().selectOption(index),
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: tileColor ?? colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.fromBorderSide(borderSide),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
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
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  currentQuiz.options[index],
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (state.isAnswerChecked)
                                if (isCorrect)
                                  const Icon(Icons.check_circle_rounded,
                                      color: Colors.green)
                                else if (isSelected)
                                  const Icon(Icons.cancel_rounded,
                                      color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  if (state.isAnswerChecked) ...[
                    Card(
                      elevation: 0,
                      color: Colors.amber.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.amber.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb_rounded,
                                color: Colors.amber.shade900),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Объяснение сомелье & Грамматика',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade900,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currentQuiz.explanation,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.amber.shade900,
                                      height: 1.35,
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
                  ],
                  FilledButton(
                    onPressed: state.selectedOption == null
                        ? null
                        : () {
                            if (!state.isAnswerChecked) {
                              context.read<WineQuizCubit>().checkAnswer();
                            } else {
                              context.read<WineQuizCubit>().nextQuestion();
                            }
                          },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      !state.isAnswerChecked
                          ? 'Проверить ответ'
                          : state.isLastQuestion
                              ? 'Завершить квиз'
                              : 'Следующий вопрос',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
