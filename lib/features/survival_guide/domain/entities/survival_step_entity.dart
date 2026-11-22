import 'package:equatable/equatable.dart';

class SurvivalStepOption extends Equatable {
  final String textPt;
  final String translationRu;
  final bool isOptimal;
  final String feedbackRu;

  const SurvivalStepOption({
    required this.textPt,
    required this.translationRu,
    required this.isOptimal,
    required this.feedbackRu,
  });

  @override
  List<Object?> get props => [
        textPt,
        translationRu,
        isOptimal,
        feedbackRu,
      ];
}

/// Шаг в интерактивном квесте выживания / решения бюрократической задачи.
class SurvivalStepEntity extends Equatable {
  final String id;
  final String speakerRole;
  final String promptPt;
  final String promptRu;
  final String? culturalNoteRu;
  final List<SurvivalStepOption> options;

  const SurvivalStepEntity({
    required this.id,
    required this.speakerRole,
    required this.promptPt,
    required this.promptRu,
    this.culturalNoteRu,
    required this.options,
  });

  @override
  List<Object?> get props => [
        id,
        speakerRole,
        promptPt,
        promptRu,
        culturalNoteRu,
        options,
      ];
}
