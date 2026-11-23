import 'package:equatable/equatable.dart';

/// Персонаж радиоспектакля.
class DramaCharacterEntity extends Equatable {
  final String id;
  final String namePt;
  final String roleRu;
  final String voiceEmoji;
  final String accentNoteRu;

  const DramaCharacterEntity({
    required this.id,
    required this.namePt,
    required this.roleRu,
    required this.voiceEmoji,
    required this.accentNoteRu,
  });

  @override
  List<Object?> get props => [id, namePt, roleRu, voiceEmoji, accentNoteRu];
}

/// Реплика актёра с театральной ремаркой и аудиофрагментом.
class DramaLineEntity extends Equatable {
  final String id;
  final String characterId;
  final String characterName;
  final String textPt;
  final String translationRu;
  final String stageDirectionRu; // Ремарка: (шепотом), (с тревогой), (смеется)
  final String slangOrIdiomNoteRu;
  final String audioSnippetText;

  const DramaLineEntity({
    required this.id,
    required this.characterId,
    required this.characterName,
    required this.textPt,
    required this.translationRu,
    required this.stageDirectionRu,
    required this.slangOrIdiomNoteRu,
    required this.audioSnippetText,
  });

  @override
  List<Object?> get props => [
        id,
        characterId,
        characterName,
        textPt,
        translationRu,
        stageDirectionRu,
        slangOrIdiomNoteRu,
        audioSnippetText,
      ];
}

/// Интерактивный сюжетный выбор слушателя в кульминации.
class DramaInteractiveChoice extends Equatable {
  final String id;
  final String promptRu;
  final String optionPt;
  final String optionRu;
  final String consequencePt;
  final String consequenceRu;

  const DramaInteractiveChoice({
    required this.id,
    required this.promptRu,
    required this.optionPt,
    required this.optionRu,
    required this.consequencePt,
    required this.consequenceRu,
  });

  @override
  List<Object?> get props => [
        id,
        promptRu,
        optionPt,
        optionRu,
        consequencePt,
        consequenceRu,
      ];
}

/// Сцена радиоспектакля.
class DramaSceneEntity extends Equatable {
  final String id;
  final int sceneNumber;
  final String sceneTitlePt;
  final String sceneTitleRu;
  final String atmosphericNoteRu;
  final List<DramaLineEntity> lines;
  final DramaInteractiveChoice? interactiveChoice;

  const DramaSceneEntity({
    required this.id,
    required this.sceneNumber,
    required this.sceneTitlePt,
    required this.sceneTitleRu,
    required this.atmosphericNoteRu,
    required this.lines,
    this.interactiveChoice,
  });

  @override
  List<Object?> get props => [
        id,
        sceneNumber,
        sceneTitlePt,
        sceneTitleRu,
        atmosphericNoteRu,
        lines,
        interactiveChoice,
      ];
}

/// Радиопостановка (аудиоспектакль).
class AudioDramaEntity extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final String genre; // 'Mistério / Noir', 'Romance Dramático', 'Suspense Marítimo', 'Thriller Corporativo'
  final String setting;
  final String dialect; // 'pt_PT' or 'pt_BR'
  final String coverEmoji;
  final String ambientSoundName;
  final String ambientSoundRu;
  final String synopsisRu;
  final String cefrLevel;
  final List<DramaCharacterEntity> characters;
  final List<DramaSceneEntity> scenes;

  const AudioDramaEntity({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.genre,
    required this.setting,
    required this.dialect,
    required this.coverEmoji,
    required this.ambientSoundName,
    required this.ambientSoundRu,
    required this.synopsisRu,
    required this.cefrLevel,
    required this.characters,
    required this.scenes,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      (dialect.toLowerCase().contains('pt') && !dialect.toLowerCase().contains('br'));

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : '🇧🇷';
  String get dialectLabel => isPtPt ? 'Portugal' : 'Brasil';

  int get totalLines => scenes.fold(0, (sum, s) => sum + s.lines.length);

  @override
  List<Object?> get props => [
        id,
        titlePt,
        titleRu,
        genre,
        setting,
        dialect,
        coverEmoji,
        ambientSoundName,
        ambientSoundRu,
        synopsisRu,
        cefrLevel,
        characters,
        scenes,
      ];
}
