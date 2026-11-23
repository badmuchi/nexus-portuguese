import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/finance/data/datasources/finance_seed_data.dart';
import 'package:nexus_portuguese_app/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:nexus_portuguese_app/features/finance/domain/entities/finance_entities.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback_fin',
        portuguese: 'pix',
        russianTranslation: 'пикс',
        partOfSpeech: 'substantivo',
        category: 'financas',
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

  group('Finance Entities Tests', () {
    test('FinanceTopicEntity dialect helpers work correctly for PT-BR and PT-PT', () {
      const brTopic = FinanceTopicEntity(
        id: 't_br',
        title: 'Pix',
        category: FinanceCategory.fintech,
        region: 'Brasil',
        country: 'Brasil',
        dialect: 'pt_BR',
        shortDescription: 'Desc curta',
        fullDescription: 'Desc longa',
        keyMechanisms: ['Chaves Pix'],
        culturalTips: ['Dica'],
        vocabulary: [],
        audioSnippet: 'Audio',
      );

      expect(brTopic.isPtBr, isTrue);
      expect(brTopic.isPtPt, isFalse);

      const ptTopic = FinanceTopicEntity(
        id: 't_pt',
        title: 'MB WAY',
        category: FinanceCategory.fintech,
        region: 'Portugal',
        country: 'Portugal',
        dialect: 'pt_PT',
        shortDescription: 'Desc curta',
        fullDescription: 'Desc longa',
        keyMechanisms: ['Multibanco'],
        culturalTips: ['Dica'],
        vocabulary: [],
        audioSnippet: 'Audio',
      );

      expect(ptTopic.isPtPt, isTrue);
      expect(ptTopic.isPtBr, isFalse);
    });

    test('FinanceVocabEntity dialect helpers and equality', () {
      const vocab1 = FinanceVocabEntity(
        id: 'v1',
        termPt: 'Chave Pix',
        translationRu: 'Ключ Pix',
        definition: 'Identificador único',
        exampleSentence: 'Minha chave é o celular',
        dialect: 'pt_BR',
      );

      const vocab2 = FinanceVocabEntity(
        id: 'v1',
        termPt: 'Chave Pix',
        translationRu: 'Ключ Pix',
        definition: 'Identificador único',
        exampleSentence: 'Minha chave é o celular',
        dialect: 'pt_BR',
      );

      expect(vocab1, equals(vocab2));
      expect(vocab1.isPtBr, isTrue);
      expect(vocab1.isPtPt, isFalse);
    });

    test('FintechSimulatorEntity and FinanceQuizQuestion properties', () {
      const sim = FintechSimulatorEntity(
        id: 's1',
        title: 'Fazer Pix',
        platform: 'Pix',
        dialect: 'pt_BR',
        scenario: 'Pagar conta',
        steps: ['Passo 1', 'Passo 2'],
        practicalAdvice: 'Conferir nome',
        icon: '⚡',
      );

      expect(sim.steps.length, 2);
      expect(sim.practicalAdvice, isNotEmpty);

      const quiz = FinanceQuizQuestion(
        id: 'q1',
        question: 'Qual meio instantâneo?',
        options: ['Pix', 'Boleto'],
        correctIndex: 0,
        explanation: 'Pix do Bacen',
        dialect: 'pt_BR',
      );

      expect(quiz.correctIndex, 0);
      expect(quiz.options[quiz.correctIndex], 'Pix');
    });
  });

  group('Finance Seed Data Integrity', () {
    test('contains 6 rich finance topics with mechanisms, tips and vocabulary', () {
      final topics = FinanceSeedData.getTopics();
      expect(topics.length, 6);

      for (final t in topics) {
        expect(t.id, isNotEmpty);
        expect(t.title, isNotEmpty);
        expect(t.region, isNotEmpty);
        expect(t.country, isNotEmpty);
        expect(t.shortDescription, isNotEmpty);
        expect(t.fullDescription, isNotEmpty);
        expect(t.keyMechanisms, isNotEmpty);
        expect(t.culturalTips, isNotEmpty);
        expect(t.audioSnippet, isNotEmpty);
        expect(t.vocabulary, isNotEmpty);
      }
    });

    test('contains 4 fintech simulators and 6 quizzes', () {
      final simulators = FinanceSeedData.getSimulators();
      expect(simulators.length, 4);

      final quizzes = FinanceSeedData.getQuizzes();
      expect(quizzes.length, 6);

      for (final q in quizzes) {
        expect(q.correctIndex, inInclusiveRange(0, q.options.length - 1));
        expect(q.explanation, isNotEmpty);
      }
    });
  });

  group('FinanceRepositoryImpl Tests', () {
    late MockSrsRepository mockSrs;
    late MockAppDatabase mockDb;
    late FinanceRepositoryImpl repository;

    setUp(() {
      mockSrs = MockSrsRepository();
      mockDb = MockAppDatabase();
      repository = FinanceRepositoryImpl(
        database: mockDb,
        srsRepository: mockSrs,
      );
    });

    test('getFinanceTopics returns all topics when no filter provided', () async {
      final res = await repository.getFinanceTopics();
      expect(res.isOk, isTrue);
      expect(res.value.length, 6);
    });

    test('getFinanceTopics filters by category correctly', () async {
      final res = await repository.getFinanceTopics(
        category: FinanceCategory.fintech,
      );
      expect(res.isOk, isTrue);
      expect(res.value.length, 2);
    });

    test('getFinanceTopics filters by dialect correctly', () async {
      final brRes = await repository.getFinanceTopics(dialect: 'pt_BR');
      expect(brRes.isOk, isTrue);
      expect(brRes.value.every((t) => t.isPtBr || t.dialect == 'all'), isTrue);

      final ptRes = await repository.getFinanceTopics(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      expect(ptRes.value.every((t) => t.isPtPt || t.dialect == 'all'), isTrue);
    });

    test('getTopicById returns topic when found, or failure when not found', () async {
      final found = await repository.getTopicById('fintech-pix-brasil');
      expect(found.isOk, isTrue);
      expect(found.value.title, 'Pix & Pagamentos Instantâneos');

      final notFound = await repository.getTopicById('unknown-topic');
      expect(notFound.isOk, isFalse);
    });

    test('getFintechSimulators returns simulators list', () async {
      final res = await repository.getFintechSimulators();
      expect(res.isOk, isTrue);
      expect(res.value.length, 4);
    });

    test('getFinanceQuizzes returns quizzes list', () async {
      final res = await repository.getFinanceQuizzes();
      expect(res.isOk, isTrue);
      expect(res.value.length, 6);
    });

    test('recordTopicViewed logs attempt in database', () async {
      when(() => mockDb.insertListeningAttemptLog(
            exerciseId: any(named: 'exerciseId'),
            wordAccuracy: any(named: 'wordAccuracy'),
            isExactMatch: any(named: 'isExactMatch'),
            attemptedAt: any(named: 'attemptedAt'),
          )).thenAnswer((_) async => 1);

      final res = await repository.recordTopicViewed('fintech-pix-brasil');
      expect(res.isOk, isTrue);

      verify(() => mockDb.insertListeningAttemptLog(
            exerciseId: 'finance-topic-fintech-pix-brasil',
            wordAccuracy: 1.0,
            isExactMatch: true,
            attemptedAt: any(named: 'attemptedAt'),
          )).called(1);
    });

    test('addFinanceVocabToSrs adds card to SrsRepository', () async {
      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});

      const vocab = FinanceVocabEntity(
        id: 'fin-chave-pix',
        termPt: 'Chave Pix',
        translationRu: 'Ключ Pix',
        definition: 'Identificador único',
        exampleSentence: 'Minha chave é o celular',
        dialect: 'pt_BR',
      );

      final res = await repository.addFinanceVocabToSrs(vocab);
      expect(res.isOk, isTrue);

      verify(() => mockSrs.addCard(any())).called(1);
    });
  });
}
