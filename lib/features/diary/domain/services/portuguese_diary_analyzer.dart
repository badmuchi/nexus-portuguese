import '../entities/diary_analysis_entity.dart';

/// Интеллектуальный анализатор записей дневника для португальского языка.
class PortugueseDiaryAnalyzer {
  static DiaryAnalysisResult analyze(String text) {
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      return const DiaryAnalysisResult(
        wordCount: 0,
        uniqueWordCount: 0,
        detectedDialect: 'neutral',
        dialectNotesRu: 'Текст не содержит слов',
        estimatedLevel: 'A1',
        feedbackSummaryRu: 'Напишите хотя бы пару предложений о вашем дне!',
        mistakes: [],
        suggestedSrsWords: [],
      );
    }

    final rawTokens = cleanText
        .split(RegExp(r'\s+'))
        .map((w) => w.replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), ''))
        .where((w) => w.isNotEmpty)
        .toList();

    final wordCount = rawTokens.length;
    final lowerTokens = rawTokens.map((w) => w.toLowerCase()).toList();
    final uniqueTokens = lowerTokens.toSet();
    final uniqueWordCount = uniqueTokens.length;

    // 1. Определение диалекта
    final dialectAnalysis = _detectDialect(cleanText, lowerTokens);

    // 2. Поиск орфографических и грамматических ошибок
    final mistakes = _detectMistakes(cleanText, lowerTokens);

    // 3. Оценка уровня CEFR
    final estimatedLevel = _estimateCefrLevel(wordCount, uniqueWordCount, cleanText);

    // 4. Похвала и резюме
    final feedback = _generateFeedback(
      wordCount: wordCount,
      uniqueWordCount: uniqueWordCount,
      estimatedLevel: estimatedLevel,
      mistakesCount: mistakes.length,
      dialect: dialectAnalysis.dialect,
    );

    // 5. Кандидаты в SRS (слова длиннее 4 букв, не служебные)
    final suggestedWords = _extractSrsCandidates(rawTokens);

    return DiaryAnalysisResult(
      wordCount: wordCount,
      uniqueWordCount: uniqueWordCount,
      detectedDialect: dialectAnalysis.dialect,
      dialectNotesRu: dialectAnalysis.note,
      estimatedLevel: estimatedLevel,
      feedbackSummaryRu: feedback,
      mistakes: mistakes,
      suggestedSrsWords: suggestedWords,
    );
  }

  static ({String dialect, String note}) _detectDialect(String fullText, List<String> tokens) {
    int ptPtScore = 0;
    int ptBrScore = 0;
    final lower = fullText.toLowerCase();

    // PT-PT маркеры
    if (RegExp(r'\bestou a\b|\bestá a\b|\bestamos a\b|\bestão a\b').hasMatch(lower)) ptPtScore += 4;
    if (tokens.contains('tu') || tokens.contains('contigo')) ptPtScore += 2;
    if (tokens.contains('autocarro') || tokens.contains('comboio') || tokens.contains('telemóvel')) ptPtScore += 3;
    if (tokens.contains('fixe') || tokens.contains('gajo') || tokens.contains('chávena') || tokens.contains('miúdo')) ptPtScore += 3;

    // PT-BR маркеры
    if (RegExp(r'\b(estou|está|estamos|estão)\s+\w+(ando|endo|indo)\b').hasMatch(lower)) ptBrScore += 3;
    if (tokens.contains('você') || tokens.contains('vocês') || tokens.contains('pra')) ptBrScore += 2;
    if (tokens.contains('ônibus') || tokens.contains('trem') || tokens.contains('celular')) ptBrScore += 3;
    if (tokens.contains('legal') || tokens.contains('bacana') || tokens.contains('cara') || tokens.contains('xícara')) ptBrScore += 3;

    if (ptPtScore > ptBrScore) {
      return (
        dialect: 'pt_PT',
        note: 'Европейский португальский (PT-PT): обнаружены характерные обороты или лексика Португалии.',
      );
    } else if (ptBrScore > ptPtScore) {
      return (
        dialect: 'pt_BR',
        note: 'Бразильский португальский (PT-BR): характерные герундии, местоимения или бразильская лексика.',
      );
    } else {
      return (
        dialect: 'neutral',
        note: 'Общепортугальский стиль: текст грамматически нейтрален для обоих берегов Атлантики.',
      );
    }
  }

  static List<DiaryMistakeItem> _detectMistakes(String fullText, List<String> tokens) {
    final mistakes = <DiaryMistakeItem>[];
    final lower = fullText.toLowerCase();

    // Ошибки обязательных слияний предлогов (Contrações)
    const contractions = {
      r'\bde o\b': ('do', 'de + o = do. В португальском слияние предлога de с артиклем o обязательно.'),
      r'\bde a\b': ('da', 'de + a = da. Слияние предлога de с артиклем a обязательно.'),
      r'\bde os\b': ('dos', 'de + os = dos. Слияние обязательно.'),
      r'\bde as\b': ('das', 'de + as = das. Слияние обязательно.'),
      r'\bem o\b': ('no', 'em + o = no. Предлог em с артиклем o всегда превращается в no.'),
      r'\bem a\b': ('na', 'em + a = na. Предлог em с артиклем a всегда превращается в na.'),
      r'\bem os\b': ('nos', 'em + os = nos. Слияние обязательно.'),
      r'\bem as\b': ('nas', 'em + as = nas. Слияние обязательно.'),
      r'\bem um\b': ('num', 'em + um = num. Слияние предлога с неопределенным артиклем.'),
      r'\bem uma\b': ('numa', 'em + uma = numa. Слияние предлога с неопределенным артиклем.'),
      r'\ba o\b': ('ao', 'a + o = ao. Направление к мужскому роду сливается в ao.'),
      r'\ba os\b': ('aos', 'a + os = aos. Слияние обязательно.'),
      r'\ba a\b': ('à', 'a + a = à (Crase). Предлог a сливается с женским артиклем a под обратным ударением.'),
      r'\bpor o\b': ('pelo', 'por + o = pelo. Предлог por всегда сливается в pelo.'),
      r'\bpor a\b': ('pela', 'por + a = pela. Слияние обязательно.'),
    };

    contractions.forEach((pattern, value) {
      if (RegExp(pattern).hasMatch(lower)) {
        final match = RegExp(pattern).firstMatch(lower)!.group(0)!;
        mistakes.add(
          DiaryMistakeItem(
            originalText: match,
            suggestedText: value.$1,
            ruleExplanationRu: value.$2,
            type: 'contraction',
          ),
        );
      }
    });

    // Ошибки пропущенных акцентов (диакритики)
    const diacritics = {
      'voce': ('você', 'Слово você пишется с циркумфлексом над буквой ê.'),
      'nao': ('não', 'Отрицание não всегда пишется с тильдой над ã.'),
      'sao': ('são', 'Глагол são пишется с тильдой над ã.'),
      'estao': ('estão', 'Форма estão требует тильды над ã.'),
      'mae': ('mãe', 'Слово mãe (мама) пишется с тильдой.'),
      'pao': ('pão', 'Слово pão (хлеб) пишется с тильдой над ã.'),
      'tambem': ('também', 'Слово também оканчивается на -ém под острым ударением.'),
      'ninguem': ('ninguém', 'Слово ninguém требует ударения над é.'),
      'parabens': ('parabéns', 'Поздравление parabéns пишется с ударением над é.'),
      'cafe': ('café', 'Напиток café всегда пишется с острым ударением над é.'),
      'facil': ('fácil', 'Прилагательное fácil имеет ударение на первом слоге.'),
      'dificil': ('difícil', 'Прилагательное difícil имеет ударение на предпоследнем слоге.'),
      'musica': ('música', 'Слово música — произносится с ударением на ú.'),
      'agua': ('água', 'Слово água требует ударения над á.'),
      'portugues': ('português', 'Слово português пишется с циркумфлексом над ê.'),
      'ingles': ('inglês', 'Слово inglês пишется с циркумфлексом над ê.'),
    };

    for (final token in tokens) {
      if (diacritics.containsKey(token)) {
        final val = diacritics[token]!;
        if (!mistakes.any((m) => m.originalText.toLowerCase() == token)) {
          mistakes.add(
            DiaryMistakeItem(
              originalText: token,
              suggestedText: val.$1,
              ruleExplanationRu: val.$2,
              type: 'accent',
            ),
          );
        }
      }
    }

    // Ошибки рода (ложные ассоциации с русским языком)
    const genderTraps = {
      r'\bo praia\b': ('a praia', 'Слово praia (пляж) в португальском женского рода: a praia.'),
      r'\ba dia\b': ('o dia', 'Слово dia (день) мужского рода, несмотря на окончание -a: o dia.'),
      r'\bo noite\b': ('a noite', 'Слово noite (ночь) женского рода: a noite.'),
      r'\ba problema\b': ('o problema', 'Слова греческого происхождения на -ma мужского рода: o problema.'),
      r'\ba mapa\b': ('o mapa', 'Слово mapa мужского рода: o mapa.'),
      r'\ba idioma\b': ('o idioma', 'Слово idioma мужского рода: o idioma.'),
      r'\ba tema\b': ('o tema', 'Слово tema мужского рода: o tema.'),
    };

    genderTraps.forEach((pattern, value) {
      if (RegExp(pattern).hasMatch(lower)) {
        final match = RegExp(pattern).firstMatch(lower)!.group(0)!;
        mistakes.add(
          DiaryMistakeItem(
            originalText: match,
            suggestedText: value.$1,
            ruleExplanationRu: value.$2,
            type: 'gender',
          ),
        );
      }
    });

    return mistakes;
  }

  static String _estimateCefrLevel(int wordCount, int uniqueWordCount, String text) {
    if (wordCount < 12) return 'A1';

    final lower = text.toLowerCase();
    final hasSubjunctiveOrComplex = RegExp(
      r'\b(quando eu tiver|se eu pudesse|caso|espero que|embora|apesar de|portanto)\b',
    ).hasMatch(lower);

    if (wordCount >= 60 && hasSubjunctiveOrComplex) return 'B2';
    if (wordCount >= 35 || hasSubjunctiveOrComplex) return 'B1';
    if (wordCount >= 18) return 'A2';
    return 'A1';
  }

  static String _generateFeedback({
    required int wordCount,
    required int uniqueWordCount,
    required String estimatedLevel,
    required int mistakesCount,
    required String dialect,
  }) {
    final buffer = StringBuffer();

    if (mistakesCount == 0 && wordCount >= 15) {
      buffer.write('Excelente! Грамотный и связный текст без грубых ошибок. ');
    } else if (mistakesCount > 0) {
      buffer.write('Muito bem! Вы отлично выразили мысль, обратите внимание на $mistakesCount подсказок ниже. ');
    } else {
      buffer.write('Bom começo! Хорошее начало, старайтесь писать чуть подробнее. ');
    }

    buffer.write('Объём: $wordCount слов ($uniqueWordCount уникальных). Оценочный уровень сложности: CEFR $estimatedLevel.');
    return buffer.toString();
  }

  static List<String> _extractSrsCandidates(List<String> rawTokens) {
    const stopwords = {
      'que', 'para', 'com', 'por', 'uma', 'como', 'mais', 'mas', 'foi', 'ele', 'ela',
      'isso', 'esse', 'essa', 'está', 'muito', 'hoje', 'aqui', 'meu', 'minha', 'seus',
      'suas', 'quando', 'onde', 'quem', 'todo', 'toda', 'todos', 'todas', 'você', 'eles',
    };

    final candidates = <String>{};
    for (final token in rawTokens) {
      final clean = token.toLowerCase();
      if (clean.length >= 4 && !stopwords.contains(clean) && !RegExp(r'^\d+$').hasMatch(clean)) {
        candidates.add(clean);
        if (candidates.length >= 6) break;
      }
    }
    return candidates.toList();
  }
}
