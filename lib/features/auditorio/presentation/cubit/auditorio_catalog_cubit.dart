import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/podcast_track_entity.dart';
import '../../domain/repositories/auditorio_repository.dart';
import 'auditorio_catalog_state.dart';

class AuditorioCatalogCubit extends Cubit<AuditorioCatalogState> {
  final AuditorioRepository _repository;

  AuditorioCatalogCubit({required AuditorioRepository repository})
      : _repository = repository,
        super(const AuditorioCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: AuditorioCatalogStatus.loading));

    final result = await _repository.getPodcasts();
    if (result.isOk) {
      final tracks = result.value;
      final completed = tracks.where((t) => t.isCompleted).length;
      final filtered = _applyFilters(
        tracks,
        state.selectedDialect,
        state.selectedCefr,
        state.selectedCategory,
        state.searchQuery,
      );

      emit(state.copyWith(
        status: AuditorioCatalogStatus.loaded,
        allTracks: tracks,
        filteredTracks: filtered,
        completedCount: completed,
      ));
    } else {
      emit(state.copyWith(
        status: AuditorioCatalogStatus.error,
        errorMessage: result.failure?.message ?? 'Ошибка загрузки подкастов',
      ));
    }
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(
      state.allTracks,
      dialect,
      state.selectedCefr,
      state.selectedCategory,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedDialect: dialect,
      filteredTracks: filtered,
    ));
  }

  void filterByCefr(String cefr) {
    final filtered = _applyFilters(
      state.allTracks,
      state.selectedDialect,
      cefr,
      state.selectedCategory,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedCefr: cefr,
      filteredTracks: filtered,
    ));
  }

  void filterByCategory(String category) {
    final filtered = _applyFilters(
      state.allTracks,
      state.selectedDialect,
      state.selectedCefr,
      category,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedCategory: category,
      filteredTracks: filtered,
    ));
  }

  void search(String query) {
    final filtered = _applyFilters(
      state.allTracks,
      state.selectedDialect,
      state.selectedCefr,
      state.selectedCategory,
      query,
    );
    emit(state.copyWith(
      searchQuery: query,
      filteredTracks: filtered,
    ));
  }

  List<PodcastTrack> _applyFilters(
    List<PodcastTrack> tracks,
    String dialect,
    String cefr,
    String category,
    String query,
  ) {
    var result = List<PodcastTrack>.from(tracks);

    if (dialect != 'all') {
      result = result.where((t) => t.dialect.toLowerCase() == dialect.toLowerCase()).toList();
    }

    if (cefr != 'all') {
      result = result.where((t) => t.cefrLevel.toUpperCase() == cefr.toUpperCase()).toList();
    }

    if (category != 'all') {
      result = result.where((t) => t.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      result = result.where((t) {
        return t.titlePt.toLowerCase().contains(q) ||
            t.titleRu.toLowerCase().contains(q) ||
            t.descriptionPt.toLowerCase().contains(q) ||
            t.descriptionRu.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
