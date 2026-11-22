import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/repositories/travel_guide_repository.dart';
import '../cubit/geography_quiz_cubit.dart';
import '../cubit/geography_quiz_state.dart';
import '../widgets/passport_stamp_badge.dart';

class GeographyQuizScreen extends StatelessWidget {
  const GeographyQuizScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const GeographyQuizScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => GeographyQuizCubit(
        repository: ctx.read<TravelGuideRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      )..loadQuestions(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Викторина: Паспорт Лузофонии 🛂',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          actions: [
            BlocBuilder<GeographyQuizCubit, GeographyQuizState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Начать сначала',
                  onPressed: () => context.read<GeographyQuizCubit>().restart(),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<GeographyQuizCubit, GeographyQuizState>(
          builder: (context, state) {
            if (state.questions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isCompleted) {
              return _buildCompletionView(context, state);
            }

            final q = state.currentQuestion;

            return Column(
              children: [
                LinearProgressIndicator(
                  value: state.progress,
                  minHeight: 4,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Вопрос ${state.currentIndex + 1} из ${state.questions.length}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Баллы: ${state.score}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Question card
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(q.flagEmoji, style: const TextStyle(fontSize: 28)),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.volume_up_rounded),
                                    tooltip: 'Озвучить вопрос',
                                    onPressed: () => context.read<GeographyQuizCubit>().playQuestionAudio(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                q.questionPt,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                q.questionRu,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Options
                        ...List.generate(q.optionsPt.length, (index) {
                          final optPt = q.optionsPt[index];
                          final optRu = q.optionsRu[index];
                          final isSelected = state.selectedOptionIndex == index;
                          final isCorrect = index == q.correctOptionIndex;

                          Color? cardColor;
                          BorderSide borderSide = BorderSide(color: Theme.of(context).colorScheme.outlineVariant);

                          if (state.isAnswered) {
                            if (isCorrect) {
                              cardColor = Colors.green.withValues(alpha: 0.15);
                              borderSide = const BorderSide(color: Colors.green, width: 2);
                            } else if (isSelected) {
                              cardColor = Colors.red.withValues(alpha: 0.15);
                              borderSide = const BorderSide(color: Colors.red, width: 2);
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => context.read<GeographyQuizCubit>().selectOption(index),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: cardColor ?? Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.fromBorderSide(borderSide),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: state.isAnswered && isCorrect
                                            ? Colors.green
                                            : (state.isAnswered && isSelected
                                                ? Colors.red
                                                : Theme.of(context).colorScheme.surfaceContainerHighest),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(65 + index),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: state.isAnswered && (isCorrect || isSelected)
                                                ? Colors.white
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            optPt,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Text(
                                            optRu,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (state.isAnswered && isCorrect)
                                      const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20)
                                    else if (state.isAnswered && isSelected)
                                      const Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                        // Explanation
                        if (state.isAnswered) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('💡 ', style: TextStyle(fontSize: 16)),
                                Expanded(
                                  child: Text(
                                    q.explanationRu,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.35),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: () => context.read<GeographyQuizCubit>().nextQuestion(),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: Text(
                              state.isLastQuestion ? 'Завершить викторину 🛂' : 'Следующий вопрос',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompletionView(BuildContext context, GeographyQuizState state) {
    final theme = Theme.of(context);
    final percent = (state.score / state.questions.length * 100).round();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('🛂', textAlign: TextAlign.center, style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              'Паспорт Лузофонии Обновлён! 🎉',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Вы набрали ${state.score} из ${state.questions.length} баллов ($percent%)',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),

            // Passport stamps box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  Text(
                    'Полученные штампы в паспорт CPLP',
                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  if (state.earnedCountryIds.isNotEmpty)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: state.earnedCountryIds.map((cid) {
                        final question = state.questions.firstWhere(
                          (q) => q.countryId == cid,
                          orElse: () => state.questions.first,
                        );
                        return PassportStampBadge(
                          flagEmoji: question.flagEmoji,
                          countryNamePt: cid,
                          stampColor: Colors.indigo,
                        );
                      }).toList(),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Попробуйте еще раз, чтобы получить свои первые штампы!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<GeographyQuizCubit>().restart(),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Пройти викторину снова',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text(
                'Вернуться в путеводитель',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
