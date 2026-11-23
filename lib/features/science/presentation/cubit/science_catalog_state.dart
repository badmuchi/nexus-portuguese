import 'package:equatable/equatable.dart';
import '../../domain/entities/science_entities.dart';

class ScienceCatalogState extends Equatable {
  final List<ScienceTopicEntity> topics;
  final List<ScienceTopicEntity> filteredTopics;
  final List<LabExperimentEntity> experiments;
  final ScienceField? selectedField;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String searchQuery;
  final int selectedTab;
  final bool isLoading;
  final String? errorMessage;

  const ScienceCatalogState({
    this.topics = const [],
    this.filteredTopics = const [],
    this.experiments = const [],
    this.selectedField,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.selectedTab = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  ScienceCatalogState copyWith({
    List<ScienceTopicEntity>? topics,
    List<ScienceTopicEntity>? filteredTopics,
    List<LabExperimentEntity>? experiments,
    ScienceField? Function()? selectedField,
    String? selectedDialect,
    String? searchQuery,
    int? selectedTab,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return ScienceCatalogState(
      topics: topics ?? this.topics,
      filteredTopics: filteredTopics ?? this.filteredTopics,
      experiments: experiments ?? this.experiments,
      selectedField:
          selectedField != null ? selectedField() : this.selectedField,
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
        experiments,
        selectedField,
        selectedDialect,
        searchQuery,
        selectedTab,
        isLoading,
        errorMessage,
      ];
}
