import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/wine_entities.dart';
import '../../domain/repositories/wine_repository.dart';
import 'wine_catalog_state.dart';

class WineCatalogCubit extends Cubit<WineCatalogState> {
  final WineRepository _repository;

  WineCatalogCubit(this._repository) : super(const WineCatalogState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final regionsRes = await _repository.getWineRegions();
    final guidesRes = await _repository.getTastingGuides();

    regionsRes.fold(
      onSuccess: (regions) {
        guidesRes.fold(
          onSuccess: (guides) {
            final filtered = _applyFilters(
              regions,
              state.selectedCategory,
              state.selectedDialect,
              state.searchQuery,
            );
            emit(state.copyWith(
              regions: regions,
              filteredRegions: filtered,
              guides: guides,
              isLoading: false,
            ));
          },
          onFailure: (message, _) {
            emit(state.copyWith(
              isLoading: false,
              errorMessage: () => message,
            ));
          },
        );
      },
      onFailure: (message, _) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: () => message,
        ));
      },
    );
  }

  void setTab(int tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  void filterByCategory(WineCategory? category) {
    final filtered = _applyFilters(
      state.regions,
      category,
      state.selectedDialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedCategory: () => category,
      filteredRegions: filtered,
    ));
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(
      state.regions,
      state.selectedCategory,
      dialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedDialect: dialect,
      filteredRegions: filtered,
    ));
  }

  void search(String query) {
    final filtered = _applyFilters(
      state.regions,
      state.selectedCategory,
      state.selectedDialect,
      query,
    );
    emit(state.copyWith(
      searchQuery: query,
      filteredRegions: filtered,
    ));
  }

  void clearFilters() {
    final filtered = _applyFilters(
      state.regions,
      null,
      'all',
      '',
    );
    emit(state.copyWith(
      selectedCategory: () => null,
      selectedDialect: 'all',
      searchQuery: '',
      filteredRegions: filtered,
    ));
  }

  List<WineRegionEntity> _applyFilters(
    List<WineRegionEntity> list,
    WineCategory? category,
    String dialect,
    String query,
  ) {
    var result = list;

    if (category != null) {
      result = result.where((r) => r.category == category).toList();
    }

    if (dialect != 'all') {
      final isPt = dialect.toLowerCase().contains('pt_pt') ||
          dialect.toLowerCase().contains('pt-pt') ||
          (dialect.toLowerCase().contains('pt') &&
              !dialect.toLowerCase().contains('br'));
      final isBr = dialect.toLowerCase().contains('br');

      result = result.where((r) {
        if (r.dialect == 'all') return true;
        if (isPt) return r.isPtPt;
        if (isBr) return r.isPtBr;
        return true;
      }).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((r) {
        return r.name.toLowerCase().contains(q) ||
            r.subRegion.toLowerCase().contains(q) ||
            r.shortSummary.toLowerCase().contains(q) ||
            r.fullDescription.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
