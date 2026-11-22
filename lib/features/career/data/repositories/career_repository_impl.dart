import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/business_phrase_entity.dart';
import '../../domain/entities/cv_guide_item_entity.dart';
import '../../domain/entities/interview_question_entity.dart';
import '../../domain/entities/interview_scenario_entity.dart';
import '../../domain/repositories/career_repository.dart';
import '../datasources/career_seed_data.dart';

class CareerRepositoryImpl implements CareerRepository {
  final AppDatabase? _database;

  CareerRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<InterviewScenarioEntity>>> getScenarios({
    CareerCategory? category,
    String? dialect,
  }) async {
    try {
      var pool = List<InterviewScenarioEntity>.from(CareerSeedData.scenarios);

      if (category != null) {
        pool = pool.where((s) => s.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        pool = pool.where((s) => s.dialect.toLowerCase() == dialect.toLowerCase()).toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить сценарии собеседований: $e'));
    }
  }

  @override
  Future<Result<InterviewScenarioEntity>> getScenarioById(String id) async {
    try {
      final scenario = CareerSeedData.scenarios.firstWhere(
        (s) => s.id == id,
        orElse: () => throw Exception('Сценарий $id не найден'),
      );
      return Result.ok(scenario);
    } catch (e) {
      return Result.err(DatabaseFailure('Сценарий не найден: $e'));
    }
  }

  @override
  Future<Result<List<BusinessPhraseEntity>>> getPhrases({
    BusinessPhraseType? phraseType,
    CareerCategory? category,
    String? dialect,
  }) async {
    try {
      var pool = List<BusinessPhraseEntity>.from(CareerSeedData.phrases);

      if (phraseType != null) {
        pool = pool.where((p) => p.phraseType == phraseType).toList();
      }

      if (category != null) {
        pool = pool.where((p) => p.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        pool = pool.where((p) => p.dialect.toLowerCase() == dialect.toLowerCase() || p.dialect == 'all').toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить профессиональные фразы: $e'));
    }
  }

  @override
  Future<Result<List<CvGuideItemEntity>>> getCvGuides({
    String? dialect,
  }) async {
    try {
      var pool = List<CvGuideItemEntity>.from(CareerSeedData.cvGuides);

      if (dialect != null && dialect != 'all') {
        pool = pool.where((g) => g.dialect.toLowerCase() == dialect.toLowerCase() || g.dialect == 'all').toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить руководство по CV: $e'));
    }
  }

  @override
  Future<Result<void>> recordInterviewCompleted({
    required String scenarioId,
    required int score,
    required int maxScore,
  }) async {
    try {
      final accuracy = maxScore > 0 ? (score / maxScore).clamp(0.0, 1.0) : 1.0;
      final isExact = accuracy >= 1.0;

      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'interview_sim_$scenarioId',
          wordAccuracy: accuracy,
          isExactMatch: isExact,
          attemptedAt: DateTime.now(),
        );
      }

      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить результат собеседования: $e'));
    }
  }
}
