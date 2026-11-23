import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/architecture/data/datasources/architecture_seed_data.dart';
import 'package:nexus_portuguese_app/features/architecture/data/repositories/architecture_repository_impl.dart';
import 'package:nexus_portuguese_app/features/architecture/domain/entities/architecture_entities.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback_arch',
        portuguese: 'concreto',
        russianTranslation: 'бетон',
        partOfSpeech: 'substantivo',
        category: 'arquitetura',
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

  group('Architecture Entities Tests', () {
    test('ArchitecturalMonumentEntity dialect helpers work correctly for PT-BR and PT-PT', () {
      const brMonument = ArchitecturalMonumentEntity(
        id: 'm_br',
        title: 'Catedral de Brasília',
        city: 'Brasília',
        country: 'Brasil',
        dialect: 'pt_BR',
        yearCompleted: '1970',
        architect: 'Oscar Niemeyer',
        styleId: 'modernismo-br',
        styleName: 'Modernismo',
        category: ArchitectureCategory.modernUrban,
        shortDescription: 'Desc curta',
        fullDescription: 'Desc longa',
        architecturalFeatures: ['Colunas curvas'],
        historicalSignificance: 'Capital do Brasil',
        vocabulary: [],
        audioSnippet: 'Audio',
      );

      expect(brMonument.isPtBr, isTrue);
      expect(brMonument.isPtPt, isFalse);

      const ptMonument = ArchitecturalMonumentEntity(
        id: 'm_pt',
        title: 'Mosteiro dos Jerónimos',
        city: 'Lisboa',
        country: 'Portugal',
        dialect: 'pt_PT',
        yearCompleted: '1501',
        architect: 'Diogo de Boitaca',
        styleId: 'manuelino',
        styleName: 'Manuelino',
        category: ArchitectureCategory.monument,
        shortDescription: 'Desc curta',
        fullDescription: 'Desc longa',
        architecturalFeatures: ['Abóbada'],
        historicalSignificance: 'Descobrimentos',
        vocabulary: [],
        audioSnippet: 'Audio',
      );

      expect(ptMonument.isPtPt, isTrue);
      expect(ptMonument.isPtBr, isFalse);
    });

    test('ArchitectVocabEntity dialect helpers and equality', () {
      const vocab1 = ArchitectVocabEntity(
        id: 'v1',
        termPt: 'Betão à vista',
        translationRu: 'Открытый бетон',
        definition: 'Acabamento',
        exampleSentence: 'Exemplo',
        dialect: 'pt_PT',
        dialectNote: 'No Brasil diz-se concreto aparente',
      );

      const vocab2 = ArchitectVocabEntity(
        id: 'v1',
        termPt: 'Betão à vista',
        translationRu: 'Открытый бетон',
        definition: 'Acabamento',
        exampleSentence: 'Exemplo',
        dialect: 'pt_PT',
        dialectNote: 'No Brasil diz-se concreto aparente',
      );

      expect(vocab1, equals(vocab2));
      expect(vocab1.isPtPt, isTrue);
      expect(vocab1.isPtBr, isFalse);
    });

    test('ArchitecturalStyleEntity and ArchitectureQuizQuestion properties', () {
      const style = ArchitecturalStyleEntity(
        id: 'st1',
        name: 'Manuelino',
        period: 'Século XVI',
        description: 'Estilo gótico português',
        keyCharacteristics: ['Cordas náuticas'],
        prominentExamples: ['Torre de Belém'],
        icon: '🧭',
      );

      expect(style.prominentExamples.first, 'Torre de Belém');

      const quiz = ArchitectureQuizQuestion(
        id: 'q1',
        question: 'Quem projetou a Catedral?',
        options: ['Niemeyer', 'Lúcio Costa'],
        correctIndex: 0,
        explanation: 'Oscar Niemeyer',
        dialect: 'pt_BR',
      );

      expect(quiz.correctIndex, 0);
      expect(quiz.options[quiz.correctIndex], 'Niemeyer');
    });
  });

  group('Architecture Seed Data Integrity', () {
    test('contains 6 monuments with complete metadata, features and vocabulary', () {
      final monuments = ArchitectureSeedData.getMonuments();
      expect(monuments.length, 6);

      for (final m in monuments) {
        expect(m.id, isNotEmpty);
        expect(m.title, isNotEmpty);
        expect(m.city, isNotEmpty);
        expect(m.country, isNotEmpty);
        expect(m.architect, isNotEmpty);
        expect(m.yearCompleted, isNotEmpty);
        expect(m.shortDescription, isNotEmpty);
        expect(m.fullDescription, isNotEmpty);
        expect(m.architecturalFeatures, isNotEmpty);
        expect(m.historicalSignificance, isNotEmpty);
        expect(m.audioSnippet, isNotEmpty);
        expect(m.vocabulary, isNotEmpty);
      }
    });

    test('contains 4 rich architectural styles and 6 quizzes', () {
      final styles = ArchitectureSeedData.getStyles();
      expect(styles.length, 4);

      final quizzes = ArchitectureSeedData.getQuizzes();
      expect(quizzes.length, 6);

      for (final q in quizzes) {
        expect(q.correctIndex, inInclusiveRange(0, q.options.length - 1));
        expect(q.explanation, isNotEmpty);
      }
    });
  });

  group('ArchitectureRepositoryImpl Tests', () {
    late MockSrsRepository mockSrs;
    late MockAppDatabase mockDb;
    late ArchitectureRepositoryImpl repository;

    setUp(() {
      mockSrs = MockSrsRepository();
      mockDb = MockAppDatabase();
      repository = ArchitectureRepositoryImpl(
        database: mockDb,
        srsRepository: mockSrs,
      );
    });

    test('getMonuments returns all monuments when no filter provided', () async {
      final res = await repository.getMonuments();
      expect(res.isOk, isTrue);
      expect(res.value.length, 6);
    });

    test('getMonuments filters by category correctly', () async {
      final res = await repository.getMonuments(
        category: ArchitectureCategory.contemporary,
      );
      expect(res.isOk, isTrue);
      expect(res.value.length, 1);
      expect(res.value.first.id, 'casa-da-musica');
    });

    test('getMonuments filters by dialect correctly', () async {
      final brRes = await repository.getMonuments(dialect: 'pt_BR');
      expect(brRes.isOk, isTrue);
      expect(brRes.value.every((m) => m.isPtBr || m.dialect == 'all'), isTrue);

      final ptRes = await repository.getMonuments(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      expect(ptRes.value.every((m) => m.isPtPt || m.dialect == 'all'), isTrue);
    });

    test('getMonumentById returns monument when found, or failure when not found', () async {
      final found = await repository.getMonumentById('catedral-brasilia');
      expect(found.isOk, isTrue);
      expect(found.value.architect, 'Oscar Niemeyer');

      final notFound = await repository.getMonumentById('unknown-monument');
      expect(notFound.isOk, isFalse);
    });

    test('getArchitecturalStyles returns styles list', () async {
      final res = await repository.getArchitecturalStyles();
      expect(res.isOk, isTrue);
      expect(res.value.length, 4);
    });

    test('getArchitectureQuizzes returns quizzes list', () async {
      final res = await repository.getArchitectureQuizzes();
      expect(res.isOk, isTrue);
      expect(res.value.length, 6);
    });

    test('recordMonumentViewed logs attempt in database', () async {
      when(() => mockDb.insertListeningAttemptLog(
            exerciseId: any(named: 'exerciseId'),
            wordAccuracy: any(named: 'wordAccuracy'),
            isExactMatch: any(named: 'isExactMatch'),
            attemptedAt: any(named: 'attemptedAt'),
          )).thenAnswer((_) async => 1);

      final res = await repository.recordMonumentViewed('catedral-brasilia');
      expect(res.isOk, isTrue);

      verify(() => mockDb.insertListeningAttemptLog(
            exerciseId: 'arch-monument-catedral-brasilia',
            wordAccuracy: 1.0,
            isExactMatch: true,
            attemptedAt: any(named: 'attemptedAt'),
          )).called(1);
    });

    test('addArchitectureVocabToSrs adds card to SrsRepository', () async {
      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});

      const vocab = ArchitectVocabEntity(
        id: 'arch-pilotis',
        termPt: 'Pilotis',
        translationRu: 'Колонны-опоры',
        definition: 'Pilares estruturais',
        exampleSentence: 'Edifício sobre pilotis',
        dialect: 'all',
      );

      final res = await repository.addArchitectureVocabToSrs(vocab);
      expect(res.isOk, isTrue);

      verify(() => mockSrs.addCard(any())).called(1);
    });
  });
}
