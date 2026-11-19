import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/core/utils/portuguese_normalizer.dart';
import 'package:nexus_portuguese_app/features/srs/domain/services/fsrs_engine.dart';

void main() {
  group('PortugueseNormalizer Tests', () {
    test('normalizes diacritics and cases correctly', () {
      expect(PortugueseNormalizer.normalize('Pão de Queijo'), equals('pao de queijo'));
      expect(PortugueseNormalizer.normalize('Você está aí?'), equals('voce esta ai'));
      expect(PortugueseNormalizer.normalize('Coração'), equals('coracao'));
    });

    test('evaluates exact match', () {
      final res = PortugueseNormalizer.evaluateAnswer(
        userInput: 'Olá',
        targetText: 'Olá',
      );
      expect(res, equals(PortugueseMatchResult.exact));
    });

    test('detects missing diacritics', () {
      final res = PortugueseNormalizer.evaluateAnswer(
        userInput: 'Ola',
        targetText: 'Olá',
      );
      expect(res, equals(PortugueseMatchResult.accentMissing));
    });

    test('detects mismatch', () {
      final res = PortugueseNormalizer.evaluateAnswer(
        userInput: 'Tchau',
        targetText: 'Olá',
      );
      expect(res, equals(PortugueseMatchResult.mismatch));
    });
  });

  group('FsrsEngine Tests', () {
    test('initializes new card on Good rating', () {
      final state = FsrsEngine.review(
        currentState: FsrsItemState(
          stability: 0.0,
          difficulty: 0.0,
          reps: 0,
          lapses: 0,
          state: 'newCard',
          dueAt: DateTime.now(),
          scheduledDays: 1,
        ),
        rating: SrsRating.good,
      );

      expect(state.reps, equals(1));
      expect(state.state, equals('review'));
      expect(state.scheduledDays, greaterThanOrEqualTo(1));
    });

    test('handles Again rating as lapse', () {
      final state = FsrsEngine.review(
        currentState: FsrsItemState(
          stability: 2.0,
          difficulty: 5.0,
          reps: 2,
          lapses: 0,
          state: 'review',
          dueAt: DateTime.now(),
          scheduledDays: 3,
        ),
        rating: SrsRating.again,
      );

      expect(state.lapses, equals(1));
      expect(state.state, equals('relearning'));
      expect(state.scheduledDays, equals(1));
    });
  });
}
