import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import 'package:nexus_portuguese_app/features/wine/data/datasources/wine_seed_data.dart';
import 'package:nexus_portuguese_app/features/wine/data/repositories/wine_repository_impl.dart';
import 'package:nexus_portuguese_app/features/wine/domain/entities/wine_entities.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback_wine',
        portuguese: 'enólogo',
        russianTranslation: 'энолог',
        partOfSpeech: 'substantivo',
        category: 'enologia',
        dialect: 'pt_PT',
        examplePortuguese: 'O enólogo avalia a acidez do vinho.',
        exampleRussian: 'Энолог оценивает кислотность вина.',
        notes: 'Termo de enologia',
        fsrsState: 'newCard',
        stability: 0,
        difficulty: 0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      ),
    );
  });

  group('Wine Entities Tests', () {
    test('WineRegionEntity dialect helpers work properly', () {
      const douroRegion = WineRegionEntity(
        id: 'douro-porto',
        name: 'Vale do Douro & Vinho do Porto',
        category: WineCategory.vinhoFortificado,
        subRegion: 'Cima Corgo',
        country: 'Portugal',
        dialect: 'pt_PT',
        shortSummary: 'Patrimônio Mundial da UNESCO...',
        fullDescription: 'Os socalcos íngremes do Alto Douro...',
        keyCastas: ['Touriga Nacional', 'Touriga Franca'],
        tastingProfile: 'Frutos pretos maduros...',
        vocabulary: [],
        audioNarration: 'Áudio narrativo',
      );

      expect(douroRegion.isPtPt, isTrue);
      expect(douroRegion.isPtBr, isFalse);

      const serraGaucha = WineRegionEntity(
        id: 'serra-gaucha',
        name: 'Vale dos Vinhedos & Serra Gaúcha',
        category: WineCategory.vinhoBrasileiroAltitude,
        subRegion: 'Bento Gonçalves',
        country: 'Brasil',
        dialect: 'pt_BR',
        shortSummary: 'Berço da vitivinicultura brasileira...',
        fullDescription: 'Imigrantes vênetos e trentinos...',
        keyCastas: ['Merlot', 'Chardonnay'],
        tastingProfile: 'Espumantes vibrantes...',
        vocabulary: [],
        audioNarration: 'Áudio narrativo',
      );

      expect(serraGaucha.isPtBr, isTrue);
      expect(serraGaucha.isPtPt, isFalse);
    });

    test('WineVocabEntity and TastingGuideEntity equality and properties', () {
      const vocab1 = WineVocabEntity(
        id: 'v1',
        termPt: 'Tanino',
        translationRu: 'Танин',
        definition: 'Composto fenólico adstringente',
        exampleSentence: 'O vinho tinto jovem tem taninos firmes.',
        dialect: 'all',
      );

      const vocab2 = WineVocabEntity(
        id: 'v1',
        termPt: 'Tanino',
        translationRu: 'Танин',
        definition: 'Composto fenólico adstringente',
        exampleSentence: 'O vinho tinto jovem tem taninos firmes.',
        dialect: 'all',
      );

      expect(vocab1, equals(vocab2));
      expect(vocab1.isPtPt, isFalse);
      expect(vocab1.isPtBr, isFalse);

      const guide = TastingGuideEntity(
        id: 'tg1',
        title: 'Exame Olfativo',
        beverageType: 'Vinho Tinto',
        visualStagePt: 'Límpido e brilhante',
        olfactoryStagePt: 'Aromas de frutos vermelhos',
        gustatoryStagePt: 'Taninos redondos',
        sommelierRecommendationPt: 'Decantar durante 30 minutos',
        subjunctiveGrammarNote: 'Caso o vinho esteja fechado, deixe que respire.',
        pairingRu: 'Carnes vermelhas maturadas',
        icon: '🍷',
      );

      expect(guide.subjunctiveGrammarNote, contains('deixe que'));
      expect(guide.pairingRu, isNotEmpty);
      expect(guide.beverageType, equals('Vinho Tinto'));
    });
  });

  group('WineSeedData Integrity Tests', () {
    test('Contains exactly 6 wine regions with complete data and vocabulary', () {
      final regions = WineSeedData.getRegions();
      expect(regions.length, equals(6));

      for (final r in regions) {
        expect(r.id, isNotEmpty);
        expect(r.name, isNotEmpty);
        expect(r.subRegion, isNotEmpty);
        expect(r.country, isNotEmpty);
        expect(r.shortSummary, isNotEmpty);
        expect(r.fullDescription, isNotEmpty);
        expect(r.keyCastas, isNotEmpty);
        expect(r.tastingProfile, isNotEmpty);
        expect(r.vocabulary, isNotEmpty);
        expect(r.audioNarration, isNotEmpty);

        for (final v in r.vocabulary) {
          expect(v.id, isNotEmpty);
          expect(v.termPt, isNotEmpty);
          expect(v.translationRu, isNotEmpty);
          expect(v.definition, isNotEmpty);
          expect(v.exampleSentence, isNotEmpty);
        }
      }
    });

    test('Contains exactly 4 tasting guides with Subjuntivo focus', () {
      final guides = WineSeedData.getTastingGuides();
      expect(guides.length, equals(4));

      for (final g in guides) {
        expect(g.id, isNotEmpty);
        expect(g.title, isNotEmpty);
        expect(g.beverageType, isNotEmpty);
        expect(g.visualStagePt, isNotEmpty);
        expect(g.olfactoryStagePt, isNotEmpty);
        expect(g.gustatoryStagePt, isNotEmpty);
        expect(g.sommelierRecommendationPt, isNotEmpty);
        expect(g.subjunctiveGrammarNote, isNotEmpty);
        expect(g.pairingRu, isNotEmpty);
        expect(g.icon, isNotEmpty);
      }
    });

    test('Contains exactly 6 quiz questions with valid options and correct indices', () {
      final quizzes = WineSeedData.getQuizzes();
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

  group('WineRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late MockSrsRepository mockSrs;
    late WineRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      mockSrs = MockSrsRepository();
      repository = WineRepositoryImpl(
        database: mockDb,
        srsRepository: mockSrs,
      );
    });

    test('getWineRegions returns full list of regions', () async {
      final result = await repository.getWineRegions();
      expect(result.isOk, isTrue);
      expect(result.value.length, equals(6));
    });

    test('getWineRegionById returns correct region or error', () async {
      final foundRes = await repository.getWineRegionById('douro-porto');
      expect(foundRes.isOk, isTrue);
      expect(foundRes.value.name, contains('Vale do Douro'));

      final notFoundRes = await repository.getWineRegionById('unknown_region');
      expect(notFoundRes.isFailure, isTrue);
    });

    test('getTastingGuides returns list of tasting guides', () async {
      final result = await repository.getTastingGuides();
      expect(result.isOk, isTrue);
      expect(result.value.length, equals(4));
    });

    test('getWineQuizzes returns list of quiz questions', () async {
      final result = await repository.getWineQuizzes();
      expect(result.isOk, isTrue);
      expect(result.value.length, equals(6));
    });

    test('recordRegionViewed records listening attempt log in database', () async {
      when(
        () => mockDb.insertListeningAttemptLog(
          exerciseId: any(named: 'exerciseId'),
          wordAccuracy: any(named: 'wordAccuracy'),
          isExactMatch: any(named: 'isExactMatch'),
          attemptedAt: any(named: 'attemptedAt'),
        ),
      ).thenAnswer((_) async => 1);

      final result = await repository.recordRegionViewed('douro-porto');
      expect(result.isOk, isTrue);

      verify(
        () => mockDb.insertListeningAttemptLog(
          exerciseId: 'wine-region-douro-porto',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: any(named: 'attemptedAt'),
        ),
      ).called(1);
    });

    test('addWineVocabToSrs delegates to SrsRepository addCard', () async {
      when(() => mockSrs.addCard(any())).thenAnswer((_) async => {});

      const vocab = WineVocabEntity(
        id: 'v_casta',
        termPt: 'Casta',
        translationRu: 'Сорт винограда',
        definition: 'Variedade de uva',
        exampleSentence: 'A Touriga Nacional é a casta rainha.',
        dialect: 'pt_PT',
      );

      final result = await repository.addWineVocabToSrs(vocab);
      expect(result.isOk, isTrue);

      verify(
        () => mockSrs.addCard(
          any(
            that: isA<SrsCardEntity>()
                .having((c) => c.id, 'id', 'wne_vocab_v_casta')
                .having((c) => c.portuguese, 'portuguese', 'Casta')
                .having((c) => c.russianTranslation, 'russian', 'Сорт винограда'),
          ),
        ),
      ).called(1);
    });
  });
}
