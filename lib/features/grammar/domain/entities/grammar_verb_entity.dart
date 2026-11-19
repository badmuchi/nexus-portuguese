import 'package:equatable/equatable.dart';

class VerbConjugationForm extends Equatable {
  final String tense;
  final String person;
  final String form;

  const VerbConjugationForm({
    required this.tense,
    required this.person,
    required this.form,
  });

  factory VerbConjugationForm.fromJson(Map<String, dynamic> json) {
    return VerbConjugationForm(
      tense: json['tense'] as String,
      person: json['person'] as String,
      form: json['form'] as String,
    );
  }

  @override
  List<Object?> get props => [tense, person, form];
}

class GrammarVerbEntity extends Equatable {
  final String id;
  final String infinitive;
  final String regularity;
  final String conjugationGroup;
  final String russianMeaning;
  final String grammarNotesRu;
  final String? differenceNote;
  final List<VerbConjugationForm> conjugations;

  const GrammarVerbEntity({
    required this.id,
    required this.infinitive,
    required this.regularity,
    required this.conjugationGroup,
    required this.russianMeaning,
    required this.grammarNotesRu,
    this.differenceNote,
    required this.conjugations,
  });

  @override
  List<Object?> get props => [
        id,
        infinitive,
        regularity,
        conjugationGroup,
        russianMeaning,
        grammarNotesRu,
        differenceNote,
        conjugations,
      ];
}

class PrepositionContractionEntity extends Equatable {
  final String preposition;
  final String article;
  final String contracted;
  final String example;
  final String translation;
  final String meaning;

  const PrepositionContractionEntity({
    required this.preposition,
    required this.article,
    required this.contracted,
    required this.example,
    required this.translation,
    required this.meaning,
  });

  @override
  List<Object?> get props => [preposition, article, contracted, example, translation, meaning];
}
