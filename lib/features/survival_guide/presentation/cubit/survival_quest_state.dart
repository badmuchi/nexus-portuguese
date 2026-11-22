import 'package:equatable/equatable.dart';
import '../../domain/entities/survival_quest_entity.dart';
import '../../domain/entities/survival_step_entity.dart';

class SurvivalQuestState extends Equatable {
  final SurvivalQuestEntity quest;
  final int currentStepIndex;
  final int? selectedOptionIndex;
  final bool isAnswered;
  final int score;
  final bool isCompleted;

  const SurvivalQuestState({
    required this.quest,
    this.currentStepIndex = 0,
    this.selectedOptionIndex,
    this.isAnswered = false,
    this.score = 0,
    this.isCompleted = false,
  });

  SurvivalStepEntity get currentStep {
    if (quest.steps.isEmpty) {
      return const SurvivalStepEntity(
        id: 'empty',
        speakerRole: '',
        promptPt: '',
        promptRu: '',
        options: [],
      );
    }
    final idx = currentStepIndex.clamp(0, quest.steps.length - 1);
    return quest.steps[idx];
  }

  double get progress {
    if (quest.steps.isEmpty) return 0.0;
    final completedCount = isCompleted ? quest.steps.length : currentStepIndex;
    return (completedCount / quest.steps.length).clamp(0.0, 1.0);
  }

  bool get isLastStep => currentStepIndex >= quest.steps.length - 1;

  SurvivalQuestState copyWith({
    SurvivalQuestEntity? quest,
    int? currentStepIndex,
    int? selectedOptionIndex,
    bool clearSelectedOption = false,
    bool? isAnswered,
    int? score,
    bool? isCompleted,
  }) {
    return SurvivalQuestState(
      quest: quest ?? this.quest,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      selectedOptionIndex: clearSelectedOption ? null : (selectedOptionIndex ?? this.selectedOptionIndex),
      isAnswered: isAnswered ?? this.isAnswered,
      score: score ?? this.score,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        quest,
        currentStepIndex,
        selectedOptionIndex,
        isAnswered,
        score,
        isCompleted,
      ];
}
