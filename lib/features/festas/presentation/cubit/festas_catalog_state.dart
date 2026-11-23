import 'package:equatable/equatable.dart';
import '../../domain/entities/festas_entities.dart';

class FestasCatalogState extends Equatable {
  final List<FestaEntity> festas;
  final List<FestaEntity> filteredFestas;
  final List<FestaTraditionEntity> traditions;
  final FestaCategory? selectedCategory;
  final String selectedDialect;
  final String searchQuery;
  final int selectedTab;
  final bool isLoading;
  final String? errorMessage;

  const FestasCatalogState({
    this.festas = const [],
    this.filteredFestas = const [],
    this.traditions = const [],
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.selectedTab = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  FestasCatalogState copyWith({
    List<FestaEntity>? festas,
    List<FestaEntity>? filteredFestas,
    List<FestaTraditionEntity>? traditions,
    FestaCategory? Function()? selectedCategory,
    String? selectedDialect,
    String? searchQuery,
    int? selectedTab,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return FestasCatalogState(
      festas: festas ?? this.festas,
      filteredFestas: filteredFestas ?? this.filteredFestas,
      traditions: traditions ?? this.traditions,
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
        festas,
        filteredFestas,
        traditions,
        selectedCategory,
        selectedDialect,
        searchQuery,
        selectedTab,
        isLoading,
        errorMessage,
      ];
}
