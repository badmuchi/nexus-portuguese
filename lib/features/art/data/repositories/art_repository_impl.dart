import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/art_entities.dart';
import '../../domain/repositories/art_repository.dart';
import '../datasources/art_seed_data.dart';

class ArtRepositoryImpl implements ArtRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  const ArtRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<ArtworkEntity>>> getArtworks({
    ArtPeriod? period,
    String? dialect,
  }) async {
    try {
      var list = ArtSeedData.getArtworks();

      if (period != null) {
        list = list.where((a) => a.period == period).toList();
      }

      if (dialect != null && dialect != 'all') {
        final dLower = dialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        list = list.where((a) {
          if (a.dialect == 'all') return true;
          if (isLookingForPt) return a.isPtPt;
          if (isLookingForBr) return a.isPtBr;
          return true;
        }).toList();
      }

      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения произведений искусства: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<ArtworkEntity>> getArtworkById(String id) async {
    try {
      final artwork = ArtSeedData.getArtworks().firstWhere(
        (a) => a.id == id,
        orElse: () => throw Exception('Произведение искусства $id не найдено'),
      );
      return Result.ok(artwork);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Произведение не найдено: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<ArtStyleEntity>>> getArtStyles() async {
    try {
      return Result.ok(ArtSeedData.getArtStyles());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения каталога стилей: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<ArtQuizQuestion>>> getArtQuizzes() async {
    try {
      return Result.ok(ArtSeedData.getArtQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения арт-викторины: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> recordArtworkViewed(String artworkId) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'art_view_$artworkId',
          wordAccuracy: 100.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка записи просмотра произведения: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addArtVocabToSrs(
    ArtVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'art_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'substantivo',
        category: 'arte',
        dialect: dialect,
        examplePortuguese: vocab.termPt,
        exampleRussian: vocab.contextRu,
        notes: vocab.contextRu,
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
        'Ошибка добавления термина в FSRS: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
