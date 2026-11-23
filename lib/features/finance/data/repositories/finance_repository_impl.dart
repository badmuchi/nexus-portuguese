import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/finance_entities.dart';
import '../../domain/repositories/finance_repository.dart';
import '../datasources/finance_seed_data.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  const FinanceRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<FinanceTopicEntity>>> getFinanceTopics({
    FinanceCategory? category,
    String? dialect,
  }) async {
    try {
      var list = FinanceSeedData.getTopics();

      if (category != null) {
        list = list.where((t) => t.category == category).toList();
      }

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
        'Ошибка получения финансовых тем: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<FinanceTopicEntity>> getTopicById(String id) async {
    try {
      final topic = FinanceSeedData.getTopics().firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Финансовая тема $id не найдена'),
      );
      return Result.ok(topic);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Тема не найдена: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<FintechSimulatorEntity>>> getFintechSimulators() async {
    try {
      return Result.ok(FinanceSeedData.getSimulators());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения финтех-симуляторов: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<FinanceQuizQuestion>>> getFinanceQuizzes() async {
    try {
      return Result.ok(FinanceSeedData.getQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка получения финансовой викторины: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> recordTopicViewed(String topicId) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'finance-topic-$topicId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Ошибка сохранения изучения финансовой темы: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addFinanceVocabToSrs(
    FinanceVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'fin_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'substantivo',
        category: 'financas',
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
        'Ошибка добавления финансового термина в интервальное повторение: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
