import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/core/speech/pronunciation_accuracy_evaluator.dart';
import 'package:nexus_portuguese_app/features/speech_lab/data/datasources/speech_lab_seed_data.dart';
import 'package:nexus_portuguese_app/features/speech_lab/domain/entities/speech_exercise.dart';

void main() {
  group('SpeechLabSeedData Tests', () {
    test('contains exercises across all categories', () {
      const exercises = SpeechLabSeedData.exercises;
      expect(exercises, isNotEmpty);

      final categories = exercises.map((e) => e.category).toSet();
      expect(categories.contains(SpeechCategory.nasalVowels), isTrue);
      expect(categories.contains(SpeechCategory.openClosed), isTrue);
      expect(categories.contains(SpeechCategory.consonants), isTrue);
      expect(categories.contains(SpeechCategory.tongueTwisters), isTrue);
      expect(categories.contains(SpeechCategory.dialogueLines), isTrue);
      expect(categories.contains(SpeechCategory.dialectContrasts), isTrue);
    });

    test('pronunciation evaluator scores high for close acoustic match', () {
      const target = 'Quero pão com manteiga.';
      const spoken = 'Quero pao com manteiga';

      final result = PronunciationAccuracyEvaluator.evaluate(
        spokenText: spoken,
        targetText: target,
      );

      expect(result.score, greaterThanOrEqualTo(0.8));
      expect(result.isPass, isTrue);
    });
  });
}
