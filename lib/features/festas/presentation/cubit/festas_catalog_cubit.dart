import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/festas_entities.dart';
import '../../domain/repositories/festas_repository.dart';
import 'festas_catalog_state.dart';

class FestasCatalogCubit extends Cubit<FestasCatalogState> {
  final FestasRepository _repository;

  FestasCatalogCubit(this._repository) : super(const FestasCatalogState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final festasRes = await _repository.getFestas();
    final traditionsRes = await _repository.getFestaTraditions();

    festasRes.fold(
      onSuccess: (festas) {
        traditionsRes.fold(
          onSuccess: (traditions) {
            final filtered = _applyFilters(
              festas,
              state.selectedCategory,
              state.selectedDialect,
              state.searchQuery,
            );
            emit(state.copyWith(
              festas: festas,
              filteredFestas: filtered,
              traditions: traditions,
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

  void filterByCategory(FestaCategory? category) {
    final filtered = _applyFilters(
      state.festas,
      category,
      state.selectedDialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedCategory: () => category,
      filteredFestas: filtered,
    ));
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(
      state.festas,
      state.selectedCategory,
      dialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedDialect: dialect,
      filteredFestas: filtered,
    ));
  }

  void search(String query) {
    final filtered = _applyFilters(
      state.festas,
      state.selectedCategory,
      state.selectedDialect,
      query,
    );
    emit(state.copyWith(
      searchQuery: query,
      filteredFestas: filtered,
    ));
  }

  List<FestaEntity> _applyFilters(
    List<FestaEntity> list,
    FestaCategory? category,
    String dialect,
    String query,
  ) {
    var result = list;

    if (category != null) {
      result = result.where((f) => f.category == category).toList();
    }

    if (dialect != 'all') {
      final dLower = dialect.toLowerCase();
      final isLookingForPt = dLower.contains('pt_pt') ||
          dLower.contains('pt-pt') ||
          (dLower.contains('pt') && !dLower.contains('br'));
      final isLookingForBr = dLower.contains('br');

      result = result.where((f) {
        if (f.dialect == 'all') return true;
        if (isLookingForPt) return f.isPtPt;
        if (isLookingForBr) return f.isPtBr;
        return true;
      }).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((f) {
        return f.title.toLowerCase().contains(q) ||
            f.region.toLowerCase().contains(q) ||
            f.shortDescription.toLowerCase().contains(q) ||
            f.fullDescription.toLowerCase().contains(q) ||
            f.seasonDate.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
