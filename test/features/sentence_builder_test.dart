import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/assessment/domain/entities/level_quiz_question.dart';
import 'package:nexus_portuguese_app/features/sentence_builder/data/repositories/sentence_builder_repository_impl.dart';
import 'package:nexus_portuguese_app/features/sentence_builder/domain/entities/sentence_builder_result.dart';
import 'package:nexus_portuguese_app/features/sentence_builder/domain/entities/sentence_puzzle.dart';

void main() {
  group('SentencePuzzle Domain Tests', () {
    const puzzle = SentencePuzzle(
      id: 'test_p1',
      targetPortuguese: 'Nós vamos à praia amanhã.',
      russianMeaning: 'Мы пойдем на пляж завтра.',
      level: CefrLevel.a2,
      availableTokens: ['Nós', 'vamos', 'à', 'praia', 'amanhã', 'no'],
      correctSequence: ['Nós', 'vamos', 'à', 'praia', 'amanhã'],
      alternativeSequences: [
        ['Amanhã', 'nós', 'vamos', 'à', 'praia'],
      ],
      grammarExplanationRu: 'Crase à praia',
    );

    test('isMatch accepts correct sequence case and punctuation insensitively', () {
      expect(puzzle.isMatch(['nós', 'vamos', 'à', 'praia', 'amanhã.']), true);
      expect(puzzle.isMatch(['Nós', 'vamos', 'à', 'praia', 'amanhã']), true);
    });

    test('isMatch accepts alternative valid sequence', () {
      expect(puzzle.isMatch(['Amanhã', 'nós', 'vamos', 'à', 'praia']), true);
    });

    test('isMatch rejects wrong token order or incorrect words', () {
      expect(puzzle.isMatch(['Nós', 'à', 'praia', 'vamos', 'amanhã']), false);
      expect(puzzle.isMatch(['Nós', 'vamos', 'no', 'praia', 'amanhã']), false);
      expect(puzzle.isMatch(['Nós', 'vamos']), false);
    });

    test('SentenceBuilderResult.evaluate calculates accuracy properly', () {
      final res = SentenceBuilderResult.evaluate(
        totalQuestions: 10,
        solvedCount: 8,
        scorePoints: 120,
        mistakes: const [puzzle],
      );

      expect(res.accuracyPercentage, 80.0);
      expect(res.solvedCount, 8);
      expect(res.totalQuestions, 10);
      expect(res.mistakes.length, 1);
    });
  });

  group('SentenceBuilderRepositoryImpl Tests', () {
    const repository = SentenceBuilderRepositoryImpl();

    test('getPuzzles returns all 20 seed puzzles', () async {
      final res = await repository.getPuzzles();
      expect(res.isOk, true);
      expect(res.value.length, 20);
    });

    test('getPuzzles can filter by CefrLevel', () async {
      final a1Res = await repository.getPuzzles(level: CefrLevel.a1);
      expect(a1Res.isOk, true);
      expect(a1Res.value.length, 6);
      for (final p in a1Res.value) {
        expect(p.level, CefrLevel.a1);
      }
    });

    test('getPuzzles can filter by dialect', () async {
      final ptRes = await repository.getPuzzles(dialect: 'pt-PT');
      expect(ptRes.isOk, true);
      for (final p in ptRes.value) {
        expect(p.dialect == 'all' || p.dialect == 'pt-PT', true);
      }
    });
  });
}
