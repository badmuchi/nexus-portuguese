import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/football_entities.dart';
import '../../domain/repositories/football_repository.dart';
import 'football_catalog_state.dart';

class FootballCatalogCubit extends Cubit<FootballCatalogState> {
  final FootballRepository _repository;

  FootballCatalogCubit({required FootballRepository repository})
      : _repository = repository,
        super(const FootballCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: FootballCatalogStatus.loading));

    final matchesRes = await _repository.getMatches();
    final termsRes = await _repository.getFootballTerms();
    final chantsRes = await _repository.getFanChants();

    if (matchesRes.isOk && termsRes.isOk && chantsRes.isOk) {
      emit(state.copyWith(
        status: FootballCatalogStatus.loaded,
        allMatches: matchesRes.value,
        allTerms: termsRes.value,
        allChants: chantsRes.value,
      ));
    } else {
      final err = matchesRes.errorOrNull ??
          termsRes.errorOrNull ??
          chantsRes.errorOrNull ??
          'Ошибка загрузки каталога футбола';
      emit(state.copyWith(
        status: FootballCatalogStatus.error,
        errorMessage: err,
      ));
    }
  }

  void filterByDialect(String dialect) {
    emit(state.copyWith(selectedDialect: dialect));
  }

  void filterByCategory(FootballTermCategory? category) {
    if (category == null) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategory: category));
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setTab(int index) {
    emit(state.copyWith(activeTabIndex: index));
  }
}
