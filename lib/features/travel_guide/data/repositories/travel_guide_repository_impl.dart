import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import '../../domain/entities/geography_quiz_entity.dart';
import '../../domain/entities/lusophone_country_entity.dart';
import '../../domain/entities/travel_phrase_entity.dart';
import '../../domain/repositories/travel_guide_repository.dart';
import '../datasources/travel_guide_seed_data.dart';

class TravelGuideRepositoryImpl implements TravelGuideRepository {
  final AppDatabase? _database;

  TravelGuideRepositoryImpl({AppDatabase? database}) : _database = database;

  @override
  Future<Result<List<LusophoneCountryEntity>>> getCountries({
    String? continent,
  }) async {
    try {
      var pool = List<LusophoneCountryEntity>.from(TravelGuideSeedData.countries);

      if (continent != null && continent.toLowerCase() != 'all') {
        pool = pool
            .where((c) => c.continentRu.toLowerCase().contains(continent.toLowerCase()))
            .toList();
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить страны лузофонии: $e'));
    }
  }

  @override
  Future<Result<LusophoneCountryEntity>> getCountryById(String id) async {
    try {
      final country = TravelGuideSeedData.countries.firstWhere(
        (c) => c.id == id,
        orElse: () => throw Exception('Страна $id не найдена'),
      );
      return Result.ok(country);
    } catch (e) {
      return Result.err(DatabaseFailure('Страна не найдена: $e'));
    }
  }

  @override
  Future<Result<List<TravelPhraseEntity>>> getTravelPhrases({
    TravelPhraseCategory? category,
    String? dialect,
  }) async {
    try {
      var pool = List<TravelPhraseEntity>.from(TravelGuideSeedData.travelPhrases);

      if (category != null) {
        pool = pool.where((p) => p.category == category).toList();
      }

      if (dialect != null && dialect.toLowerCase() != 'all') {
        final d = dialect.toLowerCase();
        final isPt = d.contains('pt') && !d.contains('br');
        final isBr = d.contains('br');

        if (isPt) {
          pool = pool.where((p) => p.isPtPt || (!p.isPtPt && !p.isPtBr)).toList();
        } else if (isBr) {
          pool = pool.where((p) => p.isPtBr || (!p.isPtPt && !p.isPtBr)).toList();
        }
      }

      return Result.ok(pool);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить фразы для путешествий: $e'));
    }
  }

  @override
  Future<Result<List<GeographyQuizQuestion>>> getQuizQuestions() async {
    try {
      return const Result.ok(TravelGuideSeedData.quizQuestions);
    } catch (e) {
      return Result.err(DatabaseFailure('Не удалось загрузить вопросы викторины: $e'));
    }
  }

  @override
  Future<Result<void>> recordQuizCompleted({
    required int score,
    required int totalQuestions,
    required List<String> earnedCountryIds,
  }) async {
    try {
      final accuracy = totalQuestions > 0 ? (score / totalQuestions).clamp(0.0, 1.0) : 1.0;
      final isExact = accuracy >= 1.0;

      if (_database != null) {
        await _database.insertListeningAttemptLog(
          exerciseId: 'travel_quiz_lusofonia',
          wordAccuracy: accuracy,
          isExactMatch: isExact,
          attemptedAt: DateTime.now(),
        );
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.err(DatabaseFailure('Ошибка сохранения результатов квиза: $e'));
    }
  }
}
