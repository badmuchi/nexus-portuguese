import '../../domain/entities/literary_work_entity.dart';

class LiteratureSeedData {
  static const List<LiteraryWorkEntity> works = [
    LiteraryWorkEntity(
      id: 'tabacaria',
      titlePt: 'Tabacaria',
      titleRu: 'Табачная лавка',
      authorName: 'Fernando Pessoa (Álvaro de Campos)',
      authorBioRu:
          'Величайший португальский поэт XX века. Создал уникальную систему гетеронимов — полноценных личностей со своими стилями, биографиями и философиями. Алвару де Кампуш — его футурист и разочарованный интроверт.',
      epochOrMovementRu: 'Модернизм (Орфей, 1928)',
      dialect: 'pt_PT',
      genre: 'Poesia Filosófica',
      coverEmoji: '🚬',
      cefrLevel: 'B2',
      analysisContextRu:
          'Вершина португальской модернистской экзистенциальной поэзии. Лирический герой сидит у окна мансарды в Лиссабоне, глядя на табачную лавку напротив, и размышляет о бездне между грандиозными внутренними мирами человека и его скромной внешней реальностью.',
      passages: [
        LiteraryPassageEntity(
          id: 'tab_1',
          originalPt:
              'Não sou nada.\nNunca serei nada.\nNão posso querer ser nada.\nÀ parte isso, tenho em mim todos os sonhos do mundo.',
          translationRu:
              'Я — ничто.\nНикогда ничем не буду.\nНе могу желать быть чем-то.\nПомимо этого, во мне заключены все сны мира.',
          grammaticalNotesRu:
              'Многократное отрицание (dupla negação): «Não... nada», «Nunca... nada». В португальском это не ошибка, а норма и усиление экспрессии. Оборот «À parte isso» означает «кроме того / помимо этого».',
          poeticDeviceRu:
              'Градация и парадокс. Переход от абсолютного экзистенциального самоуничижения к космическому масштабу внутреннего воображения.',
          audioSnippetText:
              'Não sou nada. Nunca serei nada. Não posso querer ser nada. À parte isso, tenho em mim todos os sonhos do mundo.',
        ),
        LiteraryPassageEntity(
          id: 'tab_2',
          originalPt:
              'Janelas do meu quarto,\nDo meu quarto de um dos milhões do mundo que ninguém sabe quem é\n(E se soubessem quem é, o que saberiam?),\nDais para o mistério de uma rua cruzada constantemente por gente,\nPara uma rua inacessível a todos os pensamentos.',
          translationRu:
              'Окна моей комнаты,\nКомнаты одного из миллионов людей мира, о котором никто не знает, кто он\n(А если бы и знали, что бы они знали?),\nВы выходите на тайну улицы, беспрестанно пересекаемой людьми,\nНа улицу, недоступную для любых мыслей.',
          grammaticalNotesRu:
              'Условное наклонение: «se soubessem» — Imperfeito do Subjuntivo от глагола saber, в паре с сослагательным «o que saberiam» (Condicional / Futuro do Pretérito). Архаичная форма глагола 2-го лица множественного числа «dais» (от dar para — выходить окнами на).',
          poeticDeviceRu:
              'Апострофа (прямое обращение к окнам) и риторический вопрос о границах познания человека другим человеком.',
          audioSnippetText:
              'Janelas do meu quarto, dais para o mistério de uma rua cruzada constantemente por gente.',
        ),
        LiteraryPassageEntity(
          id: 'tab_3',
          originalPt:
              'Fiz de mim o que não soube,\nE o que podia fazer de mim não o fiz.\nO dominó que vesti era errado.\nConheceram-me logo por quem não era e não desmenti, e perdi-me.',
          translationRu:
              'Я сотворил из себя то, чего не умел,\nА того, что мог бы сотворить, не сделал.\nКостюм домино, который я надел, оказался чужим.\nМеня сразу приняли не за того, кем я был, а я не стал возражать — и потерял себя.',
          grammaticalNotesRu:
              'Энклиза местоимения в прошедшем времени: «Conheceram-me» (в PT-PT строго после глагола при отсутствии триггеров проклизы). Возвратный глагол «perdi-me» (я потерялся).',
          poeticDeviceRu:
              'Метафора маскарада (домино) как искусственной социальной роли, скрывающей подлинное я.',
          audioSnippetText:
              'Fiz de mim o que não soube, e o que podia fazer de mim não o fiz. O dominó que vesti era errado.',
        ),
      ],
      vocabularyCards: [
        LiteraryVocabularyEntity(
          id: 'voc_tab_1',
          wordPt: 'Desmentir',
          translationRu: 'Опровергать, уличать во лжи, отрицать',
          partOfSpeech: 'Verbo',
          contextSentencePt: 'Não desmenti o boato e todos acreditaram.',
          contextSentenceRu: 'Я не стал опровергать слух, и все поверили.',
          etymologyRu: 'Префикс des- (отмена) + mentir (врать).',
        ),
        LiteraryVocabularyEntity(
          id: 'voc_tab_2',
          wordPt: 'Inacessível',
          translationRu: 'Недосягаемый, неприступный',
          partOfSpeech: 'Adjetivo',
          contextSentencePt: 'Para uma rua inacessível a todos os pensamentos.',
          contextSentenceRu: 'На улицу, недоступную для любых мыслей.',
          etymologyRu: 'От латинского inaccessibilis.',
        ),
      ],
    ),
    LiteraryWorkEntity(
      id: 'a_hora_da_estrela',
      titlePt: 'A Hora da Estrela',
      titleRu: 'Час звезды',
      authorName: 'Clarice Lispector',
      authorBioRu:
          'Ключевая фигура бразильской модернистской прозы XX века. Родилась в еврейской семье на Украине и переехала в Бразилию в детстве. Славится потоком сознания, экзистенциальной чувственностью и проникновением в глубины женской психики.',
      epochOrMovementRu: 'Третья волна модернизма (1977)',
      dialect: 'pt_BR',
      genre: 'Novela Existencial',
      coverEmoji: '✨',
      cefrLevel: 'B2',
      analysisContextRu:
          'Последний роман Клариси Лиспектор, изданный незадолго до её смерти. История бедной машинистки Макабеи из бедного северо-восточного региона, переехавшей в Рио-де-Жанейро. Книга начинается с размышления о самом акте творения и зарождении слова.',
      passages: [
        LiteraryPassageEntity(
          id: 'estrela_1',
          originalPt:
              'Tudo no mundo começou com um sim.\nUma molécula disse sim a outra molécula e nasceu a vida.\nMas antes da pré-história havia a pré-história da pré-história e havia o nunca e havia o sim.\nSempre houve. Não sei o quê, mas sei que o universo jamais começou.',
          translationRu:
              'Всё в мире началось с согласия — со слова «да».\nОдна молекула сказала «да» другой молекуле, и родилась жизнь.\nНо до доисторических времен была предистория предистории, и было «никогда», и было «да».\nОно было всегда. Не знаю, что именно, но знаю, что Вселенная никогда не имела начала.',
          grammaticalNotesRu:
              'Безличный глагол haver в значении существования: «havia a pré-história», «sempre houve». В этом значении глагол haver не имеет множественного числа! Конструкция «não sei o quê» (не знаю что именно).',
          poeticDeviceRu:
              'Космогоническая анафора («havia... e havia...»). Философское одушевление материи («молекула сказала да»).',
          audioSnippetText:
              'Tudo no mundo começou com um sim. Uma molécula disse sim a outra molécula e nasceu a vida.',
        ),
        LiteraryPassageEntity(
          id: 'estrela_2',
          originalPt:
              'Enquanto eu tiver perguntas e não houver resposta continuarei a escrever.\nComo começar pelo início, se as coisas acontecem antes de acontecerem?\nSe antes de doze da noite já é de madrugada?',
          translationRu:
              'Пока у меня будут вопросы и не будет ответа, я продолжу писать.\nКак начать с самого начала, если события происходят прежде, чем они случаются?\nЕсли еще до полуночи уже наступает рассвет?',
          grammaticalNotesRu:
              'Futuro do Subjuntivo: союз enquanto требует будущего сослагательного — «tiver» (от ter) и «houver» (от haver). Сочетание «continuarei a escrever» (бразильский вариант также допускает continuarei escrevendo).',
          poeticDeviceRu:
              'Парадоксальный вопрос о природе времени и причинно-следственных связей.',
          audioSnippetText:
              'Enquanto eu tiver perguntas e não houver resposta continuarei a escrever.',
        ),
      ],
      vocabularyCards: [
        LiteraryVocabularyEntity(
          id: 'voc_est_1',
          wordPt: 'Madrugada',
          translationRu: 'Раннее утро, предрассветные часы (с полуночи до зари)',
          partOfSpeech: 'Substantivo',
          contextSentencePt: 'Acordou de madrugada ouvindo o silêncio da casa.',
          contextSentenceRu: 'Она проснулась ни свет ни заря, вслушиваясь в домашнюю тишину.',
          etymologyRu: 'От позднелатинского maturicare (созревать / вставать спозаранку).',
        ),
        LiteraryVocabularyEntity(
          id: 'voc_est_2',
          wordPt: 'Desfecho',
          translationRu: 'Развязка, исход, финал',
          partOfSpeech: 'Substantivo',
          contextSentencePt: 'O desfecho da narrativa surpreendeu a todos.',
          contextSentenceRu: 'Финал повествования удивил всех.',
          etymologyRu: 'Префикс des- + fecho (замок, засов). Буквально — отпирание.',
        ),
      ],
    ),
    LiteraryWorkEntity(
      id: 'camoes_amor',
      titlePt: 'Amor é fogo que arde sem se ver',
      titleRu: 'Любовь — огонь, что пламенеет скрытно',
      authorName: 'Luís Vaz de Camões',
      authorBioRu:
          'Национальный гений Португалии, автор национального эпоса «Лузиады» (Os Lusíadas). Его сонеты считаются непревзойденной вершиной поэзии эпохи Возрождения на португальском языке.',
      epochOrMovementRu: 'Ренессанс / Классицизм (XVI век, 1595)',
      dialect: 'pt_PT',
      genre: 'Soneto Clássico',
      coverEmoji: '🔥',
      cefrLevel: 'C1',
      analysisContextRu:
          'Классический петраркистский сонет из 14 строк, построенный на серии изящных оксюморонов и антитез, описывающих противоречивую и неуловимую природу романтической любви.',
      passages: [
        LiteraryPassageEntity(
          id: 'cam_1',
          originalPt:
              'Amor é um fogo que arde sem se ver;\nÉ ferida que dói, e não se sente;\nÉ um contentamento descontente;\nÉ dor que desatina sem doer.',
          translationRu:
              'Любовь — огонь, что пламенеет скрытно;\nОна — укол, что ранит незаметно;\nОна — отрада, что порой зловеща;\nОна — страданье, полное блаженства.',
          grammaticalNotesRu:
              'Возвратная форма с пассивным значением: «sem se ver» (не будучи видимым). Глагол «desatinar» (лишать рассудка, приводить в смятение). Инфинитивные конструкции после предлогов (sem doer).',
          poeticDeviceRu:
              'Оксюморон (сочетание несочетаемого): «contentamento descontente» (недовольное довольство), «dor que desatina sem doer» (боль, сводящая с ума без боли).',
          audioSnippetText:
              'Amor é um fogo que arde sem se ver; é ferida que dói, e não se sente; é um contentamento descontente.',
        ),
        LiteraryPassageEntity(
          id: 'cam_2',
          originalPt:
              'É um não querer mais que bem querer;\nÉ um andar solitário entre a gente;\nÉ nunca contentar-se de contente;\nÉ um cuidar que ganha em se perder.',
          translationRu:
              'Она — желанье одного лишь блага;\nОна — блужданье посреди толпы;\nОна — неутолимость в насыщенье;\nОна — победа в собственном плененье.',
          grammaticalNotesRu:
              'Субстантивация инфинитивов: глаголы «querer», «andar», «cuidar» употребляются с неопределенным артиклем мужского рода как существительные («um não querer», «um andar solitário»). В PT-PT: «contentar-se» с энклизой.',
          poeticDeviceRu:
              'Антитеза уединения среди людей («andar solitário entre a gente») и победы через поражение («ganha em se perder»).',
          audioSnippetText:
              'É um não querer mais que bem querer; é um andar solitário entre a gente.',
        ),
      ],
      vocabularyCards: [
        LiteraryVocabularyEntity(
          id: 'voc_cam_1',
          wordPt: 'Desatinar',
          translationRu: 'Лишать рассудка, терять голову, буйствовать',
          partOfSpeech: 'Verbo',
          contextSentencePt: 'A paixão desatina até as mentes mais serenas.',
          contextSentenceRu: 'Страсть лишает рассудка даже самые спокойные умы.',
          etymologyRu: 'Префикс des- + tino (здравый смысл, рассудительность).',
        ),
        LiteraryVocabularyEntity(
          id: 'voc_cam_2',
          wordPt: 'Contentamento',
          translationRu: 'Удовлетворенность, блаженство, душевный покой',
          partOfSpeech: 'Substantivo',
          contextSentencePt: 'O contentamento da alma vale mais que riquezas.',
          contextSentenceRu: 'Удовлетворенность души ценнее богатств.',
          etymologyRu: 'От глагола contentar (радовать, удовлетворять).',
        ),
      ],
    ),
    LiteraryWorkEntity(
      id: 'bras_cubas',
      titlePt: 'Memórias Póstumas de Brás Cubas',
      titleRu: 'Посмертные записки Браса Кубаса',
      authorName: 'Machado de Assis',
      authorBioRu:
          'Величайший писатель в истории бразильской литературы, основатель и первый президент Бразильской академии литературы. Мастер тончайшей психологической иронии, опередивший модернизм на десятилетия.',
      epochOrMovementRu: 'Реализм (1881)',
      dialect: 'pt_BR',
      genre: 'Romance Psicológico / Sátira',
      coverEmoji: '🪦',
      cefrLevel: 'B2',
      analysisContextRu:
          'Роман-революция: повествование ведется от лица «покойного автора» (autor defunto), который уже не зависит от мнений света и с язвительным остроумием анализирует пороки, лицемерие и тщеславие бразильского общества XIX века.',
      passages: [
        LiteraryPassageEntity(
          id: 'bras_1',
          originalPt:
              'Ao verme que primeiro roeu as frias carnes do meu cadáver dedico como saudosa lembrança estas memórias póstumas.',
          translationRu:
              'Червю, который первым источил холодную плоть моего трупа, посвящаю я с нежной грустью эти посмертные записки.',
          grammaticalNotesRu:
              'Косвенное дополнение в начале фразы для смыслового акцента: «Ao verme... dedico». Знаменитое слово «saudosa» (хранящая память, полная ностальгии). Спряжение roeu — Pretérito Perfeito do Indicativo глагола roer (грызть, точить).',
          poeticDeviceRu:
              'Черная ирония и пародия на традиционные благочестивые авторские посвящения книг меценатам.',
          audioSnippetText:
              'Ao verme que primeiro roeu as frias carnes do meu cadáver dedico como saudosa lembrança estas memórias póstumas.',
        ),
        LiteraryPassageEntity(
          id: 'bras_2',
          originalPt:
              'Não tive filhos, não transmiti a nenhuma criatura o legado da nossa miséria.\nEste foi o meu maior saldo positivo na balança final da existência.',
          translationRu:
              'У меня не было детей, и я не передал ни одному созданию наследие нашей нищеты.\nЭто и стало моим самым большим положительным сальдо на итоговых весах бытия.',
          grammaticalNotesRu:
              'Pretérito Perfeito: «não tive» (ter), «não transmiti» (transmitir), «este foi» (ser). Бухгалтерская метафора: «saldo positivo na balança».',
          poeticDeviceRu:
              'Саркастический философский пессимизм: высшее благо человека — не преумножать страдания мира.',
          audioSnippetText:
              'Não tive filhos, não transmiti a nenhuma criatura o legado da nossa miséria.',
        ),
      ],
      vocabularyCards: [
        LiteraryVocabularyEntity(
          id: 'voc_bras_1',
          wordPt: 'Saudoso',
          translationRu: 'Памятный, вызывающий светлую грусть, покойный',
          partOfSpeech: 'Adjetivo',
          contextSentencePt: 'O saudoso mestre deixou lições inesquecíveis.',
          contextSentenceRu: 'Покойный наставник оставил незабвенные уроки.',
          etymologyRu: 'От корня saudade (ностальгия, тоска по прошлому).',
        ),
        LiteraryVocabularyEntity(
          id: 'voc_bras_2',
          wordPt: 'Legado',
          translationRu: 'Наследие, завещание',
          partOfSpeech: 'Substantivo',
          contextSentencePt: 'O legado cultural da língua une vários continentes.',
          contextSentenceRu: 'Культурное наследие языка объединяет несколько континентов.',
          etymologyRu: 'От латинского legatum (завещанное).',
        ),
      ],
    ),
    LiteraryWorkEntity(
      id: 'soneto_fidelidade',
      titlePt: 'Soneto de Fidelidade',
      titleRu: 'Сонет верности',
      authorName: 'Vinicius de Moraes',
      authorBioRu:
          '«О Poetinha» бразильской культуры. Дипломат, драматург, поэт и один из отцов-основателей Босса-новы вместе с Томом Жобимом. Автор слов к легендарной «Garota de Ipanema».',
      epochOrMovementRu: 'Вторая фаза бразильского модернизма (1946)',
      dialect: 'pt_BR',
      genre: 'Soneto Lírico',
      coverEmoji: '🌹',
      cefrLevel: 'B1',
      analysisContextRu:
          'Самый цитируемый в бразильских признаниях в любви сонет. Он провозглашает любовь страстной, искренней и живой, сознавая при этом бренность человеческого бытия.',
      passages: [
        LiteraryPassageEntity(
          id: 'fid_1',
          originalPt:
              'De tudo, ao meu amor serei atento\nAntes, e com tal zelo, e sempre, e tanto\nQue mesmo em face do maior encanto\nDele se encante mais meu pensamento.',
          translationRu:
              'Ко всему на свете ради моей любви буду внимателен\nПрежде всего, и с таким рвением, и всегда, и столь сильно,\nЧто даже перед лицом величайшего очарования\nЕй одной очаруется еще сильнее моя мысль.',
          grammaticalNotesRu:
              'Futuro do Presente: «serei» (буду). Конструкция следствия: «com tal zelo... que» (с таким рвением... что). Сослагательное наклонение в придаточном: «se encante» (Presente do Subjuntivo).',
          poeticDeviceRu:
              'Полисиндетон (многосоюзие «e... e... e...») для передачи нарастающей интенсивности чувства.',
          audioSnippetText:
              'De tudo, ao meu amor serei atento antes, e com tal zelo, e sempre, e tanto.',
        ),
        LiteraryPassageEntity(
          id: 'fid_2',
          originalPt:
              'Eu possa me dizer do amor (que tive):\nQue não seja imortal, posto que é chama\nMas que seja infinito enquanto dure.',
          translationRu:
              'Да смогу я сказать о любви (которая у меня была):\nПусть она не бессмертна, ведь она — лишь пламя,\nНо пусть будет бесконечна, пока она длится.',
          grammaticalNotesRu:
              'Оптотативное Presente do Subjuntivo (пожелание): «Eu possa...», «Que não seja...», «Mas que seja...». Уступительный союз «posto que» (хотя / поскольку). Временной союз «enquanto dure» с субхунтивом.',
          poeticDeviceRu:
              'Афористический парадокс: любовь не вечна, но бесконечна в каждое мгновение своего горения.',
          audioSnippetText:
              'Que não seja imortal, posto que é chama, mas que seja infinito enquanto dure.',
        ),
      ],
      vocabularyCards: [
        LiteraryVocabularyEntity(
          id: 'voc_fid_1',
          wordPt: 'Zelo',
          translationRu: 'Рвение, усердие, забота',
          partOfSpeech: 'Substantivo',
          contextSentencePt: 'Cuidava das palavras com extremo zelo e carinho.',
          contextSentenceRu: 'Он относился к словам с чрезвычайным усердием и нежностью.',
          etymologyRu: 'От греческого zelos (страстное стремление, пыл).',
        ),
        LiteraryVocabularyEntity(
          id: 'voc_fid_2',
          wordPt: 'Chama',
          translationRu: 'Пламя, огонь',
          partOfSpeech: 'Substantivo',
          contextSentencePt: 'A chama da lareira aquecia a noite de inverno.',
          contextSentenceRu: 'Пламя очага согревало зимний вечер.',
          etymologyRu: 'От латинского flamma.',
        ),
      ],
    ),
    LiteraryWorkEntity(
      id: 'florbela_amar',
      titlePt: 'Eu Quero Amar, Amar Perdidamente!',
      titleRu: 'Хочу любить, любить безудержно!',
      authorName: 'Florbela Espanca',
      authorBioRu:
          'Выдающаяся португальская поэтесса начала XX века из региона Алентежу. Предшественница феминистского самосознания в португальской лирике, писавшая со страстной эмоциональной силой и трагической искренностью.',
      epochOrMovementRu: 'Символизм / Поздний романтизм (1923)',
      dialect: 'pt_PT',
      genre: 'Soneto Passional',
      coverEmoji: '🥀',
      cefrLevel: 'B2',
      analysisContextRu:
          'Гимн абсолютной, свободной и всепоглощающей женской любви без страха перед осуждением консервативного общества того времени.',
      passages: [
        LiteraryPassageEntity(
          id: 'flor_1',
          originalPt:
              'Eu quero amar, amar perdidamente!\nAmar só por amar: Aqui... além...\nMais Este e Aquele, o Outro e toda a gente...\nAmar! Amar! E não amar ninguém!',
          translationRu:
              'Хочу любить, любить безудержно!\nЛюбить лишь ради самой любви: здесь... там...\nИ этого, и того, другого, да и всех подряд...\nЛюбить! Любить! И не любить никого!',
          grammaticalNotesRu:
              'Наречие с суффиксом -mente: «perdidamente» (безудержно, без оглядки, до безумия). Указательные местоимения в роли существительных: «Este e Aquele» (этот и тот).',
          poeticDeviceRu:
              'Анафора и экспрессивные восклицания, кульминирующие в финальном парадоксе отшельника: любить весь мир, не привязываясь ни к кому лично.',
          audioSnippetText:
              'Eu quero amar, amar perdidamente! Amar só por amar: aqui, além, mais este e aquele.',
        ),
      ],
      vocabularyCards: [
        LiteraryVocabularyEntity(
          id: 'voc_flor_1',
          wordPt: 'Perdidamente',
          translationRu: 'Безудержно, безумно, без оглядки',
          partOfSpeech: 'Advérbio',
          contextSentencePt: 'Estava perdidamente apaixonado pelo som das ondas.',
          contextSentenceRu: 'Он был безумно влюблен в шум прибоя.',
          etymologyRu: 'От причастия perdido (потерянный) + суффикс -mente.',
        ),
      ],
    ),
  ];

  static const List<LiteraryQuoteEntity> famousQuotes = [
    LiteraryQuoteEntity(
      id: 'q_saramago',
      quotePt: 'Se podes olhar, vê. Se podes ver, repara.',
      translationRu: 'Если можешь смотреть — смотри. Если можешь видеть — замечай.',
      authorName: 'José Saramago',
      workTitle: 'Ensaio sobre a Cegueira',
      publicationYear: 1995,
      dialect: 'pt_PT',
      philosophicalInsightRu:
          'Эпиграф нобелевского лауреата Жозе Сарамаго: разница между пассивным зрением и осознанным сострадательным вниманием к окружающему миру.',
    ),
    LiteraryQuoteEntity(
      id: 'q_couto',
      quotePt: 'O mar não tem caminhos: é por isso que ninguém se perde nele.',
      translationRu: 'У моря нет дорог: именно поэтому в нём никто не может заблудиться.',
      authorName: 'Mia Couto',
      workTitle: 'Terra Sonâmbula',
      publicationYear: 1992,
      dialect: 'pt_PT',
      philosophicalInsightRu:
          'Мозамбикский писатель Миа Коуто создает магический реализм через поэтическую мудрость африканского побережья Индийского океана.',
    ),
    LiteraryQuoteEntity(
      id: 'q_rosa',
      quotePt: 'O real não está na saída nem na chegada: ele se dispõe para a gente é no meio da travessia.',
      translationRu: 'Подлинное не в начале и не в конце пути: оно открывается нам в самой сердцевине переправы.',
      authorName: 'Guimarães Rosa',
      workTitle: 'Grande Sertão: Veredas',
      publicationYear: 1956,
      dialect: 'pt_BR',
      philosophicalInsightRu:
          'Великая бразильская метафора: смысл жизни заключается не в пунктах отправления или прибытия, а в самом проживании пути через сертан.',
    ),
    LiteraryQuoteEntity(
      id: 'q_drummond',
      quotePt: 'No meio do caminho tinha uma pedra / tinha uma pedra no meio do caminho.',
      translationRu: 'Посреди дороги лежал камень / лежал камень посреди дороги.',
      authorName: 'Carlos Drummond de Andrade',
      workTitle: 'Alguma Poesia',
      publicationYear: 1930,
      dialect: 'pt_BR',
      philosophicalInsightRu:
          'Знаменитейший модернистский повтор Карлоса Друммонда де Андраде — метафора непреодолимых экзистенциальных препятствий, сопровождающих каждого человека.',
    ),
    LiteraryQuoteEntity(
      id: 'q_queiros',
      quotePt: 'A curiosidade é o instinto da inteligência.',
      translationRu: 'Любопытство — это инстинкт интеллекта.',
      authorName: 'Eça de Queirós',
      workTitle: 'Os Maias',
      publicationYear: 1888,
      dialect: 'pt_PT',
      philosophicalInsightRu:
          'Эса де Кейрош, непревзойденный стилист португальского реализма, напоминает, что знание рождается из неугасающего интереса к миру.',
    ),
    LiteraryQuoteEntity(
      id: 'q_pessoa',
      quotePt: 'Tudo vale a pena se a alma não é pequena.',
      translationRu: 'Всё имеет цену и смысл, если душа не мелка.',
      authorName: 'Fernando Pessoa',
      workTitle: 'Mensagem',
      publicationYear: 1934,
      dialect: 'pt_PT',
      philosophicalInsightRu:
          'Самый цитируемый девиз португальского духа: великие испытания и плавания оправданы величием человеческой мечты.',
    ),
  ];
}
