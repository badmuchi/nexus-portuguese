enum PortugueseMatchResult {
  exact,
  accentMissing,
  mismatch,
}

class PortugueseNormalizer {
  static const _diacriticsMap = {
    'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a',
    'Á': 'a', 'À': 'a', 'Â': 'a', 'Ã': 'a', 'Ä': 'a',
    'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    'É': 'e', 'È': 'e', 'Ê': 'e', 'Ë': 'e',
    'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
    'Í': 'i', 'Ì': 'i', 'Î': 'i', 'Ï': 'i',
    'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
    'Ó': 'o', 'Ò': 'o', 'Ô': 'o', 'Õ': 'o', 'Ö': 'o',
    'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
    'Ú': 'u', 'Ù': 'u', 'Û': 'u', 'Ü': 'u',
    'ç': 'c', 'Ç': 'c',
    'ñ': 'n', 'Ñ': 'n',
  };

  /// Removes diacritics, strips punctuation, trims, and converts to lower case.
  static String normalize(String input) {
    final buffer = StringBuffer();
    for (final char in input.runes) {
      final str = String.fromCharCode(char);
      buffer.write(_diacriticsMap[str] ?? str);
    }
    return buffer.toString()
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Trims and standardizes punctuation while preserving diacritics.
  static String cleanText(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Checks typed user answer against the target Portuguese word or phrase.
  static PortugueseMatchResult evaluateAnswer({
    required String userInput,
    required String targetText,
  }) {
    final cleanUser = cleanText(userInput).toLowerCase();
    final cleanTarget = cleanText(targetText).toLowerCase();

    if (cleanUser == cleanTarget) {
      return PortugueseMatchResult.exact;
    }

    final normUser = normalize(cleanUser);
    final normTarget = normalize(cleanTarget);

    if (normUser == normTarget) {
      return PortugueseMatchResult.accentMissing;
    }

    return PortugueseMatchResult.mismatch;
  }
}
