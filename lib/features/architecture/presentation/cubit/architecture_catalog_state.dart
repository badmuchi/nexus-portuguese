import 'package:equatable/equatable.dart';
import '../../domain/entities/architecture_entities.dart';

class ArchitectureCatalogState extends Equatable {
  final List<ArchitecturalMonumentEntity> monuments;
  final List<ArchitecturalMonumentEntity> filteredMonuments;
  final List<ArchitecturalStyleEntity> styles;
  final ArchitectureCategory? selectedCategory;
  final String selectedDialect;
  final String searchQuery;
  final int selectedTab;
  final bool isLoading;
  final String? errorMessage;

  const ArchitectureCatalogState({
    this.monuments = const [],
    this.filteredMonuments = const [],
    this.styles = const [],
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.selectedTab = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  ArchitectureCatalogState copyWith({
    List<ArchitecturalMonumentEntity>? monuments,
    List<ArchitecturalMonumentEntity>? filteredMonuments,
    List<ArchitecturalStyleEntity>? styles,
    ArchitectureCategory? Function()? selectedCategory,
    String? selectedDialect,
    String? searchQuery,
    int? selectedTab,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return ArchitectureCatalogState(
      monuments: monuments ?? this.monuments,
      filteredMonuments: filteredMonuments ?? this.filteredMonuments,
      styles: styles ?? this.styles,
      selectedCategory:
          selectedCategory != null ? selectedCategory() : this.selectedCategory,
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        monuments,
        filteredMonuments,
        styles,
        selectedCategory,
        selectedDialect,
        searchQuery,
        selectedTab,
        isLoading,
        errorMessage,
      ];
}
