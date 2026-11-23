import 'package:equatable/equatable.dart';
import '../../domain/entities/wine_entities.dart';

class WineCatalogState extends Equatable {
  final List<WineRegionEntity> regions;
  final List<WineRegionEntity> filteredRegions;
  final List<TastingGuideEntity> guides;
  final WineCategory? selectedCategory;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String searchQuery;
  final int selectedTab;
  final bool isLoading;
  final String? errorMessage;

  const WineCatalogState({
    this.regions = const [],
    this.filteredRegions = const [],
    this.guides = const [],
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.selectedTab = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  WineCatalogState copyWith({
    List<WineRegionEntity>? regions,
    List<WineRegionEntity>? filteredRegions,
    List<TastingGuideEntity>? guides,
    WineCategory? Function()? selectedCategory,
    String? selectedDialect,
    String? searchQuery,
    int? selectedTab,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return WineCatalogState(
      regions: regions ?? this.regions,
      filteredRegions: filteredRegions ?? this.filteredRegions,
      guides: guides ?? this.guides,
      selectedCategory: selectedCategory != null
          ? selectedCategory()
          : this.selectedCategory,
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        regions,
        filteredRegions,
        guides,
        selectedCategory,
        selectedDialect,
        searchQuery,
        selectedTab,
        isLoading,
        errorMessage,
      ];
}
