import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/wine_entities.dart';
import '../../domain/repositories/wine_repository.dart';
import '../datasources/wine_seed_data.dart';

class WineRepositoryImpl implements WineRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  const WineRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<WineRegionEntity>>> getWineRegions({
    WineCategory? category,
    String? dialect,
  }) async {
    try {
      var list = WineSeedData.getRegions();

      if (category != null) {
        list = list.where((r) => r.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        final dLower = dialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        list = list.where((r) {
          if (r.dialect == 'all') return true;
          if (isLookingForPt) return r.isPtPt;
          if (isLookingForBr) return r.isPtBr;
          return true;
        }).toList();
      }

      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar regiões vitivinícolas: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<WineRegionEntity>> getWineRegionById(String id) async {
    try {
      final region = WineSeedData.getRegions().firstWhere(
        (r) => r.id == id,
        orElse: () => throw Exception('Região vinícola $id não encontrada'),
      );
      return Result.ok(region);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Região vinícola não encontrada: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<TastingGuideEntity>>> getTastingGuides() async {
    try {
      return Result.ok(WineSeedData.getTastingGuides());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar guias de degustação: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<WineQuizQuestion>>> getWineQuizzes() async {
    try {
      return Result.ok(WineSeedData.getQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar questionários de enologia: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> recordRegionViewed(String regionId) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'wine-region-$regionId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao registrar visualização da região vinícola: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addWineVocabToSrs(
    WineVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'wne_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'substantivo',
        category: 'vinhos',
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
        'Erro ao adicionar termo de enologia ao SRS: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
