import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/assessment/data/datasources/portuguese_assessment_seed_data.dart';
import 'package:nexus_portuguese_app/features/assessment/data/repositories/assessment_repository_impl.dart';
import 'package:nexus_portuguese_app/features/assessment/domain/entities/level_quiz_question.dart';
import 'package:nexus_portuguese_app/features/assessment/domain/entities/level_quiz_result.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  group('CEFR Level Assessment Domain Tests', () {
    test('CefrLevel enum properties and fromString parser', () {
      expect(CefrLevel.a1.label, 'A1');
      expect(CefrLevel.a2.label, 'A2');
      expect(CefrLevel.b1.label, 'B1');
      expect(CefrLevel.b2.label, 'B2');

      expect(CefrLevel.fromString('a1'), CefrLevel.a1);
      expect(CefrLevel.fromString('B1'), CefrLevel.b1);
      expect(CefrLevel.fromString('unknown'), CefrLevel.a1);
    });

    test('SkillFocus enum properties and fromString parser', () {
      expect(SkillFocus.grammar.titleRu, 'Грамматика и спряжения');
      expect(SkillFocus.prepositions.titleRu, 'Предлоги и слияния (Crase)');
      expect(SkillFocus.dialects.titleRu, 'Диалекты (PT-BR vs PT-PT)');

      expect(SkillFocus.fromString('grammar'), SkillFocus.grammar);
      expect(SkillFocus.fromString('prepositions'), SkillFocus.prepositions);
    });

    test('LevelQuizQuestion isCorrect checks answer index correctly', () {
      const q = LevelQuizQuestion(
        id: 'test_q',
        level: CefrLevel.a1,
        skill: SkillFocus.grammar,
        prompt: 'Test prompt',
        options: ['A', 'B', 'C'],
        correctOptionIndex: 1,
        explanationRu: 'Test explanation',
      );

      expect(q.isCorrect(1), true);
      expect(q.isCorrect(0), false);
      expect(q.isCorrect(2), false);
    });

    test('LevelQuizResult.evaluate produces correct levels and recommendations', () {
      const questions = PortugueseAssessmentSeedData.questions;

      // 100% correct answers -> B2
      final allCorrectAnswers = <String, int>{};
      for (final q in questions) {
        allCorrectAnswers[q.id] = q.correctOptionIndex;
      }
      final resultB2 = LevelQuizResult.evaluate(
        questions: questions,
        userAnswers: allCorrectAnswers,
      );

      expect(resultB2.level, CefrLevel.b2);
      expect(resultB2.scorePercentage, 100.0);
      expect(resultB2.correctAnswers, 15);
      expect(resultB2.mistakes.isEmpty, true);

      // Only 3 correct answers (20%) -> A1
      final answersA1 = <String, int>{
        questions[0].id: questions[0].correctOptionIndex,
        questions[1].id: questions[1].correctOptionIndex,
        questions[2].id: questions[2].correctOptionIndex,
      };
      final resultA1 = LevelQuizResult.evaluate(
        questions: questions,
        userAnswers: answersA1,
      );

      expect(resultA1.level, CefrLevel.a1);
      expect(resultA1.scorePercentage, closeTo(20.0, 0.1));
      expect(resultA1.correctAnswers, 3);
      expect(resultA1.mistakes.length, 12);
      expect(resultA1.recommendations.isNotEmpty, true);
    });
  });

  group('AssessmentRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late AssessmentRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      repository = AssessmentRepositoryImpl(database: mockDb);
      registerFallbackValue(const AssessmentResultEntriesCompanion());
    });

    test('getQuestions returns 15 calibrated seed questions', () async {
      final result = await repository.getQuestions();
      expect(result.isOk, true);
      expect(result.value.length, 15);
      expect(result.value.first.id, 'cefr_q1');
    });

    test('getLatestResult returns mapped LevelQuizResult if row exists', () async {
      final now = DateTime(2026, 11, 21);
      final row = AssessmentResultRow(
        id: 1,
        determinedLevel: 'B1',
        levelTitleRu: 'Intermediário (B1)',
        scorePercentage: 80.0,
        totalQuestions: 15,
        correctAnswers: 12,
        skillScoresJson: jsonEncode({'grammar': 80.0, 'prepositions': 75.0}),
        mistakesJson: jsonEncode(['cefr_q1', 'cefr_q2']),
        completedAt: now,
      );

      when(() => mockDb.getLatestAssessmentResult()).thenAnswer((_) async => row);

      final result = await repository.getLatestResult();
      expect(result.isOk, true);
      final entity = result.value;
      expect(entity, isNotNull);
      expect(entity?.level, CefrLevel.b1);
      expect(entity?.scorePercentage, 80.0);
      expect(entity?.mistakes.length, 2);
    });

    test('getLatestResult returns null when table is empty', () async {
      when(() => mockDb.getLatestAssessmentResult()).thenAnswer((_) async => null);

      final result = await repository.getLatestResult();
      expect(result.isOk, true);
      expect(result.value, isNull);
    });

    test('saveResult delegates to database insert', () async {
      when(() => mockDb.insertAssessmentResult(any())).thenAnswer((_) async => 1);

      final quizResult = LevelQuizResult(
        level: CefrLevel.a2,
        levelTitleRu: 'Básico (A2)',
        scorePercentage: 66.0,
        totalQuestions: 15,
        correctAnswers: 10,
        skillScores: const {SkillFocus.grammar: 70.0},
        mistakes: const [],
        recommendations: const ['Practice more!'],
        completedAt: DateTime(2026, 11, 21),
      );

      final saveRes = await repository.saveResult(quizResult);
      expect(saveRes.isOk, true);
      verify(() => mockDb.insertAssessmentResult(any())).called(1);
    });
  });
}
