import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/science_entities.dart';
import '../../domain/repositories/science_repository.dart';
import '../datasources/science_seed_data.dart';

class ScienceRepositoryImpl implements ScienceRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  const ScienceRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<ScienceTopicEntity>>> getScienceTopics({
    ScienceField? field,
    String? dialect,
  }) async {
    try {
      var list = ScienceSeedData.getTopics();

      if (field != null) {
        list = list.where((t) => t.field == field).toList();
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
        'Erro ao carregar tópicos de ciência: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<ScienceTopicEntity>> getScienceTopicById(String id) async {
    try {
      final topic = ScienceSeedData.getTopics().firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Tópico científico $id não encontrado'),
      );
      return Result.ok(topic);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Tópico científico não encontrado: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<LabExperimentEntity>>> getLabExperiments() async {
    try {
      return Result.ok(ScienceSeedData.getLabExperiments());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar experimentos laboratoriais: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<ScienceQuizQuestion>>> getScienceQuizzes() async {
    try {
      return Result.ok(ScienceSeedData.getQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar questionários científicos: $e',
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
          exerciseId: 'science-topic-$topicId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao registrar visualização de ciência: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addScienceVocabToSrs(
    ScienceVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'sci_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'substantivo',
        category: 'ciencia',
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
        'Erro ao adicionar termo científico ao SRS: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
