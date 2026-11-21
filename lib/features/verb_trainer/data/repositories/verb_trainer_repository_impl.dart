import 'dart:convert';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../grammar/domain/entities/grammar_verb_entity.dart';
import '../../domain/entities/verb_exercise.dart';
import '../../domain/entities/verb_trainer_config.dart';
import '../../domain/repositories/verb_trainer_repository.dart';
import '../datasources/verb_exercise_generator.dart';

class VerbTrainerRepositoryImpl implements VerbTrainerRepository {
  final AppDatabase database;
  final VerbExerciseGenerator generator;

  VerbTrainerRepositoryImpl({
    required this.database,
    VerbExerciseGenerator? generator,
  }) : generator = generator ?? VerbExerciseGenerator();

  @override
  Future<Result<List<VerbExercise>>> generateExercises({
    required VerbTrainerConfig config,
    int count = 25,
  }) async {
    try {
      final rows = await database.getAllGrammarVerbs();
      final entities = rows.map((row) {
        final list = (jsonDecode(row.conjugationsJson) as List<dynamic>?)
                ?.map((e) => VerbConjugationForm.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        return GrammarVerbEntity(
          id: row.id,
          infinitive: row.infinitive,
          regularity: row.regularity,
          conjugationGroup: row.conjugationGroup,
          russianMeaning: row.russianMeaning,
          grammarNotesRu: row.grammarNotesRu,
          differenceNote: row.differenceNote,
          conjugations: list,
        );
      }).toList();

      final exercises = generator.generate(
        allVerbs: entities,
        config: config,
        count: count,
      );

      return Result.ok(exercises);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to generate verb exercises: $e', stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<Result<void>> recordAttempt({
    required String verbId,
    required String tense,
    required String person,
    required bool isCorrect,
  }) async {
    try {
      await database.insertGrammarPracticeLog(
        verbId: verbId,
        tense: tense,
        person: person,
        isCorrect: isCorrect,
        practicedAt: DateTime.now(),
      );
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to record verb attempt: $e', stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<Result<Map<String, double>>> getVerbMasteryStats() async {
    try {
      final logs = await database.getAllGrammarPracticeLogs();
      final totals = <String, int>{};
      final corrects = <String, int>{};

      for (final log in logs) {
        totals[log.verbId] = (totals[log.verbId] ?? 0) + 1;
        if (log.isCorrect) {
          corrects[log.verbId] = (corrects[log.verbId] ?? 0) + 1;
        }
      }

      final stats = <String, double>{};
      for (final entry in totals.entries) {
        final total = entry.value;
        final corr = corrects[entry.key] ?? 0;
        stats[entry.key] = total > 0 ? (corr / total) * 100.0 : 0.0;
      }

      return Result.ok(stats);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load verb mastery stats: $e', stackTrace: stackTrace),
      );
    }
  }
}
