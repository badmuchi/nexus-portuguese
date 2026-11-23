import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/finance_entities.dart';
import '../../domain/repositories/finance_repository.dart';
import 'finance_catalog_state.dart';

class FinanceCatalogCubit extends Cubit<FinanceCatalogState> {
  final FinanceRepository _repository;

  FinanceCatalogCubit(this._repository) : super(const FinanceCatalogState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final topicsRes = await _repository.getFinanceTopics();
    final simulatorsRes = await _repository.getFintechSimulators();

    topicsRes.fold(
      onSuccess: (topics) {
        simulatorsRes.fold(
          onSuccess: (simulators) {
            final filtered = _applyFilters(
              topics,
              state.selectedCategory,
              state.selectedDialect,
              state.searchQuery,
            );
            emit(state.copyWith(
              topics: topics,
              filteredTopics: filtered,
              simulators: simulators,
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

  void filterByCategory(FinanceCategory? category) {
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

  List<FinanceTopicEntity> _applyFilters(
    List<FinanceTopicEntity> list,
    FinanceCategory? category,
    String dialect,
    String query,
  ) {
    var result = list;

    if (category != null) {
      result = result.where((t) => t.category == category).toList();
    }

    if (dialect != 'all') {
      final dLower = dialect.toLowerCase();
      final isLookingForPt = dLower.contains('pt_pt') ||
          dLower.contains('pt-pt') ||
          (dLower.contains('pt') && !dLower.contains('br'));
      final isLookingForBr = dLower.contains('br');

      result = result.where((t) {
        if (t.dialect == 'all') return true;
        if (isLookingForPt) return t.isPtPt;
        if (isLookingForBr) return t.isPtBr;
        return true;
      }).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.region.toLowerCase().contains(q) ||
            t.shortDescription.toLowerCase().contains(q) ||
            t.fullDescription.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
