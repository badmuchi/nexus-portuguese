import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/portuguese_song_entity.dart';
import '../../domain/repositories/music_repository.dart';
import 'music_catalog_state.dart';

class MusicCatalogCubit extends Cubit<MusicCatalogState> {
  final MusicRepository _repository;

  MusicCatalogCubit({required MusicRepository repository})
      : _repository = repository,
        super(const MusicCatalogState());

  Future<void> loadSongs() => loadCatalog();

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: MusicCatalogStatus.loading));

    final result = await _repository.getSongs();
    if (result.isOk) {
      final all = result.value;
      final filtered = _applyFilters(all, state.selectedGenre, state.selectedDialect, state.searchQuery);
      emit(state.copyWith(
        status: MusicCatalogStatus.loaded,
        allSongs: all,
        filteredSongs: filtered,
      ));
    } else {
      emit(state.copyWith(
        status: MusicCatalogStatus.error,
        errorMessage: result.failure?.message ?? 'Ошибка загрузки каталога песен',
      ));
    }
  }

  void filterByGenre(MusicGenre? genre) {
    final filtered = _applyFilters(state.allSongs, genre, state.selectedDialect, state.searchQuery);
    if (genre == null) {
      emit(state.copyWith(clearGenre: true, filteredSongs: filtered));
    } else {
      emit(state.copyWith(selectedGenre: genre, filteredSongs: filtered));
    }
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(state.allSongs, state.selectedGenre, dialect, state.searchQuery);
    emit(state.copyWith(selectedDialect: dialect, filteredSongs: filtered));
  }

  void searchSongs(String query) => search(query);

  void search(String query) {
    final filtered = _applyFilters(state.allSongs, state.selectedGenre, state.selectedDialect, query);
    emit(state.copyWith(searchQuery: query, filteredSongs: filtered));
  }

  List<PortugueseSong> _applyFilters(
    List<PortugueseSong> list,
    MusicGenre? genre,
    String dialect,
    String query,
  ) {
    var res = List<PortugueseSong>.from(list);

    if (genre != null) {
      res = res.where((s) => s.genre == genre).toList();
    }

    if (dialect != 'all') {
      res = res.where((s) => s.dialect.toLowerCase() == dialect.toLowerCase()).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      res = res.where((s) {
        return s.titlePt.toLowerCase().contains(q) ||
            s.titleRu.toLowerCase().contains(q) ||
            s.artist.toLowerCase().contains(q);
      }).toList();
    }

    return res;
  }
}
