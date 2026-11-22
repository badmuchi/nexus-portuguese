import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/diary/data/datasources/diary_prompts_seed.dart';
import 'package:nexus_portuguese_app/features/diary/data/repositories/diary_repository_impl.dart';
import 'package:nexus_portuguese_app/features/diary/domain/entities/diary_entry_entity.dart';
import 'package:nexus_portuguese_app/features/diary/domain/services/portuguese_diary_analyzer.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  group('PortugueseDiaryAnalyzer Tests', () {
    test('analyzes empty text gracefully', () {
      final result = PortugueseDiaryAnalyzer.analyze('');
      expect(result.wordCount, 0);
      expect(result.detectedDialect, 'neutral');
      expect(result.mistakes, isEmpty);
    });

    test('detects Brazilian Portuguese dialect markers', () {
      const text = 'Hoje eu peguei o ônibus e você estava lá. Foi muito legal!';
      final result = PortugueseDiaryAnalyzer.analyze(text);

      expect(result.detectedDialect, 'pt_BR');
      expect(result.dialectNotesRu.contains('Бразильский'), true);
    });

    test('detects European Portuguese dialect markers', () {
      const text = 'Hoje estou a fazer um bolo fixe e vou apanhar o autocarro contigo.';
      final result = PortugueseDiaryAnalyzer.analyze(text);

      expect(result.detectedDialect, 'pt_PT');
      expect(result.dialectNotesRu.contains('Европейский'), true);
    });

    test('identifies missing diacritics', () {
      const text = 'Eu nao sei se voce esta pronto para o cafe.';
      final result = PortugueseDiaryAnalyzer.analyze(text);

      expect(result.hasMistakes, true);
      final suggested = result.mistakes.map((m) => m.suggestedText).toList();
      expect(suggested.contains('não'), true);
      expect(suggested.contains('você'), true);
      expect(suggested.contains('café'), true);
    });

    test('identifies uncontracted prepositions', () {
      const text = 'Eu gosto de o Brasil e vou em a praia.';
      final result = PortugueseDiaryAnalyzer.analyze(text);

      expect(result.hasMistakes, true);
      final mistakes = result.mistakes.where((m) => m.type == 'contraction').toList();
      expect(mistakes.any((m) => m.suggestedText == 'do'), true);
      expect(mistakes.any((m) => m.suggestedText == 'na'), true);
    });

    test('identifies gender trap errors', () {
      const text = 'Hoje o praia estava cheia durante a dia.';
      final result = PortugueseDiaryAnalyzer.analyze(text);

      final genderMistakes = result.mistakes.where((m) => m.type == 'gender').toList();
      expect(genderMistakes.any((m) => m.suggestedText == 'a praia'), true);
      expect(genderMistakes.any((m) => m.suggestedText == 'o dia'), true);
    });

    test('extracts vocabulary candidates for FSRS', () {
      const text = 'Ontem visitei uma exposição maravilhosa sobre literatura e arquitetura em Lisboa.';
      final result = PortugueseDiaryAnalyzer.analyze(text);

      expect(result.suggestedSrsWords.isNotEmpty, true);
      expect(result.suggestedSrsWords.contains('literatura') || result.suggestedSrsWords.contains('arquitetura'), true);
    });
  });

  group('DiaryPromptsSeed Tests', () {
    test('contains calibrated Portuguese daily prompts', () {
      const prompts = DiaryPromptsSeed.prompts;
      expect(prompts.length, greaterThanOrEqualTo(5));

      for (final p in prompts) {
        expect(p.id.isNotEmpty, true);
        expect(p.questionPt.isNotEmpty, true);
        expect(p.questionRu.isNotEmpty, true);
        expect(p.hintWords.isNotEmpty, true);
      }
    });
  });

  group('DiaryRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late DiaryRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      repository = DiaryRepositoryImpl(database: mockDb);

      registerFallbackValue(const DiaryEntriesCompanion());

      when(() => mockDb.getAllDiaryEntries()).thenAnswer((_) async => []);
      when(() => mockDb.insertDiaryEntry(any())).thenAnswer((_) async => 1);
      when(() => mockDb.insertGrammarPracticeLog(
            verbId: any(named: 'verbId'),
            tense: any(named: 'tense'),
            person: any(named: 'person'),
            isCorrect: any(named: 'isCorrect'),
            practicedAt: any(named: 'practicedAt'),
          )).thenAnswer((_) async => 1);
      when(() => mockDb.deleteDiaryEntry(any())).thenAnswer((_) async => 1);
    });

    test('saveEntry inserts row and logs activity to database', () async {
      final entry = DiaryEntryEntity(
        id: 'test_entry_1',
        contentPt: 'Hoje eu fui ao parque.',
        dialect: 'pt_BR',
        wordCount: 5,
        estimatedLevel: 'A1',
        feedbackSummaryRu: 'Bom!',
        mistakes: const [],
        createdAt: DateTime.now(),
      );

      final result = await repository.saveEntry(entry);
      expect(result.isOk, true);
      expect(result.value.id, 'test_entry_1');

      verify(() => mockDb.insertDiaryEntry(any())).called(1);
      verify(() => mockDb.insertGrammarPracticeLog(
            verbId: 'diario_test_entry_1',
            tense: any(named: 'tense'),
            person: any(named: 'person'),
            isCorrect: true,
            practicedAt: any(named: 'practicedAt'),
          )).called(1);
    });

    test('deleteEntry deletes row from database', () async {
      final result = await repository.deleteEntry('test_entry_1');
      expect(result.isOk, true);
      verify(() => mockDb.deleteDiaryEntry('test_entry_1')).called(1);
    });
  });
}
