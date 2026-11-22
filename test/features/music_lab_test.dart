import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/music_lab/data/datasources/music_lab_seed_data.dart';
import 'package:nexus_portuguese_app/features/music_lab/data/repositories/music_repository_impl.dart';
import 'package:nexus_portuguese_app/features/music_lab/domain/entities/portuguese_song_entity.dart';
import 'package:nexus_portuguese_app/features/music_lab/domain/entities/song_lyric_line_entity.dart';

void main() {
  group('Music Lab Entities & Seed Data Tests', () {
    test('PortugueseSong dialect helpers identify PT-BR and PT-PT correctly', () {
      const brSong = PortugueseSong(
        id: 'br_1',
        titlePt: 'Garota de Ipanema',
        titleRu: 'Девушка из Ипанемы',
        artist: 'Tom Jobim',
        genre: MusicGenre.bossaNova,
        dialect: 'pt_BR',
        cefrLevel: 'A2',
        durationSeconds: 195,
        coverEmoji: '🌴',
        primaryColorHex: 0xFF00796B,
        accentColorHex: 0xFFFBC02D,
        culturalIntroRu: 'Знаменитая босса-нова.',
        lyrics: [],
      );

      expect(brSong.isPtBr, isTrue);
      expect(brSong.isPtPt, isFalse);
      expect(brSong.dialectFlag, '🇧🇷');
      expect(brSong.dialectLabel, 'Brasil');
      expect(brSong.formattedDuration, '3m 15s');

      const ptSong = PortugueseSong(
        id: 'pt_1',
        titlePt: 'Uma Casa Portuguesa',
        titleRu: 'Португальский дом',
        artist: 'Amália Rodrigues',
        genre: MusicGenre.fado,
        dialect: 'pt_PT',
        cefrLevel: 'B1',
        durationSeconds: 165,
        coverEmoji: '🏡',
        primaryColorHex: 0xFF3E2723,
        accentColorHex: 0xFFFF7043,
        culturalIntroRu: 'Гимн гостеприимства фаду.',
        lyrics: [],
      );

      expect(ptSong.isPtPt, isTrue);
      expect(ptSong.isPtBr, isFalse);
      expect(ptSong.dialectFlag, '🇵🇹');
      expect(ptSong.dialectLabel, 'Portugal');
      expect(ptSong.formattedDuration, '2m 45s');
    });

    test('SongLyricLine maskedTextPt masks the target word', () {
      const line = SongLyricLine(
        id: 'l_1',
        index: 0,
        startTimeMs: 0,
        endTimeMs: 4000,
        textPt: 'É pau, é pedra, é o fim do caminho',
        translationRu: 'Это палка, это камень, это конец дороги',
        targetMissingWord: 'pedra',
        quizOptions: ['pedra', 'areia', 'rio', 'mar'],
      );

      expect(line.maskedTextPt, 'É pau, é _______, é o fim do caminho');
      expect(line.durationMs, 4000);
      expect(line.formattedTime, '00:00');
    });

    test('MusicLabSeedData contains 6 songs with valid lyrics and options', () {
      const songs = MusicLabSeedData.songs;
      expect(songs.length, greaterThanOrEqualTo(6));

      for (final song in songs) {
        expect(song.id, isNotEmpty);
        expect(song.titlePt, isNotEmpty);
        expect(song.artist, isNotEmpty);
        expect(song.lyrics, isNotEmpty);
        for (final line in song.lyrics) {
          expect(line.textPt, isNotEmpty);
          expect(line.translationRu, isNotEmpty);
          if (line.targetMissingWord != null) {
            expect(line.quizOptions, contains(line.targetMissingWord));
          }
        }
      }
    });

    test('MusicRepositoryImpl returns filtered songs', () async {
      final repo = MusicRepositoryImpl();

      final allResult = await repo.getSongs();
      expect(allResult.isOk, isTrue);
      expect(allResult.value.length, greaterThanOrEqualTo(6));

      final fadoResult = await repo.getSongs(genre: MusicGenre.fado);
      expect(fadoResult.isOk, isTrue);
      for (final s in fadoResult.value) {
        expect(s.genre, MusicGenre.fado);
      }

      final brResult = await repo.getSongs(dialect: 'pt_BR');
      expect(brResult.isOk, isTrue);
      for (final s in brResult.value) {
        expect(s.dialect, 'pt_BR');
      }

      final byIdResult = await repo.getSongById('song_aguas_de_marco');
      expect(byIdResult.isOk, isTrue);
      expect(byIdResult.value.titlePt, 'Águas de Março');
    });
  });
}
