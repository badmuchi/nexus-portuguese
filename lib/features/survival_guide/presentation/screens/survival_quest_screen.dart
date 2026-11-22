import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/survival_quest_cubit.dart';
import '../cubit/survival_quest_state.dart';
import '../widgets/quest_step_view.dart';

class SurvivalQuestScreen extends StatelessWidget {
  const SurvivalQuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SurvivalQuestCubit, SurvivalQuestState>(
      listener: (context, state) {
        if (state.isCompleted) {
          _showCompletionDialog(context, state);
        }
      },
      builder: (context, state) {
        final cubit = context.read<SurvivalQuestCubit>();
        final quest = state.quest;
        final categoryColor = Color(quest.category.colorHex);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              quest.titlePt,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: LinearProgressIndicator(
                value: state.progress,
                backgroundColor: categoryColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
              ),
            ),
          ),
          body: Column(
            children: [
              if (quest.requiredDocumentsRu.isNotEmpty)
                _RequiredDocumentsBanner(
                  documents: quest.requiredDocumentsRu,
                  categoryColor: categoryColor,
                ),
              Expanded(
                child: QuestStepView(
                  step: state.currentStep,
                  stepNumber: state.currentStepIndex + 1,
                  totalSteps: quest.steps.length,
                  selectedOptionIndex: state.selectedOptionIndex,
                  isAnswered: state.isAnswered,
                  onSelectOption: cubit.selectOption,
                  onNext: cubit.nextStep,
                  onPlayPrompt: cubit.playPromptAudio,
                  categoryColor: categoryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context, SurvivalQuestState state) {
    final theme = Theme.of(context);
    final accuracy = state.quest.steps.isNotEmpty
        ? ((state.score / state.quest.steps.length) * 100).round()
        : 100;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text('🏆', style: TextStyle(fontSize: 48)),
              ),
              const SizedBox(height: 12),
              Text(
                'Квест успешно пройден!',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Оптимальных решений: $accuracy% (${state.score} из ${state.quest.steps.length})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: accuracy >= 75 ? Colors.green.shade700 : Colors.amber.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Вы отлично ориентируетесь в процедуре "${state.quest.titleRu}". Теперь в реальной жизни эта ситуация не застанет вас врасплох!',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SurvivalQuestCubit>().restart();
                      },
                      child: const Text('Сначала'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Готово'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RequiredDocumentsBanner extends StatelessWidget {
  final List<String> documents;
  final Color categoryColor;

  const _RequiredDocumentsBanner({
    required this.documents,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: categoryColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_shared_rounded, size: 16, color: categoryColor),
              const SizedBox(width: 6),
              Text(
                'Необходимые документы:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: categoryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            documents.join(' • '),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
