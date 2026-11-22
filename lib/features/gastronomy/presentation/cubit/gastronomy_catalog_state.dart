import 'package:equatable/equatable.dart';
import '../../domain/entities/culinary_vocabulary_entity.dart';
import '../../domain/entities/recipe_entity.dart';

enum GastronomyCatalogStatus { initial, loading, loaded, error }

class GastronomyCatalogState extends Equatable {
  final GastronomyCatalogStatus status;
  final List<RecipeEntity> allRecipes;
  final List<CulinaryTermEntity> allTerms;
  final String selectedDialect; // 'all', 'BR', 'PT'
  final String? selectedDifficulty;
  final CulinaryTermType? selectedTermType;
  final String searchQuery;
  final int activeTabIndex; // 0: Рецепты, 1: Словарь и утварь
  final String? errorMessage;

  const GastronomyCatalogState({
    this.status = GastronomyCatalogStatus.initial,
    this.allRecipes = const [],
    this.allTerms = const [],
    this.selectedDialect = 'all',
    this.selectedDifficulty,
    this.selectedTermType,
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  bool get isLoading => status == GastronomyCatalogStatus.loading;

  List<RecipeEntity> get filteredRecipes {
    var res = List<RecipeEntity>.from(allRecipes);

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt') &&
          !selectedDialect.toLowerCase().contains('br');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((r) => r.isPtPt).toList();
      } else if (isBr) {
        res = res.where((r) => r.isPtBr).toList();
      }
    }

    if (selectedDifficulty != null) {
      res = res.where((r) => r.difficulty.toLowerCase() == selectedDifficulty!.toLowerCase()).toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((r) =>
          r.titlePt.toLowerCase().contains(q) ||
          r.titleRu.toLowerCase().contains(q) ||
          r.region.toLowerCase().contains(q) ||
          r.culturalStoryRu.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  List<CulinaryTermEntity> get filteredTerms {
    var res = List<CulinaryTermEntity>.from(allTerms);

    if (selectedTermType != null) {
      res = res.where((t) => t.type == selectedTermType).toList();
    }

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt') &&
          !selectedDialect.toLowerCase().contains('br');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((t) => t.isPtPt || (!t.isPtPt && !t.isPtBr)).toList();
      } else if (isBr) {
        res = res.where((t) => t.isPtBr || (!t.isPtPt && !t.isPtBr)).toList();
      }
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((t) =>
          t.termPt.toLowerCase().contains(q) ||
          t.translationRu.toLowerCase().contains(q) ||
          t.usageExamplePt.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  GastronomyCatalogState copyWith({
    GastronomyCatalogStatus? status,
    List<RecipeEntity>? allRecipes,
    List<CulinaryTermEntity>? allTerms,
    String? selectedDialect,
    String? selectedDifficulty,
    bool clearDifficulty = false,
    CulinaryTermType? selectedTermType,
    bool clearTermType = false,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return GastronomyCatalogState(
      status: status ?? this.status,
      allRecipes: allRecipes ?? this.allRecipes,
      allTerms: allTerms ?? this.allTerms,
      selectedDialect: selectedDialect ?? this.selectedDialect,
      selectedDifficulty:
          clearDifficulty ? null : (selectedDifficulty ?? this.selectedDifficulty),
      selectedTermType:
          clearTermType ? null : (selectedTermType ?? this.selectedTermType),
      searchQuery: searchQuery ?? this.searchQuery,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allRecipes,
        allTerms,
        selectedDialect,
        selectedDifficulty,
        selectedTermType,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
