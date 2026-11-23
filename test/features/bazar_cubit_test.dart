import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/bazar/data/datasources/bazar_seed_data.dart';
import 'package:nexus_portuguese_app/features/bazar/domain/entities/bazar_entities.dart';
import 'package:nexus_portuguese_app/features/bazar/domain/repositories/bazar_repository.dart';
import 'package:nexus_portuguese_app/features/bazar/presentation/cubit/bargain_simulator_cubit.dart';
import 'package:nexus_portuguese_app/features/bazar/presentation/cubit/bazar_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/bazar/presentation/cubit/bazar_catalog_state.dart';

class MockBazarRepository extends Mock implements BazarRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  late MockBazarRepository mockRepository;
  late MockHybridAudioPlaybackService mockAudioService;

  setUp(() {
    mockRepository = MockBazarRepository();
    mockAudioService = MockHybridAudioPlaybackService();

    when(() => mockAudioService.stop()).thenAnswer((_) async {});
    when(
      () => mockAudioService.playAudioOrSpeak(
        fallbackText: any(named: 'fallbackText'),
        audioPathOrUrl: any(named: 'audioPathOrUrl'),
        dialect: any(named: 'dialect'),
        rate: any(named: 'rate'),
      ),
    ).thenAnswer((_) async {});
  });

  group('BazarCatalogCubit Tests', () {
    test('initial state is correct', () {
      final cubit = BazarCatalogCubit(repository: mockRepository);
      expect(cubit.state.status, BazarCatalogStatus.initial);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.activeTabIndex, 0);
      cubit.close();
    });

    test('loadCatalog success populates markets, phrases, and scenarios', () async {
      when(() => mockRepository.getMarkets())
          .thenAnswer((_) async => Result.ok(BazarSeedData.getMarkets()));
      when(() => mockRepository.getMarketPhrases())
          .thenAnswer((_) async => Result.ok(BazarSeedData.getMarketPhrases()));
      when(() => mockRepository.getBargainScenarios())
          .thenAnswer((_) async => Result.ok(BazarSeedData.getBargainScenarios()));

      final cubit = BazarCatalogCubit(repository: mockRepository);
      await cubit.loadCatalog();

      expect(cubit.state.status, BazarCatalogStatus.loaded);
      expect(cubit.state.allMarkets.length, 4);
      expect(cubit.state.allPhrases.length, greaterThanOrEqualTo(16));
      expect(cubit.state.allScenarios.length, greaterThanOrEqualTo(2));
      cubit.close();
    });

    test('loadCatalog error emits error status', () async {
      when(() => mockRepository.getMarkets())
          .thenAnswer((_) async => Result.err(const DatabaseFailure('Network error')));
      when(() => mockRepository.getMarketPhrases())
          .thenAnswer((_) async => Result.ok(BazarSeedData.getMarketPhrases()));
      when(() => mockRepository.getBargainScenarios())
          .thenAnswer((_) async => Result.ok(BazarSeedData.getBargainScenarios()));

      final cubit = BazarCatalogCubit(repository: mockRepository);
      await cubit.loadCatalog();

      expect(cubit.state.status, BazarCatalogStatus.error);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters by dialect, category, and search query', () async {
      when(() => mockRepository.getMarkets())
          .thenAnswer((_) async => Result.ok(BazarSeedData.getMarkets()));
      when(() => mockRepository.getMarketPhrases())
          .thenAnswer((_) async => Result.ok(BazarSeedData.getMarketPhrases()));
      when(() => mockRepository.getBargainScenarios())
          .thenAnswer((_) async => Result.ok(BazarSeedData.getBargainScenarios()));

      final cubit = BazarCatalogCubit(repository: mockRepository);
      await cubit.loadCatalog();

      // Dialect filter
      cubit.filterByDialect('pt_PT');
      expect(cubit.state.filteredMarkets.every((m) => m.isPtPt), isTrue);

      // Category filter
      cubit.filterByDialect('all');
      cubit.filterByCategory('greeting');
      expect(cubit.state.filteredPhrases.every((p) => p.category == 'greeting'), isTrue);

      cubit.filterByCategory(null);
      expect(cubit.state.selectedPhraseCategory, isNull);

      // Search
      cubit.search('pastel');
      expect(cubit.state.searchQuery, 'pastel');

      // Tab index
      cubit.setTab(2);
      expect(cubit.state.activeTabIndex, 2);

      cubit.close();
    });
  });

  group('BargainSimulatorCubit Tests', () {
    late BargainScenarioEntity testScenario;

    setUp(() {
      testScenario = const BargainScenarioEntity(
        id: 'test_scenario',
        itemNamePt: 'Queijo da Serra',
        itemNameRu: 'Горный сыр',
        itemEmoji: '🧀',
        marketName: 'Mercado do Bolhão',
        vendorName: 'Dona Maria',
        dialect: 'pt_PT',
        initialPrice: 20.0,
        targetFairPrice: 15.0,
        currencySymbol: '€',
        steps: [
          BargainStepEntity(
            id: 'step_1',
            buyerTacticRu: 'Оптовая скидка',
            buyerPhrasePt: 'Se levar dois, faz um desconto?',
            buyerPhraseRu: 'Если возьму два, сделаете скидку?',
            vendorResponsePt: 'Faço a 18 cada.',
            vendorResponseRu: 'Отдам по 18 за каждый.',
            offeredPrice: 18.0,
          ),
          BargainStepEntity(
            id: 'step_2',
            buyerTacticRu: 'Финальный торг',
            buyerPhrasePt: 'Fechamos em 15?',
            buyerPhraseRu: 'Договорились на 15?',
            vendorResponsePt: 'Está bem, leva lá!',
            vendorResponseRu: 'Ладно, забирай!',
            offeredPrice: 15.0,
          ),
        ],
      );

      when(
        () => mockRepository.recordMarketPurchase(
          marketId: any(named: 'marketId'),
          itemsCount: any(named: 'itemsCount'),
          totalSpent: any(named: 'totalSpent'),
        ),
      ).thenAnswer((_) async => const Result.ok(null));
    });

    test('initial state matches scenario', () {
      final cubit = BargainSimulatorCubit(
        scenario: testScenario,
        repository: mockRepository,
        audioService: mockAudioService,
      );

      expect(cubit.state.currentPrice, 20.0);
      expect(cubit.state.currentStepIndex, 0);
      expect(cubit.state.hasOfferedCurrent, isFalse);
      expect(cubit.state.isSuccess, isFalse);
      expect(cubit.state.isLastStep, isFalse);

      cubit.close();
    });

    test('applyTactic applies discount and on final step records purchase', () async {
      final cubit = BargainSimulatorCubit(
        scenario: testScenario,
        repository: mockRepository,
        audioService: mockAudioService,
      );

      // Step 1
      cubit.applyTactic();
      expect(cubit.state.hasOfferedCurrent, isTrue);
      expect(cubit.state.currentPrice, 18.0);
      expect(cubit.state.isSuccess, isFalse);

      // Move to Step 2
      cubit.nextStep();
      expect(cubit.state.currentStepIndex, 1);
      expect(cubit.state.hasOfferedCurrent, isFalse);
      expect(cubit.state.isLastStep, isTrue);

      // Step 2 (Final)
      cubit.applyTactic();
      expect(cubit.state.hasOfferedCurrent, isTrue);
      expect(cubit.state.currentPrice, 15.0);
      expect(cubit.state.isSuccess, isTrue);

      verify(
        () => mockRepository.recordMarketPurchase(
          marketId: 'test_scenario',
          itemsCount: 1,
          totalSpent: 15.0,
        ),
      ).called(1);

      cubit.close();
    });

    test('restart resets state to beginning', () {
      final cubit = BargainSimulatorCubit(
        scenario: testScenario,
        repository: mockRepository,
        audioService: mockAudioService,
      );

      cubit.applyTactic();
      cubit.nextStep();
      expect(cubit.state.currentStepIndex, 1);

      cubit.restart();
      expect(cubit.state.currentStepIndex, 0);
      expect(cubit.state.currentPrice, 20.0);
      expect(cubit.state.hasOfferedCurrent, isFalse);
      expect(cubit.state.isSuccess, isFalse);

      cubit.close();
    });
  });
}
