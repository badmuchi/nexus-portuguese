import 'package:equatable/equatable.dart';

/// Отрывок или строфа литературного произведения с грамматическим и поэтическим комментарием.
class LiteraryPassageEntity extends Equatable {
  final String id;
  final String originalPt;
  final String translationRu;
  final String grammaticalNotesRu;
  final String poeticDeviceRu;
  final String audioSnippetText;

  const LiteraryPassageEntity({
    required this.id,
    required this.originalPt,
    required this.translationRu,
    required this.grammaticalNotesRu,
    required this.poeticDeviceRu,
    required this.audioSnippetText,
  });

  @override
  List<Object?> get props => [
        id,
        originalPt,
        translationRu,
        grammaticalNotesRu,
        poeticDeviceRu,
        audioSnippetText,
      ];
}

/// Редкое литературное слово или поэтический термин с контекстом.
class LiteraryVocabularyEntity extends Equatable {
  final String id;
  final String wordPt;
  final String translationRu;
  final String partOfSpeech;
  final String contextSentencePt;
  final String contextSentenceRu;
  final String etymologyRu;

  const LiteraryVocabularyEntity({
    required this.id,
    required this.wordPt,
    required this.translationRu,
    required this.partOfSpeech,
    required this.contextSentencePt,
    required this.contextSentenceRu,
    required this.etymologyRu,
  });

  @override
  List<Object?> get props => [
        id,
        wordPt,
        translationRu,
        partOfSpeech,
        contextSentencePt,
        contextSentenceRu,
        etymologyRu,
      ];
}

/// Сущность литературного шедевра португалоязычного мира.
class LiteraryWorkEntity extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final String authorName;
  final String authorBioRu;
  final String epochOrMovementRu;
  final String dialect; // 'pt_PT' or 'pt_BR'
  final String genre; // 'Poesia', 'Prosa Poética', 'Romance Filosófico', 'Soneto'
  final String coverEmoji;
  final String cefrLevel; // 'B1', 'B2', 'C1'
  final String analysisContextRu;
  final List<LiteraryPassageEntity> passages;
  final List<LiteraryVocabularyEntity> vocabularyCards;

  const LiteraryWorkEntity({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.authorName,
    required this.authorBioRu,
    required this.epochOrMovementRu,
    required this.dialect,
    required this.genre,
    required this.coverEmoji,
    required this.cefrLevel,
    required this.analysisContextRu,
    required this.passages,
    required this.vocabularyCards,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : isPtBr ? '🇧🇷' : '🌐';
  String get dialectLabel => isPtPt ? 'Portugal' : isPtBr ? 'Brasil' : 'Lusofonia';

  @override
  List<Object?> get props => [
        id,
        titlePt,
        titleRu,
        authorName,
        authorBioRu,
        epochOrMovementRu,
        dialect,
        genre,
        coverEmoji,
        cefrLevel,
        analysisContextRu,
        passages,
        vocabularyCards,
      ];
}

/// Афоризм или великая цитата португальской классики.
class LiteraryQuoteEntity extends Equatable {
  final String id;
  final String quotePt;
  final String translationRu;
  final String authorName;
  final String workTitle;
  final int publicationYear;
  final String dialect;
  final String philosophicalInsightRu;

  const LiteraryQuoteEntity({
    required this.id,
    required this.quotePt,
    required this.translationRu,
    required this.authorName,
    required this.workTitle,
    required this.publicationYear,
    required this.dialect,
    required this.philosophicalInsightRu,
  });

  bool get isPtPt => dialect.toLowerCase().contains('pt');
  bool get isPtBr => dialect.toLowerCase().contains('br');
  String get dialectFlag => isPtPt ? '🇵🇹' : '🇧🇷';

  @override
  List<Object?> get props => [
        id,
        quotePt,
        translationRu,
        authorName,
        workTitle,
        publicationYear,
        dialect,
        philosophicalInsightRu,
      ];
}
