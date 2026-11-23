import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/features/nature/data/datasources/nature_seed_data.dart';
import 'package:nexus_portuguese_app/features/nature/data/repositories/nature_repository_impl.dart';
import 'package:nexus_portuguese_app/features/nature/domain/entities/nature_entities.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback',
        portuguese: 'teste',
        russianTranslation: 'тест',
        partOfSpeech: 'substantivo',
        category: 'natureza',
        dialect: 'pt_BR',
        examplePortuguese: 'exemplo',
        exampleRussian: 'пример',
        notes: 'nota',
        fsrsState: 'newCard',
        stability: 0,
        difficulty: 0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      ),
    );
  });

  group('Nature Entities Tests', () {
    test('NatureReserveEntity dialect helpers work correctly for PT-BR and PT-PT', () {
      const brReserve = NatureReserveEntity(
        id: 'chapada',
        namePt: 'Chapada Diamantina',
        nameRu: 'Шапада Диамантина',
        region: 'Bahia',
        country: 'Brasil',
        dialect: 'pt_BR',
        coverEmoji: '🏜️',
        biomeRu: 'Каньоны',
        descriptionRu: 'Описание',
        highlightsRu: ['Водопад'],
        trails: [],
        faunaFlora: [],
      );

      expect(brReserve.isPtBr, isTrue);
      expect(brReserve.isPtPt, isFalse);
      expect(brReserve.dialectFlag, '🇧🇷');
      expect(brReserve.dialectLabel, 'Brasil');

      const ptReserve = NatureReserveEntity(
        id: 'geres',
        namePt: 'Peneda-Gerês',
        nameRu: 'Пенеда-Жереш',
        region: 'Norte',
        country: 'Portugal',
        dialect: 'pt_PT',
        coverEmoji: '⛰️',
        biomeRu: 'Горы',
        descriptionRu: 'Описание',
        highlightsRu: ['Лагуны'],
        trails: [],
        faunaFlora: [],
      );

      expect(ptReserve.isPtPt, isTrue);
      expect(ptReserve.isPtBr, isFalse);
      expect(ptReserve.dialectFlag, '🇵🇹');
      expect(ptReserve.dialectLabel, 'Portugal');
    });

    test('SpeciesEntity properties and dialect check', () {
      const species = SpeciesEntity(
        id: 'sp_test',
        commonNamePt: 'Lobo-Ibérico',
        scientificName: 'Canis lupus signatus',
        nameRu: 'Иберийский волк',
        emoji: '🐺',
        category: SpeciesCategory.fauna,
        statusRu: 'Охраняемый',
        curiosityRu: 'Факты',
        dialect: 'pt_PT',
      );

      expect(species.isPtPt, isTrue);
      expect(species.isPtBr, isFalse);
      expect(species.dialectFlag, '🇵🇹');
      expect(species.category, SpeciesCategory.fauna);
    });

    test('EcoQuizQuestion correctOptionText returns correct string', () {
      const question = EcoQuizQuestion(
        id: 'q1',
        questionPt: 'Pergunta?',
        questionRu: 'Вопрос?',
        optionsPt: ['Opção A', 'Opção B'],
        correctOptionIndex: 0,
        explanationRu: 'Объяснение',
      );

      expect(question.correctOptionText, 'Opção A');
      expect(question.optionsPt.length, 2);
    });
  });

  group('Nature Seed Data Integrity', () {
    test('contains 6 iconic nature reserves with trails', () {
      final reserves = NatureSeedData.getReserves();
      expect(reserves.length, 6);

      for (final r in reserves) {
        expect(r.id, isNotEmpty);
        expect(r.namePt, isNotEmpty);
        expect(r.nameRu, isNotEmpty);
        expect(r.region, isNotEmpty);
        expect(r.country, isIn(['Brasil', 'Portugal']));
        expect(r.trails, isNotEmpty);

        for (final t in r.trails) {
          expect(t.distanceKm, greaterThan(0));
          expect(t.durationHours, greaterThan(0));
          expect(t.namePt, isNotEmpty);
        }
      }
    });

    test('contains rich biodiversity species for fauna and flora', () {
      final species = NatureSeedData.getAllSpecies();
      expect(species.length, greaterThanOrEqualTo(12));

      final hasFauna = species.any((s) => s.category == SpeciesCategory.fauna);
      final hasFlora = species.any((s) => s.category == SpeciesCategory.flora);
      expect(hasFauna, isTrue);
      expect(hasFlora, isTrue);
    });

    test('contains eco quizzes with valid indices', () {
      final quizzes = NatureSeedData.getEcoQuizzes();
      expect(quizzes.length, greaterThanOrEqualTo(6));

      for (final q in quizzes) {
        expect(q.correctOptionIndex, inInclusiveRange(0, q.optionsPt.length - 1));
        expect(q.correctOptionText, isNotEmpty);
      }
    });
  });

  group('NatureRepositoryImpl Tests', () {
    late NatureRepositoryImpl repository;
    late MockSrsRepository mockSrs;

    setUp(() {
      mockSrs = MockSrsRepository();
      repository = NatureRepositoryImpl(srsRepository: mockSrs);
    });

    test('getReserves returns all and filters by dialect', () async {
      final allRes = await repository.getReserves();
      expect(allRes.isOk, isTrue);
      expect(allRes.value.length, 6);

      final brRes = await repository.getReserves(dialect: 'pt_BR');
      expect(brRes.isOk, isTrue);
      expect(brRes.value.every((r) => r.isPtBr), isTrue);

      final ptRes = await repository.getReserves(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      expect(ptRes.value.every((r) => r.isPtPt), isTrue);
    });

    test('getReserveById finds reserve and fails for invalid id', () async {
      final res = await repository.getReserveById('chapada_diamantina');
      expect(res.isOk, isTrue);
      expect(res.value.namePt, contains('Chapada Diamantina'));

      final failRes = await repository.getReserveById('unknown_reserve');
      expect(failRes.isOk, isFalse);
    });

    test('getAllSpecies filters by category', () async {
      final allSp = await repository.getAllSpecies();
      expect(allSp.isOk, isTrue);
      expect(allSp.value.length, greaterThanOrEqualTo(12));

      final faunaOnly = await repository.getAllSpecies(category: SpeciesCategory.fauna);
      expect(faunaOnly.isOk, isTrue);
      expect(faunaOnly.value.every((s) => s.category == SpeciesCategory.fauna), isTrue);
    });

    test('getEcoQuizzes returns quiz list', () async {
      final quizzes = await repository.getEcoQuizzes();
      expect(quizzes.isOk, isTrue);
      expect(quizzes.value.length, greaterThanOrEqualTo(6));
    });

    test('recordTrailCompleted succeeds without database', () async {
      final res = await repository.recordTrailCompleted(trailId: 'tr_fumaca', distanceKm: 12.0);
      expect(res.isOk, isTrue);
    });

    test('addSpeciesToSrs delegates to SrsRepository', () async {
      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});

      final species = NatureSeedData.getAllSpecies().first;
      final res = await repository.addSpeciesToSrs(species);

      expect(res.isOk, isTrue);
      verify(() => mockSrs.addCard(any())).called(1);
    });
  });
}
