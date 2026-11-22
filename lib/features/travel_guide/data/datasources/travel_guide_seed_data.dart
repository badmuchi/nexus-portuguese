import '../../domain/entities/geography_quiz_entity.dart';
import '../../domain/entities/lusophone_country_entity.dart';
import '../../domain/entities/travel_phrase_entity.dart';

class TravelGuideSeedData {
  static const List<LusophoneCountryEntity> countries = [
    LusophoneCountryEntity(
      id: 'portugal',
      namePt: 'Portugal',
      nameRu: 'Португалия',
      flagEmoji: '🇵🇹',
      capitalPt: 'Lisboa',
      capitalRu: 'Лиссабон',
      continentRu: 'Европа',
      currency: 'Euro (€)',
      population: '10.3 млн',
      dialectOverviewRu:
          'Родина языка. Европейский португальский (PT-PT) отличается редуцированными безударными гласными, шипящим звуком «ш» на конце слов и грамматической конструкцией «estou a fazer».',
      culturalOverviewRu:
          'Страна мореплавателей, душевного фаду, синей плитки азулежу и более чем 850-летней истории. Родина портвейна, мадейры и паштел де ната.',
      topAttractionsRu: [
        'Башня Белем и Монастырь Жеронимуш в Лиссабоне',
        'Сказочный Дворец Пена в Синтре',
        'Виноградные террасы Долины Дору',
        'Винные погреба и набережная Рибейра в Порту',
        'Золотые пляжи и скалы Алгарве',
      ],
      nationalDishRu: 'Bacalhau à Brás e Pastel de Nata',
      localExpressions: [
        CountryLinguisticFeature(
          termPt: 'Fixe',
          translationRu: 'Круто, здорово, классно',
          explanationRu: 'Главное разговорное слово Португалии для одобрения чего-либо.',
          examplePt: 'Este restaurante é mesmo muito fixe!',
        ),
        CountryLinguisticFeature(
          termPt: 'Giro / Gira',
          translationRu: 'Симпатичный, милый, интересный',
          explanationRu: 'Употребляется как о людях, так и об одежде, местах или идеях.',
          examplePt: 'Que camisola tão gira!',
        ),
        CountryLinguisticFeature(
          termPt: 'Pá',
          translationRu: 'Дружище, парень, ну (междометие)',
          explanationRu: 'Универсальное междометие, вставляемое португальцами почти в каждую неформальную фразу.',
          examplePt: 'Olha lá, pá, vamos embora que já é tarde.',
        ),
      ],
    ),
    LusophoneCountryEntity(
      id: 'brasil',
      namePt: 'Brasil',
      nameRu: 'Бразилия',
      flagEmoji: '🇧🇷',
      capitalPt: 'Brasília',
      capitalRu: 'Бразилиа',
      continentRu: 'Южная Америка',
      currency: 'Real (R\$)',
      population: '215 млн',
      dialectOverviewRu:
          'Крупнейшая португалоязычная страна мира. Бразильский вариант (PT-BR) отличается открытыми музыкальными гласными, смягчением звуков «d» и «t» перед «i», использованием местоимения «você» и герундия «estou fazendo».',
      culturalOverviewRu:
          'Гигант природы и культуры: тропические леса Амазонии, карнавалы, босса-нова, футбол, пляжи Копакабаны и безграничный оптимизм жителей.',
      topAttractionsRu: [
        'Статуя Христа-Искупителя и Сахарная Голова в Рио',
        'Мощнейшие водопады Игуасу',
        'Колониальный исторический центр Пелоуриньо в Сальвадоре',
        'Тропические джунгли реки Амазонки',
      ],
      nationalDishRu: 'Feijoada Completa e Moqueca Baiana',
      localExpressions: [
        CountryLinguisticFeature(
          termPt: 'Beleza / Joia',
          translationRu: 'Всё отлично, договорились, привет',
          explanationRu: 'Самое универсальное бразильское приветствие и подтверждение согласия.',
          examplePt: 'E aí, tudo beleza? Vamos nos encontrar às oito.',
        ),
        CountryLinguisticFeature(
          termPt: 'Massa / Bacana',
          translationRu: 'Классный, превосходный',
          explanationRu: 'Популярное выражение восторга и одобрения.',
          examplePt: 'O show de ontem foi muito massa!',
        ),
        CountryLinguisticFeature(
          termPt: 'Saideira',
          translationRu: 'На посошок (последний напиток)',
          explanationRu: 'Традиционный заказ последнего бокала пива или кофе перед уходом из бара.',
          examplePt: 'Garçom, traz a saideira pra gente fechar a conta!',
        ),
      ],
    ),
    LusophoneCountryEntity(
      id: 'angola',
      namePt: 'Angola',
      nameRu: 'Ангола',
      flagEmoji: '🇦🇴',
      capitalPt: 'Luanda',
      capitalRu: 'Луанда',
      continentRu: 'Африка',
      currency: 'Kwanza (Kz)',
      population: '35 млн',
      dialectOverviewRu:
          'Ангольский португальский сохраняет европейскую фонетическую основу, но обогащен богатейшей лексикой языков кимбунду и умбунду. Породил множество сленговых слов, перекочевавших в молодежный португальский в Лиссабоне.',
      culturalOverviewRu:
          'Вторая по величине португалоязычная страна. Родина кизомбы и сембы, древних царств Конго и Ндонго, уникальных ландшафтов Серра-да-Леба и водопадов Каландула.',
      topAttractionsRu: [
        'Грандиозный каньон Фенда-да-Тундавала в Лубанго',
        'Водопады Каландула (одни из крупнейших в Африке)',
        'Лунная долина (Miradouro da Lua) возле Луанды',
        'Набережная Маржинал в Луанде',
      ],
      nationalDishRu: 'Muamba de Galinha com Funje',
      localExpressions: [
        CountryLinguisticFeature(
          termPt: 'Bué',
          translationRu: 'Очень, много, куча',
          explanationRu: 'Слово из языка кимбунду, которое сегодня знает каждый подросток в Португалии и Анголе.',
          examplePt: 'Estou com bué de fome, vamos comer algo.',
        ),
        CountryLinguisticFeature(
          termPt: 'Cota',
          translationRu: 'Старший, батя, мудрый человек',
          explanationRu: 'Уважительное обозначение старшего по возрасту родственника или наставника.',
          examplePt: 'O meu cota deu-me um grande conselho de vida.',
        ),
        CountryLinguisticFeature(
          termPt: 'Bazar',
          translationRu: 'Уходить, сваливать, выдвигаться',
          explanationRu: 'Ангольский глагол для ухода из компании.',
          examplePt: 'Já são duas da manhã, malta. Vamos bazar?',
        ),
      ],
    ),
    LusophoneCountryEntity(
      id: 'mocambique',
      namePt: 'Moçambique',
      nameRu: 'Мозамбик',
      flagEmoji: '🇲🇿',
      capitalPt: 'Maputo',
      capitalRu: 'Мапуту',
      continentRu: 'Африка',
      currency: 'Metical (MTn)',
      population: '33 млн',
      dialectOverviewRu:
          'Португальский Мозамбика обладает мягким певучим ритмом с влиянием языков тсонга, макуа и суахили. Часто опускаются предлоги при глаголах движения («vou Maputo» вместо «vou a Maputo»).',
      culturalOverviewRu:
          'Страна Индийского океана, бирюзовых архипелагов с белым песком, поэзии Миа Коуту и богатейшего морского биоразнообразия (дюгони, китовые акулы).',
      topAttractionsRu: [
        'Коралловый архипелаг Базаруто с бирюзовыми лагунами',
        'Остров Мозамбик — исторический форпост на пути в Индию (ЮНЕСКО)',
        'Национальный парк дикой природы Горонгоза',
        'Колониальный вокзал Мапуту (построенный по проекту учеников Эйфеля)',
      ],
      nationalDishRu: 'Frango à Zambeziana e Matapa com Camarão',
      localExpressions: [
        CountryLinguisticFeature(
          termPt: 'Machamba',
          translationRu: 'Огород, поле, плантация',
          explanationRu: 'Главное сельскохозяйственное слово Мозамбика.',
          examplePt: 'A minha família cultiva milho e mandioca na machamba.',
        ),
        CountryLinguisticFeature(
          termPt: 'Chapa',
          translationRu: 'Маршрутка, микроавтобус',
          explanationRu: 'Основной общественный транспорт мозамбикских городов.',
          examplePt: 'Vou apanhar um chapa para ir até à baixa da cidade.',
        ),
        CountryLinguisticFeature(
          termPt: 'Tchilar',
          translationRu: 'Отдыхать, чиллить с друзьями',
          explanationRu: 'Молодежное слово для приятного непринужденного досуга.',
          examplePt: 'Vamos tchilar na praia de Tofo no fim de semana.',
        ),
      ],
    ),
    LusophoneCountryEntity(
      id: 'cabo_verde',
      namePt: 'Cabo Verde',
      nameRu: 'Кабо-Верде',
      flagEmoji: '🇨🇻',
      capitalPt: 'Praia',
      capitalRu: 'Прая',
      continentRu: 'Африка (Атлантика)',
      currency: 'Escudo cabo-verdiano (CVE)',
      population: '590 тыс.',
      dialectOverviewRu:
          'Официальный язык — португальский, родной разговорный язык 100% населения — кабовердианский креольский (Kriolu). В португальском чувствуется теплое, неторопливое креольское произношение.',
      culturalOverviewRu:
          'Архипелаг из 10 вулканических островов в Атлантическом океане. Родина великой босоногой дивы Сезарии Эворы, ностальгической музыки морна и теплой философии морабезы.',
      topAttractionsRu: [
        'Действующий вулкан острова Фогу с черными лавовыми полями',
        'Пляжи острова Сал и дюны острова Боавишта',
        'Культурная столица Минделу на острове Сан-Висенте',
        'Зеленые горные хребты Санту-Антан',
      ],
      nationalDishRu: 'Cachupa Rica (рагу из кукурузы, бобов и мяса)',
      localExpressions: [
        CountryLinguisticFeature(
          termPt: 'Morabeza',
          translationRu: 'Душевное гостеприимство и доброта',
          explanationRu: 'Национальная философия кабовердианцев: искреннее радушие к каждому гостю.',
          examplePt: 'A morabeza do povo cabo-verdiano conquista qualquer viajante.',
        ),
        CountryLinguisticFeature(
          termPt: 'Sodade',
          translationRu: 'Глубокая ностальгия, тоска по дому',
          explanationRu: 'Креольский аналог португальского saudade, увековеченный в одноименной песне Сезарии Эворы.',
          examplePt: 'Tenho sodade da minha terra e do mar de Mindelo.',
        ),
        CountryLinguisticFeature(
          termPt: 'Sabura',
          translationRu: 'Сладость жизни, наслаждение, кайф',
          explanationRu: 'Ощущение радости от хорошей музыки, праздника или вкусной еды.',
          examplePt: 'Que grande sabura este festival de música!',
        ),
      ],
    ),
    LusophoneCountryEntity(
      id: 'sao_tome_e_principe',
      namePt: 'São Tomé e Príncipe',
      nameRu: 'Сан-Томе и Принсипи',
      flagEmoji: '🇸🇹',
      capitalPt: 'São Tomé',
      capitalRu: 'Сан-Томе',
      continentRu: 'Африка (Гвинейский залив)',
      currency: 'Dobra (Db)',
      population: '220 тыс.',
      dialectOverviewRu:
          'Португальский язык здесь является родным для подавляющего большинства населения, сохраняя очень чистую классическую лексику в гармонии с местными креольскими языками форро и принсипенсе.',
      culturalOverviewRu:
          '«Шоколадные острова» на самом экваторе. Бывшая мировая столица какао с колониальными усадьбами-плантациями (roças), изумрудными дождевыми лесами и философией жизни «leve-leve».',
      topAttractionsRu: [
        'Вулканический обелиск Пику-Кан-Гранде среди джунглей',
        'Старинная плантация какао Роса Агоштинью Нету',
        'Девственные пляжи острова Принсипи (Биосферный заповедник ЮНЕСКО)',
        'Экваториальный монумент на островке Ролаш',
      ],
      nationalDishRu: 'Calulu de Peixe Seco com Banana-pão',
      localExpressions: [
        CountryLinguisticFeature(
          termPt: 'Leve-leve',
          translationRu: 'Не спеша, спокойно, полегоньку',
          explanationRu: 'Главный девиз жизни на островах: жить без суеты, в гармонии и покое.',
          examplePt: 'Em São Tomé tudo se faz leve-leve, com tranquilidade.',
        ),
        CountryLinguisticFeature(
          termPt: 'Roça',
          translationRu: 'Историческая плантация какао или кофе',
          explanationRu: 'Уникальные архитектурные комплексы колониальной эпохи с домами, больницами и сушилками.',
          examplePt: 'Dormimos numa antiga roça restaurada perto do mar.',
        ),
      ],
    ),
    LusophoneCountryEntity(
      id: 'guine_bissau',
      namePt: 'Guiné-Bissau',
      nameRu: 'Гвинея-Бисау',
      flagEmoji: '🇬🇼',
      capitalPt: 'Bissau',
      capitalRu: 'Бисау',
      continentRu: 'Западная Африка',
      currency: 'Franco CFA',
      population: '2.1 млн',
      dialectOverviewRu:
          'Португальский — государственный язык администрации и образования. Широким языком межнационального общения выступает гвинейский креольский язык (Kriol).',
      culturalOverviewRu:
          'Земля нетронутой дикой природы и первозданных традиций африканских племен. Знаменита биосферным архипелагом Бижагош из 88 островов, где сохранился уникальный матриархат.',
      topAttractionsRu: [
        'Архипелаг Бижагош с дикими морскими бегемотами',
        'Национальный парк Кантаньез (дом диких шимпанзе)',
        'Колониальный старый квартал Бисау-Велью',
      ],
      nationalDishRu: 'Caldo de Mancarra (курица в арахисовом соусе)',
      localExpressions: [
        CountryLinguisticFeature(
          termPt: 'Djarama',
          translationRu: 'Спасибо, благодарю',
          explanationRu: 'Традиционное сердечное слово благодарности.',
          examplePt: 'Djarama pela hospitalidade nesta viagem.',
        ),
        CountryLinguisticFeature(
          termPt: 'Kumpu',
          translationRu: 'Чинить, обустраивать, налаживать',
          explanationRu: 'Слово, означающее приведение вещей в порядок.',
          examplePt: 'Vamos kumpu as coisas para a cerimónia.',
        ),
      ],
    ),
    LusophoneCountryEntity(
      id: 'timor_leste',
      namePt: 'Timor-Leste',
      nameRu: 'Восточный Тимор',
      flagEmoji: '🇹🇱',
      capitalPt: 'Díli',
      capitalRu: 'Дили',
      continentRu: 'Азия / Океания',
      currency: 'Dólar Americano (\$)',
      population: '1.3 млн',
      dialectOverviewRu:
          'Единственная суверенная португалоязычная страна в Азии наряду со вторым официальным языком тетум. Португальский язык является символом сопротивления и национальной идентичности.',
      culturalOverviewRu:
          'Молодое государство XXI века с богатейшей морской экосистемой на планете, горными перевалами и древними святилищами священного крокодила.',
      topAttractionsRu: [
        'Остров Атауро — мировой рекордсмен по биоразнообразию коралловых рифов',
        'Статуя Христа Дили (Cristo Rei de Díli) на утесе над морем',
        'Священная вершина Рамелау (высота почти 3000 метров)',
      ],
      nationalDishRu: 'Batar Da\'an (рагу из кукурузы, бобов и тыквы)',
      localExpressions: [
        CountryLinguisticFeature(
          termPt: 'Hamutuk',
          translationRu: 'Вместе, в единстве',
          explanationRu: 'Ключевое понятие солидарности и взаимопомощи народа Тимора.',
          examplePt: 'Trabalhamos todos hamutuk pelo futuro do país.',
        ),
        CountryLinguisticFeature(
          termPt: 'Mau-mau',
          translationRu: 'Друг, товарищ',
          explanationRu: 'Теплое неформальное обращение к товарищу.',
          examplePt: 'Olá, mau-mau, como tens passado?',
        ),
      ],
    ),
    LusophoneCountryEntity(
      id: 'macau',
      namePt: 'Macau',
      nameRu: 'Макао (Китай)',
      flagEmoji: '🇲🇴',
      capitalPt: 'Macau',
      capitalRu: 'Макао',
      continentRu: 'Азия',
      currency: 'Pataca (MOP\$)',
      population: '680 тыс.',
      dialectOverviewRu:
          'Специальный административный район Китая, где португальский язык сохраняет статус официального наряду с китайским (кантонским). Все законы, уличные таблички и официальные документы двуязычны.',
      culturalOverviewRu:
          'Более 400 лет португальской истории на побережье Южно-Китайского моря. Симбиоз традиционной португальской мозаики (calçada) с китайскими храмами и неоновыми огнями азиатского Лас-Вегаса.',
      topAttractionsRu: [
        'Руины Собора Святого Павла (фасад церкви XVI века)',
        'Площадь Сенадо с португальской черно-белой мостовой',
        'Древний даосский храм А-Ма',
        'Крепость Гуя с первым западным маяком на побережье Китая',
      ],
      nationalDishRu: 'Minchi e Galinha à Africana',
      localExpressions: [
        CountryLinguisticFeature(
          termPt: 'Calçada Portuguesa',
          translationRu: 'Португальская брусчатка с волнообразным узором',
          explanationRu: 'Символ португальского присутствия на Востоке, украшающий все пешеходные улицы Макао.',
          examplePt: 'O Largo do Senado em Macau tem uma calçada portuguesa magnífica.',
        ),
        CountryLinguisticFeature(
          termPt: 'Patoá',
          translationRu: 'Макаэнский креольский диалект',
          explanationRu: 'Уникальный исчезающий язык потомков португальцев и китаянок в Макао.',
          examplePt: 'O patoá é uma língua doce que junta português, malaio e cantonês.',
        ),
      ],
    ),
  ];

  static const List<TravelPhraseEntity> travelPhrases = [
    // Аэропорт и таможня
    TravelPhraseEntity(
      id: 'ph_airport_1',
      phrasePt: 'Onde fica o controlo de passaportes (PT) / controle de passaportes (BR)?',
      translationRu: 'Где находится паспортный контроль?',
      category: TravelPhraseCategory.airportCustoms,
      contextTipRu: 'PT: controlo / BR: controle. Ключевая фраза по прилёте.',
    ),
    TravelPhraseEntity(
      id: 'ph_airport_2',
      phrasePt: 'Vim a turismo e vou ficar por duas semanas.',
      translationRu: 'Я приехал с туристической целью и останусь на две недели.',
      category: TravelPhraseCategory.airportCustoms,
      contextTipRu: 'Стандартный ответ пограничному офицеру на паспортном контроле.',
    ),
    TravelPhraseEntity(
      id: 'ph_airport_3',
      phrasePt: 'A minha bagagem não apareceu no tapete rolante.',
      translationRu: 'Мой багаж не появился на ленте выдачи.',
      category: TravelPhraseCategory.airportCustoms,
      contextTipRu: 'PT: tapete rolante / BR: esteira de bagagem.',
    ),

    // Транспорт
    TravelPhraseEntity(
      id: 'ph_transport_1',
      phrasePt: 'Pode ligar o taxímetro, por favor?',
      translationRu: 'Включите таксометр, пожалуйста.',
      category: TravelPhraseCategory.transport,
      contextTipRu: 'Очень полезно в аэропортах Лиссабона, Рио и Луанды, чтобы не переплачивать.',
    ),
    TravelPhraseEntity(
      id: 'ph_transport_2',
      phrasePt: 'Este autocarro (PT) / ônibus (BR) vai para o centro histórico?',
      translationRu: 'Этот автобус едет в исторический центр?',
      category: TravelPhraseCategory.transport,
      contextTipRu: 'PT: autocarro / BR: ônibus / Африка: chapa или machimbombo.',
    ),
    TravelPhraseEntity(
      id: 'ph_transport_3',
      phrasePt: 'Onde posso comprar um bilhete de metro / cartão de transporte?',
      translationRu: 'Где я могу купить билет на метро / транспортную карту?',
      category: TravelPhraseCategory.transport,
      contextTipRu: 'В Лиссабоне карта называется Viva Viagem / Navegante, в Рио — RioCard.',
    ),

    // Отель
    TravelPhraseEntity(
      id: 'ph_hotel_1',
      phrasePt: 'Tenho uma reserva em nome de...',
      translationRu: 'У меня забронирован номер на имя...',
      category: TravelPhraseCategory.hotelLodging,
      contextTipRu: 'Базовая фраза на ресепшене при заселении.',
    ),
    TravelPhraseEntity(
      id: 'ph_hotel_2',
      phrasePt: 'Qual é a senha do Wi-Fi e a que horas é servido o café?',
      translationRu: 'Какой пароль от Wi-Fi и со скольки подается завтрак?',
      category: TravelPhraseCategory.hotelLodging,
      contextTipRu: 'PT: pequeno-almoço / BR: café da manhã.',
    ),
    TravelPhraseEntity(
      id: 'ph_hotel_3',
      phrasePt: 'Poderia guardar as minhas malas até à hora do voo?',
      translationRu: 'Не могли бы вы присмотреть за моими чемоданами до вылета?',
      category: TravelPhraseCategory.hotelLodging,
      contextTipRu: 'Услуга камеры хранения багажа (luggage storage) в отеле.',
    ),

    // Кафе и рестораны
    TravelPhraseEntity(
      id: 'ph_dining_1',
      phrasePt: 'Uma mesa para duas pessoas na esplanada, se faz favor.',
      translationRu: 'Столик на двоих на открытой террасе, пожалуйста.',
      category: TravelPhraseCategory.restaurantDining,
      contextTipRu: '«Esplanada» — любимая открытая веранда кафе в Португалии и Бразилии.',
    ),
    TravelPhraseEntity(
      id: 'ph_dining_2',
      phrasePt: 'O que recomenda como prato típico da casa?',
      translationRu: 'Что вы посоветуете из фирменных местных блюд?',
      category: TravelPhraseCategory.restaurantDining,
      contextTipRu: 'Идеальный способ попробовать аутентичную кухню региона.',
    ),
    TravelPhraseEntity(
      id: 'ph_dining_3',
      phrasePt: 'A conta, por favor. Aceitam cartão ou só dinheiro vivo?',
      translationRu: 'Счет, пожалуйста. Вы принимаете карты или только наличные?',
      category: TravelPhraseCategory.restaurantDining,
      contextTipRu: 'PT: dinheiro vivo / BR: dinheiro em espécie.',
    ),

    // Помощь и здоровье
    TravelPhraseEntity(
      id: 'ph_emergency_1',
      phrasePt: 'Preciso de ajuda urgente, onde fica a farmácia mais próxima?',
      translationRu: 'Мне срочно нужна помощь, где ближайшая аптека?',
      category: TravelPhraseCategory.emergencies,
      contextTipRu: 'Дежурная аптека в Португалии обозначается табличкой «Farmácia de Serviço».',
    ),
    TravelPhraseEntity(
      id: 'ph_emergency_2',
      phrasePt: 'Não me sinto bem, tenho febre alta e tonturas.',
      translationRu: 'Я плохо себя чувствую, у меня высокая температура и кружится голова.',
      category: TravelPhraseCategory.emergencies,
      contextTipRu: 'Фраза для обращения к врачу или в пункт скорой помощи (Urgência / UPA).',
    ),
    TravelPhraseEntity(
      id: 'ph_emergency_3',
      phrasePt: 'Perdi a minha carteira com os meus documentos e cartões.',
      translationRu: 'Я потерял кошелек с документами и банковскими картами.',
      category: TravelPhraseCategory.emergencies,
      contextTipRu: 'Для подачи заявления в туристическую полицию (PSP в PT / Deat в Рио).',
    ),

    // Вежливость и этикет
    TravelPhraseEntity(
      id: 'ph_courtesy_1',
      phrasePt: 'Com licença, desculpe incomodar, sabe onde fica esta rua?',
      translationRu: 'Прошу прощения, извините за беспокойство, вы не знаете, где эта улица?',
      category: TravelPhraseCategory.localCourtesies,
      contextTipRu: '«Com licença» — вежливый способ обратиться к прохожему на улице.',
    ),
    TravelPhraseEntity(
      id: 'ph_courtesy_2',
      phrasePt: 'Muito obrigado(a) pela sua ajuda e simpatia!',
      translationRu: 'Большое спасибо за вашу помощь и радушие!',
      category: TravelPhraseCategory.localCourtesies,
      contextTipRu: 'Мужчины говорят «obrigado», женщины — «obrigada».',
    ),
    TravelPhraseEntity(
      id: 'ph_courtesy_3',
      phrasePt: 'Tenha um bom dia e um bom trabalho!',
      translationRu: 'Хорошего дня и успешной работы!',
      category: TravelPhraseCategory.localCourtesies,
      contextTipRu: 'Очень теплое и распространенное пожелание таксистам, официантам и кассирам.',
    ),
  ];

  static const List<GeographyQuizQuestion> quizQuestions = [
    GeographyQuizQuestion(
      id: 'quiz_1',
      questionPt: 'Qual destas cidades é a capital de Angola?',
      questionRu: 'Какой из этих городов является столицей Анголы?',
      optionsPt: ['Luanda', 'Maputo', 'Benguela', 'Bissau'],
      optionsRu: ['Луанда', 'Мапуту', 'Бенгела', 'Бисау'],
      correctOptionIndex: 0,
      explanationRu: 'Столицей Анголы является Луанда — крупнейший экономический и культурный центр страны на берегу Атлантики.',
      countryId: 'angola',
      flagEmoji: '🇦🇴',
    ),
    GeographyQuizQuestion(
      id: 'quiz_2',
      questionPt: 'O que significa a palavra "Morabeza" em Cabo Verde?',
      questionRu: 'Что означает знаменитое кабовердианское слово «Morabeza»?',
      optionsPt: [
        'Hospitalidade calorosa e acolhimento',
        'Um tipo de peixe grelhado',
        'Uma dança tradicional rápida',
        'Vento forte do deserto'
      ],
      optionsRu: [
        'Тёплое душевное гостеприимство и радушие',
        'Вид запеченной рыбы',
        'Быстрый традиционный танец',
        'Сильный ветер из пустыни'
      ],
      correctOptionIndex: 0,
      explanationRu: 'Морабеза — это душа островов Кабо-Верде: открытость, доброта и искреннее гостеприимство к каждому человеку.',
      countryId: 'cabo_verde',
      flagEmoji: '🇨🇻',
    ),
    GeographyQuizQuestion(
      id: 'quiz_3',
      questionPt: 'Em qual destes países o lema popular de vida é "Leve-leve"?',
      questionRu: 'В какой из этих стран главным жизненным девизом является «Leve-leve»?',
      optionsPt: [
        'São Tomé e Príncipe',
        'Brasil',
        'Portugal',
        'Moçambique'
      ],
      optionsRu: [
        'Сан-Томе и Принсипи',
        'Бразилия',
        'Португалия',
        'Мозамбик'
      ],
      correctOptionIndex: 0,
      explanationRu: '«Leve-leve» — это философия Сан-Томе и Принсипи: жить спокойно, без спешки, с миром в сердце.',
      countryId: 'sao_tome_e_principe',
      flagEmoji: '🇸🇹',
    ),
    GeographyQuizQuestion(
      id: 'quiz_4',
      questionPt: 'Qual é o prato nacional emblemático de Moçambique feito com folhas de mandioca e amendoim?',
      questionRu: 'Какое традиционное блюдо Мозамбика готовится из листьев маниока и молотого арахиса?',
      optionsPt: ['Matapa', 'Feijoada', 'Caldo Verde', 'Cachupa'],
      optionsRu: ['Матапа', 'Фейжоада', 'Калду Верде', 'Качупа'],
      correctOptionIndex: 0,
      explanationRu: 'Матапа (Matapa) — шедевр кухни Мозамбика, где листья маниока тушатся в кокосовом молоке с арахисом и креветками.',
      countryId: 'mocambique',
      flagEmoji: '🇲🇿',
    ),
    GeographyQuizQuestion(
      id: 'quiz_5',
      questionPt: 'Em que continente fica Timor-Leste, único país soberano lusófono dessa região?',
      questionRu: 'На каком континенте расположен Восточный Тимор — единственное суверенное португалоязычное государство региона?',
      optionsPt: ['Ásia / Oceânia', 'África', 'América Central', 'Europa'],
      optionsRu: ['Азия / Океания', 'Африка', 'Центральная Америка', 'Европа'],
      correctOptionIndex: 0,
      explanationRu: 'Восточный Тимор расположен в Юго-Восточной Азии на острове Тимор и восстановил независимость в 2002 году.',
      countryId: 'timor_leste',
      flagEmoji: '🇹🇱',
    ),
    GeographyQuizQuestion(
      id: 'quiz_6',
      questionPt: 'Como se chama o famoso calçadão de pedras portuguesas no centro histórico de Macau?',
      questionRu: 'Какая знаменитая площадь в Макао вымощена португальской черно-белой брусчаткой calçada?',
      optionsPt: [
        'Largo do Senado',
        'Praça do Comércio',
        'Praça da Sé',
        'Largo do Pelourinho'
      ],
      optionsRu: [
        'Площадь Сенадо (Largo do Senado)',
        'Площадь Торговли (Лиссабон)',
        'Площадь Се',
        'Площадь Пелоуриньо (Сальвадор)'
      ],
      correctOptionIndex: 0,
      explanationRu: 'Площадь Сенадо в Макао — визитная карточка португальского архитектурного наследия в Азии с волнистой мозаикой.',
      countryId: 'macau',
      flagEmoji: '🇲🇴',
    ),
    GeographyQuizQuestion(
      id: 'quiz_7',
      questionPt: 'Qual o significado da gíria angolana "Bué", hoje popular também em Portugal?',
      questionRu: 'Что означает ангольский сленг «Bué», популярный ныне и в молодежной среде Португалии?',
      optionsPt: [
        'Muito, em grande quantidade',
        'Comida rápida de rua',
        'Dinheiro falso',
        'Tempo nublado'
      ],
      optionsRu: [
        'Очень, много, в большом количестве',
        'Уличная еда',
        'Фальшивые деньги',
        'Пасмурная погода'
      ],
      correctOptionIndex: 0,
      explanationRu: 'Слово «bué» пришло из языка кимбунду в Анголе и означает «очень» или «много» («estou bué cansado»).',
      countryId: 'angola',
      flagEmoji: '🇦🇴',
    ),
    GeographyQuizQuestion(
      id: 'quiz_8',
      questionPt: 'Que grande revolução pacífica portuguesa de 1974 pôs fim à ditadura e deu independência aos países africanos?',
      questionRu: 'Какая мирная португальская революция 1974 года положила конец диктатуре и открыла путь к независимости африканских стран?',
      optionsPt: [
        'Revolução dos Cravos (25 de Abril)',
        'Revolução Liberal do Porto',
        'Inconfidência Mineira',
        'Revolta da Chibata'
      ],
      optionsRu: [
        'Революция гвоздик (25 апреля)',
        'Либеральная революция в Порту',
        'Заговор в Минас-Жерайс',
        'Восстание Чибата'
      ],
      correctOptionIndex: 0,
      explanationRu: 'Революция гвоздик 25 апреля 1974 года вернула демократию в Португалию и положила конец колониальной войне в Африке.',
      countryId: 'portugal',
      flagEmoji: '🇵🇹',
    ),
  ];
}
