import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/repositories/football_repository.dart';
import '../cubit/football_quiz_cubit.dart';
import '../cubit/football_quiz_state.dart';

class FootballQuizScreen extends StatelessWidget {
  const FootballQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FootballQuizCubit(
        repository: context.read<FootballRepository>(),
        audioService: context.read<HybridAudioPlaybackService>(),
      )..loadQuestions(),
      child: const _FootballQuizView(),
    );
  }
}

class _FootballQuizView extends StatelessWidget {
  const _FootballQuizView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<FootballQuizCubit, FootballQuizState>(
      builder: (context, state) {
        if (state.questions.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.isCompleted) {
          return Scaffold(
            appBar: AppBar(title: const Text('Результаты квиза')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🏆⚽', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    Text(
                      'Quiz da Pelada Concluído!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Вы набрали ${state.score} из ${state.questions.length} очков',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.score >= (state.questions.length * 0.75)
                          ? 'Parabéns, craque da bola! Вы виртуозно ориентируетесь в футбольном сленге Португалии и Бразилии!'
                          : 'Bom esforço! Футбольный португальский язык полон тонкостей, повторите термины и попробуйте снова.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.read<FootballQuizCubit>().restart(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Сыграть заново'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final q = state.currentQuestion;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Quiz da Pelada ⚽'),
            actions: [
              IconButton(
                icon: const Icon(Icons.volume_up_rounded),
                onPressed: () => context.read<FootballQuizCubit>().playQuestionAudio(),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Вопрос ${state.currentIndex + 1} из ${state.questions.length}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${q.dialectFlag} Счёт: ${state.score}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Question Box
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.questionPt,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          q.questionRu,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Options
                ...List.generate(q.optionsPt.length, (idx) {
                  final isSelected = state.selectedOptionIndex == idx;
                  final isCorrect = idx == q.correctOptionIndex;

                  Color? tileColor;
                  BorderSide borderSide = BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  );

                  if (state.isAnswered) {
                    if (isCorrect) {
                      tileColor = Colors.green.withValues(alpha: 0.15);
                      borderSide = const BorderSide(color: Colors.green, width: 2);
                    } else if (isSelected) {
                      tileColor = Colors.red.withValues(alpha: 0.15);
                      borderSide = const BorderSide(color: Colors.red, width: 2);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: state.isAnswered
                          ? null
                          : () {
                              HapticFeedback.lightImpact();
                              context.read<FootballQuizCubit>().selectOption(idx);
                            },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: tileColor ?? theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.fromBorderSide(borderSide),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: isSelected
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : theme.colorScheme.surfaceContainerHighest,
                              child: Text(
                                String.fromCharCode(65 + idx),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    q.optionsPt[idx],
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (q.optionsRu[idx] != q.optionsPt[idx])
                                    Text(
                                      q.optionsRu[idx],
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (state.isAnswered && isCorrect)
                              const Icon(Icons.check_circle_rounded, color: Colors.green),
                            if (state.isAnswered && isSelected && !isCorrect)
                              const Icon(Icons.cancel_rounded, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                if (state.isAnswered) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            q.explanationRu,
                            style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 60),
              ],
            ),
          ),
          bottomSheet: state.isAnswered
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: FilledButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.read<FootballQuizCubit>().nextQuestion();
                    },
                    child: Text(
                      state.isLastQuestion ? 'Посмотреть результат' : 'Следующий вопрос',
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
