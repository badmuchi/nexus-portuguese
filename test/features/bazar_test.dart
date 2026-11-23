import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/bazar/data/datasources/bazar_seed_data.dart';
import 'package:nexus_portuguese_app/features/bazar/data/repositories/bazar_repository_impl.dart';
import 'package:nexus_portuguese_app/features/bazar/domain/entities/bazar_entities.dart';

void main() {
  group('Bazar Entities Tests', () {
    test('MarketplaceEntity dialect helpers detect PT-BR and PT-PT correctly', () {
      const ptMarket = MarketplaceEntity(
        id: 'ladra',
        namePt: 'Feira da Ladra',
        nameRu: 'Блошиный рынок воровки',
        city: 'Lisboa',
        dialect: 'pt_PT',
        coverEmoji: '🏺',
        atmosphereRu: 'Атмосфера',
        historicalContextRu: 'История',
        stalls: [],
      );

      expect(ptMarket.isPtPt, isTrue);
      expect(ptMarket.isPtBr, isFalse);
      expect(ptMarket.dialectFlag, '🇵🇹');
      expect(ptMarket.dialectLabel, 'Portugal');

      const brMarket = MarketplaceEntity(
        id: 'mercadao_sp',
        namePt: 'Mercadão Municipal',
        nameRu: 'Муниципальный рынок',
        city: 'São Paulo',
        dialect: 'pt_BR',
        coverEmoji: '🥪',
        atmosphereRu: 'Атмосфера',
        historicalContextRu: 'История',
        stalls: [],
      );

      expect(brMarket.isPtBr, isTrue);
      expect(brMarket.isPtPt, isFalse);
      expect(brMarket.dialectFlag, '🇧🇷');
      expect(brMarket.dialectLabel, 'Brasil');
    });

    test('MarketPhraseEntity properties and dialect flags', () {
      const phrase = MarketPhraseEntity(
        id: 'p1',
        phrasePt: 'Quanto custa o quilo?',
        translationRu: 'Сколько стоит килограмм?',
        category: 'weightAndQty',
        dialect: 'all',
        contextTipRu: 'Универсальный вопрос',
      );

      expect(phrase.id, 'p1');
      expect(phrase.category, 'weightAndQty');
      expect(phrase.dialectFlag, '🌐');

      const ptPhrase = MarketPhraseEntity(
        id: 'p2',
        phrasePt: 'Queria um quarto de quilo',
        translationRu: 'Я хотел бы четверть килограмма',
        category: 'weightAndQty',
        dialect: 'pt_PT',
        contextTipRu: 'В Португалии',
      );
      expect(ptPhrase.isPtPt, isTrue);
      expect(ptPhrase.isPtBr, isFalse);
      expect(ptPhrase.dialectFlag, '🇵🇹');
    });

    test('BargainScenarioEntity props and steps calculation', () {
      const step1 = BargainStepEntity(
        id: 's1',
        buyerTacticRu: 'Вежливый запрос скидки',
        buyerPhrasePt: 'Faz um precinho melhor?',
        buyerPhraseRu: 'Сделаете цену получше?',
        vendorResponsePt: 'Consigo fazer por 40.',
        vendorResponseRu: 'Могу отдать за 40.',
        offeredPrice: 40.0,
      );

      const scenario = BargainScenarioEntity(
        id: 'sc1',
        itemNamePt: 'Azulejo Antigo',
        itemNameRu: 'Старинный азулежу',
        itemEmoji: '🧱',
        marketName: 'Feira da Ladra',
        vendorName: 'Sr. António',
        dialect: 'pt_PT',
        initialPrice: 50.0,
        targetFairPrice: 35.0,
        currencySymbol: '€',
        steps: [step1],
      );

      expect(scenario.initialPrice, 50.0);
      expect(scenario.targetFairPrice, 35.0);
      expect(scenario.steps.length, 1);
      expect(scenario.isPtPt, isTrue);
      expect(scenario.isPtBr, isFalse);
    });
  });

  group('Bazar Seed Data Integrity', () {
    test('contains 4 authentic marketplaces with stalls and items', () {
      final markets = BazarSeedData.getMarkets();
      expect(markets.length, 4);

      for (final m in markets) {
        expect(m.id, isNotEmpty);
        expect(m.namePt, isNotEmpty);
        expect(m.nameRu, isNotEmpty);
        expect(m.city, isNotEmpty);
        expect(m.stalls, isNotEmpty);

        for (final s in m.stalls) {
          expect(s.vendorName, isNotEmpty);
          expect(s.stallNamePt, isNotEmpty);
          expect(s.catchphrasePt, isNotEmpty);
          expect(s.items, isNotEmpty);

          for (final item in s.items) {
            expect(item.defaultPrice, greaterThan(0));
            expect(item.namePt, isNotEmpty);
            expect(item.unitRu, isNotEmpty);
            expect(item.currencySymbol, isNotEmpty);
          }
        }
      }
    });

    test('contains market phrases across all categories', () {
      final phrases = BazarSeedData.getMarketPhrases();
      expect(phrases.length, greaterThanOrEqualTo(16));

      final categories = phrases.map((p) => p.category).toSet();
      expect(categories, containsAll(['greeting', 'weightAndQty', 'tasting', 'bargaining']));
    });

    test('contains bargaining scenarios with progressive discounts', () {
      final scenarios = BazarSeedData.getBargainScenarios();
      expect(scenarios.length, greaterThanOrEqualTo(2));

      for (final sc in scenarios) {
        expect(sc.initialPrice, greaterThan(sc.targetFairPrice));
        expect(sc.steps, isNotEmpty);
        for (final step in sc.steps) {
          expect(step.offeredPrice, lessThanOrEqualTo(sc.initialPrice));
        }
      }
    });
  });

  group('BazarRepositoryImpl Tests', () {
    late BazarRepositoryImpl repository;

    setUp(() {
      repository = BazarRepositoryImpl();
    });

    test('getMarkets returns all seed markets successfully', () async {
      final result = await repository.getMarkets();
      expect(result.isOk, isTrue);
      expect(result.value.length, 4);
    });

    test('getMarketById returns specific marketplace', () async {
      final result = await repository.getMarketById('mercadao_sp');
      expect(result.isOk, isTrue);
      expect(result.value.namePt, contains('Mercado Municipal'));
    });

    test('getMarketById returns failure for unknown id', () async {
      final result = await repository.getMarketById('non_existent');
      expect(result.isOk, isFalse);
    });

    test('getMarketPhrases returns all phrases', () async {
      final result = await repository.getMarketPhrases();
      expect(result.isOk, isTrue);
      expect(result.value.length, greaterThanOrEqualTo(16));
    });

    test('getBargainScenarios returns scenarios', () async {
      final result = await repository.getBargainScenarios();
      expect(result.isOk, isTrue);
      expect(result.value.length, greaterThanOrEqualTo(2));
    });

    test('recordMarketPurchase succeeds without database', () async {
      final result = await repository.recordMarketPurchase(
        marketId: 'feira_da_ladra',
        itemsCount: 2,
        totalSpent: 45.0,
      );
      expect(result.isOk, isTrue);
    });
  });
}
