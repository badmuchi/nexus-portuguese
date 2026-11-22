import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/podcast_track_entity.dart';
import '../../domain/repositories/auditorio_repository.dart';
import '../datasources/auditorio_seed_data.dart';

class AuditorioRepositoryImpl implements AuditorioRepository {
  final AppDatabase _database;

  AuditorioRepositoryImpl({required AppDatabase database}) : _database = database;

  @override
  Future<Result<List<PodcastTrack>>> getPodcasts({
    String? dialect,
    String? cefrLevel,
    String? category,
  }) async {
    try {
      final completedIdsResult = await getCompletedPodcastIds();
      final completedSet = completedIdsResult.isOk ? completedIdsResult.value.toSet() : <String>{};

      var filtered = AuditorioSeedData.tracks.map((track) {
        final isCompleted = completedSet.contains(track.id);
        return track.copyWith(isCompleted: isCompleted);
      }).toList();

      if (dialect != null && dialect != 'all') {
        filtered = filtered.where((t) => t.dialect.toLowerCase() == dialect.toLowerCase()).toList();
      }

      if (cefrLevel != null && cefrLevel.isNotEmpty && cefrLevel != 'all') {
        filtered = filtered.where((t) => t.cefrLevel.toUpperCase() == cefrLevel.toUpperCase()).toList();
      }

      if (category != null && category.isNotEmpty && category != 'all') {
        filtered = filtered.where((t) => t.category.toLowerCase() == category.toLowerCase()).toList();
      }

      return Result.ok(filtered);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить каталог подкастов: $e'));
    }
  }

  @override
  Future<Result<PodcastTrack>> getPodcastById(String id) async {
    try {
      final track = AuditorioSeedData.tracks.firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Подкаст с id $id не найден'),
      );

      final completedIdsResult = await getCompletedPodcastIds();
      final isCompleted = completedIdsResult.isOk && completedIdsResult.value.contains(id);

      return Result.ok(track.copyWith(isCompleted: isCompleted));
    } catch (e) {
      return Result.err(DatabaseFailure('Подкаст не найден: $e'));
    }
  }

  @override
  Future<Result<void>> recordPodcastListenProgress({
    required String podcastId,
    required int completedSnippets,
    required int totalSnippets,
  }) async {
    try {
      final accuracy = totalSnippets > 0 ? (completedSnippets / totalSnippets).clamp(0.0, 1.0) : 1.0;
      final isCompleted = completedSnippets >= totalSnippets;

      await _database.insertListeningAttemptLog(
        exerciseId: 'auditorio_track_$podcastId',
        wordAccuracy: accuracy,
        isExactMatch: isCompleted,
        attemptedAt: DateTime.now(),
      );

      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить прогресс прослушивания: $e'));
    }
  }

  @override
  Future<Result<void>> recordShadowingResult({
    required String podcastId,
    required String snippetId,
    required double accuracyScore,
    required bool isPass,
  }) async {
    try {
      await _database.insertListeningAttemptLog(
        exerciseId: 'auditorio_${podcastId}_$snippetId',
        wordAccuracy: accuracyScore.clamp(0.0, 1.0),
        isExactMatch: isPass,
        attemptedAt: DateTime.now(),
      );

      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить результат Shadowing: $e'));
    }
  }

  @override
  Future<Result<List<String>>> getCompletedPodcastIds() async {
    try {
      final logs = await _database.getAllListeningAttemptLogs();
      final completed = <String>{};

      for (final log in logs) {
        if (log.exerciseId.startsWith('auditorio_track_') && log.isExactMatch) {
          final id = log.exerciseId.replaceFirst('auditorio_track_', '');
          completed.add(id);
        }
      }

      return Result.ok(completed.toList());
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось получить завершенные подкасты: $e'));
    }
  }
}
