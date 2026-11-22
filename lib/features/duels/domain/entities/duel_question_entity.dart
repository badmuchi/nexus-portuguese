import 'package:equatable/equatable.dart';

enum DuelCategory {
  vocabulario('Лексика', 'Vocabulário Divergente', '🚌'),
  gramatica('Грамматика', 'Gramática em Confronto', '⚙️'),
  falsosAmigos('Ложные друзья', 'Falsos Amigos & Pegadinhas', '🎭'),
  girias('Сленг', 'Gírias: Legal vs Fixe', '🔥');

  final String labelRu;
  final String labelPt;
  final String emoji;
  const DuelCategory(this.labelRu, this.labelPt, this.emoji);
}

/// Вопрос дуэли в «Arena de Duelos Culturais».
class DuelQuestion extends Equatable {
  final String id;
  final DuelCategory category;
  final String questionTitle;
  final String promptRu;
  final String targetDialect; // 'pt_PT' или 'pt_BR'
  final List<String> options;
  final int correctIndex;
  final String ptPtEquivalent;
  final String ptBrEquivalent;
  final String culturalNotePt;
  final String culturalNoteRu;

  const DuelQuestion({
    required this.id,
    required this.category,
    required this.questionTitle,
    required this.promptRu,
    required this.targetDialect,
    required this.options,
    required this.correctIndex,
    required this.ptPtEquivalent,
    required this.ptBrEquivalent,
    required this.culturalNotePt,
    required this.culturalNoteRu,
  });

  bool get isTargetPtPt => targetDialect == 'pt_PT';
  bool get isTargetPtBr => targetDialect == 'pt_BR';

  String get targetDialectFlag => isTargetPtPt ? '🇵🇹' : '🇧🇷';
  String get targetDialectLabel => isTargetPtPt ? 'Portugal (PT-PT)' : 'Brasil (PT-BR)';

  String get correctAnswer => options[correctIndex];

  bool checkAnswer(int selectedIndex) => selectedIndex == correctIndex;

  @override
  List<Object?> get props => [
        id,
        category,
        questionTitle,
        promptRu,
        targetDialect,
        options,
        correctIndex,
        ptPtEquivalent,
        ptBrEquivalent,
        culturalNotePt,
        culturalNoteRu,
      ];
}
