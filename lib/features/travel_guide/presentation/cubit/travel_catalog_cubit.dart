import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/travel_phrase_entity.dart';
import '../../domain/repositories/travel_guide_repository.dart';
import 'travel_catalog_state.dart';

class TravelCatalogCubit extends Cubit<TravelCatalogState> {
  final TravelGuideRepository _repository;

  TravelCatalogCubit({required TravelGuideRepository repository})
      : _repository = repository,
        super(const TravelCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: TravelCatalogStatus.loading));

    final countRes = await _repository.getCountries();
    final phraseRes = await _repository.getTravelPhrases();

    if (countRes.isOk && phraseRes.isOk) {
      emit(state.copyWith(
        status: TravelCatalogStatus.loaded,
        allCountries: countRes.value,
        allPhrases: phraseRes.value,
      ));
    } else {
      final err = countRes.failure?.message ??
          phraseRes.failure?.message ??
          'Ошибка загрузки путеводителя';
      emit(state.copyWith(
        status: TravelCatalogStatus.error,
        errorMessage: err,
      ));
    }
  }

  void filterByContinent(String? continent) {
    if (continent == null || continent == 'all') {
      emit(state.copyWith(clearContinent: true));
    } else {
      emit(state.copyWith(selectedContinent: continent));
    }
  }

  void filterByPhraseCategory(TravelPhraseCategory? category) {
    if (category == null) {
      emit(state.copyWith(clearPhraseCategory: true));
    } else {
      emit(state.copyWith(selectedPhraseCategory: category));
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
