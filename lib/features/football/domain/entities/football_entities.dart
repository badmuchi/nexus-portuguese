import 'package:equatable/equatable.dart';

enum FootballTermCategory {
  positions('Posições em Campo', 'Позиции игроков', '🧤'),
  rules('Regras & Arbitragem', 'Правила и судейство', '🟨'),
  movesAndSkills('Dribles & Finalizações', 'Финты и удары', '⚽'),
  slangAndJargon('Gírias da Bola & Pelada', 'Футбольный сленг', '🗣️');

  final String labelPt;
  final String labelRu;
  final String emoji;

  const FootballTermCategory(this.labelPt, this.labelRu, this.emoji);
}

/// Термин футбольного словаря с прямым парным сравнением PT-PT и PT-BR.
class FootballTermEntity extends Equatable {
  final String id;
  final String termPtPt;
  final String termPtBr;
  final String translationRu;
  final FootballTermCategory category;
  final String explanationRu;
  final String examplePtPt;
  final String examplePtBr;

  const FootballTermEntity({
    required this.id,
    required this.termPtPt,
    required this.termPtBr,
    required this.translationRu,
    required this.category,
    required this.explanationRu,
    required this.examplePtPt,
    required this.examplePtBr,
  });

  @override
  List<Object?> get props => [
        id,
        termPtPt,
        termPtBr,
        translationRu,
        category,
        explanationRu,
        examplePtPt,
        examplePtBr,
      ];
}

/// Кричалка торсиды или фанатский гимн.
class FanChantEntity extends Equatable {
  final String id;
  final String chantPt;
  final String translationRu;
  final String clubOrCountry;
  final String dialect; // 'pt_BR' or 'pt_PT'
  final String flagEmoji;
  final String contextCultureRu;

  const FanChantEntity({
    required this.id,
    required this.chantPt,
    required this.translationRu,
    required this.clubOrCountry,
    required this.dialect,
    required this.flagEmoji,
    required this.contextCultureRu,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      (dialect.toLowerCase().contains('pt') && !dialect.toLowerCase().contains('br'));
  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase().contains('br');

  @override
  List<Object?> get props => [
        id,
        chantPt,
        translationRu,
        clubOrCountry,
        dialect,
        flagEmoji,
        contextCultureRu,
      ];
}

/// Момент матча в симуляторе комментатора.
class MatchMomentEntity extends Equatable {
  final String id;
  final int minute;
  final String eventType; // 'kickoff', 'pass', 'dribble', 'shot', 'foul', 'goal', 'save', 'penalty'
  final String eventEmoji;
  final String commentaryPt;
  final String commentaryRu;
  final String dialectHighlightRu;
  final int scoreHome;
  final int scoreAway;

  const MatchMomentEntity({
    required this.id,
    required this.minute,
    required this.eventType,
    required this.eventEmoji,
    required this.commentaryPt,
    required this.commentaryRu,
    required this.dialectHighlightRu,
    required this.scoreHome,
    required this.scoreAway,
  });

  @override
  List<Object?> get props => [
        id,
        minute,
        eventType,
        eventEmoji,
        commentaryPt,
        commentaryRu,
        dialectHighlightRu,
        scoreHome,
        scoreAway,
      ];
}

/// Сценарий футбольного матча для симулятора.
class FootballMatchEntity extends Equatable {
  final String id;
  final String matchTitle;
  final String stadium;
  final String city;
  final String dialect; // 'pt_BR' or 'pt_PT'
  final String teamHome;
  final String teamAway;
  final String flagEmojiHome;
  final String flagEmojiAway;
  final String contextRu;
  final List<MatchMomentEntity> moments;

  const FootballMatchEntity({
    required this.id,
    required this.matchTitle,
    required this.stadium,
    required this.city,
    required this.dialect,
    required this.teamHome,
    required this.teamAway,
    required this.flagEmojiHome,
    required this.flagEmojiAway,
    required this.contextRu,
    required this.moments,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      (dialect.toLowerCase().contains('pt') && !dialect.toLowerCase().contains('br'));
  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase().contains('br');
  String get dialectFlag => isPtPt ? '🇵🇹' : '🇧🇷';
  String get dialectLabel => isPtPt ? 'Portugal' : 'Brasil';

  @override
  List<Object?> get props => [
        id,
        matchTitle,
        stadium,
        city,
        dialect,
        teamHome,
        teamAway,
        flagEmojiHome,
        flagEmojiAway,
        contextRu,
        moments,
      ];
}

/// Вопрос викторины по футбольному сленгу.
class FootballQuizQuestion extends Equatable {
  final String id;
  final String questionPt;
  final String questionRu;
  final List<String> optionsPt;
  final List<String> optionsRu;
  final int correctOptionIndex;
  final String explanationRu;
  final String dialectFlag;

  const FootballQuizQuestion({
    required this.id,
    required this.questionPt,
    required this.questionRu,
    required this.optionsPt,
    required this.optionsRu,
    required this.correctOptionIndex,
    required this.explanationRu,
    required this.dialectFlag,
  });

  @override
  List<Object?> get props => [
        id,
        questionPt,
        questionRu,
        optionsPt,
        optionsRu,
        correctOptionIndex,
        explanationRu,
        dialectFlag,
      ];
}
