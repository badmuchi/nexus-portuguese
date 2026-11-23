import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/radio_novela_entities.dart';

abstract class RadioNovelaRepository {
  /// Получить каталог радиопостановок с фильтрацией.
  Future<Result<List<AudioDramaEntity>>> getDramas({
    String? dialect,
    String? genre,
  });

  /// Получить радиопостановку по ID.
  Future<Result<AudioDramaEntity>> getDramaById(String id);

  /// Сохранить отметку о прохождении радиоспектакля.
  Future<Result<void>> recordDramaCompleted({
    required String dramaId,
    required int scenesFinished,
  });
}
