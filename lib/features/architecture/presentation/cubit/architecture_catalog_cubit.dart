import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/architecture_entities.dart';
import '../../domain/repositories/architecture_repository.dart';
import 'architecture_catalog_state.dart';

class ArchitectureCatalogCubit extends Cubit<ArchitectureCatalogState> {
  final ArchitectureRepository _repository;

  ArchitectureCatalogCubit(this._repository)
      : super(const ArchitectureCatalogState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final monumentsRes = await _repository.getMonuments();
    final stylesRes = await _repository.getArchitecturalStyles();

    monumentsRes.fold(
      onSuccess: (monuments) {
        stylesRes.fold(
          onSuccess: (styles) {
            final filtered = _applyFilters(
              monuments,
              state.selectedCategory,
              state.selectedDialect,
              state.searchQuery,
            );
            emit(state.copyWith(
              monuments: monuments,
              filteredMonuments: filtered,
              styles: styles,
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

  void filterByCategory(ArchitectureCategory? category) {
    final filtered = _applyFilters(
      state.monuments,
      category,
      state.selectedDialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedCategory: () => category,
      filteredMonuments: filtered,
    ));
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(
      state.monuments,
      state.selectedCategory,
      dialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedDialect: dialect,
      filteredMonuments: filtered,
    ));
  }

  void search(String query) {
    final filtered = _applyFilters(
      state.monuments,
      state.selectedCategory,
      state.selectedDialect,
      query,
    );
    emit(state.copyWith(
      searchQuery: query,
      filteredMonuments: filtered,
    ));
  }

  List<ArchitecturalMonumentEntity> _applyFilters(
    List<ArchitecturalMonumentEntity> list,
    ArchitectureCategory? category,
    String dialect,
    String query,
  ) {
    var result = list;

    if (category != null) {
      result = result.where((m) => m.category == category).toList();
    }

    if (dialect != 'all') {
      final dLower = dialect.toLowerCase();
      final isLookingForPt = dLower.contains('pt_pt') ||
          dLower.contains('pt-pt') ||
          (dLower.contains('pt') && !dLower.contains('br'));
      final isLookingForBr = dLower.contains('br');

      result = result.where((m) {
        if (m.dialect == 'all') return true;
        if (isLookingForPt) return m.isPtPt;
        if (isLookingForBr) return m.isPtBr;
        return true;
      }).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((m) {
        return m.title.toLowerCase().contains(q) ||
            m.city.toLowerCase().contains(q) ||
            m.architect.toLowerCase().contains(q) ||
            m.styleName.toLowerCase().contains(q) ||
            m.shortDescription.toLowerCase().contains(q) ||
            m.fullDescription.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
