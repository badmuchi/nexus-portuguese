import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/literary_work_entity.dart';
import '../../domain/repositories/literature_repository.dart';
import '../datasources/literature_seed_data.dart';

class LiteratureRepositoryImpl implements LiteratureRepository {
  final AppDatabase? _database;

  LiteratureRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<LiteraryWorkEntity>>> getWorks({
    String? dialect,
    String? genre,
  }) async {
    try {
      var pool = List<LiteraryWorkEntity>.from(LiteratureSeedData.works);

      if (dialect != null && dialect.toLowerCase() != 'all') {
        final d = dialect.toLowerCase();
        final isPt = d.contains('pt') && !d.contains('br');
        final isBr = d.contains('br');

        if (isPt) {
          pool = pool.where((w) => w.isPtPt).toList();
        } else if (isBr) {
          pool = pool.where((w) => w.isPtBr).toList();
        }
      }

      if (genre != null && genre.toLowerCase() != 'all') {
        pool = pool
            .where((w) => w.genre.toLowerCase().contains(genre.toLowerCase()))
            .toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка загрузки каталога литературы: $e'));
    }
  }

  @override
  Future<Result<LiteraryWorkEntity>> getWorkById(String id) async {
    try {
      final work = LiteratureSeedData.works.firstWhere(
        (w) => w.id == id,
        orElse: () => throw Exception('Произведение $id не найдено'),
      );
      return Result.ok(work);
    } catch (e) {
      return Result.err(DatabaseFailure('Произведение не найдено: $e'));
    }
  }

  @override
  Future<Result<List<LiteraryQuoteEntity>>> getFamousQuotes({
    String? dialect,
  }) async {
    try {
      var pool = List<LiteraryQuoteEntity>.from(LiteratureSeedData.famousQuotes);

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
      return Result.err(DatabaseFailure('Ошибка загрузки поэтических цитат: $e'));
    }
  }

  @override
  Future<Result<void>> recordWorkRead({
    required String workId,
    required int passagesRead,
  }) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'literature_$workId',
          wordAccuracy: (passagesRead * 25.0).clamp(0.0, 100.0),
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить лог чтения: $e'));
    }
  }
}
