import 'package:equatable/equatable.dart';
import '../../domain/entities/ancestral_entities.dart';

class AncestralCatalogState extends Equatable {
  final List<TraditionalCommunityEntity> communities;
  final List<TraditionalCommunityEntity> filteredCommunities;
  final List<HerbalRemedyEntity> remedies;
  final bool isLoading;
  final String? errorMessage;
  final CommunityCategory? selectedCategory;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String searchQuery;
  final int selectedTab; // 0: Comunidades, 1: Ervanária & Remédios, 2: Квиз

  const AncestralCatalogState({
    this.communities = const [],
    this.filteredCommunities = const [],
    this.remedies = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.selectedTab = 0,
  });

  AncestralCatalogState copyWith({
    List<TraditionalCommunityEntity>? communities,
    List<TraditionalCommunityEntity>? filteredCommunities,
    List<HerbalRemedyEntity>? remedies,
    bool? isLoading,
    String? Function()? errorMessage,
    CommunityCategory? Function()? selectedCategory,
    String? selectedDialect,
    String? searchQuery,
    int? selectedTab,
  }) {
    return AncestralCatalogState(
      communities: communities ?? this.communities,
      filteredCommunities: filteredCommunities ?? this.filteredCommunities,
      remedies: remedies ?? this.remedies,
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
        communities,
        filteredCommunities,
        remedies,
        isLoading,
        errorMessage,
        selectedCategory,
        selectedDialect,
        searchQuery,
        selectedTab,
      ];
}
