import 'package:equatable/equatable.dart';
import '../../domain/entities/cultural_tip_entity.dart';
import '../../domain/entities/survival_phrase_entity.dart';
import '../../domain/entities/survival_quest_entity.dart';

enum SurvivalCatalogStatus { initial, loading, loaded, error }

class SurvivalCatalogState extends Equatable {
  final SurvivalCatalogStatus status;
  final List<SurvivalQuestEntity> allQuests;
  final List<SurvivalPhraseEntity> allPhrases;
  final List<CulturalTipEntity> allTips;
  final SurvivalCategory? selectedCategory;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String searchQuery;
  final int activeTabIndex; // 0 = Квесты, 1 = Шпаргалки, 2 = Этикет
  final String? errorMessage;

  const SurvivalCatalogState({
    this.status = SurvivalCatalogStatus.initial,
    this.allQuests = const [],
    this.allPhrases = const [],
    this.allTips = const [],
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  bool get isLoading => status == SurvivalCatalogStatus.loading;

  List<SurvivalQuestEntity> get filteredQuests {
    var res = List<SurvivalQuestEntity>.from(allQuests);
    if (selectedCategory != null) {
      res = res.where((q) => q.category == selectedCategory).toList();
    }
    if (selectedDialect != 'all') {
      res = res.where((q) => q.dialect.toLowerCase() == selectedDialect.toLowerCase()).toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((item) =>
          item.titlePt.toLowerCase().contains(q) ||
          item.titleRu.toLowerCase().contains(q) ||
          item.overviewRu.toLowerCase().contains(q)).toList();
    }
    return res;
  }

  List<SurvivalPhraseEntity> get filteredPhrases {
    var res = List<SurvivalPhraseEntity>.from(allPhrases);
    if (selectedCategory != null) {
      res = res.where((p) => p.category == selectedCategory).toList();
    }
    if (selectedDialect != 'all') {
      res = res.where((p) => p.dialect.toLowerCase() == selectedDialect.toLowerCase() || p.dialect == 'all').toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((p) =>
          p.textPt.toLowerCase().contains(q) ||
          p.translationRu.toLowerCase().contains(q) ||
          p.contextNoteRu.toLowerCase().contains(q)).toList();
    }
    return res;
  }

  List<CulturalTipEntity> get filteredTips {
    var res = List<CulturalTipEntity>.from(allTips);
    if (selectedCategory != null) {
      res = res.where((t) => t.category == selectedCategory).toList();
    }
    if (selectedDialect != 'all') {
      res = res.where((t) => t.dialect.toLowerCase() == selectedDialect.toLowerCase() || t.dialect == 'all').toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((t) =>
          t.titlePt.toLowerCase().contains(q) ||
          t.titleRu.toLowerCase().contains(q) ||
          t.contentRu.toLowerCase().contains(q)).toList();
    }
    return res;
  }

  SurvivalCatalogState copyWith({
    SurvivalCatalogStatus? status,
    List<SurvivalQuestEntity>? allQuests,
    List<SurvivalPhraseEntity>? allPhrases,
    List<CulturalTipEntity>? allTips,
    SurvivalCategory? selectedCategory,
    bool clearCategory = false,
    String? selectedDialect,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return SurvivalCatalogState(
      status: status ?? this.status,
      allQuests: allQuests ?? this.allQuests,
      allPhrases: allPhrases ?? this.allPhrases,
      allTips: allTips ?? this.allTips,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allQuests,
        allPhrases,
        allTips,
        selectedCategory,
        selectedDialect,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
