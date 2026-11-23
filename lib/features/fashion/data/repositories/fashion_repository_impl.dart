import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/fashion_entities.dart';
import '../../domain/repositories/fashion_repository.dart';
import '../datasources/fashion_seed_data.dart';

class FashionRepositoryImpl implements FashionRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  const FashionRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<FashionTopicEntity>>> getFashionTopics({
    FashionCategory? category,
    String? dialect,
  }) async {
    try {
      var list = FashionSeedData.getTopics();

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
        'Erro ao carregar tópicos de moda e design: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<FashionTopicEntity>> getFashionTopicById(String id) async {
    try {
      final topic = FashionSeedData.getTopics().firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Tópico de moda $id não encontrado'),
      );
      return Result.ok(topic);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Tópico de moda não encontrado: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<TextileCraftEntity>>> getTextileCrafts() async {
    try {
      return Result.ok(FashionSeedData.getTextileCrafts());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar artesanatos têxteis: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<FashionQuizQuestion>>> getFashionQuizzes() async {
    try {
      return Result.ok(FashionSeedData.getQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar questionários de moda: $e',
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
          exerciseId: 'fashion-topic-$topicId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao registrar visualização de tópico de moda: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addFashionVocabToSrs(
    FashionVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'fsh_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'substantivo',
        category: 'moda',
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
        'Erro ao adicionar termo de moda ao SRS: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
