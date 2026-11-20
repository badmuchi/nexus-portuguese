import '../entities/morphology_models.dart';

class PortugueseMorphologyEngine {
  static const Map<String, ContractionBreakdown> _contractionsMap = {
    'do': ContractionBreakdown(
      preposition: 'de',
      articleOrPronoun: 'o',
      formula: 'de + o = do',
      explanationRu: 'Слияние предлога de (из/от/кого) и определенного артикля муж. рода o (тот).',
    ),
    'da': ContractionBreakdown(
      preposition: 'de',
      articleOrPronoun: 'a',
      formula: 'de + a = da',
      explanationRu: 'Слияние предлога de (из/от/кого) и определенного артикля жен. рода a (та).',
    ),
    'dos': ContractionBreakdown(
      preposition: 'de',
      articleOrPronoun: 'os',
      formula: 'de + os = dos',
      explanationRu: 'Слияние предлога de и артикля мн. числа муж. рода os.',
    ),
    'das': ContractionBreakdown(
      preposition: 'de',
      articleOrPronoun: 'as',
      formula: 'de + as = das',
      explanationRu: 'Слияние предлога de и артикля мн. числа жен. рода as.',
    ),
    'dum': ContractionBreakdown(
      preposition: 'de',
      articleOrPronoun: 'um',
      formula: 'de + um = dum',
      explanationRu: 'Слияние предлога de и неопределенного артикля um (в Бразилии чаще пишется раздельно: de um).',
    ),
    'duma': ContractionBreakdown(
      preposition: 'de',
      articleOrPronoun: 'uma',
      formula: 'de + uma = duma',
      explanationRu: 'Слияние предлога de и неопределенного артикля uma.',
    ),
    'no': ContractionBreakdown(
      preposition: 'em',
      articleOrPronoun: 'o',
      formula: 'em + o = no',
      explanationRu: 'Слияние предлога em (в/на) и артикля o (в этом, в том самом).',
    ),
    'na': ContractionBreakdown(
      preposition: 'em',
      articleOrPronoun: 'a',
      formula: 'em + a = na',
      explanationRu: 'Слияние предлога em (в/на) и артикля a (в этой, на той самой).',
    ),
    'nos': ContractionBreakdown(
      preposition: 'em',
      articleOrPronoun: 'os',
      formula: 'em + os = nos',
      explanationRu: 'Слияние предлога em и артикля os.',
    ),
    'nas': ContractionBreakdown(
      preposition: 'em',
      articleOrPronoun: 'as',
      formula: 'em + as = nas',
      explanationRu: 'Слияние предлога em и артикля as.',
    ),
    'num': ContractionBreakdown(
      preposition: 'em',
      articleOrPronoun: 'um',
      formula: 'em + um = num',
      explanationRu: 'Слияние предлога em (в) и неопределенного артикля um (в каком-то).',
    ),
    'numa': ContractionBreakdown(
      preposition: 'em',
      articleOrPronoun: 'uma',
      formula: 'em + uma = numa',
      explanationRu: 'Слияние предлога em (в) и неопределенного артикля uma (в какой-то).',
    ),
    'pelo': ContractionBreakdown(
      preposition: 'por',
      articleOrPronoun: 'o',
      formula: 'por + o = pelo',
      explanationRu: 'Слияние предлога por (через/по/за) и артикля o.',
    ),
    'pela': ContractionBreakdown(
      preposition: 'por',
      articleOrPronoun: 'a',
      formula: 'por + a = pela',
      explanationRu: 'Слияние предлога por (через/по/за) и артикля a.',
    ),
    'pelos': ContractionBreakdown(
      preposition: 'por',
      articleOrPronoun: 'os',
      formula: 'por + os = pelos',
      explanationRu: 'Слияние предлога por и артикля мн.ч. pelos.',
    ),
    'pelas': ContractionBreakdown(
      preposition: 'por',
      articleOrPronoun: 'as',
      formula: 'por + as = pelas',
      explanationRu: 'Слияние предлога por и артикля мн.ч. pelas.',
    ),
    'à': ContractionBreakdown(
      preposition: 'a',
      articleOrPronoun: 'a',
      formula: 'a + a = à (crase)',
      explanationRu: 'Знаменитый краз (crase): слияние предлога направления a (куда) и артикля жен. рода a. Обозначается обратным ударением (`).',
    ),
    'ao': ContractionBreakdown(
      preposition: 'a',
      articleOrPronoun: 'o',
      formula: 'a + o = ao',
      explanationRu: 'Слияние предлога направления a (к/в) и артикля муж. рода o (к кому/куда).',
    ),
  };

  static const Map<String, _WordMeta> _staticDict = {
    // Articles
    'o': _WordMeta(PartOfSpeech.artigo, 'o', 'определенный артикль муж. рода (ед.ч.)', 'муж. род, ед.ч.'),
    'a': _WordMeta(PartOfSpeech.artigo, 'a', 'определенный артикль жен. рода / предлог «к, в»', 'жен. род, ед.ч.'),
    'os': _WordMeta(PartOfSpeech.artigo, 'o', 'артикль муж. рода (мн.ч.)', 'муж. род, мн.ч.'),
    'as': _WordMeta(PartOfSpeech.artigo, 'a', 'артикль жен. рода (мн.ч.)', 'жен. род, мн.ч.'),
    'um': _WordMeta(PartOfSpeech.artigo, 'um', 'неопределенный артикль / числительное «один»', 'муж. род'),
    'uma': _WordMeta(PartOfSpeech.artigo, 'uma', 'неопределенный артикль / числительное «одна»', 'жен. род'),

    // Pronouns
    'eu': _WordMeta(PartOfSpeech.pronome, 'eu', 'я (личное местоимение)', '1-е лицо ед.ч.'),
    'tu': _WordMeta(PartOfSpeech.pronome, 'tu', 'ты (личное местоимение, популярно в Португалии)', '2-е лицо ед.ч.'),
    'você': _WordMeta(PartOfSpeech.pronome, 'você', 'ты / вы (стандартное вежливое обращение в Бразилии)', '3-е лицо ед.ч.'),
    'ele': _WordMeta(PartOfSpeech.pronome, 'ele', 'он', '3-е лицо муж. род'),
    'ela': _WordMeta(PartOfSpeech.pronome, 'ela', 'она', '3-е лицо жен. род'),
    'nós': _WordMeta(PartOfSpeech.pronome, 'nós', 'мы', '1-е лицо мн.ч.'),
    'vocês': _WordMeta(PartOfSpeech.pronome, 'vocês', 'вы (множественное число)', '3-е лицо мн.ч.'),
    'eles': _WordMeta(PartOfSpeech.pronome, 'eles', 'они (мужчины / смешанная группа)', '3-е лицо мн.ч.'),
    'elas': _WordMeta(PartOfSpeech.pronome, 'elas', 'они (женщины)', '3-е лицо мн.ч.'),
    'meu': _WordMeta(PartOfSpeech.pronome, 'meu', 'мой', 'притяжательное, муж. род'),
    'minha': _WordMeta(PartOfSpeech.pronome, 'meu', 'моя', 'притяжательное, жен. род'),
    'seu': _WordMeta(PartOfSpeech.pronome, 'seu', 'ваш / твой', 'притяжательное, муж. род'),
    'sua': _WordMeta(PartOfSpeech.pronome, 'seu', 'ваша / твоя', 'притяжательное, жен. род'),
    'isso': _WordMeta(PartOfSpeech.pronome, 'isso', 'это (указательное местоимение)', 'средний род'),
    'isto': _WordMeta(PartOfSpeech.pronome, 'isto', 'вот это (близко к говорящему)', 'средний род'),
    'aquilo': _WordMeta(PartOfSpeech.pronome, 'aquilo', 'то (вдали)', 'средний род'),

    // Prepositions
    'de': _WordMeta(PartOfSpeech.preposicao, 'de', 'из, от, о, признак принадлежности (кого/чего)', 'предлог'),
    'em': _WordMeta(PartOfSpeech.preposicao, 'em', 'в, на (местоположение)', 'предлог'),
    'para': _WordMeta(PartOfSpeech.preposicao, 'para', 'для, к (цель, направление)', 'предлог'),
    'por': _WordMeta(PartOfSpeech.preposicao, 'por', 'через, по, из-за, посредством', 'предлог'),
    'com': _WordMeta(PartOfSpeech.preposicao, 'com', 'с, вместе с', 'предлог'),
    'sem': _WordMeta(PartOfSpeech.preposicao, 'sem', 'без', 'предлог'),

    // Conjunctions & Adverbs
    'e': _WordMeta(PartOfSpeech.conjuncao, 'e', 'и, а', 'соединительный союз'),
    'mas': _WordMeta(PartOfSpeech.conjuncao, 'mas', 'но, однако', 'противительный союз'),
    'que': _WordMeta(PartOfSpeech.conjuncao, 'que', 'что, который', 'союз / относительное местоимение'),
    'se': _WordMeta(PartOfSpeech.conjuncao, 'se', 'если; себя (возвратная частица)', 'союз / возвратное местоимение'),
    'não': _WordMeta(PartOfSpeech.adverbio, 'não', 'нет, не', 'отрицательное наречие'),
    'sim': _WordMeta(PartOfSpeech.adverbio, 'sim', 'да', 'утвердительное наречие'),
    'muito': _WordMeta(PartOfSpeech.adverbio, 'muito', 'очень, много', 'наречие меры и степени'),
    'bem': _WordMeta(PartOfSpeech.adverbio, 'bem', 'хорошо', 'наречие образа действия'),
    'hoje': _WordMeta(PartOfSpeech.adverbio, 'hoje', 'сегодня', 'наречие времени'),
    'amanhã': _WordMeta(PartOfSpeech.adverbio, 'amanhã', 'завтра', 'наречие времени'),
    'ontem': _WordMeta(PartOfSpeech.adverbio, 'ontem', 'вчера', 'наречие времени'),
    'aqui': _WordMeta(PartOfSpeech.adverbio, 'aqui', 'здесь, сюда', 'наречие места'),
    'lá': _WordMeta(PartOfSpeech.adverbio, 'lá', 'там, туда', 'наречие места'),

    // Key Verbs & Inflections
    'é': _WordMeta(PartOfSpeech.verbo, 'ser', 'является, есть (постоянное свойство)', 'Presente do Indicativo, 3-е л. ед.ч.'),
    'sou': _WordMeta(PartOfSpeech.verbo, 'ser', 'я есть, являюсь', 'Presente do Indicativo, 1-е л. ед.ч.'),
    'somos': _WordMeta(PartOfSpeech.verbo, 'ser', 'мы являемся', 'Presente do Indicativo, 1-е л. мн.ч.'),
    'são': _WordMeta(PartOfSpeech.verbo, 'ser', 'они являются / вы являетесь', 'Presente do Indicativo, 3-е л. мн.ч.'),
    'foi': _WordMeta(PartOfSpeech.verbo, 'ser / ir', 'был(а) / пошел, поехал', 'Pretérito Perfeito, 3-е л. ед.ч.'),
    'fui': _WordMeta(PartOfSpeech.verbo, 'ser / ir', 'я был / я пошел', 'Pretérito Perfeito, 1-е л. ед.ч.'),
    'era': _WordMeta(PartOfSpeech.verbo, 'ser', 'был(а) в прошлом (длительно)', 'Pretérito Imperfeito, 1/3-е л. ед.ч.'),
    'está': _WordMeta(PartOfSpeech.verbo, 'estar', 'находится, чувствует себя (временно)', 'Presente do Indicativo, 3-е л. ед.ч.'),
    'estou': _WordMeta(PartOfSpeech.verbo, 'estar', 'я нахожусь / чувствую себя', 'Presente do Indicativo, 1-е л. ед.ч.'),
    'estamos': _WordMeta(PartOfSpeech.verbo, 'estar', 'мы находимся', 'Presente do Indicativo, 1-е л. мн.ч.'),
    'estão': _WordMeta(PartOfSpeech.verbo, 'estar', 'они находятся', 'Presente do Indicativo, 3-е л. мн.ч.'),
    'estava': _WordMeta(PartOfSpeech.verbo, 'estar', 'находился(лась)', 'Pretérito Imperfeito, 1/3-е л. ед.ч.'),
    'tem': _WordMeta(PartOfSpeech.verbo, 'ter', 'имеет; в Бразилии: имеется, есть', 'Presente do Indicativo, 3-е л. ед.ч.'),
    'tenho': _WordMeta(PartOfSpeech.verbo, 'ter', 'я имею, у меня есть', 'Presente do Indicativo, 1-е л. ед.ч.'),
    'temos': _WordMeta(PartOfSpeech.verbo, 'ter', 'мы имеем, у нас есть', 'Presente do Indicativo, 1-е л. мн.ч.'),
    'têm': _WordMeta(PartOfSpeech.verbo, 'ter', 'они имеют, у них есть', 'Presente do Indicativo, 3-е л. мн.ч.'),
    'vai': _WordMeta(PartOfSpeech.verbo, 'ir', 'идет, едет; маркер будущего времени', 'Presente do Indicativo, 3-е л. ед.ч.'),
    'vou': _WordMeta(PartOfSpeech.verbo, 'ir', 'я иду, еду; собираюсь сделать', 'Presente do Indicativo, 1-е л. ед.ч.'),
    'vamos': _WordMeta(PartOfSpeech.verbo, 'ir', 'мы идем, едем; пойдемте!', 'Presente do Indicativo, 1-е л. мн.ч.'),
    'vão': _WordMeta(PartOfSpeech.verbo, 'ir', 'они идут / собираются', 'Presente do Indicativo, 3-е л. мн.ч.'),
    'fala': _WordMeta(PartOfSpeech.verbo, 'falar', 'говорит, разговаривает', 'Presente do Indicativo, 3-е л. ед.ч.'),
    'falo': _WordMeta(PartOfSpeech.verbo, 'falar', 'я говорю', 'Presente do Indicativo, 1-е л. ед.ч.'),
    'falam': _WordMeta(PartOfSpeech.verbo, 'falar', 'они говорят', 'Presente do Indicativo, 3-е л. мн.ч.'),
    'gosto': _WordMeta(PartOfSpeech.verbo, 'gostar', 'мне нравится (требует предлог de)', 'Presente do Indicativo, 1-е л. ед.ч.'),
    'gosta': _WordMeta(PartOfSpeech.verbo, 'gostar', 'ему/ей нравится', 'Presente do Indicativo, 3-е л. ед.ч.'),
    'moro': _WordMeta(PartOfSpeech.verbo, 'morar', 'я живу, проживаю', 'Presente do Indicativo, 1-е л. ед.ч.'),
    'mora': _WordMeta(PartOfSpeech.verbo, 'morar', 'живет, проживает', 'Presente do Indicativo, 3-е л. ед.ч.'),
    'quero': _WordMeta(PartOfSpeech.verbo, 'querer', 'я хочу', 'Presente do Indicativo, 1-е л. ед.ч.'),
    'quer': _WordMeta(PartOfSpeech.verbo, 'querer', 'хочет', 'Presente do Indicativo, 3-е л. ед.ч.'),
    'faz': _WordMeta(PartOfSpeech.verbo, 'fazer', 'делает; о погоде: faz calor/frio', 'Presente do Indicativo, 3-е л. ед.ч.'),
    'faço': _WordMeta(PartOfSpeech.verbo, 'fazer', 'я делаю', 'Presente do Indicativo, 1-е л. ед.ч.'),
  };

  /// Breaks down a sentence into individual analyzed morphological tokens.
  static SentenceXRayEntity analyzeSentence({
    required String sentence,
    String translationRu = '',
  }) {
    final rawTokens = sentence.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
    final words = <WordMorphology>[];

    for (final raw in rawTokens) {
      final clean = raw.toLowerCase().replaceAll(RegExp(r'[^\wáàâãéêíóôõúçÁÀÂÃÉÊÍÓÔÕÚÇ\-]'), '');
      if (clean.isEmpty) continue;

      words.add(_analyzeWord(raw, clean));
    }

    return SentenceXRayEntity(
      originalSentence: sentence,
      translationRu: translationRu,
      words: words,
    );
  }

  static WordMorphology _analyzeWord(String rawWord, String cleanWord) {
    // 1. Check for Preposition Contractions (do, na, numa, pelo, à...)
    if (_contractionsMap.containsKey(cleanWord)) {
      final c = _contractionsMap[cleanWord]!;
      return WordMorphology(
        rawWord: rawWord,
        cleanWord: cleanWord,
        partOfSpeech: PartOfSpeech.contracao,
        lemma: '${c.preposition} + ${c.articleOrPronoun}',
        translationRu: c.formula,
        grammarNotes: c.explanationRu,
        contraction: c,
      );
    }

    // 2. Check for Enclitic Hyphenated Pronouns (avise-me, mistura-se)
    if (cleanWord.contains('-')) {
      final parts = cleanWord.split('-');
      if (parts.length == 2) {
        final base = parts[0];
        final clitic = parts[1];
        const clitics = {'me', 'te', 'se', 'nos', 'vos', 'lhe', 'lhes', 'o', 'a', 'os', 'as'};

        if (clitics.contains(clitic)) {
          return WordMorphology(
            rawWord: rawWord,
            cleanWord: cleanWord,
            partOfSpeech: PartOfSpeech.verbo,
            lemma: base,
            translationRu: 'Глагол «$base» с местоимением «-$clitic»',
            grammarNotes: 'Энклиза (ênclise): местоимение присоединяется через дефис.',
            cliticPronoun: clitic,
          );
        }
      }
    }

    // 3. Check Static Vocabulary Dictionary
    if (_staticDict.containsKey(cleanWord)) {
      final meta = _staticDict[cleanWord]!;
      return WordMorphology(
        rawWord: rawWord,
        cleanWord: cleanWord,
        partOfSpeech: meta.pos,
        lemma: meta.lemma,
        translationRu: meta.translation,
        grammarNotes: meta.grammarNotes,
      );
    }

    // 4. Heuristics based on endings
    if (cleanWord.endsWith('mente')) {
      return WordMorphology(
        rawWord: rawWord,
        cleanWord: cleanWord,
        partOfSpeech: PartOfSpeech.adverbio,
        lemma: cleanWord.replaceAll(RegExp(r'mente$'), ''),
        translationRu: 'Наречие образа действия',
        grammarNotes: 'Образовано с помощью продуктивного суффикса -mente (как русский суффикс -о/-е).',
      );
    }

    if (cleanWord.endsWith('ção') || cleanWord.endsWith('são')) {
      return WordMorphology(
        rawWord: rawWord,
        cleanWord: cleanWord,
        partOfSpeech: PartOfSpeech.substantivo,
        lemma: cleanWord,
        translationRu: 'Отглагольное существительное',
        grammarNotes: 'Существительное женского рода на -ção (от латинского -tionem).',
      );
    }

    if (cleanWord.endsWith('ando') || cleanWord.endsWith('endo') || cleanWord.endsWith('indo')) {
      return WordMorphology(
        rawWord: rawWord,
        cleanWord: cleanWord,
        partOfSpeech: PartOfSpeech.verbo,
        lemma: cleanWord.replaceAll(RegExp(r'[aei]ndo$'), 'r'),
        translationRu: 'Герундий (Gerúndio)',
        grammarNotes: 'Форма длительного действия: используется с глаголом estar (estou fazendo / falando).',
      );
    }

    if (cleanWord.endsWith('ar') || cleanWord.endsWith('er') || cleanWord.endsWith('ir')) {
      return WordMorphology(
        rawWord: rawWord,
        cleanWord: cleanWord,
        partOfSpeech: PartOfSpeech.verbo,
        lemma: cleanWord,
        translationRu: 'Инфинитив глагола',
        grammarNotes: 'Начальная словарная форма глагола.',
      );
    }

    return WordMorphology(
      rawWord: rawWord,
      cleanWord: cleanWord,
      partOfSpeech: PartOfSpeech.desconhecido,
      lemma: cleanWord,
      translationRu: cleanWord,
    );
  }
}

class _WordMeta {
  final PartOfSpeech pos;
  final String lemma;
  final String translation;
  final String grammarNotes;

  const _WordMeta(this.pos, this.lemma, this.translation, this.grammarNotes);
}
