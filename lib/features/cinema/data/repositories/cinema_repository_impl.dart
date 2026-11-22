import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/cinema_quote_entity.dart';
import '../../domain/entities/movie_scene_entity.dart';
import '../../domain/repositories/cinema_repository.dart';
import '../datasources/cinema_seed_data.dart';

class CinemaRepositoryImpl implements CinemaRepository {
  final AppDatabase? _database;

  CinemaRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<MovieSceneEntity>>> getScenes({
    String? dialect,
    String? genre,
  }) async {
    try {
      var pool = List<MovieSceneEntity>.from(CinemaSeedData.scenes);

      if (dialect != null && dialect.toLowerCase() != 'all') {
        final d = dialect.toLowerCase();
        final isPt = d.contains('pt') && !d.contains('br');
        final isBr = d.contains('br');

        if (isPt) {
          pool = pool.where((s) => s.isPtPt).toList();
        } else if (isBr) {
          pool = pool.where((s) => s.isPtBr).toList();
        }
      }

      if (genre != null && genre.toLowerCase() != 'all') {
        pool = pool.where((s) => s.genre.toLowerCase().contains(genre.toLowerCase())).toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить киносцены: $e'));
    }
  }

  @override
  Future<Result<MovieSceneEntity>> getSceneById(String id) async {
    try {
      final scene = CinemaSeedData.scenes.firstWhere(
        (s) => s.id == id,
        orElse: () => throw Exception('Сцена $id не найдена'),
      );
      return Result.ok(scene);
    } catch (e) {
      return Result.err(DatabaseFailure('Сцена не найдена: $e'));
    }
  }

  @override
  Future<Result<List<CinemaQuoteEntity>>> getFamousQuotes({
    String? dialect,
  }) async {
    try {
      var pool = List<CinemaQuoteEntity>.from(CinemaSeedData.famousQuotes);

      if (dialect != null && dialect.toLowerCase() != 'all') {
        final d = dialect.toLowerCase();
        final isPt = d.contains('pt') && !d.contains('br');
        final isBr = d.contains('br');

        if (isPt) {
          pool = pool.where((q) => q.isPtPt).toList();
        } else if (isBr) {
          pool = pool.where((q) => q.isPtBr).toList();
        }
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить киноцитаты: $e'));
    }
  }

  @override
  Future<Result<void>> recordSceneCompleted({
    required String sceneId,
    required int linesPracticed,
  }) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'cinema_scene_$sceneId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка записи прогресса синематеки: $e'));
    }
  }
}
