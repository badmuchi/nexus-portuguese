import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/diary_analysis_entity.dart';
import '../../domain/entities/diary_entry_entity.dart';
import '../../domain/entities/diary_prompt_entity.dart';
import '../../domain/repositories/diary_repository.dart';
import '../../domain/services/portuguese_diary_analyzer.dart';
import '../datasources/diary_prompts_seed.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final AppDatabase _database;

  DiaryRepositoryImpl({required AppDatabase database}) : _database = database;

  @override
  Future<Result<List<DiaryEntryEntity>>> getAllEntries() async {
    try {
      final rows = await _database.getAllDiaryEntries();
      final entities = rows.map((r) => _mapRowToEntity(r)).toList();
      return Result.ok(entities);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить записи дневника: $e'));
    }
  }

  @override
  Future<Result<DiaryEntryEntity>> saveEntry(DiaryEntryEntity entry) async {
    try {
      final correctionsJson = jsonEncode(entry.mistakes.map((m) => m.toJson()).toList());

      await _database.insertDiaryEntry(
        DiaryEntriesCompanion(
          id: Value(entry.id),
          promptQuestionPt: Value(entry.promptQuestionPt),
          promptQuestionRu: Value(entry.promptQuestionRu),
          contentPt: Value(entry.contentPt),
          dialect: Value(entry.dialect),
          wordCount: Value(entry.wordCount),
          estimatedLevel: Value(entry.estimatedLevel),
          feedbackSummaryRu: Value(entry.feedbackSummaryRu),
          correctionsJson: Value(correctionsJson),
          createdAt: Value(entry.createdAt),
        ),
      );

      // Записываем лог в GrammarPracticeLogs для учета дневника в динамическом стрике
      await _database.insertGrammarPracticeLog(
        verbId: 'diario_${entry.id}',
        tense: 'presente',
        person: 'eu',
        isCorrect: true,
        practicedAt: entry.createdAt,
      );

      return Result.ok(entry);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить запись дневника: $e'));
    }
  }

  @override
  Future<Result<void>> deleteEntry(String id) async {
    try {
      await _database.deleteDiaryEntry(id);
      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось удалить запись: $e'));
    }
  }

  @override
  Future<Result<List<DiaryPrompt>>> getDailyPrompts() async {
    return const Result.ok(DiaryPromptsSeed.prompts);
  }

  @override
  Future<Result<DiaryAnalysisResult>> analyzeText(String text) async {
    try {
      final result = PortugueseDiaryAnalyzer.analyze(text);
      return Result.ok(result);
    } catch (e) {
      return Result.err(ValidationFailure('Ошибка при анализе текста: $e'));
    }
  }

  DiaryEntryEntity _mapRowToEntity(DiaryEntryRow row) {
    List<DiaryMistakeItem> mistakes = [];
    try {
      final decoded = jsonDecode(row.correctionsJson) as List<dynamic>;
      mistakes = decoded
          .map((item) => DiaryMistakeItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      mistakes = [];
    }

    return DiaryEntryEntity(
      id: row.id,
      promptQuestionPt: row.promptQuestionPt,
      promptQuestionRu: row.promptQuestionRu,
      contentPt: row.contentPt,
      dialect: row.dialect,
      wordCount: row.wordCount,
      estimatedLevel: row.estimatedLevel,
      feedbackSummaryRu: row.feedbackSummaryRu,
      mistakes: mistakes,
      createdAt: row.createdAt,
    );
  }
}
