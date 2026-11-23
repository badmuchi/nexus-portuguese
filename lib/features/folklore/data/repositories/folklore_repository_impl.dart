import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/folklore_entities.dart';
import '../../domain/repositories/folklore_repository.dart';
import '../datasources/folklore_seed_data.dart';

class FolkloreRepositoryImpl implements FolkloreRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  const FolkloreRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<MythicalEntity>>> getMyths({
    FolkloreOrigin? origin,
    String? dialect,
  }) async {
    try {
      var list = FolkloreSeedData.getMyths();

      if (origin != null) {
        list = list.where((m) => m.origin == origin).toList();
      }

      if (dialect != null && dialect != 'all') {
        final dLower = dialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        list = list.where((m) {
          if (m.dialect == 'all') return true;
          if (isLookingForPt) return m.isPtPt;
          if (isLookingForBr) return m.isPtBr;
          return true;
        }).toList();
      }

      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения мифов и легенд: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<MythicalEntity>> getMythById(String id) async {
    try {
      final myth = FolkloreSeedData.getMyths().firstWhere(
        (m) => m.id == id,
        orElse: () => throw Exception('Легенда $id не найдена'),
      );
      return Result.ok(myth);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Легенда не найдена: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<FolkloreTaleSnippet>>> getTaleSnippets() async {
    try {
      return Result.ok(FolkloreSeedData.getTaleSnippets());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения сказок: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<FolkloreQuizQuestion>>> getFolkloreQuizzes() async {
    try {
      return Result.ok(FolkloreSeedData.getQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения викторины по фольклору: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> recordMythViewed(String mythId) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'folklore-myth-$mythId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка сохранения изучения фольклорной темы: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addFolkloreVocabToSrs(
    FolkloreVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'folk_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'substantivo',
        category: 'folclore',
        dialect: vocab.dialect == 'all' ? dialect : vocab.dialect,
        examplePortuguese: vocab.exampleSentence,
        exampleRussian: vocab.definition,
        notes: vocab.dialectNote != null
            ? '💡 ${vocab.dialectNote}\n${vocab.definition}'
            : vocab.definition,
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
        'Ошибка добавления фольклорного термина в интервальное повторение: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
