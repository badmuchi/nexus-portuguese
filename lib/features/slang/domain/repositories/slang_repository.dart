import '../../../../core/result/result.dart';
import '../entities/slang_entity.dart';

abstract class SlangRepository {
  Future<Result<List<SlangEntity>>> getAllSlang();
}
