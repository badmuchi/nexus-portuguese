import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ancestral_entities.dart';
import '../../domain/repositories/ancestral_repository.dart';
import 'ancestral_catalog_state.dart';

class AncestralCatalogCubit extends Cubit<AncestralCatalogState> {
  final AncestralRepository _repository;

  AncestralCatalogCubit(this._repository)
      : super(const AncestralCatalogState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final communitiesRes = await _repository.getCommunities();
    final remediesRes = await _repository.getHerbalRemedies();

    communitiesRes.fold(
      onSuccess: (communities) {
        remediesRes.fold(
          onSuccess: (remedies) {
            final filtered = _applyFilters(
              communities,
              state.selectedCategory,
              state.selectedDialect,
              state.searchQuery,
            );
            emit(state.copyWith(
              communities: communities,
              filteredCommunities: filtered,
              remedies: remedies,
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

  void filterByCategory(CommunityCategory? category) {
    final filtered = _applyFilters(
      state.communities,
      category,
      state.selectedDialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedCategory: () => category,
      filteredCommunities: filtered,
    ));
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(
      state.communities,
      state.selectedCategory,
      dialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedDialect: dialect,
      filteredCommunities: filtered,
    ));
  }

  void search(String query) {
    final filtered = _applyFilters(
      state.communities,
      state.selectedCategory,
      state.selectedDialect,
      query,
    );
    emit(state.copyWith(
      searchQuery: query,
      filteredCommunities: filtered,
    ));
  }

  void clearFilters() {
    final filtered = _applyFilters(
      state.communities,
      null,
      'all',
      '',
    );
    emit(state.copyWith(
      selectedCategory: () => null,
      selectedDialect: 'all',
      searchQuery: '',
      filteredCommunities: filtered,
    ));
  }

  List<TraditionalCommunityEntity> _applyFilters(
    List<TraditionalCommunityEntity> list,
    CommunityCategory? category,
    String dialect,
    String query,
  ) {
    var result = list;

    if (category != null) {
      result = result.where((c) => c.category == category).toList();
    }

    if (dialect != 'all') {
      final isPt = dialect.toLowerCase().contains('pt_pt') ||
          dialect.toLowerCase().contains('pt-pt') ||
          (dialect.toLowerCase().contains('pt') &&
              !dialect.toLowerCase().contains('br'));
      final isBr = dialect.toLowerCase().contains('br');

      result = result.where((c) {
        if (c.dialect == 'all') return true;
        if (isPt) return c.isPtPt;
        if (isBr) return c.isPtBr;
        return true;
      }).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((c) {
        return c.title.toLowerCase().contains(q) ||
            c.region.toLowerCase().contains(q) ||
            c.shortSummary.toLowerCase().contains(q) ||
            c.fullDescription.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
