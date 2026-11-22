import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/literature_repository.dart';
import 'literature_catalog_state.dart';

class LiteratureCatalogCubit extends Cubit<LiteratureCatalogState> {
  final LiteratureRepository _repository;

  LiteratureCatalogCubit({required LiteratureRepository repository})
      : _repository = repository,
        super(const LiteratureCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: LiteratureCatalogStatus.loading));

    final worksRes = await _repository.getWorks();
    final quotesRes = await _repository.getFamousQuotes();

    if (worksRes.isOk && quotesRes.isOk) {
      emit(state.copyWith(
        status: LiteratureCatalogStatus.loaded,
        allWorks: worksRes.value,
        allQuotes: quotesRes.value,
      ));
    } else {
      final err = worksRes.isFailure
          ? (worksRes.errorOrNull ?? 'Ошибка загрузки произведений')
          : (quotesRes.errorOrNull ?? 'Ошибка загрузки цитат');
      emit(state.copyWith(
        status: LiteratureCatalogStatus.error,
        errorMessage: err,
      ));
    }
  }

  void filterByDialect(String dialect) {
    emit(state.copyWith(selectedDialect: dialect));
  }

  void filterByGenre(String? genre) {
    if (genre == null) {
      emit(state.copyWith(clearGenre: true));
    } else {
      emit(state.copyWith(selectedGenre: genre));
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setTab(int index) {
    emit(state.copyWith(activeTabIndex: index));
  }
}
