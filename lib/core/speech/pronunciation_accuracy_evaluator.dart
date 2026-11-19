import 'dart:math';
import '../utils/portuguese_normalizer.dart';

class WordEvaluation {
  final String targetWord;
  final String? spokenWord;
  final bool isCorrect;
  final double similarity;

  const WordEvaluation({
    required this.targetWord,
    this.spokenWord,
    required this.isCorrect,
    required this.similarity,
  });
}

class PronunciationResult {
  final double score; // 0.0 to 1.0
  final bool isPass;
  final List<WordEvaluation> words;
  final String feedback;

  const PronunciationResult({
    required this.score,
    required this.isPass,
    required this.words,
    required this.feedback,
  });
}

class PronunciationAccuracyEvaluator {
  static PronunciationResult evaluate({
    required String spokenText,
    required String targetText,
    double passThreshold = 0.70,
  }) {
    final normSpoken = PortugueseNormalizer.normalize(spokenText);
    final normTarget = PortugueseNormalizer.normalize(targetText);

    if (normSpoken.isEmpty) {
      return const PronunciationResult(
        score: 0.0,
        isPass: false,
        words: [],
        feedback: 'Не удалось распознать речь. Попробуйте сказать громче и чётче.',
      );
    }

    final targetWords = normTarget.split(' ').where((w) => w.isNotEmpty).toList();
    final spokenWords = normSpoken.split(' ').where((w) => w.isNotEmpty).toList();

    final wordEvaluations = <WordEvaluation>[];
    double totalSim = 0.0;

    for (int i = 0; i < targetWords.length; i++) {
      final tWord = targetWords[i];
      String? matchedSpoken;
      double bestSim = 0.0;

      for (final sWord in spokenWords) {
        final sim = _stringSimilarity(tWord, sWord);
        if (sim > bestSim) {
          bestSim = sim;
          matchedSpoken = sWord;
        }
      }

      final isWordMatch = bestSim >= 0.75;
      totalSim += bestSim;

      wordEvaluations.add(
        WordEvaluation(
          targetWord: tWord,
          spokenWord: matchedSpoken,
          isCorrect: isWordMatch,
          similarity: bestSim,
        ),
      );
    }

    final overallScore = targetWords.isEmpty ? 1.0 : (totalSim / targetWords.length).clamp(0.0, 1.0);
    final isPass = overallScore >= passThreshold;

    final feedback = switch (overallScore) {
      >= 0.90 => 'Excelente! Великолепное португальское произношение!',
      >= 0.75 => 'Muito bom! Очень хорошее и разборчивое произношение.',
      >= 0.60 => 'Bom! Вас поймут, но обратите внимание на выделенные слова.',
      _ => 'Tente novamente! Попробуйте еще раз, произносите чуть медленнее.',
    };

    return PronunciationResult(
      score: overallScore,
      isPass: isPass,
      words: wordEvaluations,
      feedback: feedback,
    );
  }

  static double _stringSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final dist = _levenshtein(s1, s2);
    final maxLen = max(s1.length, s2.length);
    return (1.0 - (dist / maxLen)).clamp(0.0, 1.0);
  }

  static int _levenshtein(String s1, String s2) {
    final m = s1.length;
    final n = s2.length;
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (int j = 0; j <= n; j++) {
      dp[0][j] = j;
    }

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        dp[i][j] = min(
          dp[i - 1][j] + 1,
          min(dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost),
        );
      }
    }

    return dp[m][n];
  }
}
