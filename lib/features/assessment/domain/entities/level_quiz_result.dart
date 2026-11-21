import 'package:equatable/equatable.dart';
import 'level_quiz_question.dart';

class LevelQuizResult extends Equatable {
  final CefrLevel level;
  final String levelTitleRu;
  final double scorePercentage;
  final int totalQuestions;
  final int correctAnswers;
  final Map<SkillFocus, double> skillScores;
  final List<LevelQuizQuestion> mistakes;
  final List<String> recommendations;
  final DateTime completedAt;

  const LevelQuizResult({
    required this.level,
    required this.levelTitleRu,
    required this.scorePercentage,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.skillScores,
    required this.mistakes,
    required this.recommendations,
    required this.completedAt,
  });

  factory LevelQuizResult.evaluate({
    required List<LevelQuizQuestion> questions,
    required Map<String, int> userAnswers,
    DateTime? completedAt,
  }) {
    if (questions.isEmpty) {
      return LevelQuizResult(
        level: CefrLevel.a1,
        levelTitleRu: CefrLevel.a1.titleRu,
        scorePercentage: 0.0,
        totalQuestions: 0,
        correctAnswers: 0,
        skillScores: const {},
        mistakes: const [],
        recommendations: const ['Пройдите тест для определения уровня.'],
        completedAt: completedAt ?? DateTime.now(),
      );
    }

    int correct = 0;
    final mistakes = <LevelQuizQuestion>[];
    final skillTotals = <SkillFocus, int>{};
    final skillCorrect = <SkillFocus, int>{};

    for (final q in questions) {
      skillTotals[q.skill] = (skillTotals[q.skill] ?? 0) + 1;
      final selected = userAnswers[q.id];
      if (selected != null && q.isCorrect(selected)) {
        correct++;
        skillCorrect[q.skill] = (skillCorrect[q.skill] ?? 0) + 1;
      } else {
        mistakes.add(q);
      }
    }

    final percentage = (correct / questions.length) * 100.0;

    final CefrLevel determinedLevel;
    if (percentage < 45.0) {
      determinedLevel = CefrLevel.a1;
    } else if (percentage < 70.0) {
      determinedLevel = CefrLevel.a2;
    } else if (percentage < 88.0) {
      determinedLevel = CefrLevel.b1;
    } else {
      determinedLevel = CefrLevel.b2;
    }

    final skillScores = <SkillFocus, double>{};
    for (final entry in skillTotals.entries) {
      final skill = entry.key;
      final total = entry.value;
      final skillCorr = skillCorrect[skill] ?? 0;
      skillScores[skill] = (skillCorr / total) * 100.0;
    }

    final recs = <String>[];
    if ((skillScores[SkillFocus.prepositions] ?? 100.0) < 70.0) {
      recs.add('Уделите внимание слияниям предлогов: de+o=do, em+a=na, a+a=à (crase).');
    }
    if ((skillScores[SkillFocus.grammar] ?? 100.0) < 70.0) {
      recs.add('Повторите спряжения в Pretérito Perfeito/Imperfeito и сослагательное наклонение (Subjuntivo).');
    }
    if ((skillScores[SkillFocus.dialects] ?? 100.0) < 70.0) {
      recs.add('Изучите контраст PT-BR и PT-PT: лексика (ônibus/autocarro) и конструкции (estou fazendo vs estou a fazer).');
    }
    if ((skillScores[SkillFocus.listening] ?? 100.0) < 70.0) {
      recs.add('Тренируйте восприятие носовых дифтонгов (-ão, -õe) в модуле Фонетика и Аудирование.');
    }
    if ((skillScores[SkillFocus.vocabulary] ?? 100.0) < 70.0) {
      recs.add('Пополняйте активный словарный запас через раздел FSRS Карточки и Живые сцены.');
    }
    if (recs.isEmpty) {
      recs.add('Великолепный результат! Продолжайте практиковать живые диалоги и чтение историй.');
    }

    return LevelQuizResult(
      level: determinedLevel,
      levelTitleRu: determinedLevel.titleRu,
      scorePercentage: percentage,
      totalQuestions: questions.length,
      correctAnswers: correct,
      skillScores: skillScores,
      mistakes: mistakes,
      recommendations: recs,
      completedAt: completedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        level,
        levelTitleRu,
        scorePercentage,
        totalQuestions,
        correctAnswers,
        skillScores,
        mistakes,
        recommendations,
        completedAt,
      ];
}
