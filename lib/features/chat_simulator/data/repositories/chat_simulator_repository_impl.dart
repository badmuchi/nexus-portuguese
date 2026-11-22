import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/chat_scenario_entity.dart';
import '../../domain/repositories/chat_simulator_repository.dart';
import '../datasources/chat_simulator_seed_data.dart';

class ChatSimulatorRepositoryImpl implements ChatSimulatorRepository {
  final AppDatabase? _database;

  ChatSimulatorRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<ChatScenarioEntity>>> getScenarios({String? dialect}) async {
    try {
      var pool = List<ChatScenarioEntity>.from(ChatSimulatorSeedData.scenarios);

      if (dialect != null && dialect != 'all') {
        pool = pool.where((s) => s.dialect.toLowerCase() == dialect.toLowerCase()).toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить сценарии переписок: $e'));
    }
  }

  @override
  Future<Result<ChatScenarioEntity>> getScenarioById(String id) async {
    try {
      final scenario = ChatSimulatorSeedData.scenarios.firstWhere(
        (s) => s.id == id,
        orElse: () => throw Exception('Сценарий $id не найден'),
      );
      return Result.ok(scenario);
    } catch (e) {
      return Result.err(DatabaseFailure('Сценарий не найден: $e'));
    }
  }

  @override
  Future<Result<void>> recordScenarioCompleted({
    required String scenarioId,
    required int score,
    required int totalChoices,
  }) async {
    try {
      final accuracy = totalChoices > 0 ? (score / totalChoices).clamp(0.0, 1.0) : 1.0;
      final isExact = accuracy >= 1.0;

      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'chat_scenario_$scenarioId',
          wordAccuracy: accuracy,
          isExactMatch: isExact,
          attemptedAt: DateTime.now(),
        );
      }

      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить прогресс переписки: $e'));
    }
  }
}
