import 'package:equatable/equatable.dart';

/// Реплика персонажа в кинематографической сцене.
class CinemaDialogueLineEntity extends Equatable {
  final String id;
  final String speakerName;
  final String speakerRoleRu; // Например, "Бускапе (рассказчик)", "Дора", "Жуан Грилу"
  final String textPt;
  final String translationRu;
  final String? slangNoteRu; // Объяснение сленга/диалектизма
  final String? culturalSubtextRu; // Скрытый подтекст или интонация

  const CinemaDialogueLineEntity({
    required this.id,
    required this.speakerName,
    required this.speakerRoleRu,
    required this.textPt,
    required this.translationRu,
    this.slangNoteRu,
    this.culturalSubtextRu,
  });

  @override
  List<Object?> get props => [
        id,
        speakerName,
        speakerRoleRu,
        textPt,
        translationRu,
        slangNoteRu,
        culturalSubtextRu,
      ];
}

/// Сцена из культового португалоязычного фильма или сериала.
class MovieSceneEntity extends Equatable {
  final String id;
  final String movieTitlePt;
  final String movieTitleRu;
  final int releaseYear;
  final String director;
  final String genre; // "Drama", "Crime", "Comédia", "Histórico", "Suspense"
  final String dialect; // 'pt_BR', 'pt_PT'
  final String region; // "Rio de Janeiro", "Sertão da Paraíba", "Lisboa", "Ribatejo"
  final String iconEmoji;
  final String cefrLevel;
  final String synopsisRu;
  final String sceneContextRu;
  final List<CinemaDialogueLineEntity> dialogueLines;
  final List<String> culturalKeytakeawaysRu;

  const MovieSceneEntity({
    required this.id,
    required this.movieTitlePt,
    required this.movieTitleRu,
    required this.releaseYear,
    required this.director,
    required this.genre,
    required this.dialect,
    required this.region,
    required this.iconEmoji,
    required this.cefrLevel,
    required this.synopsisRu,
    required this.sceneContextRu,
    required this.dialogueLines,
    required this.culturalKeytakeawaysRu,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : '🇧🇷';
  String get dialectLabel => isPtPt ? 'Portugal' : 'Brasil';

  @override
  List<Object?> get props => [
        id,
        movieTitlePt,
        movieTitleRu,
        releaseYear,
        director,
        genre,
        dialect,
        region,
        iconEmoji,
        cefrLevel,
        synopsisRu,
        sceneContextRu,
        dialogueLines,
        culturalKeytakeawaysRu,
      ];
}
