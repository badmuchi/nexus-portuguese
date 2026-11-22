import 'package:equatable/equatable.dart';
import '../../domain/entities/interview_question_entity.dart';
import '../../domain/entities/interview_scenario_entity.dart';

class InterviewSimulatorState extends Equatable {
  final InterviewScenarioEntity scenario;
  final int currentQuestionIndex;
  final int? selectedOptionIndex;
  final bool isAnswered;
  final int totalScore;
  final bool isCompleted;

  const InterviewSimulatorState({
    required this.scenario,
    this.currentQuestionIndex = 0,
    this.selectedOptionIndex,
    this.isAnswered = false,
    this.totalScore = 0,
    this.isCompleted = false,
  });

  InterviewQuestionEntity get currentQuestion {
    if (scenario.questions.isEmpty) {
      return const InterviewQuestionEntity(
        id: 'empty',
        interviewerRole: '',
        questionPt: '',
        questionRu: '',
        hrInsightRu: '',
        options: [],
      );
    }
    final idx = currentQuestionIndex.clamp(0, scenario.questions.length - 1);
    return scenario.questions[idx];
  }

  double get progress {
    if (scenario.questions.isEmpty) return 0.0;
    final done = isCompleted ? scenario.questions.length : currentQuestionIndex;
    return (done / scenario.questions.length).clamp(0.0, 1.0);
  }

  bool get isLastQuestion => currentQuestionIndex >= scenario.questions.length - 1;

  InterviewSimulatorState copyWith({
    InterviewScenarioEntity? scenario,
    int? currentQuestionIndex,
    int? selectedOptionIndex,
    bool clearSelectedOption = false,
    bool? isAnswered,
    int? totalScore,
    bool? isCompleted,
  }) {
    return InterviewSimulatorState(
      scenario: scenario ?? this.scenario,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedOptionIndex: clearSelectedOption ? null : (selectedOptionIndex ?? this.selectedOptionIndex),
      isAnswered: isAnswered ?? this.isAnswered,
      totalScore: totalScore ?? this.totalScore,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        scenario,
        currentQuestionIndex,
        selectedOptionIndex,
        isAnswered,
        totalScore,
        isCompleted,
      ];
}
