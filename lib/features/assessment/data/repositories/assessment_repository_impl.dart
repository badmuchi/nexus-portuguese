import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/level_quiz_question.dart';
import '../../domain/entities/level_quiz_result.dart';
import '../../domain/repositories/assessment_repository.dart';
import '../datasources/portuguese_assessment_seed_data.dart';

class AssessmentRepositoryImpl implements AssessmentRepository {
  final AppDatabase database;

  const AssessmentRepositoryImpl({required this.database});

  @override
  Future<Result<List<LevelQuizQuestion>>> getQuestions() async {
    try {
      return const Result.ok(PortugueseAssessmentSeedData.questions);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load assessment questions: $e', stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<Result<LevelQuizResult?>> getLatestResult() async {
    try {
      final row = await database.getLatestAssessmentResult();
      if (row == null) {
        return const Result.ok(null);
      }

      final rawSkillScores = jsonDecode(row.skillScoresJson) as Map<String, dynamic>;
      final skillScores = <SkillFocus, double>{};
      for (final entry in rawSkillScores.entries) {
        skillScores[SkillFocus.fromString(entry.key)] = (entry.value as num).toDouble();
      }

      final rawMistakeIds = (jsonDecode(row.mistakesJson) as List<dynamic>).cast<String>();
      const allQuestions = PortugueseAssessmentSeedData.questions;
      final mistakes = allQuestions.where((q) => rawMistakeIds.contains(q.id)).toList();

      final level = CefrLevel.fromString(row.determinedLevel);

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

      final result = LevelQuizResult(
        level: level,
        levelTitleRu: row.levelTitleRu,
        scorePercentage: row.scorePercentage,
        totalQuestions: row.totalQuestions,
        correctAnswers: row.correctAnswers,
        skillScores: skillScores,
        mistakes: mistakes,
        recommendations: recs,
        completedAt: row.completedAt,
      );

      return Result.ok(result);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load latest assessment result: $e', stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<Result<void>> saveResult(LevelQuizResult result) async {
    try {
      final skillScoresMap = <String, double>{};
      for (final entry in result.skillScores.entries) {
        skillScoresMap[entry.key.name] = entry.value;
      }

      final mistakeIds = result.mistakes.map((m) => m.id).toList();

      await database.insertAssessmentResult(
        AssessmentResultEntriesCompanion(
          determinedLevel: Value(result.level.label),
          levelTitleRu: Value(result.levelTitleRu),
          scorePercentage: Value(result.scorePercentage),
          totalQuestions: Value(result.totalQuestions),
          correctAnswers: Value(result.correctAnswers),
          skillScoresJson: Value(jsonEncode(skillScoresMap)),
          mistakesJson: Value(jsonEncode(mistakeIds)),
          completedAt: Value(result.completedAt),
        ),
      );

      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to save assessment result: $e', stackTrace: stackTrace),
      );
    }
  }
}
