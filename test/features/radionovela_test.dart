import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/radionovela/data/datasources/radio_novela_seed_data.dart';
import 'package:nexus_portuguese_app/features/radionovela/data/repositories/radio_novela_repository_impl.dart';
import 'package:nexus_portuguese_app/features/radionovela/domain/entities/radio_novela_entities.dart';

void main() {
  group('RadioNovela Entities Tests', () {
    test('AudioDramaEntity dialect helpers detect PT-BR and PT-PT correctly', () {
      const ptDrama = AudioDramaEntity(
        id: 'alfama',
        titlePt: 'O Mistério da Alfama',
        titleRu: 'Тайна Алфамы',
        genre: 'Mistério',
        setting: 'Lisboa',
        dialect: 'pt_PT',
        coverEmoji: '🕵️‍♂️',
        ambientSoundName: 'rain',
        ambientSoundRu: 'Дождь',
        synopsisRu: 'Синопсис',
        cefrLevel: 'B2',
        characters: [],
        scenes: [],
      );

      expect(ptDrama.isPtPt, isTrue);
      expect(ptDrama.isPtBr, isFalse);
      expect(ptDrama.dialectFlag, '🇵🇹');
      expect(ptDrama.dialectLabel, 'Portugal');

      const brDrama = AudioDramaEntity(
        id: 'sertao',
        titlePt: 'Amor no Sertão',
        titleRu: 'Любовь в сертане',
        genre: 'Romance',
        setting: 'Bahia',
        dialect: 'pt_BR',
        coverEmoji: '🌵',
        ambientSoundName: 'wind',
        ambientSoundRu: 'Ветер',
        synopsisRu: 'Синопсис',
        cefrLevel: 'B1',
        characters: [],
        scenes: [],
      );

      expect(brDrama.isPtBr, isTrue);
      expect(brDrama.isPtPt, isFalse);
      expect(brDrama.dialectFlag, '🇧🇷');
      expect(brDrama.dialectLabel, 'Brasil');
    });

    test('DramaCharacterEntity properties and Equatable', () {
      const character = DramaCharacterEntity(
        id: 'duarte',
        namePt: 'Inspetor Duarte',
        roleRu: 'Следователь',
        voiceEmoji: '🕵️‍♂️',
        accentNoteRu: 'Лиссабонский акцент',
      );

      expect(character.id, 'duarte');
      expect(character.namePt, 'Inspetor Duarte');
      expect(character.voiceEmoji, '🕵️‍♂️');
    });

    test('DramaLineEntity properties and Equatable', () {
      const line = DramaLineEntity(
        id: 'l1',
        characterId: 'duarte',
        characterName: 'Inspetor Duarte',
        textPt: 'Boa noite.',
        translationRu: 'Добрый вечер.',
        stageDirectionRu: 'Тихо садится',
        slangOrIdiomNoteRu: 'Идиома',
        audioSnippetText: 'Boa noite.',
      );

      expect(line.characterId, 'duarte');
      expect(line.stageDirectionRu, 'Тихо садится');
      expect(line.slangOrIdiomNoteRu, 'Идиома');
    });

    test('DramaInteractiveChoice properties', () {
      const choice = DramaInteractiveChoice(
        id: 'c1',
        promptRu: 'Что сделать?',
        optionPt: 'Abrir a porta',
        optionRu: 'Открыть дверь',
        consequencePt: 'A porta abre-se.',
        consequenceRu: 'Дверь открывается.',
      );

      expect(choice.id, 'c1');
      expect(choice.optionPt, 'Abrir a porta');
      expect(choice.consequencePt, 'A porta abre-se.');
    });
  });

  group('RadioNovelaSeedData Verification Tests', () {
    test('dramas contains rich audio drama episodes with scenes and lines', () {
      expect(RadioNovelaSeedData.dramas.length, greaterThanOrEqualTo(4));

      final hasPt = RadioNovelaSeedData.dramas.any((d) => d.isPtPt);
      final hasBr = RadioNovelaSeedData.dramas.any((d) => d.isPtBr);
      expect(hasPt, isTrue);
      expect(hasBr, isTrue);

      for (final drama in RadioNovelaSeedData.dramas) {
        expect(drama.id, isNotEmpty);
        expect(drama.titlePt, isNotEmpty);
        expect(drama.titleRu, isNotEmpty);
        expect(drama.genre, isNotEmpty);
        expect(drama.setting, isNotEmpty);
        expect(drama.coverEmoji, isNotEmpty);
        expect(drama.ambientSoundRu, isNotEmpty);
        expect(drama.synopsisRu, isNotEmpty);
        expect(drama.characters.length, greaterThanOrEqualTo(2));
        expect(drama.scenes, isNotEmpty);

        for (final s in drama.scenes) {
          expect(s.id, isNotEmpty);
          expect(s.sceneTitlePt, isNotEmpty);
          expect(s.lines.length, greaterThanOrEqualTo(2));

          for (final line in s.lines) {
            expect(line.id, isNotEmpty);
            expect(line.characterName, isNotEmpty);
            expect(line.textPt, isNotEmpty);
            expect(line.translationRu, isNotEmpty);
            expect(line.audioSnippetText, isNotEmpty);
          }
        }
      }
    });
  });

  group('RadioNovelaRepositoryImpl Tests', () {
    final repo = RadioNovelaRepositoryImpl();

    test('getDramas returns all dramas or filters by dialect and genre', () async {
      final allRes = await repo.getDramas();
      expect(allRes.isOk, isTrue);
      expect(allRes.value.length, RadioNovelaSeedData.dramas.length);

      final ptRes = await repo.getDramas(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      for (final d in ptRes.value) {
        expect(d.isPtPt, isTrue);
      }

      final mysteryRes = await repo.getDramas(genre: 'Mistério');
      expect(mysteryRes.isOk, isTrue);
      for (final d in mysteryRes.value) {
        expect(d.genre.toLowerCase().contains('mistério'), isTrue);
      }
    });

    test('getDramaById returns requested drama or fails for unknown id', () async {
      final res = await repo.getDramaById('misterio_alfama');
      expect(res.isOk, isTrue);
      expect(res.value.titlePt, 'O Mistério da Alfama');

      final failRes = await repo.getDramaById('non_existent');
      expect(failRes.isFailure, isTrue);
    });

    test('recordDramaCompleted runs gracefully with null database', () async {
      final res = await repo.recordDramaCompleted(
        dramaId: 'misterio_alfama',
        scenesFinished: 1,
      );
      expect(res.isOk, isTrue);
    });
  });
}
