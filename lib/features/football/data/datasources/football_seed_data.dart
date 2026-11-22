import '../../domain/entities/football_entities.dart';

class FootballSeedData {
  static const List<FootballMatchEntity> matches = [
    FootballMatchEntity(
      id: 'fla_flu_maracana',
      matchTitle: 'Clássico dos Milhões: Fla-Flu no Maracanã',
      stadium: 'Estádio do Maracanã',
      city: 'Rio de Janeiro',
      dialect: 'pt_BR',
      teamHome: 'Flamengo',
      teamAway: 'Fluminense',
      flagEmojiHome: '🔴⚫',
      flagEmojiAway: '🟢⚪🔴',
      contextRu:
          'Легендарное дерби Рио-де-Жанейро. Нельсон Родригес писал, что «Фла-Флу зародился за сорок минут до сотворения мира». Финал лиги Кариока, трибуны поют на 70 000 голосов.',
      moments: [
        MatchMomentEntity(
          id: 'ff_1',
          minute: 12,
          eventType: 'kickoff',
          eventEmoji: '⚽',
          commentaryPt:
              'Rola a bola no gramado sagrado do Maracanã! O camisa 10 domina no peito, gira com categoria e dita o ritmo no meio-campo.',
          commentaryRu:
              'Мяч катится по священному газону Мараканы! Десятый номер принимает на грудь, элегантно разворачивается и задает темп в центре поля.',
          dialectHighlightRu:
              'В Бразилии поле называют gramado (в Португалии — relvado), а футболку — camisa (в Португалии — camisola).',
          scoreHome: 0,
          scoreAway: 0,
        ),
        MatchMomentEntity(
          id: 'ff_2',
          minute: 34,
          eventType: 'dribble',
          eventEmoji: '⚡',
          commentaryPt:
              'Olha o drible da vaca! Que caneta espetacular pelo lado esquerdo! O lateral ficou procurando o rumo de casa!',
          commentaryRu:
              'Смотрите, какой финт с пробросом на ход! Какая эффектная «канета» (между ног) на левом фланге! Защитник аж потерялся!',
          dialectHighlightRu:
              'Caneta или rolinho в Бразилии — проброс мяча между ног соперника (в Португалии это называют cueca или túnel).',
          scoreHome: 0,
          scoreAway: 0,
        ),
        MatchMomentEntity(
          id: 'ff_3',
          minute: 45,
          eventType: 'foul',
          eventEmoji: '🟨',
          commentaryPt:
              'Falta dura na entrada da grande área! O juiz não hesitou e amarelou o zagueiro. Chance de ouro na bola parada!',
          commentaryRu:
              'Грубый фол перед штрафной площадью! Судья не колеблясь показал желтую карточку центральному защитнику. Золотой шанс со стандарта!',
          dialectHighlightRu:
              'Судью в Бразилии зовут juiz (в Португалии чаще árbitro), а центрального защитника — zagueiro (в Португалии — defesa-central).',
          scoreHome: 0,
          scoreAway: 0,
        ),
        MatchMomentEntity(
          id: 'ff_4',
          minute: 88,
          eventType: 'goal',
          eventEmoji: '🔥',
          commentaryPt:
              'Soltou uma bomba de canhota no ângulo! A bola estufa as redes e o goleiro nem viu a cor da bola! É goooooolaço do Mengão no apagar das luzes!',
          commentaryRu:
              'Выстрелил пушкой с левой точно в девятку! Мяч рвет сетку, вратарь даже траекторию не успел разглядеть! Фантастический голище на последних минутах!',
          dialectHighlightRu:
              'Вратарь в Бразилии — исключительно goleiro (в Португалии — guarda-redes), а девятка ворот — ângulo (в Португалии — gaveta).',
          scoreHome: 1,
          scoreAway: 0,
        ),
      ],
    ),
    FootballMatchEntity(
      id: 'benfica_porto_luz',
      matchTitle: 'O Clássico: Benfica vs FC Porto',
      stadium: 'Estádio da Luz',
      city: 'Lisboa',
      dialect: 'pt_PT',
      teamHome: 'SL Benfica',
      teamAway: 'FC Porto',
      flagEmojiHome: '🔴⚪',
      flagEmojiAway: '🔵⚪',
      contextRu:
          'Главное противостояние Португалии: столица (Лиссабон) против северной футбольной столицы (Порту). Борьба за чемпионский титул Примейра-лиги.',
      moments: [
        MatchMomentEntity(
          id: 'bp_1',
          minute: 10,
          eventType: 'pass',
          eventEmoji: '🏟️',
          commentaryPt:
              'O árbitro apita e o relvado da Luz vibra! Os adeptos entoam o cântico e a equipa da casa constrói a jogada a partir de trás.',
          commentaryRu:
              'Судья дает свисток, и газон Да Луш оживает! Болельщики запевают гимн, а хозяева строят позиционную атаку от своих ворот.',
          dialectHighlightRu:
              'Adeptos — португальское слово для болельщиков (в Бразилии — torcedores), equipa — команда (в Бразилии — time).',
          scoreHome: 0,
          scoreAway: 0,
        ),
        MatchMomentEntity(
          id: 'bp_2',
          minute: 27,
          eventType: 'shot',
          eventEmoji: '🧤',
          commentaryPt:
              'Grande chuto do avançado de fora da área! Mas o guarda-redes voa e cede pontapé de canto com uma defesa monumental!',
          commentaryRu:
              'Мощнейший удар нападающего из-за штрафной! Но вратарь в потрясающем прыжке переводит мяч на угловой монументальным сейвом!',
          dialectHighlightRu:
              'Chuto/remate — удар (в Бразилии — chute), avançado — нападающий (в Бразилии — atacante), pontapé de canto — угловой (в Бразилии — escanteio).',
          scoreHome: 0,
          scoreAway: 0,
        ),
        MatchMomentEntity(
          id: 'bp_3',
          minute: 68,
          eventType: 'penalty',
          eventEmoji: '🎯',
          commentaryPt:
              'Cai na grande área! O árbitro assinala penálti claríssimo! O capitão ajeita a bola na marca dos onze metros.',
          commentaryRu:
              'Падение в штрафной! Арбитр указывает на очевиднейший пенальти! Капитан устанавливает мяч на одиннадцатиметровую отметку.',
          dialectHighlightRu:
              'Обратите внимание на ударение и написание: в Португалии penálti (ударение на «а»), а в Бразилии pênalti (ударение на первое закрытое «ê»).',
          scoreHome: 0,
          scoreAway: 0,
        ),
        MatchMomentEntity(
          id: 'bp_4',
          minute: 89,
          eventType: 'goal',
          eventEmoji: '🎉',
          commentaryPt:
              'Rematou com frieza para o fundo da baliza! É golo, golo, golo do Glorioso! A Luz explode em festa encarnada!',
          commentaryRu:
              'Хладнокровно пробил в нижний угол ворот! Это гол, гол, гол «Славных»! Да Луш взрывается в красном празднике!',
          dialectHighlightRu:
              'Golo — в Португалии произносится с открытым [о] (в Бразилии — gol с вокализованным «л» как [gow]). Baliza — ворота (в Бразилии — trave или gol).',
          scoreHome: 1,
          scoreAway: 0,
        ),
      ],
    ),
    FootballMatchEntity(
      id: 'libertadores_final',
      matchTitle: 'Final da Copa Libertadores',
      stadium: 'Estádio Centenário',
      city: 'Montevidéu',
      dialect: 'pt_BR',
      teamHome: 'Palmeiras',
      teamAway: 'Flamengo',
      flagEmojiHome: '🟢⚪',
      flagEmojiAway: '🔴⚫',
      contextRu:
          'Финал главного клубного турнира Южной Америки. Битва титанов бразильского футбола за «Вечную славу» (Glória Eterna).',
      moments: [
        MatchMomentEntity(
          id: 'lib_1',
          minute: 5,
          eventType: 'pass',
          eventEmoji: '⚡',
          commentaryPt:
              'Lançamento primoroso na ponta direita! O ponta domina em velocidade, corta pro meio e cruza rasteiro na pequena área!',
          commentaryRu:
              'Филигранный заброс на правый фланг! Вингер принимает на скорости, смещается в центр и простреливает низом во вратарскую!',
          dialectHighlightRu:
              'Ponta / ponta de lança — вингер / крайний форвард. Cruza rasteiro — простреливает низом вдоль газона.',
          scoreHome: 0,
          scoreAway: 0,
        ),
        MatchMomentEntity(
          id: 'lib_2',
          minute: 74,
          eventType: 'foul',
          eventEmoji: '🛑',
          commentaryPt:
              'O assistente levantou a bandeira: impedimento marcado! O atacante estava meio corpo à frente na hora do passe.',
          commentaryRu:
              'Боковой арбитр поднял флажок: зафиксирован офсайд! Нападающий был на полкорпуса впереди в момент передачи.',
          dialectHighlightRu:
              'Impedimento — положение вне игры в Бразилии (в Португалии исключительно fora-de-jogo).',
          scoreHome: 1,
          scoreAway: 1,
        ),
        MatchMomentEntity(
          id: 'lib_3',
          minute: 90,
          eventType: 'goal',
          eventEmoji: '🏆',
          commentaryPt:
              'Aproveitou a bobeira da zaga, roubou a bola e tocou na saída do goleiro! É o gol do título, é a taça da Libertadores!',
          commentaryRu:
              'Воспользовался оплошностью защиты, перехватил мяч и перекинул вышедшего вратаря! Это золотой гол, это кубок Либертадорес!',
          dialectHighlightRu:
              'Zaga — линия обороны / защитники в бразильском сленге (в Португалии — defesa).',
          scoreHome: 2,
          scoreAway: 1,
        ),
      ],
    ),
    FootballMatchEntity(
      id: 'portugal_eurocopa',
      matchTitle: 'Seleção das Quinas na Eurocopa',
      stadium: 'Estádio José Alvalade',
      city: 'Lisboa',
      dialect: 'pt_PT',
      teamHome: 'Portugal',
      teamAway: 'Espanha',
      flagEmojiHome: '🇵🇹',
      flagEmojiAway: '🇪🇸',
      contextRu:
          'Иберийское дерби на чемпионате Европы. Сборная «лузитанских щитов» борется за выход в полуфинал в атмосфере единения нации.',
      moments: [
        MatchMomentEntity(
          id: 'euro_1',
          minute: 20,
          eventType: 'shot',
          eventEmoji: '🚴',
          commentaryPt:
              'Tentou um pontapé de bicicleta acrobático no coração da área! A bola raspa o poste e sai pela linha de fundo!',
          commentaryRu:
              'Попытался пробить акробатическим ударом через себя («ножницами») прямо по центру штрафной! Мяч чиркает о штангу и уходит за лицевую линию!',
          dialectHighlightRu:
              'Pontapé de bicicleta — удар через себя (в Бразилии просто gol/chute de bicicleta). Poste — штанга (в Бразилии — trave).',
          scoreHome: 0,
          scoreAway: 0,
        ),
        MatchMomentEntity(
          id: 'euro_2',
          minute: 85,
          eventType: 'goal',
          eventEmoji: '🇵🇹',
          commentaryPt:
              'Que jogada genial! Desmarcou-se nas costas dos centrais e encostou com subtileza para as redes! Portugal está na frente!',
          commentaryRu:
              'Какая гениальная комбинация! Открылся за спинами центральных защитников и аккуратно переправил мяч в сетку! Португалия выходит вперед!',
          dialectHighlightRu:
              'Centrais — центральные защитники (в Бразилии — zagueiros). Desmarcou-se — открылся от опеки.',
          scoreHome: 1,
          scoreAway: 0,
        ),
      ],
    ),
  ];

  static const List<FootballTermEntity> terms = [
    FootballTermEntity(
      id: 'term_1',
      termPtPt: 'Guarda-redes',
      termPtBr: 'Goleiro',
      translationRu: 'Вратарь (голкипер)',
      category: FootballTermCategory.positions,
      explanationRu:
          'Классический контраст: португальцы буквально говорят «хранитель сеток», бразильцы используют слово с суффиксом -eiro от слова gol.',
      examplePtPt: 'O guarda-redes segurou a vitória com defesas incríveis.',
      examplePtBr: 'O goleiro fechou o gol e garantiu os três pontos.',
    ),
    FootballTermEntity(
      id: 'term_2',
      termPtPt: 'Fora-de-jogo',
      termPtBr: 'Impedimento',
      translationRu: 'Вне игры (офсайд)',
      category: FootballTermCategory.rules,
      explanationRu:
          'В Португалии калька с английского offside («вне игры»), в Бразилии юридически строгое слово impedimento («препятствие, запрет»).',
      examplePtPt: 'O avançado estava em fora-de-jogo no momento do passe.',
      examplePtBr: 'O bandeirinha assinalou impedimento claríssimo.',
    ),
    FootballTermEntity(
      id: 'term_3',
      termPtPt: 'Pontapé de canto',
      termPtBr: 'Escanteio',
      translationRu: 'Угловой удар',
      category: FootballTermCategory.rules,
      explanationRu:
          'Португальцы называют буквально «удар с угла», бразильцы используют короткое народное слово escanteio.',
      examplePtPt: 'A equipa ganhou um pontapé de canto perigoso.',
      examplePtBr: 'Cobrança de escanteio com efeito no primeiro pau.',
    ),
    FootballTermEntity(
      id: 'term_4',
      termPtPt: 'Baliza / Poste',
      termPtBr: 'Trave / Gol',
      translationRu: 'Ворота / Штанга',
      category: FootballTermCategory.positions,
      explanationRu:
          'Стойку ворот в Португалии зовут poste или trave, а сами ворота — baliza. В Бразилии штангу называют trave, перекладину — travessão.',
      examplePtPt: 'O remate bateu com estrondo no poste da baliza.',
      examplePtBr: 'A bola carimbou o travessão e não entrou por milagre.',
    ),
    FootballTermEntity(
      id: 'term_5',
      termPtPt: 'Finta',
      termPtBr: 'Drible',
      translationRu: 'Финт / Обводка',
      category: FootballTermCategory.movesAndSkills,
      explanationRu:
          'В Португалии классическое романское слово finta (финт), в Бразилии — американизированное и культовое drible (дриблинг кудесников мяча).',
      examplePtPt: 'Deixou dois adversários para trás com uma finta de corpo.',
      examplePtBr: 'Desconcertou a marcação com um drible desconcertante.',
    ),
    FootballTermEntity(
      id: 'term_6',
      termPtPt: 'Remate / Chuto',
      termPtBr: 'Chute / Finalização',
      translationRu: 'Удар по воротам / Завершение атаки',
      category: FootballTermCategory.movesAndSkills,
      explanationRu:
          'В Португалии чаще говорят remate или chuto (с буквой «o»), в Бразилии — исключительно chute и finalização.',
      examplePtPt: 'Arriscou um remate rasteiro e levou perigo.',
      examplePtBr: 'Acertou um lindo chute de primeira no ângulo.',
    ),
    FootballTermEntity(
      id: 'term_7',
      termPtPt: 'Relvado',
      termPtBr: 'Gramado',
      translationRu: 'Газон / Поле стадиона',
      category: FootballTermCategory.positions,
      explanationRu:
          'От слова relva (трава в Португалии) vs grama (трава в Бразилии). Покрытие стадиона — relvado vs gramado.',
      examplePtPt: 'O relvado do estádio está em excelentes condições.',
      examplePtBr: 'O gramado pesado dificultou o toque de bola rápido.',
    ),
    FootballTermEntity(
      id: 'term_8',
      termPtPt: 'Equipa',
      termPtBr: 'Time',
      translationRu: 'Команда / Клуб',
      category: FootballTermCategory.positions,
      explanationRu:
          'Португальское equipa (женский род) против бразильского time (мужской род, от английского team).',
      examplePtPt: 'A nossa equipa foi superior durante os noventa minutos.',
      examplePtBr: 'O nosso time jogou com raça e mereceu o título.',
    ),
    FootballTermEntity(
      id: 'term_9',
      termPtPt: 'Camisola',
      termPtBr: 'Camisa',
      translationRu: 'Игровая форма / Футболка команды',
      category: FootballTermCategory.positions,
      explanationRu:
          'Осторожно: в Бразилии camisola — это ночная женская рубашка! Игровую футболку в Бразилии называют только camisa.',
      examplePtPt: 'Honrar a camisola do clube até ao último segundo.',
      examplePtBr: 'Pesou a camisa mais tradicional na decisão.',
    ),
    FootballTermEntity(
      id: 'term_10',
      termPtPt: 'Adeptos',
      termPtBr: 'Torcedores / Torcida',
      translationRu: 'Болельщики / Фанатское движение',
      category: FootballTermCategory.slangAndJargon,
      explanationRu:
          'В Португалии фанатов называют adeptos. В Бразилии — torcedores (от глагола torcer — болеть, переживать, буквально «выкручивать пальцы от волнения»).',
      examplePtPt: 'Os adeptos viajaram aos milhares para apoiar o clube.',
      examplePtBr: 'A torcida fez uma festa linda nas arquibancadas.',
    ),
    FootballTermEntity(
      id: 'term_11',
      termPtPt: 'Frango',
      termPtBr: 'Frango',
      translationRu: 'Вратарский ляп / Бабочка',
      category: FootballTermCategory.slangAndJargon,
      explanationRu:
          'Один из общих терминов: когда вратарь пропускает нелепый и легкий мяч, говорят «engoliu um frango» (проглотил курицу).',
      examplePtPt: 'O guarda-redes deu um frango inacreditável na primeira parte.',
      examplePtBr: 'Que frango histórico o goleiro engoliu hoje!',
    ),
    FootballTermEntity(
      id: 'term_12',
      termPtPt: 'Cueca / Túnel',
      termPtBr: 'Caneta / Rolinho',
      translationRu: 'Проброс между ног',
      category: FootballTermCategory.movesAndSkills,
      explanationRu:
          'Унизительный для защитника финт. В Португалии — cueca (трусы) или túnel, в Бразилии — caneta (ручка) или rolinho.',
      examplePtPt: 'Meteu-lhe a bola pela cueca com pura magia.',
      examplePtBr: 'Levou uma caneta desconcertante no meio de campo.',
    ),
    FootballTermEntity(
      id: 'term_13',
      termPtPt: 'Golo / Golaço',
      termPtBr: 'Gol / Golasso',
      translationRu: 'Гол / Голище',
      category: FootballTermCategory.movesAndSkills,
      explanationRu:
          'В Португалии слово сохраняет гласную «o» на конце (golo), в Бразилии произносится как gol. Восклицание красивого гола — golaço.',
      examplePtPt: 'Marcou um golo soberbo de chapéu sobre o adversário.',
      examplePtBr: 'Fez um golaço de placa que merece aplausos de pé.',
    ),
    FootballTermEntity(
      id: 'term_14',
      termPtPt: 'Mister / Treinador',
      termPtBr: 'Técnico / Professor',
      translationRu: 'Главный тренер команды',
      category: FootballTermCategory.positions,
      explanationRu:
          'В Португалии тренера уважительно зовут mister (традиция от английских тренеров). В Бразилии — professor или técnico.',
      examplePtPt: 'O mister mexeu bem na equipa no intervalo.',
      examplePtBr: 'O professor acertou na substituição tática.',
    ),
    FootballTermEntity(
      id: 'term_15',
      termPtPt: 'Chapéu / Lençol',
      termPtBr: 'Lençol / Chapéu',
      translationRu: 'Черпачок / Парашют через игрока',
      category: FootballTermCategory.movesAndSkills,
      explanationRu:
          'Переброс мяча по высокой дуге через голову защитника с приемом за его спиной. Используются оба термина chapéu (шляпа) и lençol (простыня).',
      examplePtPt: 'Fez um chapéu magnífico antes de rematar ao poste.',
      examplePtBr: 'Deu um lençol clássico no volante adversário.',
    ),
    FootballTermEntity(
      id: 'term_16',
      termPtPt: 'Prolongamento',
      termPtBr: 'Prorrogação',
      translationRu: 'Дополнительное время (овертайм)',
      category: FootballTermCategory.rules,
      explanationRu:
          'Два тайма по 15 минут в плей-офф: в Португалии prolongamento, в Бразилии prorrogação.',
      examplePtPt: 'A eliminatória foi decidida no prolongamento.',
      examplePtBr: 'A partida seguiu empatada até a prorrogação.',
    ),
  ];

  static const List<FanChantEntity> chants = [
    FanChantEntity(
      id: 'chant_br_orgulho',
      chantPt:
          'Eu sou brasileiro, com muito orgulho, com muito amor!\nEu sou brasileiro, com muito orgulho, com muito amor!',
      translationRu:
          'Я — бразилец, с великой гордостью, с великой любовью!\nЯ — бразилец, с великой гордостью, с великой любовью!',
      clubOrCountry: 'Seleção Brasileira 🇧🇷',
      dialect: 'pt_BR',
      flagEmoji: '🇧🇷',
      contextCultureRu:
          'Главный объединяющий гимн бразильских болельщиков на всех чемпионатах мира и олимпиадах.',
    ),
    FanChantEntity(
      id: 'chant_pt_forca',
      chantPt:
          'A Portuguesa / Força Portugal!\nHeróis do mar, nobre povo, nação valente e imortal!\nLevantai hoje de novo o esplendor de Portugal!',
      translationRu:
          'Вперёд, Португалия!\nГерои моря, благородный народ, нация храбрая и бессмертная!\nВозродите сегодня вновь сияние Португалии!',
      clubOrCountry: 'Seleção das Quinas 🇵🇹',
      dialect: 'pt_PT',
      flagEmoji: '🇵🇹',
      contextCultureRu:
          'Строки государственного гимна Португалии, которые 60 тысяч болельщиков поют а капелла перед стартовым свистком.',
    ),
    FanChantEntity(
      id: 'chant_fla_mengo',
      chantPt:
          'Dá-lhe, dá-lhe, dá-lhe Mengo!\nPra cima deles, meu Flamengo!\nVamos, Flamengo, vamos ser campeões!',
      translationRu:
          'Вперед, вперед, вперед, Менго!\nДави их, мой Фламенго!\nВперед, Фламенго, мы будем чемпионами!',
      clubOrCountry: 'CR Flamengo 🔴⚫',
      dialect: 'pt_BR',
      flagEmoji: '🇧🇷',
      contextCultureRu:
          'Боевой клич 40-миллионной «Nação Rubro-Negra» — крупнейшей торсиды в мировом клубном футболе.',
    ),
    FanChantEntity(
      id: 'chant_slb_chama',
      chantPt:
          'Ser Benfiquista é ter na alma a chama imensa,\nQue nos conforta e nos viva a luz intensa\nDo sol que vence a sombra da tristeza!',
      translationRu:
          'Быть бенфикистом — значит хранить в душе негасимое пламя,\nЧто согревает нас и оживляет яркий свет\nСолнца, побеждающего тень печали!',
      clubOrCountry: 'SL Benfica 🔴⚪',
      dialect: 'pt_PT',
      flagEmoji: '🇵🇹',
      contextCultureRu:
          'Гимн «Ser Benfiquista», под который перед каждым матчем на стадионе «Да Луш» выпускают живого орла Викторию.',
    ),
    FanChantEntity(
      id: 'chant_fcp_dragao',
      chantPt:
          'Filhos do Dragão, azuis e brancos de coração!\nPor nosso Porto até ao fim, na glória ou na batalha!',
      translationRu:
          'Дети Дракона, сине-белые сердцем!\nЗа наш Порту до самого конца, в славе или в битве!',
      clubOrCountry: 'FC Porto 🔵⚪',
      dialect: 'pt_PT',
      flagEmoji: '🇵🇹',
      contextCultureRu:
          'Грозная кричалка фанатской трибуны «Super Dragões» на стадионе «Драган» в Порту.',
    ),
    FanChantEntity(
      id: 'chant_br_pele',
      chantPt:
          'Mil gols, mil gols, mil gols, mil gols, mil gols!\nSó Pelé! Só Pelé!\nMaradona cheirador!',
      translationRu:
          'Тысяча голов, тысяча голов!\nТолько Пеле! Только Пеле!\n(Шуточная пикировка с аргентинцами)',
      clubOrCountry: 'Rivalidade Brasil vs Argentina 🇧🇷',
      dialect: 'pt_BR',
      flagEmoji: '🇧🇷',
      contextCultureRu:
          'Классическая ироничная чантовка бразильских фанатов в многолетнем соперничестве с Аргентиной.',
    ),
  ];

  static const List<FootballQuizQuestion> quizQuestions = [
    FootballQuizQuestion(
      id: 'q_ball_1',
      questionPt: 'Como se chama o jogador que defende as redes em Portugal?',
      questionRu: 'Как называют вратаря в Португалии?',
      optionsPt: ['Goleiro', 'Guarda-redes', 'Zagueiro', 'Avançado'],
      optionsRu: ['Goleiro', 'Guarda-redes', 'Zagueiro', 'Avançado'],
      correctOptionIndex: 1,
      explanationRu:
          'В Португалии страж ворот — guarda-redes. В Бразилии говорят goleiro.',
      dialectFlag: '🇵🇹',
    ),
    FootballQuizQuestion(
      id: 'q_ball_2',
      questionPt: 'O que significa a palavra «impedimento» no futebol brasileiro?',
      questionRu: 'Что означает термин «impedimento» в бразильском футболе?',
      optionsPt: ['Pênalti', 'Cartão vermelho', 'Fora de jogo (impedimento)', 'Falta técnica'],
      optionsRu: ['Пенальти', 'Красная карточка', 'Положение вне игры (офсайд)', 'Технический фол'],
      correctOptionIndex: 2,
      explanationRu:
          'Impedimento в Бразилии — это офсайд (в Португалии его называют fora-de-jogo).',
      dialectFlag: '🇧🇷',
    ),
    FootballQuizQuestion(
      id: 'q_ball_3',
      questionPt: 'Qual termo é usado em Portugal para o pontapé de escanteio?',
      questionRu: 'Какой термин используется в Португалии для углового удара?',
      optionsPt: ['Escanteio', 'Pontapé de canto', 'Tiro de meta', 'Lateral'],
      optionsRu: ['Escanteio', 'Pontapé de canto', 'Удар от ворот', 'Аут'],
      correctOptionIndex: 1,
      explanationRu:
          'В Португалии угловой — pontapé de canto, тогда как в Бразилии — escanteio.',
      dialectFlag: '🇵🇹',
    ),
    FootballQuizQuestion(
      id: 'q_ball_4',
      questionPt: 'O que é uma «caneta» (ou «rolinho») no drible brasileiro?',
      questionRu: 'Что такое «caneta» (или «rolinho») в бразильском дриблинге?',
      optionsPt: [
        'Chute forte de longe',
        'Passar a bola por entre as pernas do adversário',
        'Bicicleta no ar',
        'Drible da vaca',
      ],
      optionsRu: [
        'Дальний мощный удар',
        'Проброс мяча между ног соперника',
        'Удар через себя',
        'Проброс мяча с оббеганием с другой стороны',
      ],
      correctOptionIndex: 1,
      explanationRu:
          'Caneta — проброс мяча между ног (в Португалии называют cueca или túnel).',
      dialectFlag: '🇧🇷',
    ),
    FootballQuizQuestion(
      id: 'q_ball_5',
      questionPt: 'Como os portugueses costumam chamar o treinador da equipa?',
      questionRu: 'Как португальцы традиционно обращаются к главному тренеру?',
      optionsPt: ['Professor', 'Mister', 'Chefe', 'Comandante'],
      optionsRu: ['Professor', 'Mister', 'Chefe', 'Comandante'],
      correctOptionIndex: 1,
      explanationRu:
          'В Португалии тренера называют mister. В Бразилии же популярно обращение professor.',
      dialectFlag: '🇵🇹',
    ),
    FootballQuizQuestion(
      id: 'q_ball_6',
      questionPt: 'O que significa a expressão «engolir um frango»?',
      questionRu: 'Что означает футбольное выражение «engolir um frango»?',
      optionsPt: [
        'Comer antes da partida',
        'Sofrer um gol fácil por falha do goleiro',
        'Receber cartão vermelho direto',
        'Perder um pênalti',
      ],
      optionsRu: [
        'Пообедать перед игрой',
        'Пропустить нелепый гол из-за грубой ошибки вратаря (пустить бабочку)',
        'Получить прямую красную карточку',
        'Не забить пенальти',
      ],
      correctOptionIndex: 1,
      explanationRu:
          'Frango — вратарский ляп в обоих диалектах («проглотить курицу»).',
      dialectFlag: '🌐',
    ),
    FootballQuizQuestion(
      id: 'q_ball_7',
      questionPt: 'Como se chama o tapete verde do campo em Portugal?',
      questionRu: 'Как называют покрытие футбольного поля в Португалии?',
      optionsPt: ['Gramado', 'Relvado', 'Pastagem', 'Arena'],
      optionsRu: ['Gramado', 'Relvado', 'Pastagem', 'Arena'],
      correctOptionIndex: 1,
      explanationRu:
          'В Португалии трава — relva, поэтому поле — relvado. В Бразилии — gramado.',
      dialectFlag: '🇵🇹',
    ),
    FootballQuizQuestion(
      id: 'q_ball_8',
      questionPt: 'Em Portugal, o que é a «camisola» de futebol?',
      questionRu: 'Чем является «camisola» в португальском футболе?',
      optionsPt: [
        'Roupa de dormir',
        'A camisa/uniforme de jogo da equipa',
        'Casaco de inverno',
        'A chuteira do jogador',
      ],
      optionsRu: [
        'Пижама / ночная сорочка',
        'Игровая форма / футболка команды',
        'Зимняя куртка',
        'Бутсы игрока',
      ],
      correctOptionIndex: 1,
      explanationRu:
          'В Португалии camisola — это спортивная футболка клуба. В Бразилии же говорят строго camisa, потому что camisola в BR — ночная сорочка!',
      dialectFlag: '🇵🇹',
    ),
  ];
}
