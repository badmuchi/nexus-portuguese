import 'package:equatable/equatable.dart';
import '../../domain/entities/finance_entities.dart';

class FinanceCatalogState extends Equatable {
  final List<FinanceTopicEntity> topics;
  final List<FinanceTopicEntity> filteredTopics;
  final List<FintechSimulatorEntity> simulators;
  final FinanceCategory? selectedCategory;
  final String selectedDialect;
  final String searchQuery;
  final int selectedTab;
  final bool isLoading;
  final String? errorMessage;

  const FinanceCatalogState({
    this.topics = const [],
    this.filteredTopics = const [],
    this.simulators = const [],
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.selectedTab = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  FinanceCatalogState copyWith({
    List<FinanceTopicEntity>? topics,
    List<FinanceTopicEntity>? filteredTopics,
    List<FintechSimulatorEntity>? simulators,
    FinanceCategory? Function()? selectedCategory,
    String? selectedDialect,
    String? searchQuery,
    int? selectedTab,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return FinanceCatalogState(
      topics: topics ?? this.topics,
      filteredTopics: filteredTopics ?? this.filteredTopics,
      simulators: simulators ?? this.simulators,
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
        topics,
        filteredTopics,
        simulators,
        selectedCategory,
        selectedDialect,
        searchQuery,
        selectedTab,
        isLoading,
        errorMessage,
      ];
}
