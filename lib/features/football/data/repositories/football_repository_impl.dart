import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/football_entities.dart';
import '../../domain/repositories/football_repository.dart';
import '../datasources/football_seed_data.dart';

class FootballRepositoryImpl implements FootballRepository {
  final AppDatabase? _database;

  FootballRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<FootballMatchEntity>>> getMatches({
    String? dialect,
  }) async {
    try {
      var pool = List<FootballMatchEntity>.from(FootballSeedData.matches);

      if (dialect != null && dialect.toLowerCase() != 'all') {
        final d = dialect.toLowerCase();
        final isPt = d.contains('pt') && !d.contains('br');
        final isBr = d.contains('br');

        if (isPt) {
          pool = pool.where((m) => m.isPtPt).toList();
        } else if (isBr) {
          pool = pool.where((m) => m.isPtBr).toList();
        }
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка загрузки матчей: $e'));
    }
  }

  @override
  Future<Result<FootballMatchEntity>> getMatchById(String id) async {
    try {
      final match = FootballSeedData.matches.firstWhere(
        (m) => m.id == id,
        orElse: () => throw Exception('Матч $id не найден'),
      );
      return Result.ok(match);
    } catch (e) {
      return Result.err(DatabaseFailure('Матч не найден: $e'));
    }
  }

  @override
  Future<Result<List<FootballTermEntity>>> getFootballTerms({
    FootballTermCategory? category,
  }) async {
    try {
      var pool = List<FootballTermEntity>.from(FootballSeedData.terms);

      if (category != null) {
        pool = pool.where((t) => t.category == category).toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка загрузки футбольных терминов: $e'));
    }
  }

  @override
  Future<Result<List<FanChantEntity>>> getFanChants({
    String? dialect,
  }) async {
    try {
      var pool = List<FanChantEntity>.from(FootballSeedData.chants);

      if (dialect != null && dialect.toLowerCase() != 'all') {
        final d = dialect.toLowerCase();
        final isPt = d.contains('pt') && !d.contains('br');
        final isBr = d.contains('br');

        if (isPt) {
          pool = pool.where((c) => c.isPtPt).toList();
        } else if (isBr) {
          pool = pool.where((c) => c.isPtBr).toList();
        }
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка загрузки кричалок: $e'));
    }
  }

  @override
  Future<Result<List<FootballQuizQuestion>>> getQuizQuestions() async {
    try {
      return const Result.ok(FootballSeedData.quizQuestions);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка загрузки квиза: $e'));
    }
  }

  @override
  Future<Result<void>> recordMatchPractice({
    required String matchId,
    required int momentsPracticed,
  }) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'football_$matchId',
          wordAccuracy: (momentsPracticed * 25.0).clamp(0.0, 100.0),
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить лог матча: $e'));
    }
  }
}
