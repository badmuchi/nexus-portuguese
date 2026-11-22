import 'package:equatable/equatable.dart';
import 'song_lyric_line_entity.dart';

enum MusicGenre {
  bossaNova('Bossa Nova', 'Босса-нова', '🌊'),
  fado('Fado', 'Фаду', '🎸'),
  samba('Samba', 'Самба', '🥁'),
  mpb('MPB', 'Популярная музыка Бразилии', '🎺'),
  forro('Forró', 'Форро', '🪗');

  final String labelPt;
  final String labelRu;
  final String emoji;
  const MusicGenre(this.labelPt, this.labelRu, this.emoji);
}

/// Сущность португалоязычной песни в караоке-лаборатории.
class PortugueseSong extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final String artist;
  final MusicGenre genre;
  final String dialect; // 'pt_BR' или 'pt_PT'
  final String cefrLevel;
  final int durationSeconds;
  final String coverEmoji;
  final int primaryColorHex;
  final int accentColorHex;
  final String culturalIntroRu;
  final List<SongLyricLine> lyrics;

  const PortugueseSong({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.artist,
    required this.genre,
    required this.dialect,
    required this.cefrLevel,
    required this.durationSeconds,
    required this.coverEmoji,
    required this.primaryColorHex,
    required this.accentColorHex,
    required this.culturalIntroRu,
    required this.lyrics,
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

  String get formattedDuration {
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  @override
  List<Object?> get props => [
        id,
        titlePt,
        titleRu,
        artist,
        genre,
        dialect,
        cefrLevel,
        durationSeconds,
        coverEmoji,
        primaryColorHex,
        accentColorHex,
        culturalIntroRu,
        lyrics,
      ];
}
