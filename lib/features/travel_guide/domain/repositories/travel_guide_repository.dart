import 'package:nexus_portuguese_app/core/result/result.dart';
import '../entities/geography_quiz_entity.dart';
import '../entities/lusophone_country_entity.dart';
import '../entities/travel_phrase_entity.dart';

abstract class TravelGuideRepository {
  /// Получить список всех стран лузофонии.
  Future<Result<List<LusophoneCountryEntity>>> getCountries({
    String? continent,
  });

  /// Получить детальную информацию о стране по ID.
  Future<Result<LusophoneCountryEntity>> getCountryById(String id);

  /// Получить фразы для путешественника по категориям и диалекту.
  Future<Result<List<TravelPhraseEntity>>> getTravelPhrases({
    TravelPhraseCategory? category,
    String? dialect,
  });

  /// Получить вопросы квиза «Passaporte Lusófono».
  Future<Result<List<GeographyQuizQuestion>>> getQuizQuestions();

  /// Записать результат викторины в базу данных.
  Future<Result<void>> recordQuizCompleted({
    required int score,
    required int totalQuestions,
    required List<String> earnedCountryIds,
  });
}
