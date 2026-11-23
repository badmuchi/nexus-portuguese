import 'package:equatable/equatable.dart';
import '../../domain/entities/carnival_entities.dart';

class CarnivalCatalogState extends Equatable {
  final List<CarnivalTraditionEntity> traditions;
  final List<CarnivalTraditionEntity> filteredTraditions;
  final List<RhythmWorkshopEntity> workshops;
  final bool isLoading;
  final String? errorMessage;
  final CarnivalTraditionCategory? selectedCategory;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String searchQuery;
  final int selectedTab; // 0: Tradições, 1: Oficinas de Ritmo & Letra, 2: Квиз

  const CarnivalCatalogState({
    this.traditions = const [],
    this.filteredTraditions = const [],
    this.workshops = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.selectedTab = 0,
  });

  CarnivalCatalogState copyWith({
    List<CarnivalTraditionEntity>? traditions,
    List<CarnivalTraditionEntity>? filteredTraditions,
    List<RhythmWorkshopEntity>? workshops,
    bool? isLoading,
    String? Function()? errorMessage,
    CarnivalTraditionCategory? Function()? selectedCategory,
    String? selectedDialect,
    String? searchQuery,
    int? selectedTab,
  }) {
    return CarnivalCatalogState(
      traditions: traditions ?? this.traditions,
      filteredTraditions: filteredTraditions ?? this.filteredTraditions,
      workshops: workshops ?? this.workshops,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      selectedCategory: selectedCategory != null ? selectedCategory() : this.selectedCategory,
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [
        traditions,
        filteredTraditions,
        workshops,
        isLoading,
        errorMessage,
        selectedCategory,
        selectedDialect,
        searchQuery,
        selectedTab,
      ];
}
