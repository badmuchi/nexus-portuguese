import 'package:equatable/equatable.dart';

enum PartOfSpeech {
  substantivo('Существительное (Substantivo)', 'noun'),
  verbo('Глагол (Verbo)', 'verb'),
  adjetivo('Прилагательное (Adjetivo)', 'adjective'),
  pronome('Местоимение (Pronome)', 'pronoun'),
  artigo('Артикль (Artigo)', 'article'),
  preposicao('Предлог (Preposição)', 'preposition'),
  contracao('Слияние предлога (Contração)', 'contraction'),
  adverbio('Наречие (Advérbio)', 'adverb'),
  conjuncao('Союз (Conjunção)', 'conjunction'),
  interjeicao('Междометие (Interjeição)', 'interjection'),
  desconhecido('Часть речи', 'unknown');

  final String labelRu;
  final String code;
  const PartOfSpeech(this.labelRu, this.code);
}

class ContractionBreakdown extends Equatable {
  final String preposition;
  final String articleOrPronoun;
  final String formula;
  final String explanationRu;

  const ContractionBreakdown({
    required this.preposition,
    required this.articleOrPronoun,
    required this.formula,
    required this.explanationRu,
  });

  @override
  List<Object?> get props => [preposition, articleOrPronoun, formula, explanationRu];
}

class WordMorphology extends Equatable {
  final String rawWord;
  final String cleanWord;
  final PartOfSpeech partOfSpeech;
  final String lemma;
  final String translationRu;
  final String? grammarNotes;
  final ContractionBreakdown? contraction;
  final String? cliticPronoun;

  const WordMorphology({
    required this.rawWord,
    required this.cleanWord,
    required this.partOfSpeech,
    required this.lemma,
    required this.translationRu,
    this.grammarNotes,
    this.contraction,
    this.cliticPronoun,
  });

  @override
  List<Object?> get props => [
        rawWord,
        cleanWord,
        partOfSpeech,
        lemma,
        translationRu,
        grammarNotes,
        contraction,
        cliticPronoun,
      ];
}

class SentenceXRayEntity extends Equatable {
  final String originalSentence;
  final String translationRu;
  final List<WordMorphology> words;

  const SentenceXRayEntity({
    required this.originalSentence,
    required this.translationRu,
    required this.words,
  });

  @override
  List<Object?> get props => [originalSentence, translationRu, words];
}
