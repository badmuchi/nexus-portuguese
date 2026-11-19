import 'dart:convert';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/listening/domain/entities/listening_models.dart';

abstract class ListeningRepository {
  Future<List<ListeningExerciseEntity>> getAllExercises();
  Future<void> recordAttempt({
    required String exerciseId,
    required double wordAccuracy,
    required bool isExactMatch,
  });
}

class ListeningRepositoryImpl implements ListeningRepository {
  final AppDatabase _db;

  ListeningRepositoryImpl(this._db);

  @override
  Future<List<ListeningExerciseEntity>> getAllExercises() async {
    final rows = await _db.getAllListeningExercises();
    return rows.map((row) {
      final focusWordsList = (jsonDecode(row.focusWordsJson) as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      return ListeningExerciseEntity(
        id: row.id,
        transcript: row.transcript,
        russianTranslation: row.russianTranslation,
        audioUrl: row.audioUrl,
        difficulty: row.difficulty,
        focusWords: focusWordsList,
        dialect: row.dialect,
      );
    }).toList();
  }

  @override
  Future<void> recordAttempt({
    required String exerciseId,
    required double wordAccuracy,
    required bool isExactMatch,
  }) async {
    await _db.insertListeningAttemptLog(
      exerciseId: exerciseId,
      wordAccuracy: wordAccuracy,
      isExactMatch: isExactMatch,
      attemptedAt: DateTime.now(),
    );
  }
}
