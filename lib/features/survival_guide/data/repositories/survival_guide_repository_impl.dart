import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/cultural_tip_entity.dart';
import '../../domain/entities/survival_phrase_entity.dart';
import '../../domain/entities/survival_quest_entity.dart';
import '../../domain/repositories/survival_guide_repository.dart';
import '../datasources/survival_guide_seed_data.dart';

class SurvivalGuideRepositoryImpl implements SurvivalGuideRepository {
  final AppDatabase? _database;

  SurvivalGuideRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<SurvivalQuestEntity>>> getQuests({
    SurvivalCategory? category,
    String? dialect,
  }) async {
    try {
      var pool = List<SurvivalQuestEntity>.from(SurvivalGuideSeedData.quests);

      if (category != null) {
        pool = pool.where((q) => q.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        pool = pool.where((q) => q.dialect.toLowerCase() == dialect.toLowerCase()).toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить квесты выживания: $e'));
    }
  }

  @override
  Future<Result<SurvivalQuestEntity>> getQuestById(String id) async {
    try {
      final quest = SurvivalGuideSeedData.quests.firstWhere(
        (q) => q.id == id,
        orElse: () => throw Exception('Квест $id не найден'),
      );
      return Result.ok(quest);
    } catch (e) {
      return Result.err(DatabaseFailure('Квест не найден: $e'));
    }
  }

  @override
  Future<Result<List<SurvivalPhraseEntity>>> getPhrases({
    SurvivalCategory? category,
    String? dialect,
    bool? emergencyOnly,
  }) async {
    try {
      var pool = List<SurvivalPhraseEntity>.from(SurvivalGuideSeedData.phrases);

      if (category != null) {
        pool = pool.where((p) => p.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        pool = pool.where((p) => p.dialect.toLowerCase() == dialect.toLowerCase() || p.dialect == 'all').toList();
      }

      if (emergencyOnly == true) {
        pool = pool.where((p) => p.isEmergency).toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить фразы выживания: $e'));
    }
  }

  @override
  Future<Result<List<CulturalTipEntity>>> getTips({
    SurvivalCategory? category,
    String? dialect,
  }) async {
    try {
      var pool = List<CulturalTipEntity>.from(SurvivalGuideSeedData.tips);

      if (category != null) {
        pool = pool.where((t) => t.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        pool = pool.where((t) => t.dialect.toLowerCase() == dialect.toLowerCase() || t.dialect == 'all').toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить советы по этикету: $e'));
    }
  }

  @override
  Future<Result<void>> recordQuestCompleted({
    required String questId,
    required int score,
    required int totalSteps,
  }) async {
    try {
      final accuracy = totalSteps > 0 ? (score / totalSteps).clamp(0.0, 1.0) : 1.0;
      final isExact = accuracy >= 1.0;

      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'survival_quest_$questId',
          wordAccuracy: accuracy,
          isExactMatch: isExact,
          attemptedAt: DateTime.now(),
        );
      }

      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить прогресс квеста: $e'));
    }
  }
}
