import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/architecture_repository.dart';
import '../cubit/architecture_quiz_cubit.dart';
import '../cubit/architecture_quiz_state.dart';

class ArchitectureQuizScreen extends StatelessWidget {
  const ArchitectureQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ArchitectureQuizCubit(
        repository: ctx.read<ArchitectureRepository>(),
      )..loadQuizzes(),
      child: const _ArchitectureQuizView(),
    );
  }
}

class _ArchitectureQuizView extends StatelessWidget {
  const _ArchitectureQuizView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz do Arquiteto 🏛️'),
        ),
        body: BlocBuilder<ArchitectureQuizCubit, ArchitectureQuizState>(
          builder: (context, state) {
            final cubit = context.read<ArchitectureQuizCubit>();

            if (state.status == ArchitectureQuizStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ArchitectureQuizStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(state.errorMessage ?? 'Ошибка викторины'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => cubit.loadQuizzes(),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.status == ArchitectureQuizStatus.completed) {
              final total = state.quizzes.length;
              final percent =
                  total > 0 ? ((state.score / total) * 100).round() : 0;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🏛️', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text(
                        'Архитектурная викторина завершена!',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ваш результат: ${state.score} из $total ($percent%)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        percent >= 75
                            ? 'Parabéns! Вы превосходно разбираетесь в архитектуре Бразилии и Португалии: от мануэлино и барокко до модернизма Нимейера!'
                            : 'Хорошая попытка! Освежите в памяти конструктивные особенности и термины в каталоге памятников и попробуйте снова.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => cubit.restartQuiz(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Пройти заново'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final quiz = state.currentQuiz;
            if (quiz == null) {
              return const SizedBox.shrink();
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                LinearProgressIndicator(
                  value: (state.currentIndex + 1) / state.quizzes.length,
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Вопрос ${state.currentIndex + 1} из ${state.quizzes.length}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Баллы: ${state.score}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Question Card
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      quiz.question,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Options
                ...List.generate(quiz.options.length, (idx) {
                  final optionText = quiz.options[idx];
                  final isSelected = state.selectedOption == idx;
                  final isCorrectOption = idx == quiz.correctIndex;

                  Color? tileColor;
                  BorderSide borderSide = BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  );

                  if (state.isAnswerChecked) {
                    if (isCorrectOption) {
                      tileColor = Colors.green.withValues(alpha: 0.15);
                      borderSide = const BorderSide(color: Colors.green, width: 1.5);
                    } else if (isSelected) {
                      tileColor = Colors.red.withValues(alpha: 0.15);
                      borderSide = const BorderSide(color: Colors.red, width: 1.5);
                    }
                  } else if (isSelected) {
                    tileColor = colorScheme.primaryContainer.withValues(alpha: 0.3);
                    borderSide = BorderSide(color: colorScheme.primary, width: 1.5);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: tileColor ?? Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: borderSide,
                      ),
                      child: InkWell(
                        onTap: state.isAnswerChecked
                            ? null
                            : () => cubit.selectOption(idx),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.surfaceContainerHighest,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  String.fromCharCode(65 + idx), // A, B, C, D
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: isSelected
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  optionText,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (state.isAnswerChecked && isCorrectOption)
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 20)
                              else if (state.isAnswerChecked && isSelected)
                                const Icon(Icons.cancel,
                                    color: Colors.red, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Explanation & Action Button
                if (state.isAnswerChecked) ...[
                  Card(
                    elevation: 0,
                    color: state.isCorrect
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: state.isCorrect
                            ? Colors.green.withValues(alpha: 0.3)
                            : Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                state.isCorrect
                                    ? Icons.check_circle_outline
                                    : Icons.info_outline,
                                color: state.isCorrect
                                    ? Colors.green
                                    : Colors.orange.shade800,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                state.isCorrect ? 'Correto!' : 'Explicação:',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: state.isCorrect
                                      ? Colors.green
                                      : Colors.orange.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            quiz.explanation,
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => cubit.nextQuestion(),
                    child: Text(
                      state.isLastQuestion
                          ? 'Завершить викторину'
                          : 'Следующий вопрос',
                    ),
                  ),
                ] else ...[
                  FilledButton(
                    onPressed: state.selectedOption == null
                        ? null
                        : () => cubit.checkAnswer(),
                    child: const Text('Проверить ответ'),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
