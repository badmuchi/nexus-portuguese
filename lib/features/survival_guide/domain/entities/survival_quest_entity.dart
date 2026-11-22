import 'package:equatable/equatable.dart';
import 'survival_phrase_entity.dart';
import 'survival_step_entity.dart';

/// Сущность интерактивного квеста по решению бюрократической или жизненной задачи.
class SurvivalQuestEntity extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final SurvivalCategory category;
  final String dialect; // 'pt_BR', 'pt_PT'
  final String cefrLevel;
  final int estimatedMinutes;
  final String iconEmoji;
  final String overviewRu;
  final List<String> requiredDocumentsRu;
  final List<SurvivalStepEntity> steps;

  const SurvivalQuestEntity({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.category,
    required this.dialect,
    required this.cefrLevel,
    required this.estimatedMinutes,
    required this.iconEmoji,
    required this.overviewRu,
    this.requiredDocumentsRu = const [],
    required this.steps,
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

  @override
  List<Object?> get props => [
        id,
        titlePt,
        titleRu,
        category,
        dialect,
        cefrLevel,
        estimatedMinutes,
        iconEmoji,
        overviewRu,
        requiredDocumentsRu,
        steps,
      ];
}
