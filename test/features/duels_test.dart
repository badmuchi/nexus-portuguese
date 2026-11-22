import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/duels/data/datasources/duel_questions_seed.dart';
import 'package:nexus_portuguese_app/features/duels/data/repositories/duels_repository_impl.dart';
import 'package:nexus_portuguese_app/features/duels/domain/entities/duel_question_entity.dart';
import 'package:nexus_portuguese_app/features/duels/domain/entities/duel_session_result_entity.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  group('DuelQuestionsSeed Tests', () {
    test('contains 20 rich dialect questions across all categories', () {
      const questions = DuelQuestionsSeed.questions;
      expect(questions.length, 20);

      for (final q in questions) {
        expect(q.id.isNotEmpty, true);
        expect(q.promptRu.isNotEmpty, true);
        expect(q.options.length, 4);
        expect(q.correctIndex, inInclusiveRange(0, 3));
        expect(q.correctAnswer, q.options[q.correctIndex]);
        expect(q.ptPtEquivalent.isNotEmpty, true);
        expect(q.ptBrEquivalent.isNotEmpty, true);
      }

      final categories = questions.map((q) => q.category).toSet();
      expect(categories.length, 4);
      expect(categories.contains(DuelCategory.vocabulario), true);
      expect(categories.contains(DuelCategory.gramatica), true);
      expect(categories.contains(DuelCategory.falsosAmigos), true);
      expect(categories.contains(DuelCategory.girias), true);
    });

    test('DuelQuestion checkAnswer works correctly', () {
      final q = DuelQuestionsSeed.questions.first;
      expect(q.checkAnswer(q.correctIndex), true);
      expect(q.checkAnswer((q.correctIndex + 1) % 4), false);
    });
  });

  group('DuelSessionResultEntity Tests', () {
    test('evaluates 95% accuracy as Embaixador do Atlantico', () {
      final result = DuelSessionResultEntity.evaluate(
        total: 20,
        correct: 19,
        score: 2500,
        maxStreak: 12,
      );

      expect(result.accuracyPercent, 95.0);
      expect(result.titlePt, 'Embaixador do Atlântico');
      expect(result.trophyEmoji, '🏆');
    });

    test('evaluates 80% accuracy as Mestre dos Dois Mundos', () {
      final result = DuelSessionResultEntity.evaluate(
        total: 10,
        correct: 8,
        score: 950,
        maxStreak: 5,
      );

      expect(result.accuracyPercent, 80.0);
      expect(result.titlePt, 'Mestre dos Dois Mundos');
      expect(result.trophyEmoji, '🎖️');
    });
  });

  group('DuelsRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late DuelsRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      repository = DuelsRepositoryImpl(database: mockDb);

      when(() => mockDb.insertListeningAttemptLog(
            exerciseId: any(named: 'exerciseId'),
            wordAccuracy: any(named: 'wordAccuracy'),
            isExactMatch: any(named: 'isExactMatch'),
            attemptedAt: any(named: 'attemptedAt'),
          )).thenAnswer((_) async => 1);
    });

    test('getQuestions respects count and category filter', () async {
      final vocabResult = await repository.getQuestions(
        category: DuelCategory.vocabulario,
        count: 5,
      );

      expect(vocabResult.isOk, true);
      expect(vocabResult.value.length, 5);
      expect(vocabResult.value.every((q) => q.category == DuelCategory.vocabulario), true);
    });

    test('saveDuelResult inserts listening log in database', () async {
      final result = DuelSessionResultEntity.evaluate(
        total: 10,
        correct: 9,
        score: 1100,
        maxStreak: 6,
      );

      final saveRes = await repository.saveDuelResult(result);
      expect(saveRes.isOk, true);

      verify(() => mockDb.insertListeningAttemptLog(
            exerciseId: any(named: 'exerciseId'),
            wordAccuracy: 0.9,
            isExactMatch: true,
            attemptedAt: any(named: 'attemptedAt'),
          )).called(1);
    });
  });
}
