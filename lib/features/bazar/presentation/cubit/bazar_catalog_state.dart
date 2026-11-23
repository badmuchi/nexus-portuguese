import 'package:equatable/equatable.dart';
import '../../domain/entities/bazar_entities.dart';

enum BazarCatalogStatus { initial, loading, loaded, error }

class BazarCatalogState extends Equatable {
  final BazarCatalogStatus status;
  final List<MarketplaceEntity> allMarkets;
  final List<MarketPhraseEntity> allPhrases;
  final List<BargainScenarioEntity> allScenarios;
  final String? selectedPhraseCategory;
  final String selectedDialect; // 'all', 'BR', 'PT'
  final String searchQuery;
  final int activeTabIndex; // 0: Рынки, 1: Фразы, 2: Торг
  final String? errorMessage;

  const BazarCatalogState({
    this.status = BazarCatalogStatus.initial,
    this.allMarkets = const [],
    this.allPhrases = const [],
    this.allScenarios = const [],
    this.selectedPhraseCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  bool get isLoading => status == BazarCatalogStatus.loading;

  List<MarketplaceEntity> get filteredMarkets {
    var res = List<MarketplaceEntity>.from(allMarkets);

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((m) => m.isPtPt).toList();
      } else if (isBr) {
        res = res.where((m) => m.isPtBr).toList();
      }
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((m) =>
          m.namePt.toLowerCase().contains(q) ||
          m.nameRu.toLowerCase().contains(q) ||
          m.city.toLowerCase().contains(q) ||
          m.atmosphereRu.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  List<MarketPhraseEntity> get filteredPhrases {
    var res = List<MarketPhraseEntity>.from(allPhrases);

    if (selectedPhraseCategory != null) {
      res = res.where((p) => p.category == selectedPhraseCategory).toList();
    }

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((p) => p.isPtPt || (!p.isPtPt && !p.isPtBr)).toList();
      } else if (isBr) {
        res = res.where((p) => p.isPtBr || (!p.isPtPt && !p.isPtBr)).toList();
      }
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((p) =>
          p.phrasePt.toLowerCase().contains(q) ||
          p.translationRu.toLowerCase().contains(q) ||
          p.contextTipRu.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  List<BargainScenarioEntity> get filteredScenarios {
    var res = List<BargainScenarioEntity>.from(allScenarios);

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((s) => s.isPtPt).toList();
      } else if (isBr) {
        res = res.where((s) => s.isPtBr).toList();
      }
    }

    return res;
  }

  BazarCatalogState copyWith({
    BazarCatalogStatus? status,
    List<MarketplaceEntity>? allMarkets,
    List<MarketPhraseEntity>? allPhrases,
    List<BargainScenarioEntity>? allScenarios,
    String? selectedPhraseCategory,
    bool clearCategory = false,
    String? selectedDialect,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return BazarCatalogState(
      status: status ?? this.status,
      allMarkets: allMarkets ?? this.allMarkets,
      allPhrases: allPhrases ?? this.allPhrases,
      allScenarios: allScenarios ?? this.allScenarios,
      selectedPhraseCategory: clearCategory
          ? null
          : (selectedPhraseCategory ?? this.selectedPhraseCategory),
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allMarkets,
        allPhrases,
        allScenarios,
        selectedPhraseCategory,
        selectedDialect,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
