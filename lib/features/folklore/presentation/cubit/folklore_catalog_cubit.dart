import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/folklore_entities.dart';
import '../../domain/repositories/folklore_repository.dart';
import 'folklore_catalog_state.dart';

class FolkloreCatalogCubit extends Cubit<FolkloreCatalogState> {
  final FolkloreRepository _repository;

  FolkloreCatalogCubit(this._repository) : super(const FolkloreCatalogState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final mythsRes = await _repository.getMyths();
    final snippetsRes = await _repository.getTaleSnippets();

    mythsRes.fold(
      onSuccess: (myths) {
        snippetsRes.fold(
          onSuccess: (snippets) {
            final filtered = _applyFilters(
              myths,
              state.selectedOrigin,
              state.selectedDialect,
              state.searchQuery,
            );
            emit(state.copyWith(
              myths: myths,
              filteredMyths: filtered,
              snippets: snippets,
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

  void filterByOrigin(FolkloreOrigin? origin) {
    final filtered = _applyFilters(
      state.myths,
      origin,
      state.selectedDialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedOrigin: () => origin,
      filteredMyths: filtered,
    ));
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(
      state.myths,
      state.selectedOrigin,
      dialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedDialect: dialect,
      filteredMyths: filtered,
    ));
  }

  void search(String query) {
    final filtered = _applyFilters(
      state.myths,
      state.selectedOrigin,
      state.selectedDialect,
      query,
    );
    emit(state.copyWith(
      searchQuery: query,
      filteredMyths: filtered,
    ));
  }

  void clearFilters() {
    final filtered = _applyFilters(
      state.myths,
      null,
      'all',
      '',
    );
    emit(state.copyWith(
      selectedOrigin: () => null,
      selectedDialect: 'all',
      searchQuery: '',
      filteredMyths: filtered,
    ));
  }

  List<MythicalEntity> _applyFilters(
    List<MythicalEntity> list,
    FolkloreOrigin? origin,
    String dialect,
    String query,
  ) {
    var result = list;

    if (origin != null) {
      result = result.where((m) => m.origin == origin).toList();
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
        return m.name.toLowerCase().contains(q) ||
            m.aliasRu.toLowerCase().contains(q) ||
            m.region.toLowerCase().contains(q) ||
            m.shortSummary.toLowerCase().contains(q) ||
            m.fullLegend.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
