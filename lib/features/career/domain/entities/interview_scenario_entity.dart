import 'package:equatable/equatable.dart';
import 'interview_question_entity.dart';

/// Сценарий собеседования на конкретную должность.
class InterviewScenarioEntity extends Equatable {
  final String id;
  final String jobTitlePt;
  final String jobTitleRu;
  final String companyName;
  final CareerCategory category;
  final String dialect; // 'pt_BR', 'pt_PT'
  final String cefrLevel;
  final String workModel; // 'Híbrido', 'Remoto', 'Presencial'
  final String salaryContextRu;
  final String iconEmoji;
  final List<InterviewQuestionEntity> questions;

  const InterviewScenarioEntity({
    required this.id,
    required this.jobTitlePt,
    required this.jobTitleRu,
    required this.companyName,
    required this.category,
    required this.dialect,
    required this.cefrLevel,
    required this.workModel,
    required this.salaryContextRu,
    required this.iconEmoji,
    required this.questions,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : '🇧🇷';
  String get dialectLabel => isPtPt ? 'Portugal' : 'Brasil';

  int get maxScore => questions.length * 10;

  @override
  List<Object?> get props => [
        id,
        jobTitlePt,
        jobTitleRu,
        companyName,
        category,
        dialect,
        cefrLevel,
        workModel,
        salaryContextRu,
        iconEmoji,
        questions,
      ];
}
