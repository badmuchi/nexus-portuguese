import 'package:equatable/equatable.dart';
import '../../domain/entities/lusophone_country_entity.dart';
import '../../domain/entities/travel_phrase_entity.dart';

enum TravelCatalogStatus { initial, loading, loaded, error }

class TravelCatalogState extends Equatable {
  final TravelCatalogStatus status;
  final List<LusophoneCountryEntity> allCountries;
  final List<TravelPhraseEntity> allPhrases;
  final String? selectedContinent;
  final TravelPhraseCategory? selectedPhraseCategory;
  final String selectedDialect; // 'all', 'BR', 'PT'
  final String searchQuery;
  final int activeTabIndex; // 0: Страны, 1: Фразы
  final String? errorMessage;

  const TravelCatalogState({
    this.status = TravelCatalogStatus.initial,
    this.allCountries = const [],
    this.allPhrases = const [],
    this.selectedContinent,
    this.selectedPhraseCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  bool get isLoading => status == TravelCatalogStatus.loading;

  List<LusophoneCountryEntity> get filteredCountries {
    var res = List<LusophoneCountryEntity>.from(allCountries);

    if (selectedContinent != null && selectedContinent != 'all') {
      res = res
          .where((c) => c.continentRu.toLowerCase().contains(selectedContinent!.toLowerCase()))
          .toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((c) =>
          c.namePt.toLowerCase().contains(q) ||
          c.nameRu.toLowerCase().contains(q) ||
          c.capitalPt.toLowerCase().contains(q) ||
          c.capitalRu.toLowerCase().contains(q) ||
          c.culturalOverviewRu.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  List<TravelPhraseEntity> get filteredPhrases {
    var res = List<TravelPhraseEntity>.from(allPhrases);

    if (selectedPhraseCategory != null) {
      res = res.where((p) => p.category == selectedPhraseCategory).toList();
    }

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt') &&
          !selectedDialect.toLowerCase().contains('br');
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

  TravelCatalogState copyWith({
    TravelCatalogStatus? status,
    List<LusophoneCountryEntity>? allCountries,
    List<TravelPhraseEntity>? allPhrases,
    String? selectedContinent,
    bool clearContinent = false,
    TravelPhraseCategory? selectedPhraseCategory,
    bool clearPhraseCategory = false,
    String? selectedDialect,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return TravelCatalogState(
      status: status ?? this.status,
      allCountries: allCountries ?? this.allCountries,
      allPhrases: allPhrases ?? this.allPhrases,
      selectedContinent:
          clearContinent ? null : (selectedContinent ?? this.selectedContinent),
      selectedPhraseCategory: clearPhraseCategory
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
        allCountries,
        allPhrases,
        selectedContinent,
        selectedPhraseCategory,
        selectedDialect,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
