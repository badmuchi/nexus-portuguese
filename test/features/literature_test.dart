import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/literature/data/datasources/literature_seed_data.dart';
import 'package:nexus_portuguese_app/features/literature/data/repositories/literature_repository_impl.dart';
import 'package:nexus_portuguese_app/features/literature/domain/entities/literary_work_entity.dart';

void main() {
  group('Literature Entities Tests', () {
    test('LiteraryWorkEntity dialect helpers detect PT-BR and PT-PT correctly', () {
      const ptWork = LiteraryWorkEntity(
        id: 'tabacaria',
        titlePt: 'Tabacaria',
        titleRu: 'Табачная лавка',
        authorName: 'Fernando Pessoa',
        authorBioRu: 'Великий поэт',
        epochOrMovementRu: 'Модернизм',
        dialect: 'pt_PT',
        genre: 'Poesia',
        coverEmoji: '🚬',
        cefrLevel: 'B2',
        analysisContextRu: 'Контекст',
        passages: [],
        vocabularyCards: [],
      );

      expect(ptWork.isPtPt, isTrue);
      expect(ptWork.isPtBr, isFalse);
      expect(ptWork.dialectFlag, '🇵🇹');
      expect(ptWork.dialectLabel, 'Portugal');

      const brWork = LiteraryWorkEntity(
        id: 'bras_cubas',
        titlePt: 'Memórias Póstumas',
        titleRu: 'Посмертные записки',
        authorName: 'Machado de Assis',
        authorBioRu: 'Классик',
        epochOrMovementRu: 'Реализм',
        dialect: 'pt_BR',
        genre: 'Romance',
        coverEmoji: '🪦',
        cefrLevel: 'B2',
        analysisContextRu: 'Контекст',
        passages: [],
        vocabularyCards: [],
      );

      expect(brWork.isPtBr, isTrue);
      expect(brWork.isPtPt, isFalse);
      expect(brWork.dialectFlag, '🇧🇷');
      expect(brWork.dialectLabel, 'Brasil');
    });

    test('LiteraryPassageEntity properties and Equatable', () {
      const passage = LiteraryPassageEntity(
        id: 'p1',
        originalPt: 'Não sou nada.',
        translationRu: 'Я — ничто.',
        grammaticalNotesRu: 'Dupla negação',
        poeticDeviceRu: 'Paradoxo',
        audioSnippetText: 'Não sou nada.',
      );

      expect(passage.id, 'p1');
      expect(passage.originalPt, 'Não sou nada.');
      expect(passage.translationRu, 'Я — ничто.');
      expect(passage.grammaticalNotesRu, 'Dupla negação');
      expect(passage.poeticDeviceRu, 'Paradoxo');
    });

    test('LiteraryVocabularyEntity properties and Equatable', () {
      const vocab = LiteraryVocabularyEntity(
        id: 'v1',
        wordPt: 'Desassossego',
        translationRu: 'Беспокойство',
        partOfSpeech: 'Substantivo',
        contextSentencePt: 'O livro do desassossego.',
        contextSentenceRu: 'Книга непокоя.',
        etymologyRu: 'Des + assossego',
      );

      expect(vocab.wordPt, 'Desassossego');
      expect(vocab.translationRu, 'Беспокойство');
      expect(vocab.partOfSpeech, 'Substantivo');
      expect(vocab.etymologyRu, 'Des + assossego');
    });

    test('LiteraryQuoteEntity properties and dialect helpers', () {
      const quote = LiteraryQuoteEntity(
        id: 'q1',
        quotePt: 'Se podes olhar, vê.',
        translationRu: 'Если можешь смотреть — смотри.',
        authorName: 'José Saramago',
        workTitle: 'Ensaio sobre a Cegueira',
        publicationYear: 1995,
        dialect: 'pt_PT',
        philosophicalInsightRu: 'Философия осознанности',
      );

      expect(quote.isPtPt, isTrue);
      expect(quote.isPtBr, isFalse);
      expect(quote.dialectFlag, '🇵🇹');
      expect(quote.authorName, 'José Saramago');
    });
  });

  group('LiteratureSeedData Verification Tests', () {
    test('works contains rich literary masterpieces with passages and vocabulary', () {
      expect(LiteratureSeedData.works.length, greaterThanOrEqualTo(6));

      final hasPt = LiteratureSeedData.works.any((w) => w.isPtPt);
      final hasBr = LiteratureSeedData.works.any((w) => w.isPtBr);
      expect(hasPt, isTrue);
      expect(hasBr, isTrue);

      for (final w in LiteratureSeedData.works) {
        expect(w.id, isNotEmpty);
        expect(w.titlePt, isNotEmpty);
        expect(w.titleRu, isNotEmpty);
        expect(w.authorName, isNotEmpty);
        expect(w.authorBioRu, isNotEmpty);
        expect(w.epochOrMovementRu, isNotEmpty);
        expect(w.genre, isNotEmpty);
        expect(w.coverEmoji, isNotEmpty);
        expect(w.analysisContextRu, isNotEmpty);
        expect(w.passages, isNotEmpty);
        expect(w.vocabularyCards, isNotEmpty);

        for (final p in w.passages) {
          expect(p.id, isNotEmpty);
          expect(p.originalPt, isNotEmpty);
          expect(p.translationRu, isNotEmpty);
          expect(p.grammaticalNotesRu, isNotEmpty);
          expect(p.audioSnippetText, isNotEmpty);
        }

        for (final v in w.vocabularyCards) {
          expect(v.id, isNotEmpty);
          expect(v.wordPt, isNotEmpty);
          expect(v.translationRu, isNotEmpty);
          expect(v.partOfSpeech, isNotEmpty);
          expect(v.contextSentencePt, isNotEmpty);
        }
      }
    });

    test('famousQuotes contains iconic literary lines with insights', () {
      expect(LiteratureSeedData.famousQuotes.length, greaterThanOrEqualTo(6));

      for (final q in LiteratureSeedData.famousQuotes) {
        expect(q.id, isNotEmpty);
        expect(q.quotePt, isNotEmpty);
        expect(q.translationRu, isNotEmpty);
        expect(q.authorName, isNotEmpty);
        expect(q.workTitle, isNotEmpty);
        expect(q.philosophicalInsightRu, isNotEmpty);
      }
    });
  });

  group('LiteratureRepositoryImpl Tests', () {
    final repo = LiteratureRepositoryImpl();

    test('getWorks returns all works or filters by dialect and genre', () async {
      final allRes = await repo.getWorks();
      expect(allRes.isOk, isTrue);
      expect(allRes.value.length, LiteratureSeedData.works.length);

      final ptRes = await repo.getWorks(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      for (final w in ptRes.value) {
        expect(w.isPtPt, isTrue);
      }

      final poetryRes = await repo.getWorks(genre: 'Poesia');
      expect(poetryRes.isOk, isTrue);
      for (final w in poetryRes.value) {
        expect(w.genre.toLowerCase().contains('poesia'), isTrue);
      }
    });

    test('getWorkById returns requested work or fails for unknown id', () async {
      final res = await repo.getWorkById('tabacaria');
      expect(res.isOk, isTrue);
      expect(res.value.titlePt, 'Tabacaria');

      final failRes = await repo.getWorkById('non_existent');
      expect(failRes.isFailure, isTrue);
    });

    test('getFamousQuotes returns quotes and filters by dialect', () async {
      final allQuotes = await repo.getFamousQuotes();
      expect(allQuotes.isOk, isTrue);
      expect(allQuotes.value.length, LiteratureSeedData.famousQuotes.length);

      final brQuotes = await repo.getFamousQuotes(dialect: 'pt_BR');
      expect(brQuotes.isOk, isTrue);
      for (final q in brQuotes.value) {
        expect(q.isPtBr, isTrue);
      }
    });

    test('recordWorkRead runs gracefully with null database', () async {
      final res = await repo.recordWorkRead(
        workId: 'tabacaria',
        passagesRead: 3,
      );
      expect(res.isOk, isTrue);
    });
  });
}
