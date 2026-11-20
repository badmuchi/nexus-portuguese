import '../../../../core/result/result.dart';
import '../entities/progress_stats_entity.dart';

abstract class ProgressRepository {
  Future<Result<ProgressStatsEntity>> getProgressStats();
}
