import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/fashion/data/datasources/fashion_seed_data.dart';
import 'package:nexus_portuguese_app/features/fashion/data/repositories/fashion_repository_impl.dart';
import 'package:nexus_portuguese_app/features/fashion/domain/entities/fashion_entities.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback_fsh',
        portuguese: 'cabedal',
        russianTranslation: 'кожа для верха обуви',
        partOfSpeech: 'substantivo',
        category: 'moda',
        dialect: 'pt_PT',
        examplePortuguese: 'O cabedal nobre foi trabalhado pelo sapateiro.',
        exampleRussian: 'Благородная кожа была обработана сапожником.',
        notes: 'Termo de moda',
        fsrsState: 'newCard',
        stability: 0,
        difficulty: 0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      ),
    );
  });

  group('Fashion Entities Tests', () {
    test('FashionTopicEntity dialect helpers work properly', () {
      const brTopic = FashionTopicEntity(
        id: 'spfw',
        title: 'SPFW',
        category: FashionCategory.altaCostura,
        region: 'São Paulo',
        country: 'Brasil',
        dialect: 'pt_BR',
        shortSummary: 'Semana de moda',
        fullDescription: 'Desfiles no Ibirapuera...',
        keyHighlights: ['Destaque tropical'],
        culturalSignificance: 'Autoimagem cosmopolita',
        vocabulary: [],
        audioNarration: 'Áudio narrativo',
      );

      expect(brTopic.isPtBr, isTrue);
      expect(brTopic.isPtPt, isFalse);

      const ptTopic = FashionTopicEntity(
        id: 'calcado',
        title: 'Calçado Português',
        category: FashionCategory.calcadoCouro,
        region: 'São João da Madeira',
        country: 'Portugal',
        dialect: 'pt_PT',
        shortSummary: 'Sapatos de luxo',
        fullDescription: 'Goodyear welted...',
        keyHighlights: ['Sapato sexy'],
        culturalSignificance: 'Tradição artesanal',
        vocabulary: [],
        audioNarration: 'Áudio narrativo',
      );

      expect(ptTopic.isPtPt, isTrue);
      expect(ptTopic.isPtBr, isFalse);
    });

    test('FashionVocabEntity and TextileCraftEntity equality and fields', () {
      const vocab1 = FashionVocabEntity(
        id: 'fv1',
        termPt: 'Bilro',
        translationRu: 'Коклюшка',
        definition: 'Haste de madeira para renda',
        exampleSentence: 'O bilro estala ritmadamente.',
        dialect: 'all',
      );

      const vocab2 = FashionVocabEntity(
        id: 'fv1',
        termPt: 'Bilro',
        translationRu: 'Коклюшка',
        definition: 'Haste de madeira para renda',
        exampleSentence: 'O bilro estala ritmadamente.',
        dialect: 'all',
      );

      expect(vocab1, equals(vocab2));
      expect(vocab1.isPtPt, isFalse);
      expect(vocab1.isPtBr, isFalse);

      const craft = TextileCraftEntity(
        id: 'c1',
        title: 'Renda de Bilros',
        region: 'Vila do Conde',
        materialPt: 'Linho e bilros de buxo',
        techniqueDescriptionPt: 'Cruzamento de fios com almofada',
        techniqueDescriptionRu: 'Перекрещивание нитей на подушке',
        stepByStepGuide: ['Fixa-se o cartão', 'Enrolam-se os fios'],
        grammarInsight: 'As rendas são finíssimas.',
        icon: '🧵',
      );

      expect(craft.title, 'Renda de Bilros');
      expect(craft.stepByStepGuide.length, 2);
    });

    test('FashionQuizQuestion equality and properties', () {
      const quiz = FashionQuizQuestion(
        id: 'q1',
        question: 'Qual é a capital do calçado em Portugal?',
        options: ['São João da Madeira', 'Porto', 'Lisboa'],
        correctIndex: 0,
        explanation: 'São João da Madeira é a capital do calçado.',
        dialect: 'pt_PT',
        contextCategory: 'Calçado',
        accentEmoji: '👞',
      );

      expect(quiz.correctIndex, 0);
      expect(quiz.options.length, 3);
      expect(quiz.contextCategory, 'Calçado');
    });
  });

  group('FashionSeedData Integrity Tests', () {
    test('getTopics returns 6 full topics with vocabulary and highlights', () {
      final topics = FashionSeedData.getTopics();
      expect(topics.length, 6);

      for (final topic in topics) {
        expect(topic.id, isNotEmpty);
        expect(topic.title, isNotEmpty);
        expect(topic.region, isNotEmpty);
        expect(topic.shortSummary, isNotEmpty);
        expect(topic.fullDescription, isNotEmpty);
        expect(topic.keyHighlights, isNotEmpty);
        expect(topic.culturalSignificance, isNotEmpty);
        expect(topic.vocabulary, isNotEmpty);
        expect(topic.audioNarration, isNotEmpty);
      }

      final ids = topics.map((t) => t.id).toSet();
      expect(ids.contains('spfw-brasil'), isTrue);
      expect(ids.contains('calcado-portugues'), isTrue);
      expect(ids.contains('rendas-bilros'), isTrue);
      expect(ids.contains('chita-brasileira'), isTrue);
      expect(ids.contains('filigrana-gondomar'), isTrue);
      expect(ids.contains('eco-design-textil'), isTrue);
    });

    test('getTextileCrafts returns 4 crafts with step-by-step guides', () {
      final crafts = FashionSeedData.getTextileCrafts();
      expect(crafts.length, 4);

      for (final craft in crafts) {
        expect(craft.id, isNotEmpty);
        expect(craft.title, isNotEmpty);
        expect(craft.region, isNotEmpty);
        expect(craft.materialPt, isNotEmpty);
        expect(craft.techniqueDescriptionPt, isNotEmpty);
        expect(craft.techniqueDescriptionRu, isNotEmpty);
        expect(craft.stepByStepGuide, isNotEmpty);
        expect(craft.grammarInsight, isNotEmpty);
      }
    });

    test('getQuizzes returns 6 questions with valid options and correct indices', () {
      final quizzes = FashionSeedData.getQuizzes();
      expect(quizzes.length, 6);

      for (final q in quizzes) {
        expect(q.id, isNotEmpty);
        expect(q.question, isNotEmpty);
        expect(q.options.length, greaterThanOrEqualTo(3));
        expect(q.correctIndex, greaterThanOrEqualTo(0));
        expect(q.correctIndex, lessThan(q.options.length));
        expect(q.explanation, isNotEmpty);
      }
    });
  });

  group('FashionRepositoryImpl Tests', () {
    late MockSrsRepository mockSrs;
    late MockAppDatabase mockDb;
    late FashionRepositoryImpl repository;

    setUp(() {
      mockSrs = MockSrsRepository();
      mockDb = MockAppDatabase();
      repository = FashionRepositoryImpl(
        database: mockDb,
        srsRepository: mockSrs,
      );

      when(() => mockDb.insertListeningAttemptLog(
            exerciseId: any(named: 'exerciseId'),
            wordAccuracy: any(named: 'wordAccuracy'),
            isExactMatch: any(named: 'isExactMatch'),
            attemptedAt: any(named: 'attemptedAt'),
          )).thenAnswer((_) async => 1);

      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});
    });

    test('getFashionTopics returns ok Result with all topics', () async {
      final result = await repository.getFashionTopics();
      expect(result.isOk, isTrue);
      expect(result.value.length, 6);
    });

    test('getFashionTopics filters by dialect and category', () async {
      final ptRes = await repository.getFashionTopics(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      expect(ptRes.value.every((t) => t.isPtPt || t.dialect == 'all'), isTrue);

      final catRes = await repository.getFashionTopics(category: FashionCategory.altaCostura);
      expect(catRes.isOk, isTrue);
      expect(catRes.value.every((t) => t.category == FashionCategory.altaCostura), isTrue);
    });

    test('getFashionTopicById returns topic or error', () async {
      final res = await repository.getFashionTopicById('calcado-portugues');
      expect(res.isOk, isTrue);
      expect(res.value.title, contains('Calçado'));

      final err = await repository.getFashionTopicById('inexistent');
      expect(err.isFailure, isTrue);
    });

    test('getTextileCrafts returns ok Result with crafts', () async {
      final result = await repository.getTextileCrafts();
      expect(result.isOk, isTrue);
      expect(result.value.length, 4);
    });

    test('getFashionQuizzes returns ok Result with quizzes', () async {
      final result = await repository.getFashionQuizzes();
      expect(result.isOk, isTrue);
      expect(result.value.length, 6);
    });

    test('recordTopicViewed calls db.insertListeningAttemptLog', () async {
      final result = await repository.recordTopicViewed('spfw-brasil');
      expect(result.isOk, isTrue);
      verify(() => mockDb.insertListeningAttemptLog(
            exerciseId: 'fashion-topic-spfw-brasil',
            wordAccuracy: 1.0,
            isExactMatch: true,
            attemptedAt: any(named: 'attemptedAt'),
          )).called(1);
    });

    test('addFashionVocabToSrs saves card to SRS repository', () async {
      const vocab = FashionVocabEntity(
        id: 'fsh_bilro',
        termPt: 'Bilro de madeira',
        translationRu: 'Коклюшка',
        definition: 'Haste de madeira para tecer renda',
        exampleSentence: 'O bilro gira nos dedos da rendeira.',
        dialect: 'all',
      );

      final result = await repository.addFashionVocabToSrs(vocab, dialect: 'all');
      expect(result.isOk, isTrue);
      verify(() => mockSrs.addCard(any(
            that: isA<SrsCardEntity>().having(
              (c) => c.portuguese,
              'portuguese',
              'Bilro de madeira',
            ),
          ))).called(1);
    });
  });
}
