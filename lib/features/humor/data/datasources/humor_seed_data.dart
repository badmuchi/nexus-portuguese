import '../../domain/entities/humor_entities.dart';

class HumorSeedData {
  static List<JokeEntity> getJokes() => jokes;
  static List<TrocadilhoEntity> getTrocadilhos() => trocadilhos;
  static List<HumorQuizEntity> getHumorQuizzes() => humorQuizzes;

  static const List<JokeEntity> jokes = [
    JokeEntity(
      id: 'jk_boteco_1',
      titlePt: 'O Bêbado e o Espelho',
      titleRu: 'Пьяница и зеркало в баре',
      setupPt:
          'Um homem entra cambaleando num boteco às três da manhã e pede mais uma cerveja. O garçom, preocupado, aponta para o espelho atrás do balcão e diz:\n— Amigo, dá uma olhada no espelho! Você já não tem mais condições de beber hoje!\nO bêbado olha fixamente para o espelho, semicerra os olhos e responde:',
      setupRu:
          'Мужчина, шатаясь, заходит в бар в три часа ночи и просит еще пива. Обеспокоенный бармен указывает на зеркало за стойкой и говорит:\n— Дружище, взгляни в зеркало! Ты сегодня уже не в состоянии пить!\nПьяница пристально смотрит в зеркало, щурится и отвечает:',
      punchlinePt:
          '— Poxa vida, garçom... Se você não quer me atender, não precisa chamar esse cara feio aí para me encarar!',
      punchlineRu:
          '— Блин, бармен... Если не хочешь меня обслуживать, незачем звать этого урода, чтобы он на меня пялился!',
      explanationRu:
          'Классический типаж бразильских «piadas de boteco». Юмор строится на комической неспособности героя узнать самого себя в зеркале и его обиде на бармена за «недружелюбного свидетеля».',
      category: JokeCategory.boteco,
      dialect: 'pt_BR',
      funLevel: 3,
      vocabulary: [
        JokeVocabEntity(
          id: 'v_boteco',
          termPt: 'Boteco (ou Botequim)',
          translationRu: 'Традиционный простой бар / рюмочная в Бразилии',
          explanationRu: 'Культовое место общения, пива и закусок (petiscos).',
        ),
        JokeVocabEntity(
          id: 'v_encarar',
          termPt: 'Encarar',
          translationRu: 'Пристально смотреть в лицо, пялиться с вызовом',
          explanationRu: 'Образовано от «cara» (лицо/рожа). Часто используется в контексте перепалки.',
        ),
        JokeVocabEntity(
          id: 'v_poxa',
          termPt: 'Poxa vida!',
          translationRu: 'Вот блин! Ну надо же!',
          explanationRu: 'Популярное бразильское восклицание досады или удивления.',
        ),
      ],
    ),
    JokeEntity(
      id: 'jk_boteco_2',
      titlePt: 'A Mosca na Sopa',
      titleRu: 'Муха в супе',
      setupPt:
          'No restaurante popular, o cliente indignado chama o garçom com a mão erguida:\n— Garçom! O que é que esta mosca está a fazer dentro da minha sopa?!',
      setupRu:
          'В заведении возмущенный посетитель поднимает руку и подзывает официанта:\n— Официант! Что эта муха делает в моем супе?!',
      punchlinePt:
          'O garçom inclina-se sobre o prato, observa com atenção e sussurra com ar profissional:\n— Bem... parece-me que está a nadar bruços, senhor!',
      punchlineRu:
          'Официант склоняется над тарелкой, внимательно приглядывается и шепчет с профессиональным видом:\n— Хм... кажется, сэр, она плывет брассом!',
      explanationRu:
          'Буквальное восприятие возмущенного риторического вопроса: вместо оправданий за антисанитарию официант педантично описывает стиль плавания насекомого («nadar bruços» в PT-PT — плавать брассом).',
      category: JokeCategory.boteco,
      dialect: 'pt_PT',
      funLevel: 2,
      vocabulary: [
        JokeVocabEntity(
          id: 'v_brucos',
          termPt: 'Nadar de bruços',
          translationRu: 'Плавать брассом / на груди',
          explanationRu: 'В Бразилии чаще скажут «nado peito», а в Португалии — «bruços».',
        ),
        JokeVocabEntity(
          id: 'v_indignado',
          termPt: 'Indignado',
          translationRu: 'Возмущенный, оскорбленный',
          explanationRu: 'Базовое прилагательное для выражения претензий.',
        ),
      ],
    ),
    JokeEntity(
      id: 'jk_alentejano_1',
      titlePt: 'O Alentejano e o Caracol',
      titleRu: 'Алентежанец и улитка',
      setupPt:
          'Dois compadres alentejanos encontram-se na praça de Évora depois de um dia de caça no campo. Um deles tem a cara cheia de arranhões e curativos. O outro pergunta curioso:\n— Então, compadre Manel! O que é que lhe aconteceu à cara?\nE o Manel explica devagarinho, tirando o chapéu:',
      setupRu:
          'Два кума из Алентежу встречаются на площади в Эворе после дня охоты в поле. У одного всё лицо в царапинах и пластырях. Другой с любопытством спрашивает:\n— Ну и ну, кум Манел! Что стряслось с твоим лицом?\nИ Манел не спеша объясняет, снимая шляпу:',
      punchlinePt:
          '— Foi um caracol, compadre... Eu vi-o ali na erva, abaixei-me com calma para o apanhar, mas o bicho de repente... ZÁS!... deu um salto e fugiu a correr!',
      punchlineRu:
          '— Это всё улитка, кум... Увидел я её в траве, спокойно нагнулся, чтобы взять, а эта тварь вдруг... ХЛОП!... как прыгнет и бегом наутёк!',
      explanationRu:
          '«Piadas de Alentejanos» — любимый пласт португальского фольклора. Жителям знойного южного региона Алентежу приписывают крайнюю неторопливость и созерцательность. Шутка доводит стереотип до абсурда: даже улитка для них двигается со скоростью молнии.',
      category: JokeCategory.alentejano,
      dialect: 'pt_PT',
      funLevel: 3,
      vocabulary: [
        JokeVocabEntity(
          id: 'v_caracol',
          termPt: 'Caracol',
          translationRu: 'Улитка',
          explanationRu: 'Улитки — культовая летняя закуска к пиву в Португалии (caracóis cozidos).',
        ),
        JokeVocabEntity(
          id: 'v_zas',
          termPt: 'Zás!',
          translationRu: 'Хлоп! Бац! В мгновение ока!',
          explanationRu: 'Португальское звукоподражание внезапному молниеносному действию.',
        ),
        JokeVocabEntity(
          id: 'v_compadre',
          termPt: 'Compadre',
          translationRu: 'Кум, приятель, земляк',
          explanationRu: 'Традиционное деревенское обращение среди мужчин в Португалии и бразильском сертане.',
        ),
      ],
    ),
    JokeEntity(
      id: 'jk_alentejano_2',
      titlePt: 'Manuel e a Árvore do Parque',
      titleRu: 'Мануэл и дерево в парке',
      setupPt:
          'O guarda florestal vê o Manuel deitado confortavelmente debaixo de uma laranjeira com a boca aberta virada para cima. Curioso, o guarda aproxima-se e indaga:\n— Ó homem, o que está você a fazer aí assim com a boca escancarada?',
      setupRu:
          'Лесник видит Мануэла, который уютно развалился под апельсиновым деревом с открытым ртом, направленным прямо вверх. С любопытством лесник подходит и спрашивает:\n— Человек, ты что это тут разлегся с разинутым ртом?',
      punchlinePt:
          '— Estou à espera que caia uma laranja, senhor guarda!\n— Mas homem de Deus, e se não cair na sua boca e cair no chão?\n— Ah... então aí eu mudo de árvore!',
      punchlineRu:
          '— Жду, когда упадет апельсин, господин охранник!\n— Да помилуй, человек божий, а если он упадет не в рот, а на землю?\n— А... ну тогда я перелягу под другое дерево!',
      explanationRu:
          'Фирменная португальская логика «esperteza alentejana»: зачем напрягаться и подбирать упавший плод рукой, если можно просто перелечь под новое дерево.',
      category: JokeCategory.alentejano,
      dialect: 'pt_PT',
      funLevel: 2,
      vocabulary: [
        JokeVocabEntity(
          id: 'v_escancarada',
          termPt: 'Boca escancarada',
          translationRu: 'Широко разинутый рот',
          explanationRu: 'От глагола «escancarar» — распахнуть настежь.',
        ),
        JokeVocabEntity(
          id: 'v_homem_de_deus',
          termPt: 'Homem de Deus!',
          translationRu: 'Человек божий! Да помилуй!',
          explanationRu: 'Типичное восклицание удивления и увещевания в Португалии.',
        ),
      ],
    ),
    JokeEntity(
      id: 'jk_trocadilho_1',
      titlePt: 'O Livro de Matemática',
      titleRu: 'Учебник математики',
      setupPt:
          'O aluno chega em casa da escola com cara de espanto e pergunta à mãe na cozinha:\n— Mãe, você sabe por que o livro de matemática se suicidou na biblioteca ontem à tarde?',
      setupRu:
          'Ученик возвращается из школы с ошарашенным лицом и спрашивает мать на кухне:\n— Мам, ты знаешь, почему вчера днем учебник по математике покончил с собой в библиотеке?',
      punchlinePt:
          '— Não sei, meu filho... Por quê?\n— Porque ele tinha muitos problemas!',
      punchlineRu:
          '— Не знаю, сынок... Почему же?\n— Потому что у него было слишком много проблем!',
      explanationRu:
          'Двойное значение португальского слова «problema»: в школьном обиходе это «задача / математический пример» (resolver problemas), а в жизни — «жизненные трудности и невзгоды».',
      category: JokeCategory.trocadilho,
      dialect: 'all',
      funLevel: 2,
      vocabulary: [
        JokeVocabEntity(
          id: 'v_problema',
          termPt: 'Problema',
          translationRu: 'Проблема / Математическая задача',
          explanationRu: 'Каламбурное слово, объединяющее школьные упражнения и душевные терзания.',
        ),
      ],
    ),
    JokeEntity(
      id: 'jk_trocadilho_2',
      titlePt: 'O Peixe e a Filosofia',
      titleRu: 'Рыба и глубокая мысль',
      setupPt:
          'O filho pequeno aponta para o aquário da sala e pergunta todo pensativo para o pai:\n— Pai, o que é que os peixes fazem o dia inteirinho lá no fundo do mar?',
      setupRu:
          'Маленький сын показывает на аквариум в гостиной и задумчиво спрашивает отца:\n— Папа, а чем рыбы занимаются целыми днями там, на дне морском?',
      punchlinePt:
          'O pai suspira, larga o jornal e responde filosoficamente:\n— Nada, filho... Absolutamente nada!',
      punchlineRu:
          'Отец вздыхает, откладывает газету и философски отвечает:\n— Ничего, сынок... Абсолютно ничего!',
      explanationRu:
          'Игра слов на омонимах: «Nada» как местоимение «ничего» и «Nada» как форма 3-го лица глагола «nadar» (он/она плывет: ele nada). Рыба ничего не делает — она просто плывет.',
      category: JokeCategory.trocadilho,
      dialect: 'all',
      funLevel: 3,
      vocabulary: [
        JokeVocabEntity(
          id: 'v_nada',
          termPt: 'Nada (Nadar)',
          translationRu: 'Ничего / Плывет',
          explanationRu: 'Классический португальский омоним, любимый всеми поколениями шутников.',
        ),
      ],
    ),
    JokeEntity(
      id: 'jk_meme_1',
      titlePt: 'É Sobre Isso e Tá Tudo Bem',
      titleRu: '«Просто смирись, и всё норм»',
      setupPt:
          'Um brasileiro chega no trabalho ensopado pela tempestade, com o pneu do carro furado, o celular sem bateria e demitido pelo chefe antes do almoço. Ele senta na calçada, respira fundo e posta nas redes:',
      setupRu:
          'Бразилец приходит на работу промокшим до нитки из-за шторма, с пробитым колесом, разряженным телефоном и получает новость об увольнении еще до обеда. Он садится на бордюр, глубоко вздыхает и пишет в соцсетях:',
      punchlinePt:
          '— Nem todo dia é dia de vitória. Às vezes a gente perde, se machuca e vira meme. Mas é sobre isso... e tá tudo bem! ✨🧘‍♂️',
      punchlineRu:
          '— Не каждый день — день побед. Иногда мы проигрываем, набиваем шишки и становимся мемом. Но в этом весь смысл... и всё норм! ✨🧘‍♂️',
      explanationRu:
          'Пародия на вирусный бразильский мем «É sobre isso e tá tudo bem» — клише из поп-психологии и соцсетей, которым иронично оправдывают полнейшую житейскую катастрофу.',
      category: JokeCategory.meme,
      dialect: 'pt_BR',
      funLevel: 3,
      vocabulary: [
        JokeVocabEntity(
          id: 'v_e_sobre_isso',
          termPt: 'É sobre isso',
          translationRu: 'В этом весь смысл / Об этом и речь',
          explanationRu: 'Вирусная идиома соцсетей в Бразилии для принятия неизбежного.',
        ),
        JokeVocabEntity(
          id: 'v_ensopado',
          termPt: 'Ensopado',
          translationRu: 'Промокший до нитки',
          explanationRu: 'От слова «sopa» (суп), буквально: превратившийся в суп от дождя.',
        ),
      ],
    ),
    JokeEntity(
      id: 'jk_meme_2',
      titlePt: 'Com Certeza, Mas Depende',
      titleRu: '«Точно так, но это зависит...»',
      setupPt:
          'Um turista estrangeiro pede uma indicação clara em Lisboa:\n— Senhor, se eu apanhar o elétrico 28 agora, chego ao Castelo de São Jorge em dez minutos?',
      setupRu:
          'Иностранный турист просит четкий совет на улице в Лиссабоне:\n— Сеньор, если я сейчас сяду на 28-й трамвай, я доеду до Замка Святого Георгия за десять минут?',
      punchlinePt:
          'O lisboeta coça o queixo, pondera a gravidade do universo e responde com solene convicção:\n— Com certeza, meu caro! ...Mas depende.',
      punchlineRu:
          'Лиссабонец чешет подбородок, взвешивает вселенскую гравитацию и отвечает с глубокой убежденностью:\n— Конечно, дорогой мой! ...Но это зависит.',
      explanationRu:
          'Культовый португальский мем о вечном сомнении. Слово «Depende» — святыня португальского менталитета: даже ответив твердое «Com certeza», житель Португалии обязан добавить оговорку на случай непредвиденных обстоятельств.',
      category: JokeCategory.meme,
      dialect: 'pt_PT',
      funLevel: 3,
      vocabulary: [
        JokeVocabEntity(
          id: 'v_depende',
          termPt: 'Depende',
          translationRu: 'Зависит от обстоятельств / Как посмотреть',
          explanationRu: 'Универсальный португальский ответ на любой прямой вопрос.',
        ),
        JokeVocabEntity(
          id: 'v_eletrico',
          termPt: 'Elétrico',
          translationRu: 'Трамвай (в Португалии)',
          explanationRu: 'В Бразилии трамвай называют «bonde».',
        ),
      ],
    ),
  ];

  static const List<TrocadilhoEntity> trocadilhos = [
    TrocadilhoEntity(
      id: 'tr_1',
      questionPt: 'O que o número zero disse para o número oito?',
      questionRu: 'Что цифра ноль сказала восьмерке?',
      answerPt: '— Que belo cinto você está usando!',
      answerRu: '— Какой красивый пояс ты носишь!',
      wordplayExplanationRu:
          'Визуальный каламбур: восьмерка выглядит как ноль, перетянутый пояском посередине.',
      dialect: 'all',
    ),
    TrocadilhoEntity(
      id: 'tr_2',
      questionPt: 'Por que o jacaré tirou o filhote da escola?',
      questionRu: 'Почему крокодил забрал сына из школы?',
      answerPt: '— Porque ele réptil de ano!',
      answerRu: '— Потому что он рептилия (остался на второй год)!',
      wordplayExplanationRu:
          'Созвучие слов «réptil» (рептилия/пресмыкающееся) и школьного выражения «repetiu de ano» (остался на второй год в Бразилии).',
      dialect: 'pt_BR',
    ),
    TrocadilhoEntity(
      id: 'tr_3',
      questionPt: 'Qual é o café mais perigoso do mundo?',
      questionRu: 'Какой кофе самый опасный в мире?',
      answerPt: '— É o ex-presso!',
      answerRu: '— Экс-прессо (бывший зэк)!',
      wordplayExplanationRu:
          'Каламбур на написании и звучании: «café expresso» звучит в точности как «ex-preso» (бывший заключенный).',
      dialect: 'all',
    ),
    TrocadilhoEntity(
      id: 'tr_4',
      questionPt: 'O que uma impressora falou para a outra no escritório?',
      questionRu: 'Что один принтер сказал другому в офисе?',
      answerPt: '— Essa folha é tua ou é impressão minha?',
      answerRu: '— Этот лист твой, или мне показалось (это моя печать)?',
      wordplayExplanationRu:
          'Игра слов с выражением «é impressão minha» (мне показалось / мое впечатление) и словом «impressão» в значении распечатки.',
      dialect: 'all',
    ),
    TrocadilhoEntity(
      id: 'tr_5',
      questionPt: 'Porque é que os pássaros não usam telemóvel?',
      questionRu: 'Почему птицы не пользуются мобильными телефонами?',
      answerPt: '— Porque eles já têm muitos bicos!',
      answerRu: '— Потому что у них и так полно клювов (побочных заработков / связей)!',
      wordplayExplanationRu:
          'В португальском языке «bico» означает и птичий клюв, и временную подработку / халтуру (fazer uns bicos).',
      dialect: 'pt_PT',
    ),
    TrocadilhoEntity(
      id: 'tr_6',
      questionPt: 'O que o tomate foi fazer no banco?',
      questionRu: 'Зачем помидор пошел в отделение банка?',
      answerPt: '— Foi tirar um extrato!',
      answerRu: '— Снять выписку (томатную пасту)!',
      wordplayExplanationRu:
          'Термин «extrato» означает как банковскую выписку со счета (extrato bancário), так и томатную пасту / концентрат (extrato de tomate).',
      dialect: 'all',
    ),
  ];

  static const List<HumorQuizEntity> humorQuizzes = [
    HumorQuizEntity(
      id: 'qz_1',
      jokeSetupPt:
          'O cliente no boteco pede um cafezinho e pergunta ao garçom:\n— O café é quente e forte?\nO que o garçom responde?',
      jokeSetupRu:
          'Посетитель в баре просит кофе и уточняет у официанта:\n— Кофе горячий и крепкий?\nЧто отвечает официант?',
      optionsPt: [
        'É tão quente que queima o copo e tão forte que bate no senhor!',
        'Não senhor, aqui só servimos chá gelado com hortelã.',
        'O café é fraco, mas a conta vai vir fortíssima!',
        'Se o senhor quiser forte, tem que pedir para a cozinheira.',
      ],
      correctOptionIndex: 0,
      explanationRu:
          'Классический гиперболический юмор бара: кофе настолько крепкий («forte»), что может даже побить («bater em alguém»).',
      dialect: 'pt_BR',
    ),
    HumorQuizEntity(
      id: 'qz_2',
      jokeSetupPt:
          'O que o zero falou para o oito quando se encontraram na rua?',
      jokeSetupRu:
          'Что сказал ноль восьмерке при встрече на улице?',
      optionsPt: [
        'Você engordou muito desde a última vez!',
        'Gostei do seu cinto apertado!',
        'Dividir por você é um absurdo matemático!',
        'Nós dois juntos formamos oitenta centavos.',
      ],
      correctOptionIndex: 1,
      explanationRu:
          'Восьмерка похожа на ноль, который надел пояс («cinto»).',
      dialect: 'all',
    ),
    HumorQuizEntity(
      id: 'qz_3',
      jokeSetupPt:
          'Por que o livro de matemática resolveu ir ao psicólogo?',
      jokeSetupRu:
          'Почему учебник математики решил пойти к психологу?',
      optionsPt: [
        'Porque ninguém entendia as suas fórmulas.',
        'Porque estava cheio de problemas não resolvidos.',
        'Porque tinha ciúmes do livro de história.',
        'Porque perdeu a raiz quadrada.',
      ],
      correctOptionIndex: 1,
      explanationRu:
          '«Problemas» — математические задачи и психологические проблемы.',
      dialect: 'all',
    ),
    HumorQuizEntity(
      id: 'qz_4',
      jokeSetupPt:
          'Como se chama o café que saiu recentemente da prisão?',
      jokeSetupRu:
          'Как называется кофе, который недавно вышел из тюрьмы?',
      optionsPt: [
        'Café descafeinado',
        'Café pingado',
        'Ex-presso',
        'Café solúvel',
      ],
      correctOptionIndex: 2,
      explanationRu:
          'Игра слов: «expresso» и «ex-preso» (бывший заключенный).',
      dialect: 'all',
    ),
  ];
}
