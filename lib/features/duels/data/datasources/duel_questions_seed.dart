import '../../domain/entities/duel_question_entity.dart';

class DuelQuestionsSeed {
  static const List<DuelQuestion> questions = [
    // 1. Автобус (Vocabulário)
    DuelQuestion(
      id: 'duel_bus',
      category: DuelCategory.vocabulario,
      questionTitle: 'Общественный транспорт',
      promptRu: 'Как называют городской автобус в Лиссабоне (Португалия)?',
      targetDialect: 'pt_PT',
      options: ['Autocarro', 'Ônibus', 'Comboio', 'Elétrico'],
      correctIndex: 0,
      ptPtEquivalent: 'O autocarro',
      ptBrEquivalent: 'O ônibus',
      culturalNotePt: 'В Португалии автобус называется autocarro, а comboio — это поезд.',
      culturalNoteRu: 'В Бразилии говорят ônibus (от лат. omnibus), а в Португалии — autocarro.',
    ),

    // 2. Мобильный телефон (Vocabulário)
    DuelQuestion(
      id: 'duel_phone',
      category: DuelCategory.vocabulario,
      questionTitle: 'Гаджеты и связь',
      promptRu: 'Как в Бразилии называют мобильный телефон?',
      targetDialect: 'pt_BR',
      options: ['Telemóvel', 'Celular', 'Aparelho', 'Fixo'],
      correctIndex: 1,
      ptPtEquivalent: 'O telemóvel',
      ptBrEquivalent: 'O celular',
      culturalNotePt: 'В Португалии мобильный — telemóvel, в Бразилии сократили до celular.',
      culturalNoteRu: 'В Бразилии говорят celular (от сотовой сети), в Португалии — telemóvel.',
    ),

    // 3. Поезд (Vocabulário)
    DuelQuestion(
      id: 'duel_train',
      category: DuelCategory.vocabulario,
      questionTitle: 'Железная дорога',
      promptRu: 'Как в Португалии называют поезд?',
      targetDialect: 'pt_PT',
      options: ['Trem', 'Comboio', 'Metrô', 'Vagão'],
      correctIndex: 1,
      ptPtEquivalent: 'O comboio',
      ptBrEquivalent: 'O trem',
      culturalNotePt: 'Comboio в Португалии — это любой железнодорожный поезд.',
      culturalNoteRu: 'В Бразилии используется слово trem (особенно знаменит в Минас-Жерайс).',
    ),

    // 4. Завтрак (Vocabulário)
    DuelQuestion(
      id: 'duel_breakfast',
      category: DuelCategory.vocabulario,
      questionTitle: 'Еда и приемы пищи',
      promptRu: 'Как португальцы называют утренний завтрак?',
      targetDialect: 'pt_PT',
      options: ['Café da manhã', 'Pequeno-almoço', 'Lancheira', 'Desjejum'],
      correctIndex: 1,
      ptPtEquivalent: 'O pequeno-almoço',
      ptBrEquivalent: 'O café da manhã',
      culturalNotePt: 'Pequeno-almoço буквально переводится как «маленький обед».',
      culturalNoteRu: 'В Бразилии завтрак называют café da manhã («утренний кофе»).',
    ),

    // 5. Мороженое (Vocabulário)
    DuelQuestion(
      id: 'duel_icecream',
      category: DuelCategory.vocabulario,
      questionTitle: 'Десерты и сладости',
      promptRu: 'Как заказать мороженое в Рио-де-Жанейро или Сан-Паулу?',
      targetDialect: 'pt_BR',
      options: ['Gelado', 'Sorvete', 'Picolé', 'Doce frio'],
      correctIndex: 1,
      ptPtEquivalent: 'O gelado',
      ptBrEquivalent: 'O sorvete',
      culturalNotePt: 'В Португалии заказывают um gelado.',
      culturalNoteRu: 'В Бразилии — sorvete (а на палочке — picolé).',
    ),

    // 6. Чашка (Vocabulário)
    DuelQuestion(
      id: 'duel_cup',
      category: DuelCategory.vocabulario,
      questionTitle: 'Посуда',
      promptRu: 'В Португалии чашку для чая или кофе называют:',
      targetDialect: 'pt_PT',
      options: ['Xícara', 'Chávena', 'Copo', 'Caneca'],
      correctIndex: 1,
      ptPtEquivalent: 'A chávena',
      ptBrEquivalent: 'A xícara',
      culturalNotePt: 'Chávena de café — классическое португальское обозначение чашки.',
      culturalNoteRu: 'В Бразилии повсеместно употребляется xícara.',
    ),

    // 7. Ананас (Vocabulário)
    DuelQuestion(
      id: 'duel_pineapple',
      category: DuelCategory.vocabulario,
      questionTitle: 'Фрукты',
      promptRu: 'Как называют ананас в Бразилии?',
      targetDialect: 'pt_BR',
      options: ['Ananás', 'Abacaxi', 'Maracujá', 'Caju'],
      correctIndex: 1,
      ptPtEquivalent: 'O ananás',
      ptBrEquivalent: 'O abacaxi',
      culturalNotePt: 'В Португалии популярен ananás dos Açores.',
      culturalNoteRu: 'Abacaxi происходит из языка индейцев тупи-гуарани (ibá cati).',
    ),

    // 8. Герундий vs Инфинитив (Gramática)
    DuelQuestion(
      id: 'duel_grammar_gerund',
      category: DuelCategory.gramatica,
      questionTitle: 'Продолженное действие прямо сейчас',
      promptRu: 'Как португалец скажет: «Я сейчас работаю»?',
      targetDialect: 'pt_PT',
      options: ['Estou trabalhando', 'Estou a trabalhar', 'Trabalho agora', 'Fico trabalhando'],
      correctIndex: 1,
      ptPtEquivalent: 'Estou a trabalhar',
      ptBrEquivalent: 'Estou trabalhando',
      culturalNotePt: 'В европейском португальском конструкция estar a + infinitivo заменяет герундий.',
      culturalNoteRu: 'Бразильцы предпочитают классический герундий на -ando/-endo/-indo: estou trabalhando.',
    ),

    // 9. Местоимения в начале предложения (Gramática)
    DuelQuestion(
      id: 'duel_grammar_clitic',
      category: DuelCategory.gramatica,
      questionTitle: 'Положение местоимения в просьбе',
      promptRu: 'Какая фраза соответствует строгой португальской норме (PT-PT) при заказе кофе?',
      targetDialect: 'pt_PT',
      options: ['Me dá um café', 'Dá-me um café', 'Dá eu um café', 'Me dê o café'],
      correctIndex: 1,
      ptPtEquivalent: 'Dá-me um café',
      ptBrEquivalent: 'Me dá um café / Me dê um café',
      culturalNotePt: 'В Португалии никогда не начинают предложение с безударного местоимения (ênclise).',
      culturalNoteRu: 'В Бразилии в разговорной речи проклитика повсеместна: «Me dá um café».',
    ),

    // 10. Местоимение обращения (Gramática)
    DuelQuestion(
      id: 'duel_grammar_pronoun',
      category: DuelCategory.gramatica,
      questionTitle: 'Обращение на «ты»',
      promptRu: 'В Португалии при неформальном общении с другом используют:',
      targetDialect: 'pt_PT',
      options: ['Você vai', 'Tu vais', 'O senhor vai', 'A gente vai'],
      correctIndex: 1,
      ptPtEquivalent: 'Tu vais / Tu queres',
      ptBrEquivalent: 'Você vai / Você quer',
      culturalNotePt: 'В Португалии tu — теплое дружеское «ты», а você — более дистанцированное.',
      culturalNoteRu: 'В большинстве штатов Бразилии você полностью вытеснило tu в повседневной речи.',
    ),

    // 11. Глагол Ter vs Haver (Gramática)
    DuelQuestion(
      id: 'duel_grammar_ter_haver',
      category: DuelCategory.gramatica,
      questionTitle: 'Обозначение наличия («здесь есть люди»)',
      promptRu: 'Как бразильцы чаще всего скажут в разговоре: «Здесь много людей»?',
      targetDialect: 'pt_BR',
      options: ['Há muita gente aqui', 'Tem muita gente aqui', 'Existe muita gente aqui', 'Fica muita gente aqui'],
      correctIndex: 1,
      ptPtEquivalent: 'Há muita gente aqui',
      ptBrEquivalent: 'Tem muita gente aqui',
      culturalNotePt: 'В Португалии для наличия используют безличный глагол haver (há).',
      culturalNoteRu: 'В Бразилии ter в значении «иметься/существовать» повсеместен в разговорной речи.',
    ),

    // 12. Ложный друг: Propina (Falsos Amigos)
    DuelQuestion(
      id: 'duel_false_propina',
      category: DuelCategory.falsosAmigos,
      questionTitle: 'Опасный ложный друг: Propina',
      promptRu: 'Что означает слово «propina» в Португалии?',
      targetDialect: 'pt_PT',
      options: [
        'Взятка чиновнику',
        'Плата за обучение в университете',
        'Чаевые официанту',
        'Штраф за парковку',
      ],
      correctIndex: 1,
      ptPtEquivalent: 'Propinas (плата за обучение)',
      ptBrEquivalent: 'Propina (взятка / подкуп)',
      culturalNotePt: 'В Португалии студенты каждый семестр официально платят propinas университету.',
      culturalNoteRu: 'В Бразилии propina означает исключительно незаконную взятку (коррупцию)!',
    ),

    // 13. Ложный друг: Apelido (Falsos Amigos)
    DuelQuestion(
      id: 'duel_false_apelido',
      category: DuelCategory.falsosAmigos,
      questionTitle: 'Ложный друг: Apelido',
      promptRu: 'Что спрашивает португалец, когда просит назвать ваш «apelido»?',
      targetDialect: 'pt_PT',
      options: ['Вашу кличку или никнейм', 'Вашу официальную фамилию', 'Имя вашего отца', 'Вашу должность'],
      correctIndex: 1,
      ptPtEquivalent: 'Apelido (фамилия)',
      ptBrEquivalent: 'Sobrenome (фамилия) / Apelido (кличка)',
      culturalNotePt: 'В Португалии apelido — это официальная фамилия в паспорте.',
      culturalNoteRu: 'В Бразилии фамилия — это sobrenome, а apelido — прозвище или ласковое домашнее имя.',
    ),

    // 14. Ложный друг: Bicha (Falsos Amigos)
    DuelQuestion(
      id: 'duel_false_bicha',
      category: DuelCategory.falsosAmigos,
      questionTitle: 'Очередь в магазине',
      promptRu: 'В Лиссабоне в супермаркете вам могут сказать «Faça favor de entrar na bicha». Что это значит?',
      targetDialect: 'pt_PT',
      options: ['Встать в очередь', 'Оплатить картой', 'Показать чек', 'Взять корзину'],
      correctIndex: 0,
      ptPtEquivalent: 'Bicha / Fila (очередь)',
      ptBrEquivalent: 'Fila (очередь)',
      culturalNotePt: 'В Португалии bicha традиционно означает очередь людей (наряду со словом fila).',
      culturalNoteRu: 'В Бразилии это слово имеет табуированное сленговое значение, очередь — только fila.',
    ),

    // 15. Ложный друг: Rapariga (Falsos Amigos)
    DuelQuestion(
      id: 'duel_false_rapariga',
      category: DuelCategory.falsosAmigos,
      questionTitle: 'Обращение к девушке',
      promptRu: 'Кого в Португалии совершенно уважительно называют «rapariga»?',
      targetDialect: 'pt_PT',
      options: ['Молодую девушку', 'Пожилую женщину', 'Актрису театра', 'Продавщицу'],
      correctIndex: 0,
      ptPtEquivalent: 'A rapariga (девушка)',
      ptBrEquivalent: 'A garota / A moça (девушка)',
      culturalNotePt: 'В Португалии rapaz — парень, rapariga — девушка (нейтральные литературные слова).',
      culturalNoteRu: 'В некоторых регионах Бразилии это слово приобрело оскорбительный контекст.',
    ),

    // 16. Сленг: Классно / Круто (Gírias)
    DuelQuestion(
      id: 'duel_slang_cool',
      category: DuelCategory.girias,
      questionTitle: '«Круто! Классно!»',
      promptRu: 'Какое главное сленговое слово в Португалии означает «круто / классно»?',
      targetDialect: 'pt_PT',
      options: ['Legal', 'Fixe', 'Massa', 'Bacana'],
      correctIndex: 1,
      ptPtEquivalent: 'Fixe! / Que fixe!',
      ptBrEquivalent: 'Legal! / Massa! / Demais!',
      culturalNotePt: 'Fixe — самое культовое слово португальского молодежного сленга.',
      culturalNoteRu: 'В Бразилии говорят legal, massa, bacana, maneiro или show de bola.',
    ),

    // 17. Сленг: Парень / Чувак (Gírias)
    DuelQuestion(
      id: 'duel_slang_dude',
      category: DuelCategory.girias,
      questionTitle: '«Парень / чувак»',
      promptRu: 'Как в Рио и Сан-Паулу называют «чувака / парня»?',
      targetDialect: 'pt_BR',
      options: ['Gajo', 'Cara', 'Miúdo', 'Puto'],
      correctIndex: 1,
      ptPtEquivalent: 'O gajo / O tipo',
      ptBrEquivalent: 'O cara',
      culturalNotePt: 'В Португалии скажут o gajo или o tipo.',
      culturalNoteRu: 'В Бразилии cara («E aí, cara?») — абсолютный чемпион разговорной речи.',
    ),

    // 18. Сленг: Ребёнок (Gírias)
    DuelQuestion(
      id: 'duel_slang_kid',
      category: DuelCategory.girias,
      questionTitle: 'Дети и подростки',
      promptRu: 'Как в Лиссабоне ласково называют ребенка или мальчугана?',
      targetDialect: 'pt_PT',
      options: ['Moleque', 'Miúdo', 'Guri', 'Pivete'],
      correctIndex: 1,
      ptPtEquivalent: 'O miúdo / A miúda',
      ptBrEquivalent: 'O garoto / O moleque / O menino',
      culturalNotePt: 'Os miúdos в Португалии — это ребятишки, детвора.',
      culturalNoteRu: 'В Бразилии скажут moleque, garoto или guri (на юге).',
    ),

    // 19. Пешеход (Vocabulário)
    DuelQuestion(
      id: 'duel_pedestrian',
      category: DuelCategory.vocabulario,
      questionTitle: 'Уличное движение',
      promptRu: 'Как называют пешехода в правилах дорожного движения Португалии?',
      targetDialect: 'pt_PT',
      options: ['Pedestre', 'Peão', 'Andarilho', 'Caminhante'],
      correctIndex: 1,
      ptPtEquivalent: 'O peão',
      ptBrEquivalent: 'O pedestre',
      culturalNotePt: 'В Португалии пешеход — peão, а пешеходный переход — passadeira.',
      culturalNoteRu: 'В Бразилии пешеход — pedestre, а переход — faixa de pedestres.',
    ),

    // 20. Костюм (Vocabulário)
    DuelQuestion(
      id: 'duel_suit',
      category: DuelCategory.vocabulario,
      questionTitle: 'Одежда и стиль',
      promptRu: 'Как в Португалии называют классический мужской костюм (пиджак и брюки)?',
      targetDialect: 'pt_PT',
      options: ['Terno', 'Fato', 'Traje', 'Smoking'],
      correctIndex: 1,
      ptPtEquivalent: 'O fato',
      ptBrEquivalent: 'O terno',
      culturalNotePt: 'В Португалии строгий деловой костюм — o fato (буквально «факт»).',
      culturalNoteRu: 'В Бразилии говорят terno (когда-то означало тройку: пиджак, жилет, брюки).',
    ),
  ];
}
