import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/features/art/data/datasources/art_seed_data.dart';
import 'package:nexus_portuguese_app/features/art/data/repositories/art_repository_impl.dart';
import 'package:nexus_portuguese_app/features/art/domain/entities/art_entities.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback_art',
        portuguese: 'tela',
        russianTranslation: 'холст',
        partOfSpeech: 'substantivo',
        category: 'arte',
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

  group('Art Entities Tests', () {
    test('ArtworkEntity dialect helpers work correctly for PT-BR and PT-PT', () {
      const brArt = ArtworkEntity(
        id: 'art_br',
        titlePt: 'Abaporu',
        titleRu: 'Абапору',
        artistName: 'Tarsila',
        yearRu: '1928',
        period: ArtPeriod.modernism,
        dialect: 'pt_BR',
        techniquePt: 'Óleo',
        techniqueRu: 'Масло',
        locationRu: 'MALBA',
        coverEmoji: '🦶',
        descriptionRu: 'Описание',
        curatorAnalysisRu: 'Разбор',
      );

      expect(brArt.isPtBr, isTrue);
      expect(brArt.isPtPt, isFalse);
      expect(brArt.dialectFlag, '🇧🇷');
      expect(brArt.dialectLabel, 'Brasil');

      const ptArt = ArtworkEntity(
        id: 'art_pt',
        titlePt: 'Painel',
        titleRu: 'Панно',
        artistName: 'Jorge',
        yearRu: '1910',
        period: ArtPeriod.azulejaria,
        dialect: 'pt_PT',
        techniquePt: 'Azulejo',
        techniqueRu: 'Изразец',
        locationRu: 'Porto',
        coverEmoji: '🟦',
        descriptionRu: 'Описание',
        curatorAnalysisRu: 'Разбор',
      );

      expect(ptArt.isPtPt, isTrue);
      expect(ptArt.isPtBr, isFalse);
      expect(ptArt.dialectFlag, '🇵🇹');
      expect(ptArt.dialectLabel, 'Portugal');
    });

    test('ArtStyleEntity and ArtPeriodExtension properties', () {
      expect(ArtPeriod.azulejaria.shortName, 'Азулежу');
      expect(ArtPeriod.colonialBaroque.shortName, 'Барокко');
      expect(ArtPeriod.modernism.shortName, 'Модернизм');
      expect(ArtPeriod.contemporaryAndStreetArt.shortName, 'Стрит-арт');

      const style = ArtStyleEntity(
        id: 'st_test',
        namePt: 'Azulejaria',
        nameRu: 'Азулежу',
        coverEmoji: '🟦',
        country: 'Portugal',
        periodRu: 'XVI век',
        descriptionRu: 'Описание',
        hallmarksRu: ['Сине-белый цвет'],
      );

      expect(style.country, 'Portugal');
      expect(style.hallmarksRu.length, 1);
    });

    test('ArtQuizQuestion correctOptionText returns correct string', () {
      const q = ArtQuizQuestion(
        id: 'q1',
        questionPt: 'Quem pintou?',
        questionRu: 'Кто написал?',
        optionsPt: ['Tarsila', 'Portinari'],
        correctOptionIndex: 0,
        explanationRu: 'Объяснение',
      );

      expect(q.correctOptionText, 'Tarsila');
    });
  });

  group('Art Seed Data Integrity', () {
    test('contains 6 masterpieces with complete metadata and vocabulary', () {
      final artworks = ArtSeedData.getArtworks();
      expect(artworks.length, 6);

      for (final a in artworks) {
        expect(a.id, isNotEmpty);
        expect(a.titlePt, isNotEmpty);
        expect(a.titleRu, isNotEmpty);
        expect(a.artistName, isNotEmpty);
        expect(a.techniquePt, isNotEmpty);
        expect(a.locationRu, isNotEmpty);
        expect(a.curatorAnalysisRu, isNotEmpty);
        expect(a.keyVocabulary, isNotEmpty);
      }
    });

    test('contains 4 rich art styles and 6 quizzes', () {
      final styles = ArtSeedData.getArtStyles();
      expect(styles.length, 4);

      final quizzes = ArtSeedData.getArtQuizzes();
      expect(quizzes.length, 6);

      for (final q in quizzes) {
        expect(q.correctOptionIndex, inInclusiveRange(0, q.optionsPt.length - 1));
        expect(q.correctOptionText, isNotEmpty);
      }
    });
  });

  group('ArtRepositoryImpl Tests', () {
    late ArtRepositoryImpl repository;
    late MockSrsRepository mockSrs;

    setUp(() {
      mockSrs = MockSrsRepository();
      repository = ArtRepositoryImpl(srsRepository: mockSrs);
    });

    test('getArtworks returns all and filters by period and dialect', () async {
      final allRes = await repository.getArtworks();
      expect(allRes.isOk, isTrue);
      expect(allRes.value.length, 6);

      final modernRes = await repository.getArtworks(period: ArtPeriod.modernism);
      expect(modernRes.isOk, isTrue);
      expect(modernRes.value.every((a) => a.period == ArtPeriod.modernism), isTrue);

      final ptRes = await repository.getArtworks(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      expect(ptRes.value.every((a) => a.isPtPt || a.dialect == 'all'), isTrue);
    });

    test('getArtworkById finds artwork and fails for unknown id', () async {
      final found = await repository.getArtworkById('art_abaporu');
      expect(found.isOk, isTrue);
      expect(found.value.artistName, contains('Tarsila'));

      final fail = await repository.getArtworkById('unknown_id');
      expect(fail.isOk, isFalse);
    });

    test('getArtStyles and getArtQuizzes return seed lists', () async {
      final stylesRes = await repository.getArtStyles();
      expect(stylesRes.isOk, isTrue);
      expect(stylesRes.value.length, 4);

      final quizzesRes = await repository.getArtQuizzes();
      expect(quizzesRes.isOk, isTrue);
      expect(quizzesRes.value.length, 6);
    });

    test('recordArtworkViewed succeeds without database', () async {
      final res = await repository.recordArtworkViewed('art_abaporu');
      expect(res.isOk, isTrue);
    });

    test('addArtVocabToSrs delegates to SrsRepository', () async {
      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});

      final vocab = ArtSeedData.getArtworks().first.keyVocabulary.first;
      final res = await repository.addArtVocabToSrs(vocab, dialect: 'pt_BR');

      expect(res.isOk, isTrue);
      verify(() => mockSrs.addCard(any())).called(1);
    });
  });
}
