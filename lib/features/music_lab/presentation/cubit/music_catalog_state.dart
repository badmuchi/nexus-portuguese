import 'package:equatable/equatable.dart';
import '../../domain/entities/portuguese_song_entity.dart';

enum MusicCatalogStatus { initial, loading, loaded, error }

class MusicCatalogState extends Equatable {
  final MusicCatalogStatus status;
  final List<PortugueseSong> allSongs;
  final List<PortugueseSong> filteredSongs;
  final MusicGenre? selectedGenre;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String searchQuery;
  final String? errorMessage;

  const MusicCatalogState({
    this.status = MusicCatalogStatus.initial,
    this.allSongs = const [],
    this.filteredSongs = const [],
    this.selectedGenre,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.errorMessage,
  });

  bool get isLoading => status == MusicCatalogStatus.loading;
  List<PortugueseSong> get songs => filteredSongs;

  MusicCatalogState copyWith({
    MusicCatalogStatus? status,
    List<PortugueseSong>? allSongs,
    List<PortugueseSong>? filteredSongs,
    MusicGenre? selectedGenre,
    bool clearGenre = false,
    String? selectedDialect,
    String? searchQuery,
    String? errorMessage,
  }) {
    return MusicCatalogState(
      status: status ?? this.status,
      allSongs: allSongs ?? this.allSongs,
      filteredSongs: filteredSongs ?? this.filteredSongs,
      selectedGenre: clearGenre ? null : (selectedGenre ?? this.selectedGenre),
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allSongs,
        filteredSongs,
        selectedGenre,
        selectedDialect,
        searchQuery,
        errorMessage,
      ];
}
