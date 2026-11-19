import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/grammar/domain/entities/grammar_verb_entity.dart';

abstract class GrammarRepository {
  Future<List<GrammarVerbEntity>> getAllVerbs();
  Future<List<PrepositionContractionEntity>> getPrepositionContractions();
  Future<void> recordPractice({
    required String verbId,
    required String tense,
    required String person,
    required bool isCorrect,
  });
}

class GrammarRepositoryImpl implements GrammarRepository {
  final AppDatabase _db;

  GrammarRepositoryImpl(this._db);

  @override
  Future<List<GrammarVerbEntity>> getAllVerbs() async {
    final rows = await _db.getAllGrammarVerbs();
    return rows.map((row) {
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
  }

  @override
  Future<List<PrepositionContractionEntity>> getPrepositionContractions() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/grammar_verbs_seed.json');
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      final list = (root['preposition_contractions'] as List<dynamic>?) ?? [];
      return list.map((item) {
        final m = item as Map<String, dynamic>;
        return PrepositionContractionEntity(
          preposition: m['preposition'] as String,
          article: m['article'] as String,
          contracted: m['contracted'] as String,
          example: m['example'] as String,
          translation: m['translation'] as String,
          meaning: m['meaning'] as String,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> recordPractice({
    required String verbId,
    required String tense,
    required String person,
    required bool isCorrect,
  }) async {
    await _db.insertGrammarPracticeLog(
      verbId: verbId,
      tense: tense,
      person: person,
      isCorrect: isCorrect,
      practicedAt: DateTime.now(),
    );
  }
}
