import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/architecture_entities.dart';
import '../../domain/repositories/architecture_repository.dart';
import '../datasources/architecture_seed_data.dart';

class ArchitectureRepositoryImpl implements ArchitectureRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  const ArchitectureRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<ArchitecturalMonumentEntity>>> getMonuments({
    ArchitectureCategory? category,
    String? dialect,
  }) async {
    try {
      var list = ArchitectureSeedData.getMonuments();

      if (category != null) {
        list = list.where((m) => m.category == category).toList();
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
        'Ошибка получения памятников архитектуры: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<ArchitecturalMonumentEntity>> getMonumentById(String id) async {
    try {
      final monument = ArchitectureSeedData.getMonuments().firstWhere(
        (m) => m.id == id,
        orElse: () => throw Exception('Памятник архитектуры $id не найден'),
      );
      return Result.ok(monument);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Памятник архитектуры не найден: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<ArchitecturalStyleEntity>>> getArchitecturalStyles() async {
    try {
      return Result.ok(ArchitectureSeedData.getStyles());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения каталога стилей архитектуры: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<ArchitectureQuizQuestion>>> getArchitectureQuizzes() async {
    try {
      return Result.ok(ArchitectureSeedData.getQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения архитектурной викторины: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> recordMonumentViewed(String monumentId) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'arch-monument-$monumentId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка сохранения изучения архитектурного памятника: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addArchitectureVocabToSrs(
    ArchitectVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'arch_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'substantivo',
        category: 'arquitetura',
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
        'Ошибка добавления архитектурного термина в интервальное повторение: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
