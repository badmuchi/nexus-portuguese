import 'package:equatable/equatable.dart';
import '../../domain/entities/humor_entities.dart';

enum HumorCatalogStatus { initial, loading, loaded, error }

class HumorCatalogState extends Equatable {
  final HumorCatalogStatus status;
  final List<JokeEntity> allJokes;
  final List<TrocadilhoEntity> allTrocadilhos;
  final JokeCategory? selectedCategory;
  final String selectedDialect;
  final String searchQuery;
  final int activeTabIndex;
  final String? errorMessage;

  const HumorCatalogState({
    this.status = HumorCatalogStatus.initial,
    this.allJokes = const [],
    this.allTrocadilhos = const [],
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  List<JokeEntity> get filteredJokes {
    return allJokes.where((joke) {
      // Category filter
      if (selectedCategory != null && joke.category != selectedCategory) {
        return false;
      }

      // Dialect filter
      if (selectedDialect != 'all') {
        final dLower = selectedDialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        if (joke.dialect != 'all') {
          if (isLookingForPt && !joke.isPtPt) return false;
          if (isLookingForBr && !joke.isPtBr) return false;
        }
      }

      // Search query
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final inTitle = joke.titlePt.toLowerCase().contains(q) ||
            joke.titleRu.toLowerCase().contains(q);
        final inSetup = joke.setupPt.toLowerCase().contains(q) ||
            joke.setupRu.toLowerCase().contains(q);
        final inPunchline = joke.punchlinePt.toLowerCase().contains(q) ||
            joke.punchlineRu.toLowerCase().contains(q);
        if (!inTitle && !inSetup && !inPunchline) return false;
      }

      return true;
    }).toList();
  }

  List<TrocadilhoEntity> get filteredTrocadilhos {
    return allTrocadilhos.where((trocadilho) {
      // Dialect filter
      if (selectedDialect != 'all') {
        final dLower = selectedDialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        if (trocadilho.dialect != 'all') {
          if (isLookingForPt && !trocadilho.isPtPt) return false;
          if (isLookingForBr && !trocadilho.isPtBr) return false;
        }
      }

      // Search query
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final inQ = trocadilho.questionPt.toLowerCase().contains(q) ||
            trocadilho.questionRu.toLowerCase().contains(q);
        final inA = trocadilho.answerPt.toLowerCase().contains(q) ||
            trocadilho.answerRu.toLowerCase().contains(q);
        final inExpl = trocadilho.wordplayExplanationRu.toLowerCase().contains(q);
        if (!inQ && !inA && !inExpl) return false;
      }

      return true;
    }).toList();
  }

  HumorCatalogState copyWith({
    HumorCatalogStatus? status,
    List<JokeEntity>? allJokes,
    List<TrocadilhoEntity>? allTrocadilhos,
    JokeCategory? selectedCategory,
    bool clearCategory = false,
    String? selectedDialect,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return HumorCatalogState(
      status: status ?? this.status,
      allJokes: allJokes ?? this.allJokes,
      allTrocadilhos: allTrocadilhos ?? this.allTrocadilhos,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allJokes,
        allTrocadilhos,
        selectedCategory,
        selectedDialect,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
