import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/festas/data/datasources/festas_seed_data.dart';
import 'package:nexus_portuguese_app/features/festas/data/repositories/festas_repository_impl.dart';
import 'package:nexus_portuguese_app/features/festas/domain/entities/festas_entities.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback_festa',
        portuguese: 'carnaval',
        russianTranslation: 'карнавал',
        partOfSpeech: 'substantivo',
        category: 'festas',
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

  group('Festas Entities Tests', () {
    test('FestaEntity dialect helpers work correctly for PT-BR and PT-PT', () {
      const brFesta = FestaEntity(
        id: 'f_br',
        title: 'Carnaval do Rio',
        region: 'Rio de Janeiro',
        country: 'Brasil',
        dialect: 'pt_BR',
        seasonDate: 'Fevereiro',
        category: FestaCategory.carnaval,
        shortDescription: 'Desc curta',
        fullDescription: 'Desc longa',
        ritualsAndTraditions: ['Desfile'],
        foodsAndDrinks: ['Feijoada'],
        vocabulary: [],
        audioSnippet: 'Audio',
      );

      expect(brFesta.isPtBr, isTrue);
      expect(brFesta.isPtPt, isFalse);

      const ptFesta = FestaEntity(
        id: 'f_pt',
        title: 'São João no Porto',
        region: 'Porto',
        country: 'Portugal',
        dialect: 'pt_PT',
        seasonDate: '23 de Junho',
        category: FestaCategory.santosPopulares,
        shortDescription: 'Desc curta',
        fullDescription: 'Desc longa',
        ritualsAndTraditions: ['Martelinhos'],
        foodsAndDrinks: ['Sardinhas'],
        vocabulary: [],
        audioSnippet: 'Audio',
      );

      expect(ptFesta.isPtPt, isTrue);
      expect(ptFesta.isPtBr, isFalse);
    });

    test('FestaVocabEntity dialect helpers and equality', () {
      const vocab1 = FestaVocabEntity(
        id: 'v1',
        termPt: 'Manjerico',
        translationRu: 'Манжерику',
        definition: 'Planta aromática',
        exampleSentence: 'Vaso de manjerico',
        dialect: 'pt_PT',
      );

      const vocab2 = FestaVocabEntity(
        id: 'v1',
        termPt: 'Manjerico',
        translationRu: 'Манжерику',
        definition: 'Planta aromática',
        exampleSentence: 'Vaso de manjerico',
        dialect: 'pt_PT',
      );

      expect(vocab1, equals(vocab2));
      expect(vocab1.isPtPt, isTrue);
      expect(vocab1.isPtBr, isFalse);
    });

    test('FestaTraditionEntity and FestaQuizQuestion properties', () {
      const tradition = FestaTraditionEntity(
        id: 't1',
        title: 'Manjerico',
        festaName: 'Santo António',
        region: 'Lisboa',
        description: 'Dar manjerico',
        instructions: ['Comprar vaso', 'Escrever quadra'],
        curiousFact: 'Não cheirar com nariz',
        icon: '🪴',
      );

      expect(tradition.instructions.length, 2);
      expect(tradition.curiousFact, isNotEmpty);

      const quiz = FestaQuizQuestion(
        id: 'q1',
        question: 'O que se atira no São João?',
        options: ['Martelinhos', 'Flores'],
        correctIndex: 0,
        explanation: 'Martelinhos de plástico',
        dialect: 'pt_PT',
      );

      expect(quiz.correctIndex, 0);
      expect(quiz.options[quiz.correctIndex], 'Martelinhos');
    });
  });

  group('Festas Seed Data Integrity', () {
    test('contains 6 authentic festas with complete rituals, foods and vocabulary', () {
      final festas = FestasSeedData.getFestas();
      expect(festas.length, 6);

      for (final f in festas) {
        expect(f.id, isNotEmpty);
        expect(f.title, isNotEmpty);
        expect(f.region, isNotEmpty);
        expect(f.country, isNotEmpty);
        expect(f.seasonDate, isNotEmpty);
        expect(f.shortDescription, isNotEmpty);
        expect(f.fullDescription, isNotEmpty);
        expect(f.ritualsAndTraditions, isNotEmpty);
        expect(f.foodsAndDrinks, isNotEmpty);
        expect(f.audioSnippet, isNotEmpty);
        expect(f.vocabulary, isNotEmpty);
      }
    });

    test('contains 4 traditions and 6 quizzes', () {
      final traditions = FestasSeedData.getTraditions();
      expect(traditions.length, 4);

      final quizzes = FestasSeedData.getQuizzes();
      expect(quizzes.length, 6);

      for (final q in quizzes) {
        expect(q.correctIndex, inInclusiveRange(0, q.options.length - 1));
        expect(q.explanation, isNotEmpty);
      }
    });
  });

  group('FestasRepositoryImpl Tests', () {
    late MockSrsRepository mockSrs;
    late MockAppDatabase mockDb;
    late FestasRepositoryImpl repository;

    setUp(() {
      mockSrs = MockSrsRepository();
      mockDb = MockAppDatabase();
      repository = FestasRepositoryImpl(
        database: mockDb,
        srsRepository: mockSrs,
      );
    });

    test('getFestas returns all festas when no filter provided', () async {
      final res = await repository.getFestas();
      expect(res.isOk, isTrue);
      expect(res.value.length, 6);
    });

    test('getFestas filters by category correctly', () async {
      final res = await repository.getFestas(
        category: FestaCategory.santosPopulares,
      );
      expect(res.isOk, isTrue);
      expect(res.value.length, 2);
    });

    test('getFestas filters by dialect correctly', () async {
      final brRes = await repository.getFestas(dialect: 'pt_BR');
      expect(brRes.isOk, isTrue);
      expect(brRes.value.every((f) => f.isPtBr || f.dialect == 'all'), isTrue);

      final ptRes = await repository.getFestas(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      expect(ptRes.value.every((f) => f.isPtPt || f.dialect == 'all'), isTrue);
    });

    test('getFestaById returns festa when found, or failure when not found', () async {
      final found = await repository.getFestaById('carnaval-rio');
      expect(found.isOk, isTrue);
      expect(found.value.title, 'Carnaval do Rio de Janeiro');

      final notFound = await repository.getFestaById('unknown-festa');
      expect(notFound.isOk, isFalse);
    });

    test('getFestaTraditions returns traditions list', () async {
      final res = await repository.getFestaTraditions();
      expect(res.isOk, isTrue);
      expect(res.value.length, 4);
    });

    test('getFestaQuizzes returns quizzes list', () async {
      final res = await repository.getFestaQuizzes();
      expect(res.isOk, isTrue);
      expect(res.value.length, 6);
    });

    test('recordFestaViewed logs attempt in database', () async {
      when(() => mockDb.insertListeningAttemptLog(
            exerciseId: any(named: 'exerciseId'),
            wordAccuracy: any(named: 'wordAccuracy'),
            isExactMatch: any(named: 'isExactMatch'),
            attemptedAt: any(named: 'attemptedAt'),
          )).thenAnswer((_) async => 1);

      final res = await repository.recordFestaViewed('carnaval-rio');
      expect(res.isOk, isTrue);

      verify(() => mockDb.insertListeningAttemptLog(
            exerciseId: 'festa-carnaval-rio',
            wordAccuracy: 1.0,
            isExactMatch: true,
            attemptedAt: any(named: 'attemptedAt'),
          )).called(1);
    });

    test('addFestaVocabToSrs adds card to SrsRepository', () async {
      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});

      const vocab = FestaVocabEntity(
        id: 'festa-pipoca',
        termPt: 'Pipoca',
        translationRu: 'Пипока',
        definition: 'Foliões na rua fora das cordas',
        exampleSentence: 'Pular na pipoca',
        dialect: 'pt_BR',
      );

      final res = await repository.addFestaVocabToSrs(vocab);
      expect(res.isOk, isTrue);

      verify(() => mockSrs.addCard(any())).called(1);
    });
  });
}
