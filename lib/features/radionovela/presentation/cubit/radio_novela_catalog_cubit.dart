import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/radio_novela_repository.dart';
import 'radio_novela_catalog_state.dart';

class RadioNovelaCatalogCubit extends Cubit<RadioNovelaCatalogState> {
  final RadioNovelaRepository _repository;

  RadioNovelaCatalogCubit({required RadioNovelaRepository repository})
      : _repository = repository,
        super(const RadioNovelaCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: RadioNovelaCatalogStatus.loading));

    final res = await _repository.getDramas();
    if (res.isOk) {
      emit(state.copyWith(
        status: RadioNovelaCatalogStatus.loaded,
        allDramas: res.value,
      ));
    } else {
      emit(state.copyWith(
        status: RadioNovelaCatalogStatus.error,
        errorMessage: res.errorOrNull ?? 'Ошибка загрузки радионовелл',
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
}
