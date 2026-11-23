import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/fashion_entities.dart';
import '../../domain/repositories/fashion_repository.dart';
import 'fashion_catalog_state.dart';

class FashionCatalogCubit extends Cubit<FashionCatalogState> {
  final FashionRepository _repository;

  FashionCatalogCubit(this._repository) : super(const FashionCatalogState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final topicsRes = await _repository.getFashionTopics();
    final craftsRes = await _repository.getTextileCrafts();

    topicsRes.fold(
      onSuccess: (topics) {
        craftsRes.fold(
          onSuccess: (crafts) {
            final filtered = _applyFilters(
              topics,
              state.selectedCategory,
              state.selectedDialect,
              state.searchQuery,
            );
            emit(state.copyWith(
              topics: topics,
              filteredTopics: filtered,
              crafts: crafts,
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

  void filterByCategory(FashionCategory? category) {
    final filtered = _applyFilters(
      state.topics,
      category,
      state.selectedDialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedCategory: () => category,
      filteredTopics: filtered,
    ));
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(
      state.topics,
      state.selectedCategory,
      dialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedDialect: dialect,
      filteredTopics: filtered,
    ));
  }

  void search(String query) {
    final filtered = _applyFilters(
      state.topics,
      state.selectedCategory,
      state.selectedDialect,
      query,
    );
    emit(state.copyWith(
      searchQuery: query,
      filteredTopics: filtered,
    ));
  }

  void clearFilters() {
    final filtered = _applyFilters(
      state.topics,
      null,
      'all',
      '',
    );
    emit(state.copyWith(
      selectedCategory: () => null,
      selectedDialect: 'all',
      searchQuery: '',
      filteredTopics: filtered,
    ));
  }

  List<FashionTopicEntity> _applyFilters(
    List<FashionTopicEntity> list,
    FashionCategory? category,
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
            t.fullDescription.toLowerCase().contains(q) ||
            t.culturalSignificance.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
