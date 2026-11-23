import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/bazar_repository.dart';
import 'bazar_catalog_state.dart';

class BazarCatalogCubit extends Cubit<BazarCatalogState> {
  final BazarRepository _repository;

  BazarCatalogCubit({required BazarRepository repository})
      : _repository = repository,
        super(const BazarCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: BazarCatalogStatus.loading));

    final marketsRes = await _repository.getMarkets();
    final phrasesRes = await _repository.getMarketPhrases();
    final scenariosRes = await _repository.getBargainScenarios();

    if (marketsRes.isOk && phrasesRes.isOk && scenariosRes.isOk) {
      emit(state.copyWith(
        status: BazarCatalogStatus.loaded,
        allMarkets: marketsRes.value,
        allPhrases: phrasesRes.value,
        allScenarios: scenariosRes.value,
      ));
    } else {
      final err = marketsRes.errorOrNull ??
          phrasesRes.errorOrNull ??
          scenariosRes.errorOrNull ??
          'Ошибка загрузки каталога рынков';
      emit(state.copyWith(
        status: BazarCatalogStatus.error,
        errorMessage: err,
      ));
    }
  }

  void filterByDialect(String dialect) {
    emit(state.copyWith(selectedDialect: dialect));
  }

  void filterByCategory(String? category) {
    if (category == null) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedPhraseCategory: category));
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setTab(int index) {
    emit(state.copyWith(activeTabIndex: index));
  }
}
