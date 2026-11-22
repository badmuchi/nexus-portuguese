import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/travel_guide/data/datasources/travel_guide_seed_data.dart';
import 'package:nexus_portuguese_app/features/travel_guide/data/repositories/travel_guide_repository_impl.dart';
import 'package:nexus_portuguese_app/features/travel_guide/domain/entities/geography_quiz_entity.dart';
import 'package:nexus_portuguese_app/features/travel_guide/domain/entities/lusophone_country_entity.dart';
import 'package:nexus_portuguese_app/features/travel_guide/domain/entities/travel_phrase_entity.dart';

void main() {
  group('Travel Guide Entities Tests', () {
    test('LusophoneCountryEntity properties and Equatable', () {
      const country = LusophoneCountryEntity(
        id: 'portugal',
        namePt: 'Portugal',
        nameRu: 'Португалия',
        flagEmoji: '🇵🇹',
        capitalPt: 'Lisboa',
        capitalRu: 'Лиссабон',
        continentRu: 'Европа',
        currency: 'Euro (€)',
        population: '10.3 млн',
        dialectOverviewRu: 'Европейский португальский (pt-PT).',
        culturalOverviewRu: 'Родина фаду и великих мореплавателей.',
        topAttractionsRu: ['Торри-ди-Белен', 'Синтра'],
        nationalDishRu: 'Bacalhau à Brás',
        localExpressions: [
          CountryLinguisticFeature(
            termPt: 'Fixe',
            translationRu: 'Круто / здорово',
            explanationRu: 'Популярнейший сленг в Португалии.',
            examplePt: 'Este lugar é mesmo fixe!',
          ),
        ],
      );

      expect(country.id, 'portugal');
      expect(country.namePt, 'Portugal');
      expect(country.capitalRu, 'Лиссабон');
      expect(country.continentRu, 'Европа');
      expect(country.flagEmoji, '🇵🇹');
      expect(country.nationalDishRu, 'Bacalhau à Brás');
      expect(country.localExpressions.first.termPt, 'Fixe');
    });

    test('CountryLinguisticFeature properties and Equatable', () {
      const feature = CountryLinguisticFeature(
        termPt: 'Mano',
        translationRu: 'Брат, чувак',
        explanationRu: 'Типично для Сан-Паулу и фавел.',
        examplePt: 'E aí, mano, tudo bem?',
      );

      expect(feature.termPt, 'Mano');
      expect(feature.translationRu, 'Брат, чувак');
      expect(feature.examplePt, 'E aí, mano, tudo bem?');
    });

    test('TravelPhraseEntity properties and dialect helpers', () {
      const ptPhrase = TravelPhraseEntity(
        id: 'tp1',
        phrasePt: 'Onde fica a paragem de autocarro?',
        translationRu: 'Где находится автобусная остановка?',
        category: TravelPhraseCategory.transport,
        dialect: 'pt_PT',
        contextTipRu: 'В Португалии autocarro, в Бразилии ônibus.',
      );

      expect(ptPhrase.isPtPt, isTrue);
      expect(ptPhrase.isPtBr, isFalse);
      expect(ptPhrase.dialectFlag, '🇵🇹');
      expect(ptPhrase.category, TravelPhraseCategory.transport);

      const brPhrase = TravelPhraseEntity(
        id: 'tp2',
        phrasePt: 'Onde fica o ponto de ônibus?',
        translationRu: 'Где автобусная остановка?',
        category: TravelPhraseCategory.transport,
        dialect: 'pt_BR',
        contextTipRu: 'В Бразилии ponto de ônibus.',
      );

      expect(brPhrase.isPtBr, isTrue);
      expect(brPhrase.isPtPt, isFalse);
      expect(brPhrase.dialectFlag, '🇧🇷');

      const neutralPhrase = TravelPhraseEntity(
        id: 'tp3',
        phrasePt: 'Muito obrigado!',
        translationRu: 'Большое спасибо!',
        category: TravelPhraseCategory.localCourtesies,
        dialect: 'all',
        contextTipRu: 'Универсально во всех странах CPLP.',
      );

      expect(neutralPhrase.isPtPt, isFalse);
      expect(neutralPhrase.isPtBr, isFalse);
      expect(neutralPhrase.dialectFlag, '🌐');
    });

    test('GeographyQuizQuestion properties and Equatable', () {
      const q = GeographyQuizQuestion(
        id: 'q1',
        questionPt: 'Qual é a capital de Angola?',
        questionRu: 'Какая столица Анголы?',
        optionsPt: ['Luanda', 'Maputo', 'Praia', 'Díli'],
        optionsRu: ['Луанда', 'Мапуту', 'Прая', 'Дили'],
        correctOptionIndex: 0,
        explanationRu: 'Луанда — столица Анголы.',
        countryId: 'angola',
        flagEmoji: '🇦🇴',
      );

      expect(q.id, 'q1');
      expect(q.countryId, 'angola');
      expect(q.correctOptionIndex, 0);
      expect(q.optionsPt[0], 'Luanda');
      expect(q.flagEmoji, '🇦🇴');
    });
  });

  group('TravelGuideSeedData Verification Tests', () {
    test('countries contains all 9 Lusophone nations/territories', () {
      expect(TravelGuideSeedData.countries.length, 9);

      final countryIds = TravelGuideSeedData.countries.map((c) => c.id).toSet();
      expect(countryIds.contains('portugal'), isTrue);
      expect(countryIds.contains('brasil'), isTrue);
      expect(countryIds.contains('angola'), isTrue);
      expect(countryIds.contains('mocambique'), isTrue);
      expect(countryIds.contains('cabo_verde'), isTrue);
      expect(countryIds.contains('sao_tome_e_principe'), isTrue);
      expect(countryIds.contains('guine_bissau'), isTrue);
      expect(countryIds.contains('timor_leste'), isTrue);
      expect(countryIds.contains('macau'), isTrue);

      for (final c in TravelGuideSeedData.countries) {
        expect(c.namePt, isNotEmpty);
        expect(c.nameRu, isNotEmpty);
        expect(c.flagEmoji, isNotEmpty);
        expect(c.capitalPt, isNotEmpty);
        expect(c.capitalRu, isNotEmpty);
        expect(c.population, isNotEmpty);
        expect(c.continentRu, isNotEmpty);
        expect(c.currency, isNotEmpty);
        expect(c.culturalOverviewRu, isNotEmpty);
        expect(c.nationalDishRu, isNotEmpty);
        expect(c.localExpressions, isNotEmpty);
      }
    });

    test('travelPhrases covers multiple essential categories', () {
      expect(TravelGuideSeedData.travelPhrases.length, greaterThanOrEqualTo(15));

      final categories = TravelGuideSeedData.travelPhrases.map((p) => p.category).toSet();
      expect(categories.contains(TravelPhraseCategory.airportCustoms), isTrue);
      expect(categories.contains(TravelPhraseCategory.transport), isTrue);
      expect(categories.contains(TravelPhraseCategory.hotelLodging), isTrue);
      expect(categories.contains(TravelPhraseCategory.restaurantDining), isTrue);
      expect(categories.contains(TravelPhraseCategory.emergencies), isTrue);
      expect(categories.contains(TravelPhraseCategory.localCourtesies), isTrue);

      for (final phrase in TravelGuideSeedData.travelPhrases) {
        expect(phrase.id, isNotEmpty);
        expect(phrase.phrasePt, isNotEmpty);
        expect(phrase.translationRu, isNotEmpty);
        expect(phrase.contextTipRu, isNotEmpty);
      }
    });

    test('quizQuestions contains valid options and indexes', () {
      expect(TravelGuideSeedData.quizQuestions.length, greaterThanOrEqualTo(8));

      for (final q in TravelGuideSeedData.quizQuestions) {
        expect(q.id, isNotEmpty);
        expect(q.questionPt, isNotEmpty);
        expect(q.questionRu, isNotEmpty);
        expect(q.optionsPt.length, 4);
        expect(q.optionsRu.length, 4);
        expect(q.correctOptionIndex, inInclusiveRange(0, 3));
        expect(q.explanationRu, isNotEmpty);
        expect(q.countryId, isNotEmpty);
        expect(q.flagEmoji, isNotEmpty);
      }
    });
  });

  group('TravelGuideRepositoryImpl Tests', () {
    final repo = TravelGuideRepositoryImpl();

    test('getCountries returns all countries or filters by continent', () async {
      final allRes = await repo.getCountries();
      expect(allRes.isOk, isTrue);
      expect(allRes.value.length, 9);

      final europeRes = await repo.getCountries(continent: 'Европа');
      expect(europeRes.isOk, isTrue);
      expect(europeRes.value.every((c) => c.continentRu == 'Европа'), isTrue);

      final africaRes = await repo.getCountries(continent: 'Африка');
      expect(africaRes.isOk, isTrue);
      expect(africaRes.value.length, 5); // Angola, Moçambique, Cabo Verde, São Tomé, Guiné-Bissau
    });

    test('getCountryById returns requested country or fails for unknown id', () async {
      final res = await repo.getCountryById('brasil');
      expect(res.isOk, isTrue);
      expect(res.value.capitalPt, 'Brasília');

      final failRes = await repo.getCountryById('mars');
      expect(failRes.isFailure, isTrue);
    });

    test('getTravelPhrases returns phrases and filters by category and dialect', () async {
      final allPhrases = await repo.getTravelPhrases();
      expect(allPhrases.isOk, isTrue);
      expect(allPhrases.value.length, TravelGuideSeedData.travelPhrases.length);

      final airportPhrases = await repo.getTravelPhrases(category: TravelPhraseCategory.airportCustoms);
      expect(airportPhrases.isOk, isTrue);
      for (final p in airportPhrases.value) {
        expect(p.category, TravelPhraseCategory.airportCustoms);
      }

      final brPhrases = await repo.getTravelPhrases(dialect: 'pt_BR');
      expect(brPhrases.isOk, isTrue);
      for (final p in brPhrases.value) {
        expect(p.isPtBr || (!p.isPtPt && !p.isPtBr), isTrue);
      }
    });

    test('getQuizQuestions returns seed questions', () async {
      final quizRes = await repo.getQuizQuestions();
      expect(quizRes.isOk, isTrue);
      expect(quizRes.value.length, TravelGuideSeedData.quizQuestions.length);
    });

    test('recordQuizCompleted runs gracefully with null database', () async {
      final res = await repo.recordQuizCompleted(
        score: 7,
        totalQuestions: 8,
        earnedCountryIds: ['angola', 'brasil'],
      );
      expect(res.isOk, isTrue);
    });
  });
}
