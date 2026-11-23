import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/nature_repository.dart';
import '../cubit/eco_quiz_cubit.dart';
import '../cubit/eco_quiz_state.dart';

class EcoQuizScreen extends StatelessWidget {
  const EcoQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => EcoQuizCubit(
        repository: ctx.read<NatureRepository>(),
      )..loadQuizzes(),
      child: const _EcoQuizView(),
    );
  }
}

class _EcoQuizView extends StatelessWidget {
  const _EcoQuizView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Ecológico 🌿'),
        ),
        body: BlocBuilder<EcoQuizCubit, EcoQuizState>(
          builder: (context, state) {
            final cubit = context.read<EcoQuizCubit>();

            if (state.status == EcoQuizStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == EcoQuizStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
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

            if (state.status == EcoQuizStatus.completed) {
              final total = state.quizzes.length;
              final percent = total > 0 ? ((state.score / total) * 100).round() : 0;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🌱', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text(
                        'Эко-викторина пройдена!',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ваш результат: ${state.score} из $total ($percent%)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        percent >= 75
                            ? 'Отличные знания природы Португалии и Бразилии! Вы готовы к путешествию по диким тропам! 🎒'
                            : 'Хороший результат! Повторите маршруты и редкие виды в каталоге, чтобы закрепить материал.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => cubit.restart(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.questionPt,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          quiz.questionRu,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Options
                ...List.generate(quiz.optionsPt.length, (idx) {
                  final optionText = quiz.optionsPt[idx];
                  final isSelected = state.selectedOption == idx;
                  final isCorrectOption = idx == quiz.correctOptionIndex;

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

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: state.isAnswerChecked
                          ? null
                          : () => cubit.selectOption(idx),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: tileColor ?? colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: borderSide.color,
                            width: borderSide.width,
                          ),
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
                                String.fromCharCode(65 + idx),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                optionText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight:
                                      isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (state.isAnswerChecked && isCorrectOption)
                              const Icon(Icons.check_circle, color: Colors.green)
                            else if (state.isAnswerChecked && isSelected)
                              const Icon(Icons.cancel, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Explanation
                if (state.isAnswerChecked) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: state.isCorrect
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: state.isCorrect
                            ? Colors.green.shade300
                            : Colors.amber.shade300,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.isCorrect ? '✅' : '💡',
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            quiz.explanationRu,
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Button
                if (!state.isAnswerChecked)
                  FilledButton(
                    onPressed: state.selectedOption != null
                        ? () => cubit.checkAnswer()
                        : null,
                    child: const Text('Проверить ответ'),
                  )
                else
                  FilledButton.icon(
                    onPressed: () => cubit.nextQuestion(),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      state.isLastQuestion ? 'Посмотреть итог' : 'Следующий вопрос',
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
