import 'package:equatable/equatable.dart';
import '../../domain/entities/grammar_verb_entity.dart';

abstract class GrammarState extends Equatable {
  const GrammarState();

  @override
  List<Object?> get props => [];
}

class GrammarInitial extends GrammarState {}

class GrammarLoading extends GrammarState {}

class GrammarLoaded extends GrammarState {
  final List<GrammarVerbEntity> verbs;
  final List<PrepositionContractionEntity> contractions;
  final String selectedGroup; // 'all', '-ar', '-er', '-ir', 'irregular'
  final String selectedTense; // 'presente_indicativo', 'preterito_perfeito', etc.
  final GrammarVerbEntity selectedVerb;

  const GrammarLoaded({
    required this.verbs,
    required this.contractions,
    this.selectedGroup = 'all',
    this.selectedTense = 'presente_indicativo',
    required this.selectedVerb,
  });

  List<GrammarVerbEntity> get filteredVerbs {
    if (selectedGroup == 'all') return verbs;
    if (selectedGroup == 'irregular') {
      return verbs.where((v) => v.regularity == 'irregular').toList();
    }
    return verbs.where((v) => v.conjugationGroup == selectedGroup).toList();
  }

  GrammarLoaded copyWith({
    List<GrammarVerbEntity>? verbs,
    List<PrepositionContractionEntity>? contractions,
    String? selectedGroup,
    String? selectedTense,
    GrammarVerbEntity? selectedVerb,
  }) {
    return GrammarLoaded(
      verbs: verbs ?? this.verbs,
      contractions: contractions ?? this.contractions,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      selectedTense: selectedTense ?? this.selectedTense,
      selectedVerb: selectedVerb ?? this.selectedVerb,
    );
  }

  @override
  List<Object?> get props => [
        verbs,
        contractions,
        selectedGroup,
        selectedTense,
        selectedVerb,
      ];
}

class GrammarError extends GrammarState {
  final String message;
  const GrammarError(this.message);

  @override
  List<Object?> get props => [message];
}
