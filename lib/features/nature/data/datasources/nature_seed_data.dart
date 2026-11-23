import '../../domain/entities/nature_entities.dart';

class NatureSeedData {
  static List<NatureReserveEntity> getReserves() => reserves;
  static List<SpeciesEntity> getAllSpecies() => allSpecies;
  static List<EcoQuizQuestion> getEcoQuizzes() => ecoQuizzes;

  static const List<SpeciesEntity> allSpecies = [
    SpeciesEntity(
      id: 'sp_onca',
      commonNamePt: 'Onça-Pintada',
      scientificName: 'Panthera onca',
      nameRu: 'Ягуар',
      emoji: '🐆',
      category: SpeciesCategory.fauna,
      statusRu: 'Уязвимый вид (Владыка Амазонки и Пантанала)',
      curiosityRu:
          'Самый крупный кошачий Нового Света. В отличие от большинства кошек, великолепно плавает и охотится в воде на кайманов и капибар.',
      dialect: 'pt_BR',
    ),
    SpeciesEntity(
      id: 'sp_boto',
      commonNamePt: 'Boto-Cor-de-Rosa',
      scientificName: 'Inia geoffrensis',
      nameRu: 'Розовый речной дельфин (Амазонский иния)',
      emoji: '🐬',
      category: SpeciesCategory.fauna,
      statusRu: 'Эндемик бассейна Амазонки',
      curiosityRu:
          'Герой бразильского фольклора. По легенде, в полнолуние выходит на берег в белом костюме и шляпе, чтобы очаровывать сельских красавиц.',
      dialect: 'pt_BR',
    ),
    SpeciesEntity(
      id: 'sp_vitoria_regia',
      commonNamePt: 'Vitória-Régia',
      scientificName: 'Victoria amazonica',
      nameRu: 'Виктория амазонская',
      emoji: '🪷',
      category: SpeciesCategory.flora,
      statusRu: 'Символ амазонской флоры',
      curiosityRu:
          'Гигантская кувшинка с плавающими листьями диаметром до 2,5 метров, способными выдержать вес ребенка (до 40 кг).',
      dialect: 'pt_BR',
    ),
    SpeciesEntity(
      id: 'sp_tuiuiu',
      commonNamePt: 'Tuiuiú (Jabiru)',
      scientificName: 'Jabiru mycteria',
      nameRu: 'Ябиру (Туиуиу)',
      emoji: '🪶',
      category: SpeciesCategory.fauna,
      statusRu: 'Птица — символ Пантанала',
      curiosityRu:
          'Огромный аист с размахом крыльев до 3 метров и характерной красно-черной шеей без оперения.',
      dialect: 'pt_BR',
    ),
    SpeciesEntity(
      id: 'sp_capivara',
      commonNamePt: 'Capivara',
      scientificName: 'Hydrochoerus hydrochaeris',
      nameRu: 'Капибара',
      emoji: '🦫',
      category: SpeciesCategory.fauna,
      statusRu: 'Крупнейший грызун планеты',
      curiosityRu:
          'Миролюбивые полуводные животные. Название на языке тупи-гуарани означает «поедатель тонкой травы».',
      dialect: 'pt_BR',
    ),
    SpeciesEntity(
      id: 'sp_garrano',
      commonNamePt: 'Garrano',
      scientificName: 'Equus caballus',
      nameRu: 'Гаррану (Дикая горная лошадь)',
      emoji: '🐎',
      category: SpeciesCategory.fauna,
      statusRu: 'Реликтовая автохтонная порода Португалии',
      curiosityRu:
          'Коренастые дикие низкорослые лошади, обитающие на гранитных плато национального парка Пенеда-Жереш с кельтских времён.',
      dialect: 'pt_PT',
    ),
    SpeciesEntity(
      id: 'sp_lobo_iberico',
      commonNamePt: 'Lobo-Ibérico',
      scientificName: 'Canis lupus signatus',
      nameRu: 'Иберийский волк',
      emoji: '🐺',
      category: SpeciesCategory.fauna,
      statusRu: 'Строго охраняемый исчезающий подвид',
      curiosityRu:
          'Обитает в труднодоступных скалистых ущельях на севере Португалии. Отличается характерными темными полосами на морде.',
      dialect: 'pt_PT',
    ),
    SpeciesEntity(
      id: 'sp_lirio_geres',
      commonNamePt: 'Lírio-do-Gerês',
      scientificName: 'Iris boissieri',
      nameRu: 'Жерешский ирис',
      emoji: '🟣',
      category: SpeciesCategory.flora,
      statusRu: 'Эндемик гранитных скал Жереша',
      curiosityRu:
          'Редчайший фиолетовый ирис с желтой бородкой, цветущий только на больших высотах в июне среди каменных разломов.',
      dialect: 'pt_PT',
    ),
    SpeciesEntity(
      id: 'sp_cachalote',
      commonNamePt: 'Cachalote',
      scientificName: 'Physeter macrocephalus',
      nameRu: 'Кашалот',
      emoji: '🐋',
      category: SpeciesCategory.fauna,
      statusRu: 'Символ океанических глубин Азорских островов',
      curiosityRu:
          'Глубоководный гигант, способный нырять на глубину до 2 километров в поисках гигантских кальмаров возле Азорского желоба.',
      dialect: 'pt_PT',
    ),
    SpeciesEntity(
      id: 'sp_priolo',
      commonNamePt: 'Priolo (Dom-fafe de São Miguel)',
      scientificName: 'Pyrrhula murina',
      nameRu: 'Азорский снегирь (Приолу)',
      emoji: '🐦',
      category: SpeciesCategory.fauna,
      statusRu: 'Один из редчайших эндемиков Европы',
      curiosityRu:
          'Обитает исключительно в реликтовых лавровых лесах (Laurissilva) на востоке острова Сан-Мигел.',
      dialect: 'pt_PT',
    ),
    SpeciesEntity(
      id: 'sp_cao_serra_estrela',
      commonNamePt: 'Cão da Serra da Estrela',
      scientificName: 'Canis lupus familiaris',
      nameRu: 'Эштрельская овчарка',
      emoji: '🐕',
      category: SpeciesCategory.fauna,
      statusRu: 'Древнейшая пастушья порода Португалии',
      curiosityRu:
          'Веками защищала отары овец в суровых заснеженных горах Эштрелы от нападений волков.',
      dialect: 'pt_PT',
    ),
    SpeciesEntity(
      id: 'sp_hortensia',
      commonNamePt: 'Hortênsia-Azul',
      scientificName: 'Hydrangea macrophylla',
      nameRu: 'Голубая гортензия',
      emoji: '🪻',
      category: SpeciesCategory.flora,
      statusRu: 'Визитная карточка ландшафта Азор',
      curiosityRu:
          'Вулканические кислые почвы Азорских островов придают лепесткам гортензий пронзительно-синий и голубой оттенок, образуя живые изгороди вдоль дорог.',
      dialect: 'pt_PT',
    ),
  ];

  static const List<NatureReserveEntity> reserves = [
    NatureReserveEntity(
      id: 'chapada_diamantina',
      namePt: 'Parque Nacional da Chapada Diamantina',
      nameRu: 'Национальный парк Шапада-Диамантина',
      region: 'Bahia (Sertão & Caatinga)',
      country: 'Brasil',
      dialect: 'pt_BR',
      coverEmoji: '🏜️',
      biomeRu: 'Каньоны, плато (chapadas), водопады и пещеры',
      descriptionRu:
          'Величественный горный массив в сердце штата Баия. Древние алмазные копи, кристально чистые подземные озера с бирюзовой водой и грандиозные водопады, низвергающиеся с отвесных скал.',
      highlightsRu: [
        'Cachoeira da Fumaça — водопад высотой 340 м, где вода распыляется ветром в дым',
        'Morro do Pai Inácio — культовый утес с панорамным закатом над долиной',
        'Poço Encantado — подземное озеро с оптической прозрачностью до 60 метров',
      ],
      trails: [
        NatureTrailEntity(
          id: 'tr_fumaca',
          namePt: 'Trilha da Cachoeira da Fumaça por Cima',
          nameRu: 'Тропа на вершину водопада Кашоэйра-да-Фумаса',
          difficultyRu: 'Средний',
          distanceKm: 12.0,
          durationHours: 4.5,
          elevationGainMeters: 380,
          descriptionRu:
              'Подъем по каменистому плато к краю 400-метровой бездны с видом на парящие капли воды.',
          safetyTipsRu: [
            'Возьмите не менее 2 литров воды (на плато нет тени)',
            'Не подходите к обрыву в ветреную погоду',
            'Используйте обувь с цепкой подошвой для песчаника',
          ],
        ),
        NatureTrailEntity(
          id: 'tr_pai_inacio',
          namePt: 'Subida ao Morro do Pai Inácio',
          nameRu: 'Подъем на холм Морро-ду-Пай-Инасиу',
          difficultyRu: 'Легкий',
          distanceKm: 2.5,
          durationHours: 1.5,
          elevationGainMeters: 150,
          descriptionRu:
              'Классический короткий трек к плоской вершине плато с кактусами и легендарным закатом.',
          safetyTipsRu: [
            'Начинайте подъем за 1.5 часа до заката солнца',
            'Возьмите ветровку — на вершине сильный ветер',
          ],
        ),
      ],
      faunaFlora: [
        SpeciesEntity(
          id: 'sp_tamandua',
          commonNamePt: 'Tamanduá-Bandeira',
          scientificName: 'Myrmecophaga tridactyla',
          nameRu: 'Гигантский муравьед',
          emoji: '🐾',
          category: SpeciesCategory.fauna,
          statusRu: 'Редкий обитатель серрадо и каатинги',
          curiosityRu:
          'Его хвост напоминает флаг (bandeira), а длина языка достигает 60 сантиметров.',
          dialect: 'pt_BR',
        ),
      ],
    ),
    NatureReserveEntity(
      id: 'floresta_amazonica',
      namePt: 'Parque Nacional de Anavilhanas & Amazônia',
      nameRu: 'Национальный парк Анавильянас и тропические леса Амазонки',
      region: 'Amazonas (Bacia Amazônica)',
      country: 'Brasil',
      dialect: 'pt_BR',
      coverEmoji: '🌴',
      biomeRu: 'Влажные экваториальные леса (Selva / Floresta Pluvial)',
      descriptionRu:
          'Самый большой массив тропических дождевых лесов и крупнейший в мире речной архипелаг пресной воды. Невероятное биоразнообразие, звуки цикад и туканов, зеркальные протоки (igarapés).',
      highlightsRu: [
        'Encontro das Águas — слияние черных вод Риу-Негру и глинистых вод Солимойнс',
        'Arquipélago de Anavilhanas — лабиринт из более чем 400 островов на реке',
        'Floresta de Igapó — затопленный лес, по которому скользят деревянные каноэ',
      ],
      trails: [
        NatureTrailEntity(
          id: 'tr_sumauma',
          namePt: 'Trilha das Árvores Gigantes e Sumaúma',
          nameRu: 'Тропа гигантских деревьев и священной сейбы (сумаумы)',
          difficultyRu: 'Средний',
          distanceKm: 6.0,
          durationHours: 3.0,
          elevationGainMeters: 40,
          descriptionRu:
              'Пеший поход сквозь первозданный лес к тысячелетней сумауме с досковидными корнями в человеческий рост.',
          safetyTipsRu: [
            'Всегда идите только в сопровождении сертифицированного местного проводника',
            'Используйте репелленты и закрытую одежду с длинными рукавами',
            'Никогда не прикасайтесь к незнакомым гусеницам и лягушкам ярких расцветок',
          ],
        ),
      ],
      faunaFlora: [
        SpeciesEntity(
          id: 'sp_onca',
          commonNamePt: 'Onça-Pintada',
          scientificName: 'Panthera onca',
          nameRu: 'Ягуар',
          emoji: '🐆',
          category: SpeciesCategory.fauna,
          statusRu: 'Уязвимый вид',
          curiosityRu: 'Хозяин амазонских дебрей.',
          dialect: 'pt_BR',
        ),
        SpeciesEntity(
          id: 'sp_vitoria_regia',
          commonNamePt: 'Vitória-Régia',
          scientificName: 'Victoria amazonica',
          nameRu: 'Виктория амазонская',
          emoji: '🪷',
          category: SpeciesCategory.flora,
          statusRu: 'Символ Амазонии',
          curiosityRu: 'Гигантская плавучая кувшинка.',
          dialect: 'pt_BR',
        ),
      ],
    ),
    NatureReserveEntity(
      id: 'peneda_geres',
      namePt: 'Parque Nacional da Peneda-Gerês',
      nameRu: 'Национальный парк Пенеда-Жереш',
      region: 'Minho / Trás-os-Montes',
      country: 'Portugal',
      dialect: 'pt_PT',
      coverEmoji: '⛰️',
      biomeRu: 'Гранитные горы, дубравы, лагуны и альпийские луга',
      descriptionRu:
          'Единственный национальный парк Португалии. Гранитные монолиты, кристально чистые горные водопады, дикие лошади гаррану, пастушьи каменные хижины (espigueiros) и римская дорога Geira Romana.',
      highlightsRu: [
        'Sete Lagoas — каскад бирюзовых природных бассейнов среди гранитных скал',
        'Mata de Albergaria — реликтовый дубовый лес со строжайшим режимом охраны',
        'Vila do Soajo e Lindoso — старинные гранитные амбары на сваях (espigueiros)',
      ],
      trails: [
        NatureTrailEntity(
          id: 'tr_sete_lagoas',
          namePt: 'Trilho das Sete Lagoas do Gerês',
          nameRu: 'Маршрут к Семи Лагунам Жереша',
          difficultyRu: 'Средний',
          distanceKm: 11.5,
          durationHours: 4.0,
          elevationGainMeters: 320,
          descriptionRu:
              'Живописный горный трек по ущелью реки к каскаду чистейших изумрудных лагун.',
          safetyTipsRu: [
            'Вода в горных лагунах очень холодная даже летом — купайтесь осторожно',
            'Погода в горах переменчива: берите непромокаемую мембранную куртку',
          ],
        ),
      ],
      faunaFlora: [
        SpeciesEntity(
          id: 'sp_garrano',
          commonNamePt: 'Garrano',
          scientificName: 'Equus caballus',
          nameRu: 'Гаррану',
          emoji: '🐎',
          category: SpeciesCategory.fauna,
          statusRu: 'Автохтонная порода лошадей',
          curiosityRu: 'Свободно пасутся на горных плато парка.',
          dialect: 'pt_PT',
        ),
      ],
    ),
    NatureReserveEntity(
      id: 'pantanal',
      namePt: 'Parque Nacional do Pantanal Matogrossense',
      nameRu: 'Национальный парк Пантанал',
      region: 'Mato Grosso / Mato Grosso do Sul',
      country: 'Brasil',
      dialect: 'pt_BR',
      coverEmoji: '🐊',
      biomeRu: 'Заливные равнины и водно-болотные угодья',
      descriptionRu:
          'Крупнейшая в мире сезонно затопляемая равнина. Рай для фотографов дикой природы: плотность диких птиц, кайманов и капибар здесь выше, чем где-либо на континенте.',
      highlightsRu: [
        'Rodovia Transpantaneira — грунтовая дорога с 120 деревянными мостами через лагуны',
        'Fotossafári de Onça-Pintada — речные сафари на моторных лодках вдоль реки Куяба',
        'Ninho de Tuiuiús — колоссальные гнезда птиц на вершинах изолированных деревьев',
      ],
      trails: [
        NatureTrailEntity(
          id: 'tr_pantanal_safari',
          namePt: 'Trilha Ecológica dos Capões e Corixos',
          nameRu: 'Экологическая тропа островных лесков и речных рукавов',
          difficultyRu: 'Легкий',
          distanceKm: 5.0,
          durationHours: 2.0,
          elevationGainMeters: 10,
          descriptionRu:
              'Пешая прогулка с биологом среди сотен капибар, цапель и кайманов, греющихся на солнце.',
          safetyTipsRu: [
            'Соблюдайте дистанцию не менее 5 метров от диких кайманов',
            'Обязательно надевайте высокую закрытую обувь и брюки',
          ],
        ),
      ],
      faunaFlora: [
        SpeciesEntity(
          id: 'sp_tuiuiu',
          commonNamePt: 'Tuiuiú (Jabiru)',
          scientificName: 'Jabiru mycteria',
          nameRu: 'Ябиру',
          emoji: '🪶',
          category: SpeciesCategory.fauna,
          statusRu: 'Символ Пантанала',
          curiosityRu: 'Король пантанальского неба.',
          dialect: 'pt_BR',
        ),
      ],
    ),
    NatureReserveEntity(
      id: 'acores_sete_cidades',
      namePt: 'Parque Natural de São Miguel & Sete Cidades',
      nameRu: 'Природный парк острова Сан-Мигел и Сете-Сидадеш',
      region: 'Região Autónoma dos Açores',
      country: 'Portugal',
      dialect: 'pt_PT',
      coverEmoji: '🌋',
      biomeRu: 'Вулканические кальдеры, лавровые леса и океанические рифы',
      descriptionRu:
          'Зеленый вулканический оазис посреди Атлантического океана. Двухцветные озера (Зеленое и Синее), гейзеры и фумаролы Фурнаша, где еду готовят прямо в вулканическом грунте (Cozido das Furnas).',
      highlightsRu: [
        'Miradouro da Boca do Inferno — одна из самых захватывающих панорам в Европе',
        'Lagoa das Furnas — кипящие серные источники и термальные террасы',
        'Whale Watching — наблюдение за кашалотами и сейвалами в открытом океане',
      ],
      trails: [
        NatureTrailEntity(
          id: 'tr_boca_inferno',
          namePt: 'Trilho da Cumeeira das Sete Cidades',
          nameRu: 'Маршрут по гребню кратера Сете-Сидадеш',
          difficultyRu: 'Средний',
          distanceKm: 12.0,
          durationHours: 3.5,
          elevationGainMeters: 260,
          descriptionRu:
              'Переход по кромке древней кальдеры между океаном и двойным кратерным озером.',
          safetyTipsRu: [
            'При сильном тумане видимость падает до 5 метров — сверяйтесь с GPS',
            'Не сходите с размеченной тропы: края кальдеры крутые и травянистые',
          ],
        ),
      ],
      faunaFlora: [
        SpeciesEntity(
          id: 'sp_hortensia',
          commonNamePt: 'Hortênsia-Azul',
          scientificName: 'Hydrangea macrophylla',
          nameRu: 'Голубая гортензия',
          emoji: '🪻',
          category: SpeciesCategory.flora,
          statusRu: 'Символ Азорских островов',
          curiosityRu: 'Вулканические изгороди вдоль всех дорог острова.',
          dialect: 'pt_PT',
        ),
      ],
    ),
    NatureReserveEntity(
      id: 'serra_da_estrela',
      namePt: 'Parque Natural da Serra da Estrela',
      nameRu: 'Природный парк Серра-да-Эштрела',
      region: 'Beira Alta / Centro',
      country: 'Portugal',
      dialect: 'pt_PT',
      coverEmoji: '❄️',
      biomeRu: 'Ледниковые долины, высокогорные плато и кристальные истоки рек',
      descriptionRu:
          'Крыша континентальной Португалии (вершина Torre, 1993 м). Грандиозные U-образные ледниковые долины, исток реки Мондегу и родина легендарного сыра Queijo Serra da Estrela.',
      highlightsRu: [
        'Torre — высшая точка материковой Португалии с каменным обелиском',
        'Vale Glaciar do Zêzere — одна из крупнейших ледниковых долин Европы',
        'Covão dos Conchos — сюрреалистическая воронка-водосброс посреди горного озера',
      ],
      trails: [
        NatureTrailEntity(
          id: 'tr_vale_glaciar',
          namePt: 'Rota do Vale Glaciar do Zêzere',
          nameRu: 'Маршрут по ледниковой долине реки Зезере',
          difficultyRu: 'Сложный',
          distanceKm: 17.0,
          durationHours: 5.5,
          elevationGainMeters: 550,
          descriptionRu:
              'Глубокое погружение в альпийский ландшафт древнего ледника с отарами овец и можжевельником.',
          safetyTipsRu: [
            'Зимой и весной возможны снежные бураны и обледенение тропы',
            'Обязательно имейте теплые слои одежды и запас питательных батончиков',
          ],
        ),
      ],
      faunaFlora: [
        SpeciesEntity(
          id: 'sp_cao_serra_estrela',
          commonNamePt: 'Cão da Serra da Estrela',
          scientificName: 'Canis lupus familiaris',
          nameRu: 'Эштрельская овчарка',
          emoji: '🐕',
          category: SpeciesCategory.fauna,
          statusRu: 'Овчарка-великан',
          curiosityRu: 'Верный страж пастухов от волков.',
          dialect: 'pt_PT',
        ),
      ],
    ),
  ];

  static const List<EcoQuizQuestion> ecoQuizzes = [
    EcoQuizQuestion(
      id: 'qz_eco_1',
      questionPt: 'Qual é a maior ave voadora do Pantanal brasileiro, considerada símbolo da região?',
      questionRu: 'Какая самая крупная летающая птица Пантанала считается символом этого региона?',
      optionsPt: [
        'Tuiuiú (Jabiru)',
        'Arara-Vermelha',
        'Tucano-Toco',
        'Gavião-Real',
      ],
      correctOptionIndex: 0,
      explanationRu:
          'Туиуиу (Tuiuiú / Jabiru mycteria) с размахом крыльев до 3 метров — официальная птица-символ Пантанала.',
      dialect: 'pt_BR',
    ),
    EcoQuizQuestion(
      id: 'qz_eco_2',
      questionPt: 'Como se chama o cavalo selvagem autóctone que vive em liberdade no Parque Nacional da Peneda-Gerês?',
      questionRu: 'Как называется дикая аборигенная порода лошадей, свободно живущая в парке Пенеда-Жереш?',
      optionsPt: [
        'Puro Sangue Lusitano',
        'Garrano',
        'Sorraia',
        'Campolina',
      ],
      correctOptionIndex: 1,
      explanationRu:
          'Гаррану (Garrano) — реликтовая низкорослая порода лошадей, живущая в горах Жереша с доисторических времён.',
      dialect: 'pt_PT',
    ),
    EcoQuizQuestion(
      id: 'qz_eco_3',
      questionPt: 'Qual é o nome da gigantesca planta aquática da Amazônia cujas folhas flutuantes aguentam o peso de uma criança?',
      questionRu: 'Как называется гигантское водное растение Амазонии, чьи листья выдерживают вес ребенка?',
      optionsPt: [
        'Vitória-Régia',
        'Aguapé',
        'Flor-de-Lótus',
        'Sumaúma',
      ],
      correctOptionIndex: 0,
      explanationRu:
          'Виктория амазонская (Vitória-Régia) имеет плавучие дискообразные листья диаметром до 2,5 метров.',
      dialect: 'pt_BR',
    ),
    EcoQuizQuestion(
      id: 'qz_eco_4',
      questionPt: 'Em Portugal, como se diz "смотровая площадка" (em contraste com o termo brasileiro "mirante")?',
      questionRu: 'Как в Португалии называют смотровую площадку (в отличие от бразильского термина «mirante»)?',
      optionsPt: [
        'Miradouro',
        'Observatório',
        'Ponto alto',
        'Belvedere',
      ],
      correctOptionIndex: 0,
      explanationRu:
          'В европейском португальском смотровая площадка называется «miradouro», тогда как в Бразилии говорят «mirante».',
      dialect: 'pt_PT',
    ),
    EcoQuizQuestion(
      id: 'qz_eco_5',
      questionPt: 'Qual é o ponto mais alto de Portugal Continental, localizado na Serra da Estrela a 1993 metros de altitude?',
      questionRu: 'Какая самая высокая точка континентальной Португалии на высоте 1993 м в Серра-да-Эштрела?',
      optionsPt: [
        'Torre',
        'Pico do Arieiro',
        'Pico da Nevosa',
        'Ponta do Pico',
      ],
      correctOptionIndex: 0,
      explanationRu:
          'Вершина «Torre» (Башня) — наивысшая точка материковой Португалии. (Абсолютный пик всей Португалии — вулкан Ponta do Pico на Азорах, 2351 м).',
      dialect: 'pt_PT',
    ),
    EcoQuizQuestion(
      id: 'qz_eco_6',
      questionPt: 'Qual mamífero aquático da Amazônia é cor-de-rosa e tem papel central no folclore do norte do Brasil?',
      questionRu: 'Какое водное млекопитающее Амазонки розового цвета играет ключевую роль в фольклоре севера Бразилии?',
      optionsPt: [
        'Boto-Cor-de-Rosa',
        'Peixe-Boi',
        'Ariranha',
        'Lontra-Neotropical',
      ],
      correctOptionIndex: 0,
      explanationRu:
          'Бото (Boto-Cor-de-Rosa) — речной дельфин, о котором сложены многочисленные бразильские легенды.',
      dialect: 'pt_BR',
    ),
  ];
}
