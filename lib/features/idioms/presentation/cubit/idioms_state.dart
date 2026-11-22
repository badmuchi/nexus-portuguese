import 'package:equatable/equatable.dart';
import '../../domain/entities/idiom_quiz_challenge_entity.dart';
import '../../domain/entities/portuguese_idiom_entity.dart';

enum IdiomsStatus { initial, loading, loaded, quizActive, quizFinished, error }

class IdiomsState extends Equatable {
  final IdiomsStatus status;
  final List<PortugueseIdiom> allIdioms;
  final List<PortugueseIdiom> filteredIdioms;
  final IdiomCategory? selectedCategory;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String searchQuery;
  final List<IdiomQuizChallenge> quizChallenges;
  final int currentQuizIndex;
  final int? selectedQuizAnswerIndex;
  final int quizCorrectAnswers;
  final String? errorMessage;

  const IdiomsState({
    this.status = IdiomsStatus.initial,
    this.allIdioms = const [],
    this.filteredIdioms = const [],
    this.selectedCategory,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.quizChallenges = const [],
    this.currentQuizIndex = 0,
    this.selectedQuizAnswerIndex,
    this.quizCorrectAnswers = 0,
    this.errorMessage,
  });

  IdiomQuizChallenge? get currentChallenge {
    if (quizChallenges.isEmpty || currentQuizIndex < 0 || currentQuizIndex >= quizChallenges.length) {
      return null;
    }
    return quizChallenges[currentQuizIndex];
  }

  IdiomsState copyWith({
    IdiomsStatus? status,
    List<PortugueseIdiom>? allIdioms,
    List<PortugueseIdiom>? filteredIdioms,
    IdiomCategory? selectedCategory,
    bool clearCategory = false,
    String? selectedDialect,
    String? searchQuery,
    List<IdiomQuizChallenge>? quizChallenges,
    int? currentQuizIndex,
    int? selectedQuizAnswerIndex,
    bool clearSelection = false,
    int? quizCorrectAnswers,
    String? errorMessage,
  }) {
    return IdiomsState(
      status: status ?? this.status,
      allIdioms: allIdioms ?? this.allIdioms,
      filteredIdioms: filteredIdioms ?? this.filteredIdioms,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      quizChallenges: quizChallenges ?? this.quizChallenges,
      currentQuizIndex: currentQuizIndex ?? this.currentQuizIndex,
      selectedQuizAnswerIndex: clearSelection ? null : (selectedQuizAnswerIndex ?? this.selectedQuizAnswerIndex),
      quizCorrectAnswers: quizCorrectAnswers ?? this.quizCorrectAnswers,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allIdioms,
        filteredIdioms,
        selectedCategory,
        selectedDialect,
        searchQuery,
        quizChallenges,
        currentQuizIndex,
        selectedQuizAnswerIndex,
        quizCorrectAnswers,
        errorMessage,
      ];
}
