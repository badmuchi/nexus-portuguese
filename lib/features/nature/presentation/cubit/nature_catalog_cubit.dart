import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/nature_entities.dart';
import '../../domain/repositories/nature_repository.dart';
import 'nature_catalog_state.dart';

class NatureCatalogCubit extends Cubit<NatureCatalogState> {
  final NatureRepository _repository;

  NatureCatalogCubit({required NatureRepository repository})
      : _repository = repository,
        super(const NatureCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: NatureCatalogStatus.loading));

    final reservesRes = await _repository.getReserves();
    final speciesRes = await _repository.getAllSpecies();

    if (reservesRes.isOk && speciesRes.isOk) {
      emit(state.copyWith(
        status: NatureCatalogStatus.loaded,
        allReserves: reservesRes.value,
        allSpecies: speciesRes.value,
      ));
    } else {
      final err = reservesRes.errorOrNull ??
          speciesRes.errorOrNull ??
          'Ошибка загрузки каталога природы';
      emit(state.copyWith(
        status: NatureCatalogStatus.error,
        errorMessage: err,
      ));
    }
  }

  void filterByDialect(String dialect) {
    emit(state.copyWith(selectedDialect: dialect));
  }

  void filterBySpeciesCategory(SpeciesCategory? category) {
    if (category == null) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedSpeciesCategory: category));
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setTab(int index) {
    emit(state.copyWith(activeTabIndex: index));
  }
}
