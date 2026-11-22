import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/interview_question_entity.dart';
import '../../domain/entities/interview_scenario_entity.dart';
import '../../domain/repositories/career_repository.dart';
import '../cubit/interview_simulator_cubit.dart';
import '../cubit/interview_simulator_state.dart';
import '../widgets/interview_dialog_view.dart';

class InterviewSimulatorScreen extends StatelessWidget {
  final InterviewScenarioEntity scenario;

  const InterviewSimulatorScreen({
    super.key,
    required this.scenario,
  });

  static Route<void> route({required InterviewScenarioEntity scenario}) {
    return MaterialPageRoute(
      builder: (_) => InterviewSimulatorScreen(scenario: scenario),
    );
  }

  Color _getCategoryColor(CareerCategory cat) {
    switch (cat) {
      case CareerCategory.tech:
        return Colors.indigo;
      case CareerCategory.sales:
        return Colors.teal;
      case CareerCategory.hospitality:
        return Colors.orange.shade800;
      case CareerCategory.marketing:
        return Colors.purple;
      case CareerCategory.general:
        return Colors.green.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _getCategoryColor(scenario.category);

    return BlocProvider(
      create: (ctx) => InterviewSimulatorCubit(
        scenario: scenario,
        repository: ctx.read<CareerRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                scenario.jobTitleRu,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${scenario.companyName} • ${scenario.workModel}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: scenario.isPtPt
                    ? Colors.red.withValues(alpha: 0.15)
                    : Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                scenario.isPtPt ? '🇵🇹 PT-PT' : '🇧🇷 PT-BR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: scenario.isPtPt ? Colors.red.shade700 : Colors.green.shade700,
                ),
              ),
            ),
            BlocBuilder<InterviewSimulatorCubit, InterviewSimulatorState>(
              builder: (context, state) {
                return IconButton(
                  tooltip: 'Начать сначала',
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () => context.read<InterviewSimulatorCubit>().restart(),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<InterviewSimulatorCubit, InterviewSimulatorState>(
          builder: (context, state) {
            if (state.isCompleted) {
              return _buildCompletionView(context, state, catColor);
            }

            final progress = (state.currentQuestionIndex + 1) / state.scenario.questions.length;

            return Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: catColor.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(catColor),
                  minHeight: 4,
                ),
                Expanded(
                  child: InterviewDialogView(
                    question: state.currentQuestion,
                    questionNumber: state.currentQuestionIndex + 1,
                    totalQuestions: state.scenario.questions.length,
                    selectedOptionIndex: state.selectedOptionIndex,
                    isAnswered: state.isAnswered,
                    categoryColor: catColor,
                    onSelectOption: (idx) {
                      context.read<InterviewSimulatorCubit>().selectOption(idx);
                    },
                    onNext: () {
                      context.read<InterviewSimulatorCubit>().nextQuestion();
                    },
                    onPlayQuestion: () {
                      context.read<InterviewSimulatorCubit>().playQuestionAudio();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompletionView(
    BuildContext context,
    InterviewSimulatorState state,
    Color catColor,
  ) {
    final theme = Theme.of(context);
    final maxPts = state.scenario.maxScore;
    final percent = maxPts > 0 ? (state.totalScore / maxPts * 100).round() : 0;

    String resultTitle;
    String resultDesc;
    Color resultColor;
    IconData resultIcon;

    if (percent >= 80) {
      resultTitle = 'Parabéns! Excelente Desempenho! 🚀';
      resultDesc = 'Вы продемонстрировали высокий уровень профессионализма, знание STAR-метода и уверенный португальский!';
      resultColor = Colors.green;
      resultIcon = Icons.stars_rounded;
    } else if (percent >= 50) {
      resultTitle = 'Bom Trabalho! Интервью пройдено! 👍';
      resultDesc = 'У вас хорошая база, но некоторые ответы были слишком общими или недостаточно структурированными.';
      resultColor = Colors.amber.shade800;
      resultIcon = Icons.check_circle_rounded;
    } else {
      resultTitle = 'Vale a Pena Praticar! 📚';
      resultDesc = 'HR обращает внимание на формулировки и дипломатичность. Попробуйте еще раз, изучив рекомендации!';
      resultColor = Colors.orange.shade800;
      resultIcon = Icons.replay_circle_filled_rounded;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(resultIcon, size: 72, color: resultColor),
            const SizedBox(height: 16),
            Text(
              resultTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              resultDesc,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  Text(
                    'Итоговый результат',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${state.totalScore} / $maxPts',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                  Text(
                    '$percent% правильности стратегий',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.payments_outlined, size: 20, color: catColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.scenario.salaryContextRu,
                          style: theme.textTheme.bodySmall?.copyWith(
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<InterviewSimulatorCubit>().restart(),
              style: FilledButton.styleFrom(
                backgroundColor: catColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Пройти интервью снова',
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
                'Вернуться в карьерный хаб',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
