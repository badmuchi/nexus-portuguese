import 'package:equatable/equatable.dart';
import '../../domain/entities/art_entities.dart';

enum ArtCatalogStatus { initial, loading, loaded, error }

class ArtCatalogState extends Equatable {
  final ArtCatalogStatus status;
  final List<ArtworkEntity> allArtworks;
  final List<ArtStyleEntity> allStyles;
  final ArtPeriod? selectedPeriod;
  final String selectedDialect;
  final String searchQuery;
  final int activeTabIndex;
  final String? errorMessage;

  const ArtCatalogState({
    this.status = ArtCatalogStatus.initial,
    this.allArtworks = const [],
    this.allStyles = const [],
    this.selectedPeriod,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  List<ArtworkEntity> get filteredArtworks {
    return allArtworks.where((a) {
      if (selectedPeriod != null && a.period != selectedPeriod) {
        return false;
      }

      if (selectedDialect != 'all') {
        final dLower = selectedDialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        if (a.dialect != 'all') {
          if (isLookingForPt && !a.isPtPt) return false;
          if (isLookingForBr && !a.isPtBr) return false;
        }
      }

      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final inTitle = a.titlePt.toLowerCase().contains(q) ||
            a.titleRu.toLowerCase().contains(q);
        final inArtist = a.artistName.toLowerCase().contains(q);
        final inLocation = a.locationRu.toLowerCase().contains(q);
        if (!inTitle && !inArtist && !inLocation) return false;
      }

      return true;
    }).toList();
  }

  ArtCatalogState copyWith({
    ArtCatalogStatus? status,
    List<ArtworkEntity>? allArtworks,
    List<ArtStyleEntity>? allStyles,
    ArtPeriod? selectedPeriod,
    bool clearPeriod = false,
    String? selectedDialect,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return ArtCatalogState(
      status: status ?? this.status,
      allArtworks: allArtworks ?? this.allArtworks,
      allStyles: allStyles ?? this.allStyles,
      selectedPeriod: clearPeriod ? null : (selectedPeriod ?? this.selectedPeriod),
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allArtworks,
        allStyles,
        selectedPeriod,
        selectedDialect,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
