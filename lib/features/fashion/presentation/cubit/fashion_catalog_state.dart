import 'package:equatable/equatable.dart';
import '../../domain/entities/fashion_entities.dart';

class FashionCatalogState extends Equatable {
  final List<FashionTopicEntity> topics;
  final List<FashionTopicEntity> filteredTopics;
  final List<TextileCraftEntity> crafts;
  final FashionCategory? selectedCategory;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String searchQuery;
  final int selectedTab;
  final bool isLoading;
  final String? errorMessage;

  const FashionCatalogState({
    this.topics = const [],
    this.filteredTopics = const [],
    this.crafts = const [],
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.selectedTab = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  FashionCatalogState copyWith({
    List<FashionTopicEntity>? topics,
    List<FashionTopicEntity>? filteredTopics,
    List<TextileCraftEntity>? crafts,
    FashionCategory? Function()? selectedCategory,
    String? selectedDialect,
    String? searchQuery,
    int? selectedTab,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return FashionCatalogState(
      topics: topics ?? this.topics,
      filteredTopics: filteredTopics ?? this.filteredTopics,
      crafts: crafts ?? this.crafts,
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
        topics,
        filteredTopics,
        crafts,
        selectedCategory,
        selectedDialect,
        searchQuery,
        selectedTab,
        isLoading,
        errorMessage,
      ];
}
