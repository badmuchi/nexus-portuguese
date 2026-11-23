import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/ancestral_entities.dart';
import '../../domain/repositories/ancestral_repository.dart';
import '../datasources/ancestral_seed_data.dart';

class AncestralRepositoryImpl implements AncestralRepository {
  final AppDatabase? _database;
  final SrsRepository? _srsRepository;

  AncestralRepositoryImpl({
    AppDatabase? database,
    SrsRepository? srsRepository,
  })  : _database = database,
        _srsRepository = srsRepository;

  @override
  Future<Result<List<TraditionalCommunityEntity>>> getCommunities({
    CommunityCategory? category,
    String? dialect,
  }) async {
    try {
      var list = AncestralSeedData.getCommunities();

      if (category != null) {
        list = list.where((c) => c.category == category).toList();
      }

      if (dialect != null && dialect != 'all') {
        final isPt = dialect.toLowerCase().contains('pt_pt') ||
            dialect.toLowerCase().contains('pt-pt') ||
            (dialect.toLowerCase().contains('pt') &&
                !dialect.toLowerCase().contains('br'));
        final isBr = dialect.toLowerCase().contains('br');

        list = list.where((c) {
          if (c.dialect == 'all') return true;
          if (isPt) return c.isPtPt;
          if (isBr) return c.isPtBr;
          return true;
        }).toList();
      }

      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar povos tradicionais e saberes da terra: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<TraditionalCommunityEntity>> getCommunityById(String id) async {
    try {
      final community = AncestralSeedData.getCommunities().firstWhere(
        (c) => c.id == id,
        orElse: () => throw Exception('Comunidade tradicional $id não encontrada'),
      );
      return Result.ok(community);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Comunidade tradicional não encontrada: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<HerbalRemedyEntity>>> getHerbalRemedies() async {
    try {
      return Result.ok(AncestralSeedData.getHerbalRemedies());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar receitas da medicina tradicional: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<AncestralQuizQuestion>>> getAncestralQuizzes() async {
    try {
      return Result.ok(AncestralSeedData.getQuizzes());
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao carregar questionários de saberes ancestrais: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> recordCommunityViewed(String communityId) async {
    try {
      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'ancestral-community-$communityId',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(DatabaseFailure(
        'Erro ao registrar visualização da comunidade tradicional: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> addAncestralVocabToSrs(
    AncestralVocabEntity vocab, {
    String dialect = 'all',
  }) async {
    if (_srsRepository == null) {
      return const Result.ok(null);
    }

    try {
      final card = SrsCardEntity(
        id: 'anc_vocab_${vocab.id}',
        portuguese: vocab.termPt,
        russianTranslation: vocab.translationRu,
        partOfSpeech: 'substantivo',
        category: 'ancestralidade',
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
        'Erro ao adicionar termo ancestral ao SRS: $e',
        cause: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
