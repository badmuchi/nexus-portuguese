import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/ancestral/data/datasources/ancestral_seed_data.dart';
import 'package:nexus_portuguese_app/features/ancestral/data/repositories/ancestral_repository_impl.dart';
import 'package:nexus_portuguese_app/features/ancestral/domain/entities/ancestral_entities.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback_ancestral',
        portuguese: 'mutirão',
        russianTranslation: 'коллективная взаимопомощь',
        partOfSpeech: 'substantivo',
        category: 'ancestralidade',
        dialect: 'pt_BR',
        examplePortuguese: 'Fizemos um mutirão para erguer a casa.',
        exampleRussian: 'Мы собрали коллективный труд, чтобы построить дом.',
        notes: 'Termo comunitário',
        fsrsState: 'newCard',
        stability: 0,
        difficulty: 0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      ),
    );
  });

  group('Ancestral Entities Tests', () {
    test('TraditionalCommunityEntity dialect helpers work properly', () {
      const ribeirinhos = TraditionalCommunityEntity(
        id: 'ribeirinhos-amazonas',
        title: 'Ribeirinhos dos Rios Solimões e Negro',
        category: CommunityCategory.ribeirinhos,
        region: 'Bacia Amazônica',
        country: 'Brasil',
        dialect: 'pt_BR',
        shortSummary: 'Populações tradicionais...',
        fullDescription: 'Os povos ribeirinhos...',
        lifestyleHighlights: ['Habitações em palafitas'],
        vocabulary: [],
        audioNarration: 'Áudio narrativo',
      );

      expect(ribeirinhos.isPtBr, isTrue);
      expect(ribeirinhos.isPtPt, isFalse);

      const pastores = TraditionalCommunityEntity(
        id: 'pastores-serra-estrela',
        title: 'Pastores da Transumância',
        category: CommunityCategory.pastores,
        region: 'Serra da Estrela',
        country: 'Portugal',
        dialect: 'pt_PT',
        shortSummary: 'A transumância milenar...',
        fullDescription: 'A transumância é...',
        lifestyleHighlights: ['Marcha pastoral'],
        vocabulary: [],
        audioNarration: 'Áudio narrativo',
      );

      expect(pastores.isPtPt, isTrue);
      expect(pastores.isPtBr, isFalse);
    });

    test('AncestralVocabEntity and HerbalRemedyEntity equality and properties', () {
      const vocab1 = AncestralVocabEntity(
        id: 'v1',
        termPt: 'Palafita',
        translationRu: 'Дом на сваях',
        definition: 'Casa sobre estacas',
        exampleSentence: 'A palafita resiste à cheia.',
        dialect: 'all',
      );

      const vocab2 = AncestralVocabEntity(
        id: 'v1',
        termPt: 'Palafita',
        translationRu: 'Дом на сваях',
        definition: 'Casa sobre estacas',
        exampleSentence: 'A palafita resiste à cheia.',
        dialect: 'all',
      );

      expect(vocab1, equals(vocab2));
      expect(vocab1.isPtPt, isFalse);
      expect(vocab1.isPtBr, isFalse);

      const remedy = HerbalRemedyEntity(
        id: 'hr1',
        plantNamePt: 'Infusão de Poejo',
        nameRu: 'Настой мяты блошиной',
        scientificName: 'Mentha pulegium',
        traditionalUsePt: 'Facilitar a digestão',
        preparationInstructionsPt: 'Ferva a água e deite as folhas.',
        imperativeGrammarNote: 'Imperativo Afirmativo: Ferva, Deite',
        precautionsRu: 'Evitar em doses elevadas',
      );

      expect(remedy.imperativeGrammarNote, contains('Imperativo'));
      expect(remedy.nameRu, isNotEmpty);
      expect(remedy.scientificName, equals('Mentha pulegium'));
    });
  });

  group('AncestralSeedData Integrity Tests', () {
    test('Contains exactly 6 traditional communities with complete data and vocabulary', () {
      final communities = AncestralSeedData.getCommunities();
      expect(communities.length, equals(6));

      for (final c in communities) {
        expect(c.id, isNotEmpty);
        expect(c.title, isNotEmpty);
        expect(c.region, isNotEmpty);
        expect(c.country, isNotEmpty);
        expect(c.shortSummary, isNotEmpty);
        expect(c.fullDescription, isNotEmpty);
        expect(c.lifestyleHighlights, isNotEmpty);
        expect(c.vocabulary, isNotEmpty);
        expect(c.audioNarration, isNotEmpty);

        for (final v in c.vocabulary) {
          expect(v.id, isNotEmpty);
          expect(v.termPt, isNotEmpty);
          expect(v.translationRu, isNotEmpty);
          expect(v.definition, isNotEmpty);
          expect(v.exampleSentence, isNotEmpty);
        }
      }
    });

    test('Contains exactly 4 herbal remedies with Imperativo grammar notes', () {
      final remedies = AncestralSeedData.getHerbalRemedies();
      expect(remedies.length, equals(4));

      for (final r in remedies) {
        expect(r.id, isNotEmpty);
        expect(r.plantNamePt, isNotEmpty);
        expect(r.nameRu, isNotEmpty);
        expect(r.scientificName, isNotEmpty);
        expect(r.traditionalUsePt, isNotEmpty);
        expect(r.preparationInstructionsPt, isNotEmpty);
        expect(r.imperativeGrammarNote, contains('Imperativo'));
        expect(r.precautionsRu, isNotEmpty);
        expect(r.icon, isNotEmpty);
      }
    });

    test('Contains exactly 6 quiz questions with valid options and correct indices', () {
      final quizzes = AncestralSeedData.getQuizzes();
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

  group('AncestralRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late MockSrsRepository mockSrs;
    late AncestralRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      mockSrs = MockSrsRepository();
      repository = AncestralRepositoryImpl(
        database: mockDb,
        srsRepository: mockSrs,
      );
    });

    test('getCommunities returns full list of communities', () async {
      final result = await repository.getCommunities();
      expect(result.isOk, isTrue);
      expect(result.value.length, equals(6));
    });

    test('getCommunityById returns correct community or error', () async {
      final foundRes = await repository.getCommunityById('ribeirinhos-amazonas');
      expect(foundRes.isOk, isTrue);
      expect(foundRes.value.title, contains('Ribeirinhos'));

      final notFoundRes = await repository.getCommunityById('unknown_community');
      expect(notFoundRes.isFailure, isTrue);
    });

    test('getHerbalRemedies returns list of herbal remedies', () async {
      final result = await repository.getHerbalRemedies();
      expect(result.isOk, isTrue);
      expect(result.value.length, equals(4));
    });

    test('getAncestralQuizzes returns list of quiz questions', () async {
      final result = await repository.getAncestralQuizzes();
      expect(result.isOk, isTrue);
      expect(result.value.length, equals(6));
    });

    test('recordCommunityViewed records listening attempt log in database', () async {
      when(
        () => mockDb.insertListeningAttemptLog(
          exerciseId: any(named: 'exerciseId'),
          wordAccuracy: any(named: 'wordAccuracy'),
          isExactMatch: any(named: 'isExactMatch'),
          attemptedAt: any(named: 'attemptedAt'),
        ),
      ).thenAnswer((_) async => 1);

      final result = await repository.recordCommunityViewed('ribeirinhos-amazonas');
      expect(result.isOk, isTrue);

      verify(
        () => mockDb.insertListeningAttemptLog(
          exerciseId: 'ancestral-community-ribeirinhos-amazonas',
          wordAccuracy: 1.0,
          isExactMatch: true,
          attemptedAt: any(named: 'attemptedAt'),
        ),
      ).called(1);
    });

    test('addAncestralVocabToSrs delegates to SrsRepository addCard', () async {
      when(() => mockSrs.addCard(any())).thenAnswer((_) async => {});

      const vocab = AncestralVocabEntity(
        id: 'v_gibao',
        termPt: 'Gibão',
        translationRu: 'Кожаная куртка',
        definition: 'Casaco de couro de vaqueiro',
        exampleSentence: 'O gibão protege contra espinhos.',
        dialect: 'pt_BR',
      );

      final result = await repository.addAncestralVocabToSrs(vocab);
      expect(result.isOk, isTrue);

      verify(
        () => mockSrs.addCard(
          any(
            that: isA<SrsCardEntity>()
                .having((c) => c.id, 'id', 'anc_vocab_v_gibao')
                .having((c) => c.portuguese, 'portuguese', 'Gibão')
                .having((c) => c.russianTranslation, 'russian', 'Кожаная куртка'),
          ),
        ),
      ).called(1);
    });
  });
}
