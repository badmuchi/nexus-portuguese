import '../../domain/entities/art_entities.dart';

class ArtSeedData {
  static List<ArtworkEntity> getArtworks() => artworks;
  static List<ArtStyleEntity> getArtStyles() => artStyles;
  static List<ArtQuizQuestion> getArtQuizzes() => artQuizzes;

  static const List<ArtworkEntity> artworks = [
    ArtworkEntity(
      id: 'art_abaporu',
      titlePt: 'Abaporu',
      titleRu: 'Абапору («Человек, который ест людей»)',
      artistName: 'Tarsila do Amaral',
      yearRu: '1928 г.',
      period: ArtPeriod.modernism,
      dialect: 'pt_BR',
      techniquePt: 'Óleo sobre tela',
      techniqueRu: 'Масло на холсте',
      locationRu: 'Музей латиноамериканского искусства (MALBA), Буэнос-Айрес',
      coverEmoji: '🦶',
      descriptionRu:
          'Самая знаменитая картина в истории бразильского искусства. Гигантская обнаженная ступня, крошечная голова, задумчивая поза и одинокий кактус под палящим солнцем.',
      curatorAnalysisRu:
          'Картина вдохновила мужа художницы Освалда де Андраде на написание «Манифеста антропофагии» (Manifesto Antropófago). Главная философская идея — образное «пожирание» и переваривание чужеродной европейской культуры для рождения самобытного бразильского искусства.',
      keyVocabulary: [
        ArtVocabEntity(
          id: 'v_antropofagia',
          termPt: 'Antropofagia',
          translationRu: 'Антропофагия / Культурный каннибализм',
          contextRu: 'Авангардная бразильская концепция переработки мирового опыта в национальный стиль.',
        ),
        ArtVocabEntity(
          id: 'v_oleo_sobre_tela',
          termPt: 'Óleo sobre tela',
          translationRu: 'Холст, масло',
          contextRu: 'Классическая живописная техника.',
        ),
        ArtVocabEntity(
          id: 'v_vanguarda',
          termPt: 'Vanguarda',
          translationRu: 'Авангард',
          contextRu: 'Художественное новаторство, ломающее академические каноны.',
        ),
      ],
    ),
    ArtworkEntity(
      id: 'art_sao_bento',
      titlePt: 'Painéis Históricos de São Bento',
      titleRu: 'Исторические панно вокзала Сан-Бенту',
      artistName: 'Jorge Colaço',
      yearRu: '1905–1916 гг.',
      period: ArtPeriod.azulejaria,
      dialect: 'pt_PT',
      techniquePt: 'Azulejos vidrados pintados à mão',
      techniqueRu: 'Глазурованная керамическая плитка ручной росписи',
      locationRu: 'Вокзал Сан-Бенту (Estação de São Bento), Порту',
      coverEmoji: '🟦',
      descriptionRu:
          'Грандиозный монументальный ансамбль из более чем 20 000 сине-белых керамических изразцов, покрывающих весь вестибюль одного из красивейших вокзалов мира.',
      curatorAnalysisRu:
          'Панно иллюстрируют ключевые моменты португальской истории: битву при Вальдевеше (1140 г.), встречу рыцаря Эгаша Мониша с королем Леона и триумфальный въезд короля Жуана I в Порту. Традиция сине-белой росписи («azul e branco») восходит к голландскому делфтскому фарфору и китайскому стилю эпохи Мин, воспринятому португальцами.',
      keyVocabulary: [
        ArtVocabEntity(
          id: 'v_azulejo',
          termPt: 'Azulejo',
          translationRu: 'Азулежу (расписная керамическая плитка)',
          contextRu: 'Главный символ декоративного искусства Португалии.',
        ),
        ArtVocabEntity(
          id: 'v_vidrado',
          termPt: 'Vidrado',
          translationRu: 'Глазурованный / Эмалированный',
          contextRu: 'Защитный стекловидный слой керамики после обжига.',
        ),
        ArtVocabEntity(
          id: 'v_painel',
          termPt: 'Painel',
          translationRu: 'Панно / Настенная композиция',
          contextRu: 'Масштабная сюжетная композиция из множества элементов.',
        ),
      ],
    ),
    ArtworkEntity(
      id: 'art_profetas',
      titlePt: 'Os Doze Profetas de Congonhas',
      titleRu: 'Двенадцать пророков в Конгоньясе',
      artistName: 'Aleijadinho (Antônio Francisco Lisboa)',
      yearRu: '1800–1805 гг.',
      period: ArtPeriod.colonialBaroque,
      dialect: 'pt_BR',
      techniquePt: 'Escultura em pedra-sabão',
      techniqueRu: 'Скульптура из талькохлорита (мыльного камня)',
      locationRu: 'Святилище Бон-Жезус-ди-Матозиньюс, Минас-Жерайс',
      coverEmoji: '🗿',
      descriptionRu:
          'Вершина бразильского колониального барокко. Двенадцать монументальных фигур ветхозаветных пророков в натуральную величину, расположенных на парапетах лестницы храма.',
      curatorAnalysisRu:
          'Скульптор Алейжадинью («Калека»), страдавший от тяжелой дегенеративной болезни суставов, творил с привязанными к рукам резцом и молотком. Экспрессивные жесты, драматические драпировки и глубокий психологизм лиц делают этот ансамбль объектом Всемирного наследия ЮНЕСКО.',
      keyVocabulary: [
        ArtVocabEntity(
          id: 'v_pedra_sabao',
          termPt: 'Pedra-sabão',
          translationRu: 'Мыльный камень (талькохлорит)',
          contextRu: 'Мягкий в обработке природный камень, твердеющий на воздухе.',
        ),
        ArtVocabEntity(
          id: 'v_barroco',
          termPt: 'Barroco Colonial',
          translationRu: 'Колониальное барокко',
          contextRu: 'Стиль роскошной эмоциональности и золоченых алтарей Минас-Жерайс.',
        ),
      ],
    ),
    ArtworkEntity(
      id: 'art_guerra_paz',
      titlePt: 'Guerra e Paz',
      titleRu: '«Война и мир»',
      artistName: 'Candido Portinari',
      yearRu: '1952–1956 гг.',
      period: ArtPeriod.modernism,
      dialect: 'pt_BR',
      techniquePt: 'Óleo sobre madeira compensada',
      techniqueRu: 'Масло на фанере',
      locationRu: 'Штаб-квартира Организации Объединенных Наций (ООН), Нью-Йорк',
      coverEmoji: '🕊️',
      descriptionRu:
          'Два колоссальных панно площадью по 140 кв. метров каждое, украшающие вход в зал Генеральной Ассамблеи ООН: ужас, боль и разрушение «Войны» в контрасте со светом, танцем и братством «Мира».',
      curatorAnalysisRu:
          'Портинари работал над картинами день и ночь, пренебрегая предупреждениями врачей о смертельной токсичности свинцовых красок, что в итоге стоило ему жизни. На картине «Война» нет ни оружия, ни солдат — только плач матерей, сироты и трагедия человечества.',
      keyVocabulary: [
        ArtVocabEntity(
          id: 'v_muralismo',
          termPt: 'Muralismo',
          translationRu: 'Мурализм / Монументальная живопись',
          contextRu: 'Искусство грандиозных настенных картин социально-политического звучания.',
        ),
        ArtVocabEntity(
          id: 'v_pincelada',
          termPt: 'Pincelada',
          translationRu: 'Мазок кисти',
          contextRu: 'Индивидуальный характер нанесения краски художником.',
        ),
      ],
    ),
    ArtworkEntity(
      id: 'art_lince_bordalo',
      titlePt: 'Lince Ibérico (Big Trash Animals)',
      titleRu: '«Иберийская рысь» (Серия Big Trash Animals)',
      artistName: 'Bordalo II (Artur Bordalo)',
      yearRu: '2019 г.',
      period: ArtPeriod.contemporaryAndStreetArt,
      dialect: 'pt_PT',
      techniquePt: 'Escultura de parede com materiais reciclados e spray',
      techniqueRu: 'Настенная скульптура из автозапчастей, отходов и аэрозоля',
      locationRu: 'Парк Наций (Parque das Nações), Лиссабон',
      coverEmoji: '🐱',
      descriptionRu:
          'Огромная 10-метровая скульптура иберийской рыси, созданная из выброшенных пластиковых бамперов, мусорных контейнеров, шин и кабелей прямо на фасаде здания.',
      curatorAnalysisRu:
          'Португальский стрит-арт художник Бордало II манифестирует экологический протест: он изображает вымирающих и уязвимых животных из того самого мусора, который разрушает их естественную среду обитания.',
      keyVocabulary: [
        ArtVocabEntity(
          id: 'v_arte_urbana',
          termPt: 'Arte urbana',
          translationRu: 'Стрит-арт / Городское уличное искусство',
          contextRu: 'Интервенции художников в городскую ткань.',
        ),
        ArtVocabEntity(
          id: 'v_reciclado',
          termPt: 'Materiais reciclados',
          translationRu: 'Вторичные переработанные материалы',
          contextRu: 'Использование отходов как художественного медиума.',
        ),
      ],
    ),
    ArtworkEntity(
      id: 'art_amadeo',
      titlePt: 'Canção Popular a Russa e o Fígaro',
      titleRu: '«Народная песня, русская и Фигаро»',
      artistName: 'Amadeo de Souza-Cardoso',
      yearRu: '1916 г.',
      period: ArtPeriod.modernism,
      dialect: 'pt_PT',
      techniquePt: 'Óleo e colagem sobre tela',
      techniqueRu: 'Масло и коллаж на холсте',
      locationRu: 'Центр современного искусства Гюльбенкяна (CAM), Лиссабон',
      coverEmoji: '🎼',
      descriptionRu:
          'Блестящий шедевр португальского кубофутуризма. Динамический вихрь геометрических плоскостей, типографики, зеркал, народных мотивов и ярких контрастных цветов.',
      curatorAnalysisRu:
          'Амадеу де Соуза-Кардозу дружил с Модильяни, Бранкузи и Делоне в Париже, синтезировав кубизм, футуризм и орфизм с португальской народной эстетикой до своей трагической гибели от испанки в 30 лет.',
      keyVocabulary: [
        ArtVocabEntity(
          id: 'v_colagem',
          termPt: 'Colagem',
          translationRu: 'Коллаж',
          contextRu: 'Наклеивание на основу материалов различной фактуры.',
        ),
        ArtVocabEntity(
          id: 'v_cubismo',
          termPt: 'Cubismo',
          translationRu: 'Кубизм',
          contextRu: 'Авангардное разложение объектов на геометрические грани.',
        ),
      ],
    ),
  ];

  static const List<ArtStyleEntity> artStyles = [
    ArtStyleEntity(
      id: 'st_azulejaria',
      namePt: 'Azulejaria Tradicional Portuguesa',
      nameRu: 'Традиционное искусство португальского изразца (Азулежу)',
      coverEmoji: '🟦',
      country: 'Portugal',
      periodRu: 'XVI век — наши дни',
      descriptionRu:
          'Уникальная для мировой архитектуры традиция сплошной облицовки фасадов, церквей, дворцов и вокзалов керамическими плитками. Первоначально заимствовано у мавров, но получило всемирную славу в кобальтово-синем исполнении.',
      hallmarksRu: [
        'Кобальтово-синяя и белая палитра (Barroco Joanino)',
        'Повествовательные исторические и библейские сюжеты',
        'Геометрические ковровые орнаменты (Padrão)',
      ],
    ),
    ArtStyleEntity(
      id: 'st_antropofagia',
      namePt: 'Modernismo & Antropofagia Brasileira',
      nameRu: 'Бразильский модернизм и Антропофагическое движение',
      coverEmoji: '🎨',
      country: 'Brasil',
      periodRu: '1920–1940-е гг.',
      descriptionRu:
          'Культурная революция, начавшаяся с Недели современного искусства 1922 года (Semana de Arte Moderna) в Сан-Паулу. Отказ от рабского подражания академической Европе в пользу ярких красок тропиков, фавел и мифологии аборигенов.',
      hallmarksRu: [
        'Буйство ярких бразильских красок (чистый синий, желтый, зеленый)',
        'Стилизация фигур и акцент на народные образы',
        'Синтез кубизма, сюрреализма и туземного фольклора',
      ],
    ),
    ArtStyleEntity(
      id: 'st_barroco_mineiro',
      namePt: 'Barroco Mineiro & Escultura Devocional',
      nameRu: 'Барокко Минас-Жерайс («Золотой век»)',
      coverEmoji: '⚜️',
      country: 'Brasil',
      periodRu: 'XVIII век',
      descriptionRu:
          'Эпоха «Золотой лихорадки» в штате Минас-Жерайс породила пышный архитектурно-скульптурный стиль с резными золотыми алтарями (talha dourada) и непревзойденными скульптурами Алейжадинью.',
      hallmarksRu: [
        'Резьба по мыльному камню (pedra-sabão) и кедру',
        'Сложная драматургия поз, патетика и миндалевидные глаза святых',
        'Интеграция скульптуры в горный ландшафт',
      ],
    ),
    ArtStyleEntity(
      id: 'st_arte_urbana',
      namePt: 'Arte Urbana & Murais Lusófonos',
      nameRu: 'Мурализм и стрит-арт лузофонного мира',
      coverEmoji: '🏙️',
      country: 'Luso',
      periodRu: '2000-е годы — наши дни',
      descriptionRu:
          'Сан-Паулу и Лиссабон входят в топ-5 мировых столиц стрит-арта. От колоссальных калейдоскопических муралов Эдуардо Кобры и наивного мира Os Gêmeos до трехмерных скульптур-мусора Bordalo II и барельефов Vhils.',
      hallmarksRu: [
        'Гигантский масштаб фасадов (муралы на 10-15 этажей)',
        'Экологические манифесты и сохранение исторической памяти',
        'Смешение граффити, трафарета (stencil) и скульптурного барельефа',
      ],
    ),
  ];

  static const List<ArtQuizQuestion> artQuizzes = [
    EcoQuizQuestionWrapper(
      id: 'qz_art_1',
      questionPt: 'Qual pintura icônica de Tarsila do Amaral deu origem ao Movimento Antropofágico no Modernismo brasileiro?',
      questionRu: 'Какая культовая картина Тарсилы ду Амарал дала начало Антропофагическому движению?',
      optionsPt: [
        'Abaporu',
        'Operários',
        'A Negra',
        'Antropofagia',
      ],
      correctOptionIndex: 0,
      explanationRu:
          '«Abaporu» (1928 г.) вдохновила поэта Освалда де Андраде на «Manifesto Antropófago».',
      dialect: 'pt_BR',
    ),
    EcoQuizQuestionWrapper(
      id: 'qz_art_2',
      questionPt: 'Quantos azulejos históricos compõem o grandioso átrio da Estação de São Bento no Porto?',
      questionRu: 'Сколько исторических изразцов азулежу украшают атриум вокзала Сан-Бенту в Порту?',
      optionsPt: [
        'Cerca de 20.000 azulejos',
        'Cerca de 5.000 azulejos',
        'Mais de 100.000 azulejos',
        'Exatamente 1.000 azulejos',
      ],
      correctOptionIndex: 0,
      explanationRu:
          'Художник Жоржи Коласу расписал вручную более 20 000 плиток для вокзала Сан-Бенту.',
      dialect: 'pt_PT',
    ),
    EcoQuizQuestionWrapper(
      id: 'qz_art_3',
      questionPt: 'Qual material mineral foi utilizado pelo mestre Aleijadinho para esculpir Os Doze Profetas em Congonhas?',
      questionRu: 'Какой минеральный материал использовал мастер Алейжадинью для создания скульптур Двенадцати пророков?',
      optionsPt: [
        'Pedra-sabão (esteatito)',
        'Mármore de Carrara',
        'Granito bruto',
        'Bronze fundido',
      ],
      correctOptionIndex: 0,
      explanationRu:
          'Мыльный камень (pedra-sabão) — пластичный для резьбы минерал, традиционный для Минас-Жерайс.',
      dialect: 'pt_BR',
    ),
    EcoQuizQuestionWrapper(
      id: 'qz_art_4',
      questionPt: 'Onde estão instalados permanentemente os monumentais murais "Guerra e Paz" de Candido Portinari?',
      questionRu: 'Где постоянно установлены монументальные панно «Война и мир» Кандиду Портинари?',
      optionsPt: [
        'Sede da ONU em Nova York',
        'Museu do Louvre em Paris',
        'Palácio do Planalto em Brasília',
        'Museu de Arte de São Paulo (MASP)',
      ],
      correctOptionIndex: 0,
      explanationRu:
          'Панно украшают холл Генеральной Ассамблеи ООН в Нью-Йорке.',
      dialect: 'pt_BR',
    ),
    EcoQuizQuestionWrapper(
      id: 'qz_art_5',
      questionPt: 'Qual artista urbano português é mundialmente famoso pela série de esculturas de animais feitas de lixo (Big Trash Animals)?',
      questionRu: 'Какой португальский стрит-арт художник всемирно известен серией скульптур животных из мусора?',
      optionsPt: [
        'Bordalo II',
        'Vhils',
        'Eduardo Kobra',
        'Os Gêmeos',
      ],
      correctOptionIndex: 0,
      explanationRu:
          'Артур Бордало (Bordalo II) создает арт-объекты из переработанного мусора как манифест экологии.',
      dialect: 'pt_PT',
    ),
    EcoQuizQuestionWrapper(
      id: 'qz_art_6',
      questionPt: 'Em que ano aconteceu a histórica Semana de Arte Moderna no Teatro Municipal de São Paulo, marco do Modernismo?',
      questionRu: 'В каком году состоялась историческая Неделя современного искусства в Сан-Паулу, давшая старт модернизму?',
      optionsPt: [
        '1922',
        '1900',
        '1945',
        '1968',
      ],
      correctOptionIndex: 0,
      explanationRu:
          '«Semana de 22» в феврале 1922 года перевернула культурную жизнь Бразилии.',
      dialect: 'pt_BR',
    ),
  ];
}

// Хелпер совместимости для инициализации ArtQuizQuestion
typedef EcoQuizQuestionWrapper = ArtQuizQuestion;
