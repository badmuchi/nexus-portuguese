import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/bazar_entities.dart';

abstract class BazarRepository {
  /// Получить список всех рынков и ярмарок.
  Future<Result<List<MarketplaceEntity>>> getMarkets({
    String? dialect,
  });

  /// Получить детальную информацию о рынке по ID.
  Future<Result<MarketplaceEntity>> getMarketById(String id);

  /// Получить фразы для покупок и торга на рынке.
  Future<Result<List<MarketPhraseEntity>>> getMarketPhrases({
    String? category,
    String? dialect,
  });

  /// Получить интерактивные сценарии торга.
  Future<Result<List<BargainScenarioEntity>>> getBargainScenarios();

  /// Записать покупку/прогресс по рынку.
  Future<Result<void>> recordMarketPurchase({
    required String marketId,
    required int itemsCount,
    required double totalSpent,
  });
}
