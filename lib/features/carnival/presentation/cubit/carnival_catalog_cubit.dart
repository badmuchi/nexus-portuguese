import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/carnival_entities.dart';
import '../../domain/repositories/carnival_repository.dart';
import 'carnival_catalog_state.dart';

class CarnivalCatalogCubit extends Cubit<CarnivalCatalogState> {
  final CarnivalRepository _repository;

  CarnivalCatalogCubit(this._repository)
      : super(const CarnivalCatalogState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final traditionsRes = await _repository.getTraditions();
    final workshopsRes = await _repository.getRhythmWorkshops();

    traditionsRes.fold(
      onSuccess: (traditions) {
        workshopsRes.fold(
          onSuccess: (workshops) {
            final filtered = _applyFilters(
              traditions,
              state.selectedCategory,
              state.selectedDialect,
              state.searchQuery,
            );
            emit(state.copyWith(
              traditions: traditions,
              filteredTraditions: filtered,
              workshops: workshops,
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

  void filterByCategory(CarnivalTraditionCategory? category) {
    final filtered = _applyFilters(
      state.traditions,
      category,
      state.selectedDialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedCategory: () => category,
      filteredTraditions: filtered,
    ));
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(
      state.traditions,
      state.selectedCategory,
      dialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedDialect: dialect,
      filteredTraditions: filtered,
    ));
  }

  void search(String query) {
    final filtered = _applyFilters(
      state.traditions,
      state.selectedCategory,
      state.selectedDialect,
      query,
    );
    emit(state.copyWith(
      searchQuery: query,
      filteredTraditions: filtered,
    ));
  }

  void clearFilters() {
    final filtered = _applyFilters(
      state.traditions,
      null,
      'all',
      '',
    );
    emit(state.copyWith(
      selectedCategory: () => null,
      selectedDialect: 'all',
      searchQuery: '',
      filteredTraditions: filtered,
    ));
  }

  List<CarnivalTraditionEntity> _applyFilters(
    List<CarnivalTraditionEntity> list,
    CarnivalTraditionCategory? category,
    String dialect,
    String query,
  ) {
    var result = list;

    if (category != null) {
      result = result.where((t) => t.category == category).toList();
    }

    if (dialect != 'all') {
      final isPt = dialect.toLowerCase().contains('pt_pt') ||
          dialect.toLowerCase().contains('pt-pt') ||
          (dialect.toLowerCase().contains('pt') &&
              !dialect.toLowerCase().contains('br'));
      final isBr = dialect.toLowerCase().contains('br');

      result = result.where((t) {
        if (t.dialect == 'all') return true;
        if (isPt) return t.isPtPt;
        if (isBr) return t.isPtBr;
        return true;
      }).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.region.toLowerCase().contains(q) ||
            t.shortSummary.toLowerCase().contains(q) ||
            t.fullDescription.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
