import 'package:equatable/equatable.dart';
import '../../domain/entities/radio_novela_entities.dart';

enum RadioNovelaCatalogStatus { initial, loading, loaded, error }

class RadioNovelaCatalogState extends Equatable {
  final RadioNovelaCatalogStatus status;
  final List<AudioDramaEntity> allDramas;
  final String? selectedGenre;
  final String selectedDialect; // 'all', 'BR', 'PT'
  final String searchQuery;
  final String? errorMessage;

  const RadioNovelaCatalogState({
    this.status = RadioNovelaCatalogStatus.initial,
    this.allDramas = const [],
    this.selectedGenre,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.errorMessage,
  });

  bool get isLoading => status == RadioNovelaCatalogStatus.loading;

  List<AudioDramaEntity> get filteredDramas {
    var res = List<AudioDramaEntity>.from(allDramas);

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((d) => d.isPtPt).toList();
      } else if (isBr) {
        res = res.where((d) => d.isPtBr).toList();
      }
    }

    if (selectedGenre != null && selectedGenre != 'all') {
      res = res
          .where((d) => d.genre.toLowerCase().contains(selectedGenre!.toLowerCase()))
          .toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((d) =>
          d.titlePt.toLowerCase().contains(q) ||
          d.titleRu.toLowerCase().contains(q) ||
          d.setting.toLowerCase().contains(q) ||
          d.synopsisRu.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  RadioNovelaCatalogState copyWith({
    RadioNovelaCatalogStatus? status,
    List<AudioDramaEntity>? allDramas,
    String? selectedGenre,
    bool clearGenre = false,
    String? selectedDialect,
    String? searchQuery,
    String? errorMessage,
  }) {
    return RadioNovelaCatalogState(
      status: status ?? this.status,
      allDramas: allDramas ?? this.allDramas,
      selectedGenre:
          clearGenre ? null : (selectedGenre ?? this.selectedGenre),
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allDramas,
        selectedGenre,
        selectedDialect,
        searchQuery,
        errorMessage,
      ];
}
