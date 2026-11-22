import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/podcast_track_entity.dart';

abstract class AuditorioRepository {
  /// Получить список всех подкастов с опциональной фильтрацией по диалекту, уровню или категории.
  Future<Result<List<PodcastTrack>>> getPodcasts({
    String? dialect,
    String? cefrLevel,
    String? category,
  });

  /// Получить конкретный подкаст по id.
  Future<Result<PodcastTrack>> getPodcastById(String id);

  /// Зафиксировать прогресс прослушивания подкаста в логах БД.
  Future<Result<void>> recordPodcastListenProgress({
    required String podcastId,
    required int completedSnippets,
    required int totalSnippets,
  });

  /// Сохранить результат попытки Shadowing в БД.
  Future<Result<void>> recordShadowingResult({
    required String podcastId,
    required String snippetId,
    required double accuracyScore,
    required bool isPass,
  });

  /// Получить список id завершенных подкастов.
  Future<Result<List<String>>> getCompletedPodcastIds();
}
