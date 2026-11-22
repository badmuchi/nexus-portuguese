import 'package:equatable/equatable.dart';
import '../../domain/entities/football_entities.dart';

enum FootballCatalogStatus { initial, loading, loaded, error }

class FootballCatalogState extends Equatable {
  final FootballCatalogStatus status;
  final List<FootballMatchEntity> allMatches;
  final List<FootballTermEntity> allTerms;
  final List<FanChantEntity> allChants;
  final FootballTermCategory? selectedCategory;
  final String selectedDialect; // 'all', 'BR', 'PT'
  final String searchQuery;
  final int activeTabIndex; // 0: Матчи, 1: Словарь, 2: Кричалки
  final String? errorMessage;

  const FootballCatalogState({
    this.status = FootballCatalogStatus.initial,
    this.allMatches = const [],
    this.allTerms = const [],
    this.allChants = const [],
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  bool get isLoading => status == FootballCatalogStatus.loading;

  List<FootballMatchEntity> get filteredMatches {
    var res = List<FootballMatchEntity>.from(allMatches);

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
          m.matchTitle.toLowerCase().contains(q) ||
          m.stadium.toLowerCase().contains(q) ||
          m.city.toLowerCase().contains(q) ||
          m.teamHome.toLowerCase().contains(q) ||
          m.teamAway.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  List<FootballTermEntity> get filteredTerms {
    var res = List<FootballTermEntity>.from(allTerms);

    if (selectedCategory != null) {
      res = res.where((t) => t.category == selectedCategory).toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((t) =>
          t.termPtPt.toLowerCase().contains(q) ||
          t.termPtBr.toLowerCase().contains(q) ||
          t.translationRu.toLowerCase().contains(q) ||
          t.explanationRu.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  List<FanChantEntity> get filteredChants {
    var res = List<FanChantEntity>.from(allChants);

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((c) => c.isPtPt).toList();
      } else if (isBr) {
        res = res.where((c) => c.isPtBr).toList();
      }
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((c) =>
          c.chantPt.toLowerCase().contains(q) ||
          c.translationRu.toLowerCase().contains(q) ||
          c.clubOrCountry.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  FootballCatalogState copyWith({
    FootballCatalogStatus? status,
    List<FootballMatchEntity>? allMatches,
    List<FootballTermEntity>? allTerms,
    List<FanChantEntity>? allChants,
    FootballTermCategory? selectedCategory,
    bool clearCategory = false,
    String? selectedDialect,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return FootballCatalogState(
      status: status ?? this.status,
      allMatches: allMatches ?? this.allMatches,
      allTerms: allTerms ?? this.allTerms,
      allChants: allChants ?? this.allChants,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allMatches,
        allTerms,
        allChants,
        selectedCategory,
        selectedDialect,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
