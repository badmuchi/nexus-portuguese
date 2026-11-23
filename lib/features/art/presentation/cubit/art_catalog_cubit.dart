import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/art_entities.dart';
import '../../domain/repositories/art_repository.dart';
import 'art_catalog_state.dart';

class ArtCatalogCubit extends Cubit<ArtCatalogState> {
  final ArtRepository _repository;

  ArtCatalogCubit({required ArtRepository repository})
      : _repository = repository,
        super(const ArtCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: ArtCatalogStatus.loading));

    final artworksRes = await _repository.getArtworks();
    final stylesRes = await _repository.getArtStyles();

    if (artworksRes.isOk && stylesRes.isOk) {
      emit(state.copyWith(
        status: ArtCatalogStatus.loaded,
        allArtworks: artworksRes.value,
        allStyles: stylesRes.value,
      ));
    } else {
      final err = artworksRes.errorOrNull ??
          stylesRes.errorOrNull ??
          'Ошибка загрузки каталога искусства';
      emit(state.copyWith(
        status: ArtCatalogStatus.error,
        errorMessage: err,
      ));
    }
  }

  void filterByPeriod(ArtPeriod? period) {
    if (period == null) {
      emit(state.copyWith(clearPeriod: true));
    } else {
      emit(state.copyWith(selectedPeriod: period));
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
