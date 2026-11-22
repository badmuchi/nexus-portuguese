import 'package:equatable/equatable.dart';
import '../../domain/entities/podcast_track_entity.dart';

enum AuditorioCatalogStatus { initial, loading, loaded, error }

class AuditorioCatalogState extends Equatable {
  final AuditorioCatalogStatus status;
  final List<PodcastTrack> allTracks;
  final List<PodcastTrack> filteredTracks;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String selectedCefr; // 'all', 'A1', 'A2', 'B1', 'B2'
  final String selectedCategory; // 'all', ...
  final String searchQuery;
  final int completedCount;
  final String? errorMessage;

  const AuditorioCatalogState({
    this.status = AuditorioCatalogStatus.initial,
    this.allTracks = const [],
    this.filteredTracks = const [],
    this.selectedDialect = 'all',
    this.selectedCefr = 'all',
    this.selectedCategory = 'all',
    this.searchQuery = '',
    this.completedCount = 0,
    this.errorMessage,
  });

  AuditorioCatalogState copyWith({
    AuditorioCatalogStatus? status,
    List<PodcastTrack>? allTracks,
    List<PodcastTrack>? filteredTracks,
    String? selectedDialect,
    String? selectedCefr,
    String? selectedCategory,
    String? searchQuery,
    int? completedCount,
    String? errorMessage,
  }) {
    return AuditorioCatalogState(
      status: status ?? this.status,
      allTracks: allTracks ?? this.allTracks,
      filteredTracks: filteredTracks ?? this.filteredTracks,
      selectedDialect: selectedDialect ?? this.selectedDialect,
      selectedCefr: selectedCefr ?? this.selectedCefr,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      completedCount: completedCount ?? this.completedCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allTracks,
        filteredTracks,
        selectedDialect,
        selectedCefr,
        selectedCategory,
        searchQuery,
        completedCount,
        errorMessage,
      ];
}
