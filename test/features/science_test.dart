import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/science/data/datasources/science_seed_data.dart';
import 'package:nexus_portuguese_app/features/science/data/repositories/science_repository_impl.dart';
import 'package:nexus_portuguese_app/features/science/domain/entities/science_entities.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback_sci',
        portuguese: 'ensaio clínico',
        russianTranslation: 'клиническое испытание',
        partOfSpeech: 'substantivo',
        category: 'ciencia',
        dialect: 'pt_BR',
        examplePortuguese: 'O ensaio clínico confirmou a eficácia.',
        exampleRussian: 'Клиническое испытание подтвердило эффективность.',
        notes: 'Termo científico',
        fsrsState: 'newCard',
        stability: 0,
        difficulty: 0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      ),
    );
  });

  group('Science Entities Tests', () {
    test('ScienceTopicEntity dialect helpers work properly', () {
      const brTopic = ScienceTopicEntity(
        id: 'butantan',
        title: 'Instituto Butantan',
        field: ScienceField.biomedicina,
        institution: 'Butantan',
        region: 'São Paulo',
        country: 'Brasil',
        dialect: 'pt_BR',
        shortSummary: 'Soros e vacinas',
        fullDescription: 'Pesquisa com venenos...',
        keyDiscoveries: ['Captopril'],
        scientificImpact: 'Impacto global',
        vocabulary: [],
        audioNarration: 'Áudio narrativo',
      );

      expect(brTopic.isPtBr, isTrue);
      expect(brTopic.isPtPt, isFalse);

      const ptTopic = ScienceTopicEntity(
        id: 'acores',
        title: 'Mar dos Açores',
        field: ScienceField.oceanografia,
        institution: 'Univ. Açores',
        region: 'Açores',
        country: 'Portugal',
        dialect: 'pt_PT',
        shortSummary: 'Fontes hidrotermais',
        fullDescription: 'Abissal...',
        keyDiscoveries: ['Lucky Strike'],
        scientificImpact: 'Plataforma continental',
        vocabulary: [],
        audioNarration: 'Áudio narrativo',
      );

      expect(ptTopic.isPtPt, isTrue);
      expect(ptTopic.isPtBr, isFalse);
    });

    test('ScienceVocabEntity and LabExperimentEntity equality and fields', () {
      const vocab1 = ScienceVocabEntity(
        id: 'sv1',
        termPt: 'Amostragem',
        translationRu: 'Отбор проб',
        definition: 'Coleta de amostras',
        exampleSentence: 'A amostragem foi feita no mar.',
        dialect: 'pt_PT',
      );

      const vocab2 = ScienceVocabEntity(
        id: 'sv1',
        termPt: 'Amostragem',
        translationRu: 'Отбор проб',
        definition: 'Coleta de amostras',
        exampleSentence: 'A amostragem foi feita no mar.',
        dialect: 'pt_PT',
      );

      expect(vocab1, equals(vocab2));
      expect(vocab1.isPtPt, isTrue);
      expect(vocab1.isPtBr, isFalse);

      const exp = LabExperimentEntity(
        id: 'exp1',
        title: 'Análise de eDNA',
        field: ScienceField.oceanografia,
        objectivePt: 'Extrair DNA do oceano',
        objectiveRu: 'Извлечь ДНК океана',
        hypothesisPt: 'Se a água for filtrada, detectar-se-á o peixe.',
        procedureSteps: ['Coleta-se a água', 'Filtra-se o sedimento'],
        conclusionInsight: 'Espécie identificada com sucesso.',
        passiveVoiceGrammarNote: 'Uso da voz passiva sintética.',
        icon: '🧬',
      );

      expect(exp.title, 'Análise de eDNA');
      expect(exp.field, ScienceField.oceanografia);
      expect(exp.procedureSteps.length, 2);
    });

    test('ScienceQuizQuestion equality and properties', () {
      const quiz = ScienceQuizQuestion(
        id: 'q1',
        question: 'Qual medicamento derivou do veneno da jararaca?',
        options: ['Captopril', 'Penicilina', 'Insulina'],
        correctIndex: 0,
        explanation: 'O Captopril foi desenvolvido a partir do veneno da jararaca.',
        dialect: 'pt_BR',
        contextField: 'Biomedicina',
        accentEmoji: '🐍',
      );

      expect(quiz.correctIndex, 0);
      expect(quiz.options.length, 3);
      expect(quiz.contextField, 'Biomedicina');
    });
  });

  group('ScienceSeedData Integrity Tests', () {
    test('getTopics returns 6 full topics with vocabulary and discoveries', () {
      final topics = ScienceSeedData.getTopics();
      expect(topics.length, 6);

      for (final topic in topics) {
        expect(topic.id, isNotEmpty);
        expect(topic.title, isNotEmpty);
        expect(topic.institution, isNotEmpty);
        expect(topic.shortSummary, isNotEmpty);
        expect(topic.fullDescription, isNotEmpty);
        expect(topic.keyDiscoveries, isNotEmpty);
        expect(topic.scientificImpact, isNotEmpty);
        expect(topic.vocabulary, isNotEmpty);
        expect(topic.audioNarration, isNotEmpty);
      }

      final ids = topics.map((t) => t.id).toSet();
      expect(ids.contains('mar-dos-acores'), isTrue);
      expect(ids.contains('instituto-butantan'), isTrue);
      expect(ids.contains('windfloat-peniche'), isTrue);
      expect(ids.contains('fiocruz-biomedicina'), isTrue);
      expect(ids.contains('alcantara-espacial'), isTrue);
      expect(ids.contains('champalimaud-neurociencia'), isTrue);
    });

    test('getLabExperiments returns 4 experiments with passive voice notes', () {
      final experiments = ScienceSeedData.getLabExperiments();
      expect(experiments.length, 4);

      for (final exp in experiments) {
        expect(exp.id, isNotEmpty);
        expect(exp.title, isNotEmpty);
        expect(exp.objectivePt, isNotEmpty);
        expect(exp.objectiveRu, isNotEmpty);
        expect(exp.hypothesisPt, contains('Se '));
        expect(exp.procedureSteps, isNotEmpty);
        expect(exp.passiveVoiceGrammarNote, isNotEmpty);
      }
    });

    test('getQuizzes returns 6 questions with valid options and correct indices', () {
      final quizzes = ScienceSeedData.getQuizzes();
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

  group('ScienceRepositoryImpl Tests', () {
    late MockSrsRepository mockSrs;
    late MockAppDatabase mockDb;
    late ScienceRepositoryImpl repository;

    setUp(() {
      mockSrs = MockSrsRepository();
      mockDb = MockAppDatabase();
      repository = ScienceRepositoryImpl(
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

    test('getScienceTopics returns ok Result with all topics', () async {
      final result = await repository.getScienceTopics();
      expect(result.isOk, isTrue);
      expect(result.value.length, 6);
    });

    test('getScienceTopics filters by dialect and field', () async {
      final ptRes = await repository.getScienceTopics(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      expect(ptRes.value.every((t) => t.isPtPt || t.dialect == 'all'), isTrue);

      final bioRes = await repository.getScienceTopics(field: ScienceField.biomedicina);
      expect(bioRes.isOk, isTrue);
      expect(bioRes.value.every((t) => t.field == ScienceField.biomedicina), isTrue);
    });

    test('getScienceTopicById returns topic or error', () async {
      final res = await repository.getScienceTopicById('mar-dos-acores');
      expect(res.isOk, isTrue);
      expect(res.value.title, contains('Açores'));

      final err = await repository.getScienceTopicById('inexistent');
      expect(err.isFailure, isTrue);
    });

    test('getLabExperiments returns ok Result with experiments', () async {
      final result = await repository.getLabExperiments();
      expect(result.isOk, isTrue);
      expect(result.value.length, 4);
    });

    test('getScienceQuizzes returns ok Result with quizzes', () async {
      final result = await repository.getScienceQuizzes();
      expect(result.isOk, isTrue);
      expect(result.value.length, 6);
    });

    test('recordTopicViewed calls db.insertListeningAttemptLog', () async {
      final result = await repository.recordTopicViewed('instituto-butantan');
      expect(result.isOk, isTrue);
      verify(() => mockDb.insertListeningAttemptLog(
            exerciseId: 'science-topic-instituto-butantan',
            wordAccuracy: 1.0,
            isExactMatch: true,
            attemptedAt: any(named: 'attemptedAt'),
          )).called(1);
    });

    test('addScienceVocabToSrs saves card to SRS repository', () async {
      const vocab = ScienceVocabEntity(
        id: 'sci_peconha',
        termPt: 'Peçonha',
        translationRu: 'Зоотоксин',
        definition: 'Substância tóxica',
        exampleSentence: 'A peçonha é potente.',
        dialect: 'pt_BR',
      );

      final result = await repository.addScienceVocabToSrs(vocab, dialect: 'pt_BR');
      expect(result.isOk, isTrue);
      verify(() => mockSrs.addCard(any(
            that: isA<SrsCardEntity>().having(
              (c) => c.portuguese,
              'portuguese',
              'Peçonha',
            ),
          ))).called(1);
    });
  });
}
