import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/nature_entities.dart';
import '../../domain/repositories/nature_repository.dart';
import '../datasources/nature_seed_data.dart';

class NatureRepositoryImpl implements NatureRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  const NatureRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<NatureReserveEntity>>> getReserves({String? dialect}) async {
    try {
      var list = NatureSeedData.getReserves();

      if (dialect != null && dialect != 'all') {
        final dLower = dialect.toLowerCase();
        final isLookingForPt = dLower.contains('pt_pt') ||
            dLower.contains('pt-pt') ||
            (dLower.contains('pt') && !dLower.contains('br'));
        final isLookingForBr = dLower.contains('br');

        list = list.where((r) {
          if (isLookingForPt) return r.isPtPt;
          if (isLookingForBr) return r.isPtBr;
          return true;
        }).toList();
      }

      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения заповедников: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<NatureReserveEntity>> getReserveById(String id) async {
    try {
      final reserve = NatureSeedData.getReserves().firstWhere(
        (r) => r.id == id,
        orElse: () => throw Exception('Заповедник $id не найден'),
      );
      return Result.ok(reserve);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Заповедник не найден: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<SpeciesEntity>>> getAllSpecies({
    SpeciesCategory? category,
  }) async {
    try {
      var list = NatureSeedData.getAllSpecies();
      if (category != null) {
        list = list.where((s) => s.category == category).toList();
      }
      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения флоры и фауны: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<EcoQuizQuestion>>> getEcoQuizzes() async {
    try {
      return Result.ok(NatureSeedData.getEcoQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения эко-викторины: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> recordTrailCompleted({
    required String trailId,
    required double distanceKm,
  }) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'nature_trail_$trailId',
          wordAccuracy: (distanceKm * 10.0).clamp(50.0, 100.0),
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка сохранения прохождения трека: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addSpeciesToSrs(SpeciesEntity species) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'species_${species.id}',
        portuguese: species.commonNamePt,
        russianTranslation: species.nameRu,
        partOfSpeech: 'substantivo',
        category: 'natureza',
        dialect: species.dialect,
        examplePortuguese: '${species.commonNamePt} (${species.scientificName})',
        exampleRussian: '${species.nameRu}. ${species.curiosityRu}',
        notes: '${species.statusRu}. ${species.curiosityRu}',
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
