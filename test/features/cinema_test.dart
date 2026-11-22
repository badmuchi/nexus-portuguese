import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/cinema/data/datasources/cinema_seed_data.dart';
import 'package:nexus_portuguese_app/features/cinema/data/repositories/cinema_repository_impl.dart';
import 'package:nexus_portuguese_app/features/cinema/domain/entities/cinema_quote_entity.dart';
import 'package:nexus_portuguese_app/features/cinema/domain/entities/movie_scene_entity.dart';

void main() {
  group('Cinema Entities Tests', () {
    test('MovieSceneEntity dialect helpers detect PT-BR and PT-PT correctly', () {
      const ptScene = MovieSceneEntity(
        id: 'cda',
        movieTitlePt: 'Capitães de Abril',
        movieTitleRu: 'Апрельские капитаны',
        releaseYear: 2000,
        director: 'Maria de Medeiros',
        genre: 'Histórico',
        dialect: 'pt_PT',
        region: 'Lisboa',
        iconEmoji: '🌹',
        cefrLevel: 'B2',
        synopsisRu: 'Синопсис',
        sceneContextRu: 'Контекст',
        dialogueLines: [],
        culturalKeytakeawaysRu: [],
      );

      expect(ptScene.isPtPt, isTrue);
      expect(ptScene.isPtBr, isFalse);
      expect(ptScene.dialectFlag, '🇵🇹');
      expect(ptScene.dialectLabel, 'Portugal');

      const brScene = MovieSceneEntity(
        id: 'cdd',
        movieTitlePt: 'Cidade de Deus',
        movieTitleRu: 'Город Бога',
        releaseYear: 2002,
        director: 'Fernando Meirelles',
        genre: 'Crime',
        dialect: 'pt_BR',
        region: 'Rio de Janeiro',
        iconEmoji: '🎬',
        cefrLevel: 'B1',
        synopsisRu: 'Синопсис',
        sceneContextRu: 'Контекст',
        dialogueLines: [],
        culturalKeytakeawaysRu: [],
      );

      expect(brScene.isPtBr, isTrue);
      expect(brScene.isPtPt, isFalse);
      expect(brScene.dialectFlag, '🇧🇷');
      expect(brScene.dialectLabel, 'Brasil');
    });

    test('CinemaDialogueLineEntity properties and Equatable', () {
      const line = CinemaDialogueLineEntity(
        id: 'l1',
        speakerName: 'Buscapé',
        speakerRoleRu: 'Бускапе',
        textPt: 'Se correr o bicho pega.',
        translationRu: 'Побежишь — зверь догонит.',
        slangNoteRu: 'Поговорка',
        culturalSubtextRu: 'Подтекст',
      );

      expect(line.speakerName, 'Buscapé');
      expect(line.slangNoteRu, 'Поговорка');
      expect(line.culturalSubtextRu, 'Подтекст');
    });

    test('CinemaQuoteEntity properties and dialect helpers', () {
      const quote = CinemaQuoteEntity(
        id: 'q1',
        quotePt: 'Não sei, só sei que foi assim!',
        translationRu: 'Не знаю, знаю только, что всё так и было!',
        character: 'Chicó',
        movieTitle: 'O Auto da Compadecida',
        releaseYear: 2000,
        dialect: 'pt_BR',
        popCultureImpactRu: 'Культовое оправдание',
      );

      expect(quote.isPtBr, isTrue);
      expect(quote.dialectFlag, '🇧🇷');
      expect(quote.character, 'Chicó');
    });
  });

  group('CinemaSeedData Verification Tests', () {
    test('Seed data contains rich movie scenes with dialogue and takeaways', () {
      expect(CinemaSeedData.scenes.length, greaterThanOrEqualTo(5));

      final hasPt = CinemaSeedData.scenes.any((s) => s.isPtPt);
      final hasBr = CinemaSeedData.scenes.any((s) => s.isPtBr);
      expect(hasPt, isTrue);
      expect(hasBr, isTrue);

      for (final s in CinemaSeedData.scenes) {
        expect(s.id, isNotEmpty);
        expect(s.movieTitlePt, isNotEmpty);
        expect(s.movieTitleRu, isNotEmpty);
        expect(s.director, isNotEmpty);
        expect(s.genre, isNotEmpty);
        expect(s.region, isNotEmpty);
        expect(s.synopsisRu, isNotEmpty);
        expect(s.sceneContextRu, isNotEmpty);
        expect(s.dialogueLines.length, greaterThanOrEqualTo(4));
        expect(s.culturalKeytakeawaysRu, isNotEmpty);

        for (final line in s.dialogueLines) {
          expect(line.id, isNotEmpty);
          expect(line.speakerName, isNotEmpty);
          expect(line.speakerRoleRu, isNotEmpty);
          expect(line.textPt, isNotEmpty);
          expect(line.translationRu, isNotEmpty);
        }
      }
    });

    test('Seed data famousQuotes contains iconic lines with popCultureImpactRu', () {
      expect(CinemaSeedData.famousQuotes.length, greaterThanOrEqualTo(8));

      for (final q in CinemaSeedData.famousQuotes) {
        expect(q.id, isNotEmpty);
        expect(q.quotePt, isNotEmpty);
        expect(q.translationRu, isNotEmpty);
        expect(q.character, isNotEmpty);
        expect(q.movieTitle, isNotEmpty);
        expect(q.popCultureImpactRu, isNotEmpty);
      }
    });
  });

  group('CinemaRepositoryImpl Tests', () {
    final repo = CinemaRepositoryImpl();

    test('getScenes returns all scenes or filters by dialect and genre', () async {
      final allRes = await repo.getScenes();
      expect(allRes.isOk, isTrue);
      expect(allRes.value.length, CinemaSeedData.scenes.length);

      final ptRes = await repo.getScenes(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      for (final s in ptRes.value) {
        expect(s.isPtPt, isTrue);
      }

      final crimeRes = await repo.getScenes(genre: 'Crime');
      expect(crimeRes.isOk, isTrue);
      for (final s in crimeRes.value) {
        expect(s.genre.toLowerCase().contains('crime'), isTrue);
      }
    });

    test('getSceneById returns scene or failure', () async {
      final first = CinemaSeedData.scenes.first;
      final res = await repo.getSceneById(first.id);
      expect(res.isOk, isTrue);
      expect(res.value.id, first.id);

      final notFound = await repo.getSceneById('non_existent');
      expect(notFound.isFailure, isTrue);
    });

    test('getFamousQuotes returns quotes and filters by dialect', () async {
      final allQuotes = await repo.getFamousQuotes();
      expect(allQuotes.isOk, isTrue);
      expect(allQuotes.value.length, CinemaSeedData.famousQuotes.length);

      final brQuotes = await repo.getFamousQuotes(dialect: 'pt_BR');
      expect(brQuotes.isOk, isTrue);
      for (final q in brQuotes.value) {
        expect(q.isPtBr, isTrue);
      }
    });

    test('recordSceneCompleted handles null database gracefully', () async {
      final res = await repo.recordSceneCompleted(
        sceneId: 'cidade_de_deus',
        linesPracticed: 4,
      );
      expect(res.isOk, isTrue);
    });
  });
}
