import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/music_lab/data/datasources/music_lab_seed_data.dart';
import 'package:nexus_portuguese_app/features/music_lab/domain/entities/portuguese_song_entity.dart';
import 'package:nexus_portuguese_app/features/music_lab/domain/repositories/music_repository.dart';
import 'package:nexus_portuguese_app/features/music_lab/presentation/cubit/music_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/music_lab/presentation/cubit/song_player_cubit.dart';

class MockMusicRepository extends Mock implements MusicRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('MusicCatalogCubit Tests', () {
    late MockMusicRepository mockRepo;
    late MusicCatalogCubit cubit;
    const testSongs = MusicLabSeedData.songs;

    setUp(() {
      mockRepo = MockMusicRepository();
      when(() => mockRepo.getSongs(
            genre: any(named: 'genre'),
            dialect: any(named: 'dialect'),
          )).thenAnswer((_) async => const Result.ok(testSongs));

      cubit = MusicCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty songs and not loading', () {
      expect(cubit.state.songs, isEmpty);
      expect(cubit.state.isLoading, isFalse);
    });

    test('loadSongs emits songs on success', () async {
      await cubit.loadSongs();
      expect(cubit.state.songs.length, testSongs.length);
      expect(cubit.state.isLoading, isFalse);
    });

    test('filterByGenre updates selectedGenre and filters results', () async {
      await cubit.loadSongs();
      cubit.filterByGenre(MusicGenre.fado);

      expect(cubit.state.selectedGenre, MusicGenre.fado);
      for (final song in cubit.state.filteredSongs) {
        expect(song.genre, MusicGenre.fado);
      }
    });

    test('searchSongs filters songs by title or artist', () async {
      await cubit.loadSongs();
      cubit.searchSongs('Jobim');

      expect(cubit.state.filteredSongs.length, 1);
      expect(cubit.state.filteredSongs.first.artist, contains('Jobim'));
    });
  });

  group('SongPlayerCubit Tests', () {
    late MockMusicRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late SongPlayerCubit cubit;
    final testSong = MusicLabSeedData.songs.first;

    setUp(() {
      mockRepo = MockMusicRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockRepo.recordSongPractice(
            songId: any(named: 'songId'),
            linesCompleted: any(named: 'linesCompleted'),
            totalLines: any(named: 'totalLines'),
          )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
            fallbackText: any(named: 'fallbackText'),
            dialect: any(named: 'dialect'),
            rate: any(named: 'rate'),
          )).thenAnswer((_) async {});

      when(() => mockAudio.stop()).thenAnswer((_) async {});

      cubit = SongPlayerCubit(
        song: testSong,
        repository: mockRepo,
        audioService: mockAudio,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has line index 0 and is not playing', () {
      expect(cubit.state.currentLineIndex, 0);
      expect(cubit.state.isPlaying, isFalse);
      expect(cubit.state.isQuizMode, isFalse);
      expect(cubit.state.quizScore, 0);
      expect(cubit.state.progress, 0.0);
    });

    test('togglePlayPause starts playback and speaks line', () {
      cubit.togglePlayPause();

      expect(cubit.state.isPlaying, isTrue);
      verify(() => mockAudio.playAudioOrSpeak(
            fallbackText: testSong.lyrics.first.textPt,
            dialect: any(named: 'dialect'),
            rate: any(named: 'rate'),
          )).called(1);

      cubit.togglePlayPause();
      expect(cubit.state.isPlaying, isFalse);
      verify(() => mockAudio.stop()).called(1);
    });

    test('nextLine and previousLine navigate correctly', () {
      cubit.nextLine();
      expect(cubit.state.currentLineIndex, 1);

      cubit.previousLine();
      expect(cubit.state.currentLineIndex, 0);

      // Clamping at index 0
      cubit.previousLine();
      expect(cubit.state.currentLineIndex, 0);
    });

    test('speed, translation, and quiz mode toggling', () {
      cubit.setPlaybackSpeed(1.25);
      expect(cubit.state.playbackSpeed, 1.25);

      cubit.toggleTranslation();
      expect(cubit.state.showTranslation, isFalse);

      cubit.toggleQuizMode();
      expect(cubit.state.isQuizMode, isTrue);
    });

    test('selectQuizOption scores correct answer and updates completed lines', () {
      cubit.toggleQuizMode();
      final line = cubit.state.currentLine;
      final targetWord = line.targetMissingWord!;

      cubit.selectQuizOption(targetWord);

      expect(cubit.state.isOptionCorrect, isTrue);
      expect(cubit.state.quizScore, 10);
      expect(cubit.state.completedLineIndices, contains(0));
      expect(cubit.state.progress, greaterThan(0.0));

      verify(() => mockRepo.recordSongPractice(
            songId: testSong.id,
            linesCompleted: any(named: 'linesCompleted'),
            totalLines: any(named: 'totalLines'),
          )).called(1);
    });

    test('selectQuizOption marks false on incorrect answer without increasing score', () {
      cubit.toggleQuizMode();
      cubit.selectQuizOption('WRONG_WORD_123');

      expect(cubit.state.isOptionCorrect, isFalse);
      expect(cubit.state.quizScore, 0);
    });

    test('resetProgress resets index, completed lines, and score', () {
      cubit.toggleQuizMode();
      final line = cubit.state.currentLine;
      cubit.selectQuizOption(line.targetMissingWord!);

      cubit.resetProgress();
      expect(cubit.state.currentLineIndex, 0);
      expect(cubit.state.quizScore, 0);
      expect(cubit.state.completedLineIndices, isEmpty);
      expect(cubit.state.isPlaying, isFalse);
    });
  });
}
