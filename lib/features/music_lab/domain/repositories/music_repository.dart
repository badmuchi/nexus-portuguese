import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/portuguese_song_entity.dart';

abstract class MusicRepository {
  /// Получить каталог песен с возможностью фильтрации по жанру и диалекту.
  Future<Result<List<PortugueseSong>>> getSongs({
    MusicGenre? genre,
    String? dialect,
  });

  /// Получить песню по id.
  Future<Result<PortugueseSong>> getSongById(String id);

  /// Зафиксировать прогресс разучивания песни в истории БД.
  Future<Result<void>> recordSongPractice({
    required String songId,
    required int linesCompleted,
    required int totalLines,
  });
}
