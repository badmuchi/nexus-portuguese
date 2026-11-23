import 'package:equatable/equatable.dart';
import '../../domain/entities/folklore_entities.dart';

class FolkloreCatalogState extends Equatable {
  final List<MythicalEntity> myths;
  final List<MythicalEntity> filteredMyths;
  final List<FolkloreTaleSnippet> snippets;
  final FolkloreOrigin? selectedOrigin;
  final String selectedDialect;
  final String searchQuery;
  final int selectedTab;
  final bool isLoading;
  final String? errorMessage;

  const FolkloreCatalogState({
    this.myths = const [],
    this.filteredMyths = const [],
    this.snippets = const [],
    this.selectedOrigin,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.selectedTab = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  FolkloreCatalogState copyWith({
    List<MythicalEntity>? myths,
    List<MythicalEntity>? filteredMyths,
    List<FolkloreTaleSnippet>? snippets,
    FolkloreOrigin? Function()? selectedOrigin,
    String? selectedDialect,
    String? searchQuery,
    int? selectedTab,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return FolkloreCatalogState(
      myths: myths ?? this.myths,
      filteredMyths: filteredMyths ?? this.filteredMyths,
      snippets: snippets ?? this.snippets,
      selectedOrigin:
          selectedOrigin != null ? selectedOrigin() : this.selectedOrigin,
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        myths,
        filteredMyths,
        snippets,
        selectedOrigin,
        selectedDialect,
        searchQuery,
        selectedTab,
        isLoading,
        errorMessage,
      ];
}
