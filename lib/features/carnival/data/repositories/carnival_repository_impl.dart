import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/carnival_entities.dart';
import '../../domain/repositories/carnival_repository.dart';
import '../datasources/carnival_seed_data.dart';

class CarnivalRepositoryImpl implements CarnivalRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  CarnivalRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<CarnivalTraditionEntity>>> getTraditions({
    CarnivalTraditionCategory? category,
    String? dialect,
  }) async {
    try {
      var list = CarnivalSeedData.getTraditions();

      if (category != null) {
        list = list.where((t) => t.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        final isPt = dialect.toLowerCase().contains('pt_pt') ||
            dialect.toLowerCase().contains('pt-pt') ||
            (dialect.toLowerCase().contains('pt') &&
                !dialect.toLowerCase().contains('br'));
        final isBr = dialect.toLowerCase().contains('br');

        list = list.where((t) {
          if (t.dialect == 'all') return true;
          if (isPt) return t.isPtPt;
          if (isBr) return t.isPtBr;
          return true;
        }).toList();
      }

      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar tradições e ritmos carnavalescos: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<CarnivalTraditionEntity>> getTraditionById(String id) async {
    try {
      final tradition = CarnivalSeedData.getTraditions().firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Tradição carnavalesca $id não encontrada'),
      );
      return Result.ok(tradition);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Tradição carnavalesca não encontrada: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<RhythmWorkshopEntity>>> getRhythmWorkshops() async {
    try {
      return Result.ok(CarnivalSeedData.getRhythmWorkshops());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar oficinas de ritmo e letra: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<CarnivalQuizQuestion>>> getCarnivalQuizzes() async {
    try {
      return Result.ok(CarnivalSeedData.getQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar questionários de carnaval: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> recordTraditionViewed(String traditionId) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'carnival-tradition-$traditionId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao registrar visualização da tradição carnavalesca: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addCarnivalVocabToSrs(
    CarnivalVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'crn_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'substantivo',
        category: 'carnaval',
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
        'Erro ao adicionar termo carnavalesco ao SRS: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
