import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/humor_entities.dart';
import '../../domain/repositories/humor_repository.dart';
import '../datasources/humor_seed_data.dart';

class HumorRepositoryImpl implements HumorRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  const HumorRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<JokeEntity>>> getJokes({
    JokeCategory? category,
    String? dialect,
  }) async {
    try {
      var list = HumorSeedData.getJokes();

      if (category != null) {
        list = list.where((j) => j.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        final dLower = dialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        list = list.where((j) {
          if (j.dialect == 'all') return true;
          if (isLookingForPt) return j.isPtPt;
          if (isLookingForBr) return j.isPtBr;
          return true;
        }).toList();
      }

      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения анекдотов: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<JokeEntity>> getJokeById(String id) async {
    try {
      final joke = HumorSeedData.getJokes().firstWhere(
        (j) => j.id == id,
        orElse: () => throw Exception('Шутка с id $id не найдена'),
      );
      return Result.ok(joke);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Шутка не найдена: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<TrocadilhoEntity>>> getTrocadilhos({String? dialect}) async {
    try {
      var list = HumorSeedData.getTrocadilhos();

      if (dialect != null && dialect != 'all') {
        final dLower = dialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        list = list.where((t) {
          if (t.dialect == 'all') return true;
          if (isLookingForPt) return t.isPtPt;
          if (isLookingForBr) return t.isPtBr;
          return true;
        }).toList();
      }

      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения каламбуров: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<HumorQuizEntity>>> getHumorQuizzes() async {
    try {
      return Result.ok(HumorSeedData.getHumorQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения викторины юмора: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> recordJokeReaction({
    required String jokeId,
    required bool liked,
  }) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'humor_$jokeId',
          wordAccuracy: liked ? 100.0 : 50.0,
          isExactMatch: liked,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка сохранения реакции: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addWordToSrs(
    JokeVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'humor_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'expressão',
        category: 'humor',
        dialect: dialect,
        examplePortuguese: vocab.termPt,
        exampleRussian: vocab.explanationRu,
        notes: vocab.explanationRu,
        fsrsState: 'newCard',
        stability: 0.0,
        difficulty: 0.0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      );

      await _srsRepository.addCard(card);
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка добавления карточки FSRS: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
