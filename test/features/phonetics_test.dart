import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/phonetics/domain/entities/phonetic_trainer_models.dart';

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
}
