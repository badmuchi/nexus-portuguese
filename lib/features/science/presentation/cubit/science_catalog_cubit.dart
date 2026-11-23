import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/science_entities.dart';
import '../../domain/repositories/science_repository.dart';
import 'science_catalog_state.dart';

class ScienceCatalogCubit extends Cubit<ScienceCatalogState> {
  final ScienceRepository _repository;

  ScienceCatalogCubit(this._repository) : super(const ScienceCatalogState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final topicsRes = await _repository.getScienceTopics();
    final experimentsRes = await _repository.getLabExperiments();

    topicsRes.fold(
      onSuccess: (topics) {
        experimentsRes.fold(
          onSuccess: (experiments) {
            final filtered = _applyFilters(
              topics,
              state.selectedField,
              state.selectedDialect,
              state.searchQuery,
            );
            emit(state.copyWith(
              topics: topics,
              filteredTopics: filtered,
              experiments: experiments,
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

  void filterByField(ScienceField? field) {
    final filtered = _applyFilters(
      state.topics,
      field,
      state.selectedDialect,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedField: () => field,
      filteredTopics: filtered,
    ));
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(
      state.topics,
      state.selectedField,
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
      state.selectedField,
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
      selectedField: () => null,
      selectedDialect: 'all',
      searchQuery: '',
      filteredTopics: filtered,
    ));
  }

  List<ScienceTopicEntity> _applyFilters(
    List<ScienceTopicEntity> list,
    ScienceField? field,
    String dialect,
    String query,
  ) {
    var result = list;

    if (field != null) {
      result = result.where((t) => t.field == field).toList();
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
            t.institution.toLowerCase().contains(q) ||
            t.shortSummary.toLowerCase().contains(q) ||
            t.region.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
