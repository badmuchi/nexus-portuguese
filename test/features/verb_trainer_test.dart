import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/grammar/domain/entities/grammar_verb_entity.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/data/datasources/verb_exercise_generator.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/data/repositories/verb_trainer_repository_impl.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/domain/entities/verb_exercise.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/domain/entities/verb_trainer_config.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/domain/entities/verb_trainer_session_result.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  group('VerbTrainer Domain Tests', () {
    test('VerbTense and VerbPerson parsers work correctly', () {
      expect(VerbTense.fromRaw('presente_indicativo'), VerbTense.presenteIndicativo);
      expect(VerbTense.fromRaw('preterito_perfeito'), VerbTense.preteritoPerfeito);
      expect(VerbTense.fromRaw('unknown'), VerbTense.presenteIndicativo);

      expect(VerbPerson.fromRaw('eu'), VerbPerson.eu);
      expect(VerbPerson.fromRaw('tu'), VerbPerson.tu);
      expect(VerbPerson.fromRaw('ele/ela/você'), VerbPerson.eleElaVoce);
      expect(VerbPerson.fromRaw('nós'), VerbPerson.nos);
      expect(VerbPerson.fromRaw('eles/elas/vocês'), VerbPerson.elesElasVoces);
    });

    test('VerbExercise isCorrect matches correctForm case-insensitively', () {
      const ex = VerbExercise(
        id: 'ex_1',
        verbId: 'verb_ser',
        infinitive: 'ser',
        russianMeaning: 'быть',
        isIrregular: true,
        tense: VerbTense.presenteIndicativo,
        person: VerbPerson.eu,
        correctForm: 'sou',
        options: ['sou', 'és', 'é', 'somos'],
        explanationRu: 'Eu sou',
        audioPhrase: 'Eu sou',
      );

      expect(ex.isCorrect('sou'), true);
      expect(ex.isCorrect('SOU '), true);
      expect(ex.isCorrect('és'), false);
    });

    test('VerbTrainerSessionResult.evaluate computes accurate metrics', () {
      const ex = VerbExercise(
        id: 'ex_1',
        verbId: 'verb_ser',
        infinitive: 'ser',
        russianMeaning: 'быть',
        isIrregular: true,
        tense: VerbTense.presenteIndicativo,
        person: VerbPerson.eu,
        correctForm: 'sou',
        options: ['sou', 'és', 'é', 'somos'],
        explanationRu: 'Eu sou',
        audioPhrase: 'Eu sou',
      );

      final result = VerbTrainerSessionResult.evaluate(
        totalAttempts: 10,
        correctCount: 8,
        maxStreak: 5,
        scorePoints: 850,
        mistakes: [ex],
        mode: TrainerMode.sprint60,
      );

      expect(result.accuracyPercentage, 80.0);
      expect(result.maxStreak, 5);
      expect(result.scorePoints, 850);
      expect(result.mistakes.length, 1);
    });
  });

  group('VerbExerciseGenerator Tests', () {
    final sampleVerbs = [
      const GrammarVerbEntity(
        id: 'verb_fazer',
        infinitive: 'fazer',
        regularity: 'irregular',
        conjugationGroup: '-er',
        russianMeaning: 'делать',
        grammarNotesRu: 'Неправильный',
        conjugations: [
          VerbConjugationForm(tense: 'presente_indicativo', person: 'eu', form: 'faço'),
          VerbConjugationForm(tense: 'presente_indicativo', person: 'tu', form: 'fazes'),
          VerbConjugationForm(tense: 'presente_indicativo', person: 'ele/ela/você', form: 'faz'),
          VerbConjugationForm(tense: 'presente_indicativo', person: 'nós', form: 'fazemos'),
          VerbConjugationForm(tense: 'presente_indicativo', person: 'eles/elas/vocês', form: 'fazem'),
          VerbConjugationForm(tense: 'preterito_perfeito', person: 'eu', form: 'fiz'),
          VerbConjugationForm(tense: 'preterito_perfeito', person: 'ele/ela/você', form: 'fez'),
        ],
      ),
      const GrammarVerbEntity(
        id: 'verb_falar',
        infinitive: 'falar',
        regularity: 'regular',
        conjugationGroup: '-ar',
        russianMeaning: 'говорить',
        grammarNotesRu: 'Правильный',
        conjugations: [
          VerbConjugationForm(tense: 'presente_indicativo', person: 'eu', form: 'falo'),
          VerbConjugationForm(tense: 'presente_indicativo', person: 'ele/ela/você', form: 'fala'),
          VerbConjugationForm(tense: 'preterito_perfeito', person: 'eu', form: 'falei'),
        ],
      ),
    ];

    test('generates valid exercises with 4 options containing correct form', () {
      final generator = VerbExerciseGenerator();
      final exercises = generator.generate(
        allVerbs: sampleVerbs,
        config: const VerbTrainerConfig(mode: TrainerMode.drill15),
        count: 5,
      );

      expect(exercises.isNotEmpty, true);
      for (final ex in exercises) {
        expect(ex.options.length, 4);
        expect(ex.options.contains(ex.correctForm), true);
        expect(ex.options.toSet().length, 4); // All options unique
      }
    });

    test('respects irregularsOnly filter', () {
      final generator = VerbExerciseGenerator();
      final exercises = generator.generate(
        allVerbs: sampleVerbs,
        config: const VerbTrainerConfig(irregularsOnly: true),
        count: 5,
      );

      for (final ex in exercises) {
        expect(ex.infinitive, 'fazer');
        expect(ex.isIrregular, true);
      }
    });
  });

  group('VerbTrainerRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late VerbTrainerRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      repository = VerbTrainerRepositoryImpl(database: mockDb);
    });

    test('generateExercises loads rows from database and generates exercises', () async {
      final row = GrammarVerbRow(
        id: 'verb_ir',
        infinitive: 'ir',
        regularity: 'irregular',
        conjugationGroup: '-ir',
        russianMeaning: 'идти',
        grammarNotesRu: 'Очень неправильный',
        differenceNote: null,
        conjugationsJson: jsonEncode([
          {'tense': 'presente_indicativo', 'person': 'eu', 'form': 'vou'},
          {'tense': 'presente_indicativo', 'person': 'tu', 'form': 'vais'},
          {'tense': 'presente_indicativo', 'person': 'ele/ela/você', 'form': 'vai'},
          {'tense': 'presente_indicativo', 'person': 'nós', 'form': 'vamos'},
          {'tense': 'preterito_perfeito', 'person': 'eu', 'form': 'fui'},
        ]),
      );

      when(() => mockDb.getAllGrammarVerbs()).thenAnswer((_) async => [row]);

      final result = await repository.generateExercises(
        config: const VerbTrainerConfig(),
        count: 3,
      );

      expect(result.isOk, true);
      expect(result.value.isNotEmpty, true);
      expect(result.value.first.verbId, 'verb_ir');
    });

    test('recordAttempt inserts log into database', () async {
      when(() => mockDb.insertGrammarPracticeLog(
            verbId: any(named: 'verbId'),
            tense: any(named: 'tense'),
            person: any(named: 'person'),
            isCorrect: any(named: 'isCorrect'),
            practicedAt: any(named: 'practicedAt'),
          )).thenAnswer((_) async => 1);

      final res = await repository.recordAttempt(
        verbId: 'verb_ser',
        tense: 'presente_indicativo',
        person: 'eu',
        isCorrect: true,
      );

      expect(res.isOk, true);
      verify(() => mockDb.insertGrammarPracticeLog(
            verbId: 'verb_ser',
            tense: 'presente_indicativo',
            person: 'eu',
            isCorrect: true,
            practicedAt: any(named: 'practicedAt'),
          )).called(1);
    });

    test('getVerbMasteryStats calculates accuracy per verbId', () async {
      final now = DateTime.now();
      final logs = [
        GrammarPracticeLogRow(
          id: 1,
          verbId: 'verb_ter',
          tense: 'presente_indicativo',
          person: 'eu',
          isCorrect: true,
          practicedAt: now,
        ),
        GrammarPracticeLogRow(
          id: 2,
          verbId: 'verb_ter',
          tense: 'presente_indicativo',
          person: 'tu',
          isCorrect: false,
          practicedAt: now,
        ),
      ];

      when(() => mockDb.getAllGrammarPracticeLogs()).thenAnswer((_) async => logs);

      final res = await repository.getVerbMasteryStats();
      expect(res.isOk, true);
      expect(res.value['verb_ter'], 50.0);
    });
  });
}
