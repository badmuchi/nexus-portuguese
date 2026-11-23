import 'package:equatable/equatable.dart';
import '../../domain/entities/nature_entities.dart';

enum NatureCatalogStatus { initial, loading, loaded, error }

class NatureCatalogState extends Equatable {
  final NatureCatalogStatus status;
  final List<NatureReserveEntity> allReserves;
  final List<SpeciesEntity> allSpecies;
  final String selectedDialect;
  final SpeciesCategory? selectedSpeciesCategory;
  final String searchQuery;
  final int activeTabIndex;
  final String? errorMessage;

  const NatureCatalogState({
    this.status = NatureCatalogStatus.initial,
    this.allReserves = const [],
    this.allSpecies = const [],
    this.selectedDialect = 'all',
    this.selectedSpeciesCategory,
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  List<NatureReserveEntity> get filteredReserves {
    return allReserves.where((r) {
      if (selectedDialect != 'all') {
        final dLower = selectedDialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        if (isLookingForPt && !r.isPtPt) return false;
        if (isLookingForBr && !r.isPtBr) return false;
      }

      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final inName = r.namePt.toLowerCase().contains(q) ||
            r.nameRu.toLowerCase().contains(q);
        final inRegion = r.region.toLowerCase().contains(q);
        final inBiome = r.biomeRu.toLowerCase().contains(q);
        if (!inName && !inRegion && !inBiome) return false;
      }

      return true;
    }).toList();
  }

  List<SpeciesEntity> get filteredSpecies {
    return allSpecies.where((s) {
      if (selectedSpeciesCategory != null &&
          s.category != selectedSpeciesCategory) {
        return false;
      }

      if (selectedDialect != 'all') {
        final dLower = selectedDialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        if (s.dialect != 'all') {
          if (isLookingForPt && !s.isPtPt) return false;
          if (isLookingForBr && !s.isPtBr) return false;
        }
      }

      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final inName = s.commonNamePt.toLowerCase().contains(q) ||
            s.nameRu.toLowerCase().contains(q) ||
            s.scientificName.toLowerCase().contains(q);
        if (!inName) return false;
      }

      return true;
    }).toList();
  }

  NatureCatalogState copyWith({
    NatureCatalogStatus? status,
    List<NatureReserveEntity>? allReserves,
    List<SpeciesEntity>? allSpecies,
    String? selectedDialect,
    SpeciesCategory? selectedSpeciesCategory,
    bool clearCategory = false,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return NatureCatalogState(
      status: status ?? this.status,
      allReserves: allReserves ?? this.allReserves,
      allSpecies: allSpecies ?? this.allSpecies,
      selectedDialect: selectedDialect ?? this.selectedDialect,
      selectedSpeciesCategory: clearCategory
          ? null
          : (selectedSpeciesCategory ?? this.selectedSpeciesCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allReserves,
        allSpecies,
        selectedDialect,
        selectedSpeciesCategory,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
