import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/portuguese_song_entity.dart';
import '../../domain/repositories/music_repository.dart';
import '../datasources/music_lab_seed_data.dart';

class MusicRepositoryImpl implements MusicRepository {
  final AppDatabase? _database;

  MusicRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<PortugueseSong>>> getSongs({
    MusicGenre? genre,
    String? dialect,
  }) async {
    try {
      var pool = List<PortugueseSong>.from(MusicLabSeedData.songs);

      if (genre != null) {
        pool = pool.where((s) => s.genre == genre).toList();
      }

      if (dialect != null && dialect != 'all') {
        pool = pool.where((s) => s.dialect.toLowerCase() == dialect.toLowerCase()).toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить каталог песен: $e'));
    }
  }

  @override
  Future<Result<PortugueseSong>> getSongById(String id) async {
    try {
      final song = MusicLabSeedData.songs.firstWhere(
        (s) => s.id == id,
        orElse: () => throw Exception('Песня $id не найдена'),
      );
      return Result.ok(song);
    } catch (e) {
      return Result.err(DatabaseFailure('Песня не найдена: $e'));
    }
  }

  @override
  Future<Result<void>> recordSongPractice({
    required String songId,
    required int linesCompleted,
    required int totalLines,
  }) async {
    try {
      final accuracy = totalLines > 0 ? (linesCompleted / totalLines).clamp(0.0, 1.0) : 1.0;
      final isExact = linesCompleted >= totalLines;

      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'song_practice_$songId',
          wordAccuracy: accuracy,
          isExactMatch: isExact,
          attemptedAt: DateTime.now(),
        );
      }

      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить прогресс караоке: $e'));
    }
  }
}
