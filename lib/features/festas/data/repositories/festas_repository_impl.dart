import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/festas_entities.dart';
import '../../domain/repositories/festas_repository.dart';
import '../datasources/festas_seed_data.dart';

class FestasRepositoryImpl implements FestasRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  const FestasRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<FestaEntity>>> getFestas({
    FestaCategory? category,
    String? dialect,
  }) async {
    try {
      var list = FestasSeedData.getFestas();

      if (category != null) {
        list = list.where((f) => f.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        final dLower = dialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        list = list.where((f) {
          if (f.dialect == 'all') return true;
          if (isLookingForPt) return f.isPtPt;
          if (isLookingForBr) return f.isPtBr;
          return true;
        }).toList();
      }

      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения каталога праздников: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<FestaEntity>> getFestaById(String id) async {
    try {
      final festa = FestasSeedData.getFestas().firstWhere(
        (f) => f.id == id,
        orElse: () => throw Exception('Праздник $id не найден'),
      );
      return Result.ok(festa);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Праздник не найден: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<FestaTraditionEntity>>> getFestaTraditions() async {
    try {
      return Result.ok(FestasSeedData.getTraditions());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения каталога традиций: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<FestaQuizQuestion>>> getFestaQuizzes() async {
    try {
      return Result.ok(FestasSeedData.getQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения викторины по праздникам: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> recordFestaViewed(String festaId) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'festa-$festaId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка сохранения изучения праздника: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addFestaVocabToSrs(
    FestaVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'festa_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'substantivo',
        category: 'festas',
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
        'Ошибка добавления праздничного термина в интервальное повторение: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
