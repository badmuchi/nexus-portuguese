import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/humor_entities.dart';
import '../../domain/repositories/humor_repository.dart';
import 'humor_catalog_state.dart';

class HumorCatalogCubit extends Cubit<HumorCatalogState> {
  final HumorRepository _repository;

  HumorCatalogCubit({required HumorRepository repository})
      : _repository = repository,
        super(const HumorCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: HumorCatalogStatus.loading));

    final jokesRes = await _repository.getJokes();
    final trocadilhosRes = await _repository.getTrocadilhos();

    if (jokesRes.isOk && trocadilhosRes.isOk) {
      emit(state.copyWith(
        status: HumorCatalogStatus.loaded,
        allJokes: jokesRes.value,
        allTrocadilhos: trocadilhosRes.value,
      ));
    } else {
      final err = jokesRes.errorOrNull ??
          trocadilhosRes.errorOrNull ??
          'Ошибка загрузки каталога юмора';
      emit(state.copyWith(
        status: HumorCatalogStatus.error,
        errorMessage: err,
      ));
    }
  }

  void filterByCategory(JokeCategory? category) {
    if (category == null) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategory: category));
    }
  }

  void filterByDialect(String dialect) {
    emit(state.copyWith(selectedDialect: dialect));
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setTab(int index) {
    emit(state.copyWith(activeTabIndex: index));
  }
}
