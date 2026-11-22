import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/cinema_repository.dart';
import 'cinema_catalog_state.dart';

class CinemaCatalogCubit extends Cubit<CinemaCatalogState> {
  final CinemaRepository _repository;

  CinemaCatalogCubit({required CinemaRepository repository})
      : _repository = repository,
        super(const CinemaCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: CinemaCatalogStatus.loading));

    final scRes = await _repository.getScenes();
    final quRes = await _repository.getFamousQuotes();

    if (scRes.isOk && quRes.isOk) {
      emit(state.copyWith(
        status: CinemaCatalogStatus.loaded,
        allScenes: scRes.value,
        allQuotes: quRes.value,
      ));
    } else {
      final err = scRes.failure?.message ??
          quRes.failure?.message ??
          'Ошибка загрузки каталога синематеки';
      emit(state.copyWith(
        status: CinemaCatalogStatus.error,
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
