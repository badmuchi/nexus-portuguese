import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/features/humor/data/datasources/humor_seed_data.dart';
import 'package:nexus_portuguese_app/features/humor/data/repositories/humor_repository_impl.dart';
import 'package:nexus_portuguese_app/features/humor/domain/entities/humor_entities.dart';
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
        partOfSpeech: 'frase',
        category: 'geral',
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

  group('Humor Entities Tests', () {
    test('JokeEntity dialect helpers work correctly for PT-BR, PT-PT, and all', () {
      const brJoke = JokeEntity(
        id: 'br_1',
        titlePt: 'Boteco',
        titleRu: 'Бар',
        setupPt: 'Setup',
        setupRu: 'Завязка',
        punchlinePt: 'Punchline',
        punchlineRu: 'Панчлайн',
        explanationRu: 'Разбор',
        category: JokeCategory.boteco,
        dialect: 'pt_BR',
      );

      expect(brJoke.isPtBr, isTrue);
      expect(brJoke.isPtPt, isFalse);
      expect(brJoke.dialectFlag, '🇧🇷');
      expect(brJoke.dialectLabel, 'Brasil');

      const ptJoke = JokeEntity(
        id: 'pt_1',
        titlePt: 'Alentejano',
        titleRu: 'Алентежанец',
        setupPt: 'Setup',
        setupRu: 'Завязка',
        punchlinePt: 'Punchline',
        punchlineRu: 'Панчлайн',
        explanationRu: 'Разбор',
        category: JokeCategory.alentejano,
        dialect: 'pt_PT',
      );

      expect(ptJoke.isPtPt, isTrue);
      expect(ptJoke.isPtBr, isFalse);
      expect(ptJoke.dialectFlag, '🇵🇹');
      expect(ptJoke.dialectLabel, 'Portugal');

      const allJoke = JokeEntity(
        id: 'all_1',
        titlePt: 'Trocadilho',
        titleRu: 'Каламбур',
        setupPt: 'Setup',
        setupRu: 'Завязка',
        punchlinePt: 'Punchline',
        punchlineRu: 'Панчлайн',
        explanationRu: 'Разбор',
        category: JokeCategory.trocadilho,
        dialect: 'all',
      );

      expect(allJoke.dialectFlag, '🌐');
      expect(allJoke.dialectLabel, 'Luso');
    });

    test('TrocadilhoEntity properties and flags', () {
      const trocadilho = TrocadilhoEntity(
        id: 'tr_test',
        questionPt: 'Pergunta',
        questionRu: 'Вопрос',
        answerPt: 'Resposta',
        answerRu: 'Ответ',
        wordplayExplanationRu: 'Игра слов',
        dialect: 'pt_PT',
      );

      expect(trocadilho.isPtPt, isTrue);
      expect(trocadilho.isPtBr, isFalse);
      expect(trocadilho.dialectFlag, '🇵🇹');
    });

    test('HumorQuizEntity correctPunchlinePt returns correct string', () {
      const quiz = HumorQuizEntity(
        id: 'qz_test',
        jokeSetupPt: 'Início da piada...',
        jokeSetupRu: 'Начало шутки...',
        optionsPt: ['Opção A', 'Opção B', 'Opção C'],
        correctOptionIndex: 1,
        explanationRu: 'Объяснение',
      );

      expect(quiz.correctPunchlinePt, 'Opção B');
      expect(quiz.optionsPt.length, 3);
    });
  });

  group('Humor Seed Data Integrity', () {
    test('contains at least 8 jokes covering all categories', () {
      final jokes = HumorSeedData.getJokes();
      expect(jokes.length, greaterThanOrEqualTo(8));

      final categories = jokes.map((j) => j.category).toSet();
      expect(categories, containsAll(JokeCategory.values));

      for (final j in jokes) {
        expect(j.id, isNotEmpty);
        expect(j.titlePt, isNotEmpty);
        expect(j.setupPt, isNotEmpty);
        expect(j.punchlinePt, isNotEmpty);
        expect(j.explanationRu, isNotEmpty);
      }
    });

    test('contains trocadilhos with explanations', () {
      final trocadilhos = HumorSeedData.getTrocadilhos();
      expect(trocadilhos.length, greaterThanOrEqualTo(6));

      for (final t in trocadilhos) {
        expect(t.questionPt, isNotEmpty);
        expect(t.answerPt, isNotEmpty);
        expect(t.wordplayExplanationRu, isNotEmpty);
      }
    });

    test('contains quiz questions with valid correctOptionIndex', () {
      final quizzes = HumorSeedData.getHumorQuizzes();
      expect(quizzes.length, greaterThanOrEqualTo(4));

      for (final q in quizzes) {
        expect(q.correctOptionIndex, inInclusiveRange(0, q.optionsPt.length - 1));
        expect(q.correctPunchlinePt, isNotEmpty);
      }
    });
  });

  group('HumorRepositoryImpl Tests', () {
    late HumorRepositoryImpl repository;
    late MockSrsRepository mockSrs;

    setUp(() {
      mockSrs = MockSrsRepository();
      repository = HumorRepositoryImpl(srsRepository: mockSrs);
    });

    test('getJokes returns list and filters by category & dialect', () async {
      final allRes = await repository.getJokes();
      expect(allRes.isOk, isTrue);
      expect(allRes.value.length, greaterThanOrEqualTo(8));

      final botecoRes = await repository.getJokes(category: JokeCategory.boteco);
      expect(botecoRes.isOk, isTrue);
      expect(botecoRes.value.every((j) => j.category == JokeCategory.boteco), isTrue);

      final ptRes = await repository.getJokes(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      expect(ptRes.value.every((j) => j.isPtPt || j.dialect == 'all'), isTrue);
    });

    test('getJokeById finds existing joke and fails for unknown', () async {
      final found = await repository.getJokeById('jk_boteco_1');
      expect(found.isOk, isTrue);
      expect(found.value.titlePt, contains('Bêbado'));

      final notFound = await repository.getJokeById('non_existent');
      expect(notFound.isOk, isFalse);
    });

    test('getTrocadilhos returns list and filters by dialect', () async {
      final res = await repository.getTrocadilhos();
      expect(res.isOk, isTrue);
      expect(res.value.length, greaterThanOrEqualTo(6));

      final brRes = await repository.getTrocadilhos(dialect: 'pt_BR');
      expect(brRes.isOk, isTrue);
      expect(brRes.value.every((t) => t.isPtBr || t.dialect == 'all'), isTrue);
    });

    test('getHumorQuizzes returns list of quizzes', () async {
      final res = await repository.getHumorQuizzes();
      expect(res.isOk, isTrue);
      expect(res.value.length, greaterThanOrEqualTo(4));
    });

    test('recordJokeReaction succeeds without database', () async {
      final res = await repository.recordJokeReaction(jokeId: 'jk_boteco_1', liked: true);
      expect(res.isOk, isTrue);
    });

    test('addWordToSrs delegates to SrsRepository', () async {
      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});

      const vocab = JokeVocabEntity(
        id: 'v1',
        termPt: 'Boteco',
        translationRu: 'Бар',
        explanationRu: 'Культурное заведение',
      );

      final res = await repository.addWordToSrs(vocab, dialect: 'pt_BR');
      expect(res.isOk, isTrue);
      verify(() => mockSrs.addCard(any())).called(1);
    });
  });
}
