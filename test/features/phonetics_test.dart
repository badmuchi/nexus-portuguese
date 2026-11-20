import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/phonetics/data/repositories/phonetics_repository_impl.dart';
import 'package:nexus_portuguese_app/features/phonetics/domain/entities/phonetic_trainer_models.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  group('Phonetics Trainer Domain Models Tests', () {
    test('MinimalPairItem serializes and deserializes correctly', () {
      final jsonMap = {
        'word_a': 'pão',
        'ipa_a': '[ˈpɐ̃w̃]',
        'meaning_a_ru': 'хлеб',
        'word_b': 'pau',
        'ipa_b': '[ˈpaw]',
        'meaning_b_ru': 'палка',
        'distinction_note': 'Носовой резонанс против чистого открытого',
      };

      final item = MinimalPairItem.fromJson(jsonMap);
      expect(item.wordA, 'pão');
      expect(item.wordB, 'pau');
      expect(item.meaningARu, 'хлеб');
      expect(item.meaningBRu, 'палка');
      expect(item.distinctionNote, contains('Носовой'));

      final serialized = item.toJson();
      expect(serialized['word_a'], 'pão');
      expect(serialized['word_b'], 'pau');
    });

    test('PhoneticExercise parses JSON with contrast pairs and dialect comparison', () {
      const jsonString = '''
      {
        "sound_id": "nasal_ao",
        "sound_category": "nasal_vowels",
        "title": "Носовой дифтонг -ÃO / -AM",
        "ipa": "[ɐ̃w̃]",
        "tip_pt": "O ar sai pelo nariz.",
        "tip_ru": "Воздух через нос.",
        "contrast_pairs": [
          {
            "word_a": "pão",
            "ipa_a": "[ˈpɐ̃w̃]",
            "meaning_a_ru": "хлеб",
            "word_b": "pau",
            "ipa_b": "[ˈpaw]",
            "meaning_b_ru": "палка",
            "distinction_note": "Различие в носовом звуке"
          }
        ],
        "dialect_comparison": {
          "word": "coração",
          "meaning_ru": "сердце",
          "note_br": "Открыто в Бразилии",
          "note_pt": "Редуцировано в Португалии"
        }
      }
      ''';

      final exercise = PhoneticExercise.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
      expect(exercise.soundId, 'nasal_ao');
      expect(exercise.soundCategory, 'nasal_vowels');
      expect(exercise.ipa, '[ɐ̃w̃]');
      expect(exercise.contrastPairs.length, 1);
      expect(exercise.contrastPairs.first.wordA, 'pão');
      expect(exercise.dialectComparison.word, 'coração');
      expect(exercise.dialectComparison.noteBr, contains('Бразилии'));
    });

    test('PhoneticMastery correctly computes ear and mouth accuracy percentages', () {
      final mastery = PhoneticMastery(
        soundId: 'nasal_ao',
        soundCategory: 'nasal_vowels',
        title: 'Носовой дифтонг -ÃO',
        masteryScore: 85.0,
        earAttempts: 10,
        earCorrect: 8,
        mouthAttempts: 2,
        mouthScoreSum: 180.0,
        lastPracticedAt: DateTime(2026, 11, 20),
      );

      expect(mastery.earAccuracyPercent, 80.0);
      expect(mastery.mouthAccuracyAverage, 90.0);
      expect(mastery.masteryScore, 85.0);
    });
  });

  group('PhoneticsRepositoryImpl Data Layer Tests', () {
    late MockAppDatabase mockDatabase;
    late PhoneticsRepositoryImpl repository;

    setUp(() {
      mockDatabase = MockAppDatabase();
      repository = PhoneticsRepositoryImpl(database: mockDatabase);
    });

    test('getMasteryList returns mapped entities from Drift rows', () async {
      final now = DateTime(2026, 11, 20);
      final row = PhoneticMasteryRow(
        soundId: 'nasal_ao',
        soundCategory: 'nasal_vowels',
        title: 'Носовой -ÃO',
        masteryScore: 85.0,
        earAttempts: 10,
        earCorrect: 8,
        mouthAttempts: 2,
        mouthScoreSum: 180.0,
        lastPracticedAt: now,
      );

      when(() => mockDatabase.getAllPhoneticMastery()).thenAnswer((_) async => [row]);

      final result = await repository.getMasteryList();
      expect(result.isOk, true);
      expect(result.value.length, 1);
      expect(result.value.first.soundId, 'nasal_ao');
      expect(result.value.first.masteryScore, 85.0);
      expect(result.value.first.earAccuracyPercent, 80.0);
    });

    test('getMasteryList returns DatabaseFailure when database throws', () async {
      when(() => mockDatabase.getAllPhoneticMastery()).thenThrow(Exception('DB error'));

      final result = await repository.getMasteryList();
      expect(result.isFailure, true);
      expect(result.failure?.message, contains('Failed to fetch phonetic mastery'));
    });

    test('recordEarAnswer delegates to database and returns ok', () async {
      when(() => mockDatabase.recordPhoneticEarAttempt(
            soundId: any(named: 'soundId'),
            isCorrect: any(named: 'isCorrect'),
            soundCategory: any(named: 'soundCategory'),
            title: any(named: 'title'),
          )).thenAnswer((_) async {});

      final result = await repository.recordEarAnswer(
        soundId: 'nasal_ao',
        isCorrect: true,
        soundCategory: 'nasal_vowels',
        title: 'Носовой -ÃO',
      );

      expect(result.isOk, true);
      verify(() => mockDatabase.recordPhoneticEarAttempt(
            soundId: 'nasal_ao',
            isCorrect: true,
            soundCategory: 'nasal_vowels',
            title: 'Носовой -ÃO',
          )).called(1);
    });

    test('recordMouthScore delegates to database and returns ok', () async {
      when(() => mockDatabase.recordPhoneticMouthAttempt(
            soundId: any(named: 'soundId'),
            scorePercent: any(named: 'scorePercent'),
            soundCategory: any(named: 'soundCategory'),
            title: any(named: 'title'),
          )).thenAnswer((_) async {});

      final result = await repository.recordMouthScore(
        soundId: 'nasal_ao',
        scorePercent: 95.0,
        soundCategory: 'nasal_vowels',
        title: 'Носовой -ÃO',
      );

      expect(result.isOk, true);
      verify(() => mockDatabase.recordPhoneticMouthAttempt(
            soundId: 'nasal_ao',
            scorePercent: 95.0,
            soundCategory: 'nasal_vowels',
            title: 'Носовой -ÃO',
          )).called(1);
    });
  });
}
