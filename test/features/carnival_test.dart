import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/carnival/data/datasources/carnival_seed_data.dart';
import 'package:nexus_portuguese_app/features/carnival/data/repositories/carnival_repository_impl.dart';
import 'package:nexus_portuguese_app/features/carnival/domain/entities/carnival_entities.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback_carnival',
        portuguese: 'alfaia',
        russianTranslation: 'барабан альфайя',
        partOfSpeech: 'substantivo',
        category: 'carnaval',
        dialect: 'pt_BR',
        examplePortuguese: 'O trovão da alfaia fez tremer o chão.',
        exampleRussian: 'Гром альфайи заставил землю дрожать.',
        notes: 'Termo de maracatu',
        fsrsState: 'newCard',
        stability: 0,
        difficulty: 0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      ),
    );
  });

  group('Carnival Entities Tests', () {
    test('CarnivalTraditionEntity dialect helpers work properly', () {
      const frevo = CarnivalTraditionEntity(
        id: 'frevo-olinda',
        title: 'Frevo de Olinda & Recife',
        category: CarnivalTraditionCategory.frevo,
        region: 'Pernambuco',
        country: 'Brasil',
        dialect: 'pt_BR',
        shortSummary: 'Ritmo frenético...',
        fullDescription: 'O Frevo surgiu...',
        keyInstruments: ['Metais'],
        culturalRituals: ['Passos acrobáticos'],
        vocabulary: [],
        audioNarration: 'Áudio narrativo',
      );

      expect(frevo.isPtBr, isTrue);
      expect(frevo.isPtPt, isFalse);

      const entrudo = CarnivalTraditionEntity(
        id: 'entrudo-torres-podence',
        title: 'Carnaval de Torres Vedras',
        category: CarnivalTraditionCategory.entrudoPortugues,
        region: 'Torres Vedras e Podence',
        country: 'Portugal',
        dialect: 'pt_PT',
        shortSummary: 'A folia lusa...',
        fullDescription: 'O Carnaval em Portugal...',
        keyInstruments: ['Chocalhos'],
        culturalRituals: ['A Chocalhada'],
        vocabulary: [],
        audioNarration: 'Áudio narrativo',
      );

      expect(entrudo.isPtPt, isTrue);
      expect(entrudo.isPtBr, isFalse);
    });

    test('CarnivalVocabEntity and RhythmWorkshopEntity equality and properties', () {
      const vocab1 = CarnivalVocabEntity(
        id: 'v1',
        termPt: 'Sombrinha',
        translationRu: 'Зонтик для фрево',
        definition: 'Elemento coreográfico',
        exampleSentence: 'A sombrinha equilibra o passista.',
        dialect: 'pt_BR',
      );

      const vocab2 = CarnivalVocabEntity(
        id: 'v1',
        termPt: 'Sombrinha',
        translationRu: 'Зонтик для фрево',
        definition: 'Elemento coreográfico',
        exampleSentence: 'A sombrinha equilibra o passista.',
        dialect: 'pt_BR',
      );

      expect(vocab1, equals(vocab2));
      expect(vocab1.isPtPt, isFalse);
      expect(vocab1.isPtBr, isTrue);

      const workshop = RhythmWorkshopEntity(
        id: 'w1',
        title: 'Compasso Rasgado no Frevo',
        genre: 'Frevo de Rua',
        dialect: 'pt_BR',
        tempoBpm: 152,
        rhythmicPatternRu: 'Sincopado 2/4',
        lyricsSamplePt: 'A multidão vem frevendo!',
        lyricsTranslationRu: 'Толпа закипает!',
        continuousActionGrammarNote: 'Gerúndio contínuo: vem frevendo',
      );

      expect(workshop.isPtBr, isTrue);
      expect(workshop.isPtPt, isFalse);
      expect(workshop.continuousActionGrammarNote, contains('Gerúndio'));
      expect(workshop.tempoBpm, equals(152));
    });
  });

  group('CarnivalSeedData Integrity Tests', () {
    test('Contains exactly 6 carnival traditions with complete data and vocabulary', () {
      final traditions = CarnivalSeedData.getTraditions();
      expect(traditions.length, equals(6));

      for (final t in traditions) {
        expect(t.id, isNotEmpty);
        expect(t.title, isNotEmpty);
        expect(t.region, isNotEmpty);
        expect(t.country, isNotEmpty);
        expect(t.shortSummary, isNotEmpty);
        expect(t.fullDescription, isNotEmpty);
        expect(t.keyInstruments, isNotEmpty);
        expect(t.culturalRituals, isNotEmpty);
        expect(t.vocabulary, isNotEmpty);
        expect(t.audioNarration, isNotEmpty);

        for (final v in t.vocabulary) {
          expect(v.id, isNotEmpty);
          expect(v.termPt, isNotEmpty);
          expect(v.translationRu, isNotEmpty);
          expect(v.definition, isNotEmpty);
          expect(v.exampleSentence, isNotEmpty);
        }
      }
    });

    test('Contains exactly 4 rhythm workshops with continuous action notes', () {
      final workshops = CarnivalSeedData.getRhythmWorkshops();
      expect(workshops.length, equals(4));

      for (final w in workshops) {
        expect(w.id, isNotEmpty);
        expect(w.title, isNotEmpty);
        expect(w.genre, isNotEmpty);
        expect(w.tempoBpm, greaterThan(80));
        expect(w.rhythmicPatternRu, isNotEmpty);
        expect(w.lyricsSamplePt, isNotEmpty);
        expect(w.lyricsTranslationRu, isNotEmpty);
        expect(w.continuousActionGrammarNote, isNotEmpty);
        expect(w.icon, isNotEmpty);
      }
    });

    test('Contains exactly 6 quiz questions with valid options and correct indices', () {
      final quizzes = CarnivalSeedData.getQuizzes();
      expect(quizzes.length, equals(6));

      for (final q in quizzes) {
        expect(q.id, isNotEmpty);
        expect(q.question, isNotEmpty);
        expect(q.options.length, equals(4));
        expect(q.correctIndex, inInclusiveRange(0, 3));
        expect(q.explanation, isNotEmpty);
      }
    });
  });

  group('CarnivalRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late MockSrsRepository mockSrs;
    late CarnivalRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      mockSrs = MockSrsRepository();
      repository = CarnivalRepositoryImpl(
        database: mockDb,
        srsRepository: mockSrs,
      );
    });

    test('getTraditions returns full list of traditions', () async {
      final result = await repository.getTraditions();
      expect(result.isOk, isTrue);
      expect(result.value.length, equals(6));
    });

    test('getTraditionById returns correct tradition or error', () async {
      final foundRes = await repository.getTraditionById('frevo-olinda');
      expect(foundRes.isOk, isTrue);
      expect(foundRes.value.title, contains('Frevo'));

      final notFoundRes = await repository.getTraditionById('unknown_tradition');
      expect(notFoundRes.isFailure, isTrue);
    });

    test('getRhythmWorkshops returns list of rhythm workshops', () async {
      final result = await repository.getRhythmWorkshops();
      expect(result.isOk, isTrue);
      expect(result.value.length, equals(4));
    });

    test('getCarnivalQuizzes returns list of quiz questions', () async {
      final result = await repository.getCarnivalQuizzes();
      expect(result.isOk, isTrue);
      expect(result.value.length, equals(6));
    });

    test('recordTraditionViewed records listening attempt log in database', () async {
      when(
        () => mockDb.insertListeningAttemptLog(
          exerciseId: any(named: 'exerciseId'),
          wordAccuracy: any(named: 'wordAccuracy'),
          isExactMatch: any(named: 'isExactMatch'),
          attemptedAt: any(named: 'attemptedAt'),
        ),
      ).thenAnswer((_) async => 1);

      final result = await repository.recordTraditionViewed('frevo-olinda');
      expect(result.isOk, isTrue);

      verify(
        () => mockDb.insertListeningAttemptLog(
          exerciseId: 'carnival-tradition-frevo-olinda',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: any(named: 'attemptedAt'),
        ),
      ).called(1);
    });

    test('addCarnivalVocabToSrs delegates to SrsRepository addCard', () async {
      when(() => mockSrs.addCard(any())).thenAnswer((_) async => {});

      const vocab = CarnivalVocabEntity(
        id: 'v_cuica',
        termPt: 'Cuíca',
        translationRu: 'Куика',
        definition: 'Instrumento de fricção',
        exampleSentence: 'O choro da cuíca abriu o desfile.',
        dialect: 'pt_BR',
      );

      final result = await repository.addCarnivalVocabToSrs(vocab);
      expect(result.isOk, isTrue);

      verify(
        () => mockSrs.addCard(
          any(
            that: isA<SrsCardEntity>()
                .having((c) => c.id, 'id', 'crn_vocab_v_cuica')
                .having((c) => c.portuguese, 'portuguese', 'Cuíca')
                .having((c) => c.russianTranslation, 'russian', 'Куика'),
          ),
        ),
      ).called(1);
    });
  });
}
