import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/diary_analysis_entity.dart';
import '../entities/diary_entry_entity.dart';
import '../entities/diary_prompt_entity.dart';

abstract class DiaryRepository {
  /// Получить все сохранённые записи дневника.
  Future<Result<List<DiaryEntryEntity>>> getAllEntries();

  /// Сохранить новую или отредактированную запись.
  Future<Result<DiaryEntryEntity>> saveEntry(DiaryEntryEntity entry);

  /// Удалить запись по id.
  Future<Result<void>> deleteEntry(String id);

  /// Получить вдохновляющие темы/промпты дня.
  Future<Result<List<DiaryPrompt>>> getDailyPrompts();

  /// Выполнить грамматический и лексический анализ текста на португальском.
  Future<Result<DiaryAnalysisResult>> analyzeText(String text);
}
