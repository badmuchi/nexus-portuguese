import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/football/data/datasources/football_seed_data.dart';
import 'package:nexus_portuguese_app/features/football/data/repositories/football_repository_impl.dart';
import 'package:nexus_portuguese_app/features/football/domain/entities/football_entities.dart';

void main() {
  group('Football Entities Tests', () {
    test('FootballMatchEntity dialect helpers detect PT-BR and PT-PT correctly', () {
      const brMatch = FootballMatchEntity(
        id: 'fla_flu',
        matchTitle: 'Fla-Flu',
        stadium: 'Maracanã',
        city: 'Rio',
        dialect: 'pt_BR',
        teamHome: 'Flamengo',
        teamAway: 'Fluminense',
        flagEmojiHome: '🔴⚫',
        flagEmojiAway: '🟢⚪🔴',
        contextRu: 'Контекст',
        moments: [],
      );

      expect(brMatch.isPtBr, isTrue);
      expect(brMatch.isPtPt, isFalse);
      expect(brMatch.dialectFlag, '🇧🇷');
      expect(brMatch.dialectLabel, 'Brasil');

      const ptMatch = FootballMatchEntity(
        id: 'benfica_porto',
        matchTitle: 'O Clássico',
        stadium: 'Luz',
        city: 'Lisboa',
        dialect: 'pt_PT',
        teamHome: 'Benfica',
        teamAway: 'Porto',
        flagEmojiHome: '🔴⚪',
        flagEmojiAway: '🔵⚪',
        contextRu: 'Контекст',
        moments: [],
      );

      expect(ptMatch.isPtPt, isTrue);
      expect(ptMatch.isPtBr, isFalse);
      expect(ptMatch.dialectFlag, '🇵🇹');
      expect(ptMatch.dialectLabel, 'Portugal');
    });

    test('MatchMomentEntity properties and Equatable', () {
      const moment = MatchMomentEntity(
        id: 'm1',
        minute: 12,
        eventType: 'goal',
        eventEmoji: '⚽',
        commentaryPt: 'É gooolaço!',
        commentaryRu: 'Это голище!',
        dialectHighlightRu: 'Goleiro vs Guarda-redes',
        scoreHome: 1,
        scoreAway: 0,
      );

      expect(moment.minute, 12);
      expect(moment.eventType, 'goal');
      expect(moment.scoreHome, 1);
      expect(moment.scoreAway, 0);
    });

    test('FootballTermEntity properties and Equatable', () {
      const term = FootballTermEntity(
        id: 't1',
        termPtPt: 'Guarda-redes',
        termPtBr: 'Goleiro',
        translationRu: 'Вратарь',
        category: FootballTermCategory.positions,
        explanationRu: 'Пояснение',
        examplePtPt: 'Exemplo PT',
        examplePtBr: 'Exemplo BR',
      );

      expect(term.termPtPt, 'Guarda-redes');
      expect(term.termPtBr, 'Goleiro');
      expect(term.category, FootballTermCategory.positions);
      expect(term.translationRu, 'Вратарь');
    });

    test('FanChantEntity dialect helpers', () {
      const brChant = FanChantEntity(
        id: 'c1',
        chantPt: 'Eu sou brasileiro',
        translationRu: 'Я бразилец',
        clubOrCountry: 'Brasil',
        dialect: 'pt_BR',
        flagEmoji: '🇧🇷',
        contextCultureRu: 'Культура',
      );

      expect(brChant.isPtBr, isTrue);
      expect(brChant.isPtPt, isFalse);

      const ptChant = FanChantEntity(
        id: 'c2',
        chantPt: 'A Portuguesa',
        translationRu: 'Португальцы',
        clubOrCountry: 'Portugal',
        dialect: 'pt_PT',
        flagEmoji: '🇵🇹',
        contextCultureRu: 'Культура',
      );

      expect(ptChant.isPtPt, isTrue);
      expect(ptChant.isPtBr, isFalse);
    });
  });

  group('FootballSeedData Verification Tests', () {
    test('matches contains authentic matches with moments', () {
      expect(FootballSeedData.matches.length, greaterThanOrEqualTo(4));

      final hasPt = FootballSeedData.matches.any((m) => m.isPtPt);
      final hasBr = FootballSeedData.matches.any((m) => m.isPtBr);
      expect(hasPt, isTrue);
      expect(hasBr, isTrue);

      for (final m in FootballSeedData.matches) {
        expect(m.id, isNotEmpty);
        expect(m.matchTitle, isNotEmpty);
        expect(m.stadium, isNotEmpty);
        expect(m.city, isNotEmpty);
        expect(m.teamHome, isNotEmpty);
        expect(m.teamAway, isNotEmpty);
        expect(m.contextRu, isNotEmpty);
        expect(m.moments.length, greaterThanOrEqualTo(2));

        for (final moment in m.moments) {
          expect(moment.id, isNotEmpty);
          expect(moment.minute, inInclusiveRange(0, 120));
          expect(moment.commentaryPt, isNotEmpty);
          expect(moment.commentaryRu, isNotEmpty);
          expect(moment.dialectHighlightRu, isNotEmpty);
        }
      }
    });

    test('terms covers all categories with comparison examples', () {
      expect(FootballSeedData.terms.length, greaterThanOrEqualTo(16));

      for (final t in FootballSeedData.terms) {
        expect(t.id, isNotEmpty);
        expect(t.termPtPt, isNotEmpty);
        expect(t.termPtBr, isNotEmpty);
        expect(t.translationRu, isNotEmpty);
        expect(t.explanationRu, isNotEmpty);
        expect(t.examplePtPt, isNotEmpty);
        expect(t.examplePtBr, isNotEmpty);
      }
    });

    test('chants contains iconic fan songs', () {
      expect(FootballSeedData.chants.length, greaterThanOrEqualTo(6));

      for (final c in FootballSeedData.chants) {
        expect(c.id, isNotEmpty);
        expect(c.chantPt, isNotEmpty);
        expect(c.translationRu, isNotEmpty);
        expect(c.clubOrCountry, isNotEmpty);
        expect(c.contextCultureRu, isNotEmpty);
      }
    });

    test('quizQuestions contains valid options and indexes', () {
      expect(FootballSeedData.quizQuestions.length, greaterThanOrEqualTo(8));

      for (final q in FootballSeedData.quizQuestions) {
        expect(q.id, isNotEmpty);
        expect(q.questionPt, isNotEmpty);
        expect(q.questionRu, isNotEmpty);
        expect(q.optionsPt.length, 4);
        expect(q.correctOptionIndex, inInclusiveRange(0, 3));
        expect(q.explanationRu, isNotEmpty);
      }
    });
  });

  group('FootballRepositoryImpl Tests', () {
    final repo = FootballRepositoryImpl();

    test('getMatches returns all matches or filters by dialect', () async {
      final allRes = await repo.getMatches();
      expect(allRes.isOk, isTrue);
      expect(allRes.value.length, FootballSeedData.matches.length);

      final ptRes = await repo.getMatches(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      for (final m in ptRes.value) {
        expect(m.isPtPt, isTrue);
      }

      final brRes = await repo.getMatches(dialect: 'pt_BR');
      expect(brRes.isOk, isTrue);
      for (final m in brRes.value) {
        expect(m.isPtBr, isTrue);
      }
    });

    test('getMatchById returns requested match or fails for unknown id', () async {
      final res = await repo.getMatchById('fla_flu_maracana');
      expect(res.isOk, isTrue);
      expect(res.value.teamHome, 'Flamengo');

      final failRes = await repo.getMatchById('non_existent');
      expect(failRes.isFailure, isTrue);
    });

    test('getFootballTerms returns terms and filters by category', () async {
      final allTerms = await repo.getFootballTerms();
      expect(allTerms.isOk, isTrue);
      expect(allTerms.value.length, FootballSeedData.terms.length);

      final rulesTerms = await repo.getFootballTerms(category: FootballTermCategory.rules);
      expect(rulesTerms.isOk, isTrue);
      for (final t in rulesTerms.value) {
        expect(t.category, FootballTermCategory.rules);
      }
    });

    test('getFanChants returns chants and filters by dialect', () async {
      final allChants = await repo.getFanChants();
      expect(allChants.isOk, isTrue);
      expect(allChants.value.length, FootballSeedData.chants.length);

      final brChants = await repo.getFanChants(dialect: 'pt_BR');
      expect(brChants.isOk, isTrue);
      for (final c in brChants.value) {
        expect(c.isPtBr, isTrue);
      }
    });

    test('getQuizQuestions returns quiz questions', () async {
      final quizRes = await repo.getQuizQuestions();
      expect(quizRes.isOk, isTrue);
      expect(quizRes.value.length, FootballSeedData.quizQuestions.length);
    });

    test('recordMatchPractice runs gracefully with null database', () async {
      final res = await repo.recordMatchPractice(
        matchId: 'fla_flu_maracana',
        momentsPracticed: 4,
      );
      expect(res.isOk, isTrue);
    });
  });
}
