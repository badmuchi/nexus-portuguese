import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/bazar_entities.dart';
import '../../domain/repositories/bazar_repository.dart';
import '../datasources/bazar_seed_data.dart';

class BazarRepositoryImpl implements BazarRepository {
  final AppDatabase? _database;

  BazarRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<MarketplaceEntity>>> getMarkets({
    String? dialect,
  }) async {
    try {
      var pool = List<MarketplaceEntity>.from(BazarSeedData.markets);

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
      return Result.err(DatabaseFailure('Ошибка загрузки рынков: $e'));
    }
  }

  @override
  Future<Result<MarketplaceEntity>> getMarketById(String id) async {
    try {
      final market = BazarSeedData.markets.firstWhere(
        (m) => m.id == id,
        orElse: () => throw Exception('Рынок $id не найден'),
      );
      return Result.ok(market);
    } catch (e) {
      return Result.err(DatabaseFailure('Рынок не найден: $e'));
    }
  }

  @override
  Future<Result<List<MarketPhraseEntity>>> getMarketPhrases({
    String? category,
    String? dialect,
  }) async {
    try {
      var pool = List<MarketPhraseEntity>.from(BazarSeedData.phrases);

      if (category != null && category.toLowerCase() != 'all') {
        pool = pool.where((p) => p.category == category).toList();
      }

      if (dialect != null && dialect.toLowerCase() != 'all') {
        final d = dialect.toLowerCase();
        final isPt = d.contains('pt') && !d.contains('br');
        final isBr = d.contains('br');

        if (isPt) {
          pool = pool.where((p) => p.isPtPt || (!p.isPtPt && !p.isPtBr)).toList();
        } else if (isBr) {
          pool = pool.where((p) => p.isPtBr || (!p.isPtPt && !p.isPtBr)).toList();
        }
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка загрузки фраз рынка: $e'));
    }
  }

  @override
  Future<Result<List<BargainScenarioEntity>>> getBargainScenarios() async {
    try {
      return const Result.ok(BazarSeedData.scenarios);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка загрузки сценариев торга: $e'));
    }
  }

  @override
  Future<Result<void>> recordMarketPurchase({
    required String marketId,
    required int itemsCount,
    required double totalSpent,
  }) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'bazar_$marketId',
          wordAccuracy: (itemsCount * 25.0).clamp(0.0, 100.0),
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить лог покупок: $e'));
    }
  }
}
