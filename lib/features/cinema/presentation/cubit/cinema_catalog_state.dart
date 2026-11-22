import 'package:equatable/equatable.dart';
import '../../domain/entities/cinema_quote_entity.dart';
import '../../domain/entities/movie_scene_entity.dart';

enum CinemaCatalogStatus { initial, loading, loaded, error }

class CinemaCatalogState extends Equatable {
  final CinemaCatalogStatus status;
  final List<MovieSceneEntity> allScenes;
  final List<CinemaQuoteEntity> allQuotes;
  final String selectedDialect; // 'all', 'BR', 'PT'
  final String? selectedGenre;
  final String searchQuery;
  final int activeTabIndex; // 0: Сцены, 1: Цитаты
  final String? errorMessage;

  const CinemaCatalogState({
    this.status = CinemaCatalogStatus.initial,
    this.allScenes = const [],
    this.allQuotes = const [],
    this.selectedDialect = 'all',
    this.selectedGenre,
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  bool get isLoading => status == CinemaCatalogStatus.loading;

  List<MovieSceneEntity> get filteredScenes {
    var res = List<MovieSceneEntity>.from(allScenes);

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt') &&
          !selectedDialect.toLowerCase().contains('br');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((s) => s.isPtPt).toList();
      } else if (isBr) {
        res = res.where((s) => s.isPtBr).toList();
      }
    }

    if (selectedGenre != null) {
      res = res.where((s) => s.genre.toLowerCase().contains(selectedGenre!.toLowerCase())).toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((s) =>
          s.movieTitlePt.toLowerCase().contains(q) ||
          s.movieTitleRu.toLowerCase().contains(q) ||
          s.director.toLowerCase().contains(q) ||
          s.region.toLowerCase().contains(q) ||
          s.synopsisRu.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  List<CinemaQuoteEntity> get filteredQuotes {
    var res = List<CinemaQuoteEntity>.from(allQuotes);

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt') &&
          !selectedDialect.toLowerCase().contains('br');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((q) => q.isPtPt).toList();
      } else if (isBr) {
        res = res.where((q) => q.isPtBr).toList();
      }
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((qItem) =>
          qItem.quotePt.toLowerCase().contains(q) ||
          qItem.translationRu.toLowerCase().contains(q) ||
          qItem.character.toLowerCase().contains(q) ||
          qItem.movieTitle.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  CinemaCatalogState copyWith({
    CinemaCatalogStatus? status,
    List<MovieSceneEntity>? allScenes,
    List<CinemaQuoteEntity>? allQuotes,
    String? selectedDialect,
    String? selectedGenre,
    bool clearGenre = false,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return CinemaCatalogState(
      status: status ?? this.status,
      allScenes: allScenes ?? this.allScenes,
      allQuotes: allQuotes ?? this.allQuotes,
      selectedDialect: selectedDialect ?? this.selectedDialect,
      selectedGenre: clearGenre ? null : (selectedGenre ?? this.selectedGenre),
      searchQuery: searchQuery ?? this.searchQuery,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allScenes,
        allQuotes,
        selectedDialect,
        selectedGenre,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
