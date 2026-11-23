import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/radio_novela_entities.dart';
import '../../domain/repositories/radio_novela_repository.dart';
import '../datasources/radio_novela_seed_data.dart';

class RadioNovelaRepositoryImpl implements RadioNovelaRepository {
  final AppDatabase? _database;

  RadioNovelaRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<AudioDramaEntity>>> getDramas({
    String? dialect,
    String? genre,
  }) async {
    try {
      var pool = List<AudioDramaEntity>.from(RadioNovelaSeedData.dramas);

      if (dialect != null && dialect.toLowerCase() != 'all') {
        final d = dialect.toLowerCase();
        final isPt = d.contains('pt') && !d.contains('br');
        final isBr = d.contains('br');

        if (isPt) {
          pool = pool.where((m) => m.isPtPt).toList();
        } else if (isBr) {
          pool = pool.where((m) => m.isPtBr).toList();
        }
      }

      if (genre != null && genre.toLowerCase() != 'all') {
        pool = pool
            .where((m) => m.genre.toLowerCase().contains(genre.toLowerCase()))
            .toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка загрузки радионовелл: $e'));
    }
  }

  @override
  Future<Result<AudioDramaEntity>> getDramaById(String id) async {
    try {
      final drama = RadioNovelaSeedData.dramas.firstWhere(
        (d) => d.id == id,
        orElse: () => throw Exception('Радиоспектакль $id не найден'),
      );
      return Result.ok(drama);
    } catch (e) {
      return Result.err(DatabaseFailure('Радиоспектакль не найден: $e'));
    }
  }

  @override
  Future<Result<void>> recordDramaCompleted({
    required String dramaId,
    required int scenesFinished,
  }) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'radionovela_$dramaId',
          wordAccuracy: (scenesFinished * 35.0).clamp(0.0, 100.0),
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить прогресс спектакля: $e'));
    }
  }
}
