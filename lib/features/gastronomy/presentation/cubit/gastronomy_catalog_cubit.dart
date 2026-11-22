import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/culinary_vocabulary_entity.dart';
import '../../domain/repositories/gastronomy_repository.dart';
import 'gastronomy_catalog_state.dart';

class GastronomyCatalogCubit extends Cubit<GastronomyCatalogState> {
  final GastronomyRepository _repository;

  GastronomyCatalogCubit({required GastronomyRepository repository})
      : _repository = repository,
        super(const GastronomyCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: GastronomyCatalogStatus.loading));

    final recRes = await _repository.getRecipes();
    final termRes = await _repository.getCulinaryTerms();

    if (recRes.isOk && termRes.isOk) {
      emit(state.copyWith(
        status: GastronomyCatalogStatus.loaded,
        allRecipes: recRes.value,
        allTerms: termRes.value,
      ));
    } else {
      final err = recRes.failure?.message ??
          termRes.failure?.message ??
          'Ошибка загрузки кулинарного каталога';
      emit(state.copyWith(
        status: GastronomyCatalogStatus.error,
        errorMessage: err,
      ));
    }
  }

  void filterByDialect(String dialect) {
    emit(state.copyWith(selectedDialect: dialect));
  }

  void filterByDifficulty(String? difficulty) {
    if (difficulty == null) {
      emit(state.copyWith(clearDifficulty: true));
    } else {
      emit(state.copyWith(selectedDifficulty: difficulty));
    }
  }

  void filterByTermType(CulinaryTermType? type) {
    if (type == null) {
      emit(state.copyWith(clearTermType: true));
    } else {
      emit(state.copyWith(selectedTermType: type));
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setTab(int index) {
    emit(state.copyWith(activeTabIndex: index));
  }
}
