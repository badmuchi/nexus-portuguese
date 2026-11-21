import 'package:equatable/equatable.dart';
import 'package:nexus_portuguese_app/features/assessment/domain/entities/level_quiz_question.dart';

class SentencePuzzle extends Equatable {
  final String id;
  final String targetPortuguese;
  final String russianMeaning;
  final CefrLevel level;
  final List<String> availableTokens;
  final List<String> correctSequence;
  final List<List<String>> alternativeSequences;
  final String grammarExplanationRu;
  final String dialect;

  const SentencePuzzle({
    required this.id,
    required this.targetPortuguese,
    required this.russianMeaning,
    required this.level,
    required this.availableTokens,
    required this.correctSequence,
    this.alternativeSequences = const [],
    required this.grammarExplanationRu,
    this.dialect = 'all',
  });

  static String normalizeToken(String t) =>
      t.toLowerCase().replaceAll(RegExp(r'[.,!?:;]'), '').trim();

  bool isMatch(List<String> userTokens) {
    if (userTokens.length != correctSequence.length) return false;

    bool matchesList(List<String> expected) {
      if (userTokens.length != expected.length) return false;
      for (int i = 0; i < userTokens.length; i++) {
        if (normalizeToken(userTokens[i]) != normalizeToken(expected[i])) {
          return false;
        }
      }
      return true;
    }

    if (matchesList(correctSequence)) return true;

    for (final alt in alternativeSequences) {
      if (matchesList(alt)) return true;
    }

    return false;
  }

  @override
  List<Object?> get props => [
        id,
        targetPortuguese,
        russianMeaning,
        level,
        availableTokens,
        correctSequence,
        alternativeSequences,
        grammarExplanationRu,
        dialect,
      ];
}
