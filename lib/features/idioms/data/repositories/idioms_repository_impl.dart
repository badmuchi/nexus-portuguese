import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/idiom_quiz_challenge_entity.dart';
import '../../domain/entities/portuguese_idiom_entity.dart';
import '../../domain/repositories/idioms_repository.dart';
import '../datasources/idioms_seed_data.dart';

class IdiomsRepositoryImpl implements IdiomsRepository {
  final AppDatabase _database;

  IdiomsRepositoryImpl({required AppDatabase database}) : _database = database;

  @override
  Future<Result<List<PortugueseIdiom>>> getIdioms({
    IdiomCategory? category,
    String? dialect,
  }) async {
    try {
      var pool = List<PortugueseIdiom>.from(IdiomsSeedData.idioms);

      if (category != null) {
        pool = pool.where((i) => i.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        pool = pool.where((i) => i.dialect == 'all' || i.dialect.toLowerCase() == dialect.toLowerCase()).toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить каталог идиом: $e'));
    }
  }

  @override
  Future<Result<PortugueseIdiom>> getIdiomById(String id) async {
    try {
      final item = IdiomsSeedData.idioms.firstWhere(
        (i) => i.id == id,
        orElse: () => throw Exception('Идиома $id не найдена'),
      );
      return Result.ok(item);
    } catch (e) {
      return Result.err(DatabaseFailure('Идиома не найдена: $e'));
    }
  }

  @override
  Future<Result<List<IdiomQuizChallenge>>> getQuizChallenges({int count = 5}) async {
    try {
      final all = List<PortugueseIdiom>.from(IdiomsSeedData.idioms)..shuffle();
      final selected = all.take(count).toList();

      final challenges = selected.map((target) {
        // Подбираем 3 дистрактора из других идиом
        final otherMeanings = all
            .where((i) => i.id != target.id)
            .map((i) => i.meaningRu)
            .toList()
          ..shuffle();

        final distractors = otherMeanings.take(3).toList();
        final options = [target.meaningRu, ...distractors]..shuffle();
        final correctIndex = options.indexOf(target.meaningRu);

        return IdiomQuizChallenge(
          id: 'challenge_${target.id}',
          idiom: target,
          questionRu: 'Что на самом деле означает португальское выражение «${target.expressionPt}» (${target.literalTranslationRu})?',
          optionsRu: options,
          correctIndex: correctIndex,
        );
      }).toList();

      return Result.ok(challenges);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сгенерировать квиз: $e'));
    }
  }

  @override
  Future<Result<void>> recordQuizResult({required int total, required int correct}) async {
    try {
      final accuracy = total > 0 ? (correct / total).clamp(0.0, 1.0) : 1.0;
      final isExact = correct == total;

      await _database.insertListeningAttemptLog(
        exerciseId: 'idiom_quiz_${DateTime.now().millisecondsSinceEpoch}',
        wordAccuracy: accuracy,
        isExactMatch: isExact,
        attemptedAt: DateTime.now(),
      );

      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось сохранить результат квиза: $e'));
    }
  }
}
