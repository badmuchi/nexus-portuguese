import 'package:equatable/equatable.dart';
import '../../domain/entities/literary_work_entity.dart';

enum LiteratureCatalogStatus { initial, loading, loaded, error }

class LiteratureCatalogState extends Equatable {
  final LiteratureCatalogStatus status;
  final List<LiteraryWorkEntity> allWorks;
  final List<LiteraryQuoteEntity> allQuotes;
  final String? selectedGenre;
  final String selectedDialect; // 'all', 'BR', 'PT'
  final String searchQuery;
  final int activeTabIndex; // 0: Шедевры, 1: Цитаты
  final String? errorMessage;

  const LiteratureCatalogState({
    this.status = LiteratureCatalogStatus.initial,
    this.allWorks = const [],
    this.allQuotes = const [],
    this.selectedGenre,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  bool get isLoading => status == LiteratureCatalogStatus.loading;

  List<LiteraryWorkEntity> get filteredWorks {
    var res = List<LiteraryWorkEntity>.from(allWorks);

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((w) => w.isPtPt).toList();
      } else if (isBr) {
        res = res.where((w) => w.isPtBr).toList();
      }
    }

    if (selectedGenre != null && selectedGenre != 'all') {
      res = res
          .where((w) => w.genre.toLowerCase().contains(selectedGenre!.toLowerCase()))
          .toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((w) =>
          w.titlePt.toLowerCase().contains(q) ||
          w.titleRu.toLowerCase().contains(q) ||
          w.authorName.toLowerCase().contains(q) ||
          w.analysisContextRu.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  List<LiteraryQuoteEntity> get filteredQuotes {
    var res = List<LiteraryQuoteEntity>.from(allQuotes);

    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt');
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
          qItem.authorName.toLowerCase().contains(q) ||
          qItem.workTitle.toLowerCase().contains(q)).toList();
    }

    return res;
  }

  LiteratureCatalogState copyWith({
    LiteratureCatalogStatus? status,
    List<LiteraryWorkEntity>? allWorks,
    List<LiteraryQuoteEntity>? allQuotes,
    String? selectedGenre,
    bool clearGenre = false,
    String? selectedDialect,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return LiteratureCatalogState(
      status: status ?? this.status,
      allWorks: allWorks ?? this.allWorks,
      allQuotes: allQuotes ?? this.allQuotes,
      selectedGenre:
          clearGenre ? null : (selectedGenre ?? this.selectedGenre),
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allWorks,
        allQuotes,
        selectedGenre,
        selectedDialect,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
