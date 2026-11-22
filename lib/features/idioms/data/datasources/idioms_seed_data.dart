import '../../domain/entities/portuguese_idiom_entity.dart';

class IdiomsSeedData {
  static const List<PortugueseIdiom> idioms = [
    // 1. Pagar o pato
    PortugueseIdiom(
      id: 'idiom_pagar_o_pato',
      expressionPt: 'Pagar o pato',
      literalTranslationRu: 'Платить за утку',
      meaningRu: 'Расплачиваться за чужую вину, быть козлом отпущения.',
      meaningPt: 'Assumir a culpa ou o prejuízo por algo que outra pessoa fez.',
      originStoryRu: 'Восходит к популярной итальянской новелле XV века, где крестьянин отведал утки у дамы, а счет заставили оплатить случайного прохожего мужа.',
      examplePt: 'Todo o grupo errou no projeto, mas só o Pedro foi demitido e acabou pagando o pato.',
      exampleRu: 'Вся группа ошиблась в проекте, но уволили только Педру — он остался козлом отпущения.',
      dialect: 'all',
      category: IdiomCategory.animais,
      illustrationEmoji: '🦆',
    ),

    // 2. Tirar o cavalinho da chuva
    PortugueseIdiom(
      id: 'idiom_cavalinho_chuva',
      expressionPt: 'Tirar o cavalinho da chuva',
      literalTranslationRu: 'Увести лошадку из-под дождя',
      meaningRu: 'Оставить напрасные надежды, отказаться от затеи, не рассчитывать на что-то.',
      meaningPt: 'Desistir de uma ilusão ou de uma pretensão inútil.',
      originStoryRu: 'В XIX веке гости привязывали лошадей под открытым небом. Если хозяин дома говорил: «Заведи лошадку под навес от дождя», это значило, что гостя ждут надолго. Фраза «можешь уводить лошадку» означала отказ в приеме.',
      examplePt: 'Se você acha que vou te emprestar mais dinheiro, pode tirar o cavalinho da chuva!',
      exampleRu: 'Если ты думаешь, что я одолжу тебе еще денег, можешь даже не надеяться!',
      dialect: 'pt_BR',
      category: IdiomCategory.animais,
      illustrationEmoji: '🐴',
    ),

    // 3. Comprar gato por lebre
    PortugueseIdiom(
      id: 'idiom_gato_lebre',
      expressionPt: 'Comprar gato por lebre',
      literalTranslationRu: 'Купить кота вместо зайца',
      meaningRu: 'Быть обманутым при покупке, купить фальшивку или некачественный товар.',
      meaningPt: 'Ser enganado ao comprar algo de qualidade inferior achando que era bom.',
      originStoryRu: 'В Средние века в недобросовестных тавернах вместо дорогого мяса зайца или кролика в жаркое нередко подсовывали кошачье мясо.',
      examplePt: 'Achei que o relógio era original, mas comprei gato por lebre: parou no segundo dia.',
      exampleRu: 'Я думал, что часы оригинальные, но меня обманули: они встали на второй день.',
      dialect: 'all',
      category: IdiomCategory.animais,
      illustrationEmoji: '🐱',
    ),

    // 4. Dar zebra
    PortugueseIdiom(
      id: 'idiom_dar_zebra',
      expressionPt: 'Dar zebra',
      literalTranslationRu: 'Случилась зебра',
      meaningRu: 'Неожиданный, сенсационный результат; победа явного аутсайдера.',
      meaningPt: 'Acontecer um resultado totalmente inesperado ou surpreendente.',
      originStoryRu: 'В бразильской нелегальной лотерее «Jogo do Bicho» (Игра в зверушек) было 25 животных, но зебры среди них не было вообще. «Выпала зебра» означало нечто абсолютно невероятное.',
      examplePt: 'O time pequeno venceu o campeão por três a zero, deu zebra total!',
      exampleRu: 'Маленькая команда разгромила чемпиона 3:0, случилась полная сенсация!',
      dialect: 'pt_BR',
      category: IdiomCategory.animais,
      illustrationEmoji: '🦓',
    ),

    // 5. Muitos anos a virar frangos
    PortugueseIdiom(
      id: 'idiom_virar_frangos',
      expressionPt: 'Muitos anos a virar frangos',
      literalTranslationRu: 'Много лет переворачивать кур на гриле',
      meaningRu: 'Иметь колоссальный опыт и стаж в каком-то деле; «собаку съел».',
      meaningPt: 'Ter muita experiência, maturidade e prática numa determinada área.',
      originStoryRu: 'Идиома родилась в португальских churrasqueiras, где мастер годами стоял у огня и идеально знал момент готовности птицы.',
      examplePt: 'Não me tentes enganar com esse relatório, rapaz. São muitos anos a virar frangos!',
      exampleRu: 'Не пытайся меня обмануть этим отчетом, парень. Я в этом деле собаку съел!',
      dialect: 'pt_PT',
      category: IdiomCategory.comida,
      illustrationEmoji: '🍗',
    ),

    // 6. Acabar em pizza
    PortugueseIdiom(
      id: 'idiom_acabar_em_pizza',
      expressionPt: 'Acabar em pizza',
      literalTranslationRu: 'Закончиться пиццей',
      meaningRu: 'Когда громкое расследование или скандал замяли и никто не был наказан.',
      meaningPt: 'Terminar sem punição para os culpados após um escândalo ou disputa.',
      originStoryRu: 'В 1960-х годах директора футбольного клуба Palmeiras в Сан-Паулу 14 часов бурно ругались на собрании, а проголодавшись, пошли в пиццерию, помирились за пиццей и закрыли спор.',
      examplePt: 'Mais uma comissão parlamentar de inquérito que acabou em pizza.',
      exampleRu: 'Очередная парламентская комиссия по расследованию, которая закончилась пшиком.',
      dialect: 'pt_BR',
      category: IdiomCategory.comida,
      illustrationEmoji: '🍕',
    ),

    // 7. Descascar o abacaxi
    PortugueseIdiom(
      id: 'idiom_descascar_abacaxi',
      expressionPt: 'Descascar o abacaxi',
      literalTranslationRu: 'Чистить ананас',
      meaningRu: 'Решать сложную, колючую и неприятную проблему; разгребать завалы.',
      meaningPt: 'Resolver um problema muito complexo, trabalhoso e espinhoso.',
      originStoryRu: 'Ананас очень вкусный, но его кожура грубая и колючая, поэтому чистить его вручную требует больших усилий и сноровки.',
      examplePt: 'O chefe viajou e sobrou para mim descascar esse abacaxi com o cliente.',
      exampleRu: 'Начальник уехал, и мне пришлось разгребать эту сложнейшую проблему с клиентом.',
      dialect: 'pt_BR',
      category: IdiomCategory.comida,
      illustrationEmoji: '🍍',
    ),

    // 8. Pão pão, queijo queijo
    PortugueseIdiom(
      id: 'idiom_pao_queijo',
      expressionPt: 'Pão pão, queijo queijo',
      literalTranslationRu: 'Хлеб — это хлеб, а сыр — это сыр',
      meaningRu: 'Называть вещи своими именами; говорить предельно ясно и прямо.',
      meaningPt: 'Falar de forma clara, direta e sem rodeios.',
      originStoryRu: 'Старинная португальская поговорка о честности и простоте: не нужно путать разные вещи и выдумывать лишнее.',
      examplePt: 'Vamos falar com franqueza: pão pão, queijo queijo, o orçamento não chega.',
      exampleRu: 'Давайте начистоту, называя вещи своими именами: бюджета просто не хватает.',
      dialect: 'pt_PT',
      category: IdiomCategory.comida,
      illustrationEmoji: '🧀',
    ),

    // 9. Enfiar o pé na jaca
    PortugueseIdiom(
      id: 'idiom_pe_na_jaca',
      expressionPt: 'Enfiar o pé na jaca',
      literalTranslationRu: 'Засунуть ногу в джекфрут',
      meaningRu: 'Пойти вразнос, потерять меру (напиться, объесться или загулять).',
      meaningPt: 'Cometer excessos, perder o controle ou exagerar na comida/bebida.',
      originStoryRu: 'Раньше крестьяне перевозили товар в плетеных корзинах «jacá». Выпив в трактире, в темноте они спотыкались и буквально наступали ногой в корзину.',
      examplePt: 'Depois de semanas de dieta rigorosa, ontem enfiei o pé na jaca na festa.',
      exampleRu: 'После недель строгой диеты вчера на вечеринке я пошел в полный разнос.',
      dialect: 'pt_BR',
      category: IdiomCategory.comida,
      illustrationEmoji: '🍈',
    ),

    // 10. Falar pelos cotovelos
    PortugueseIdiom(
      id: 'idiom_falar_cotovelos',
      expressionPt: 'Falar pelos cotovelos',
      literalTranslationRu: 'Говорить локтями',
      meaningRu: 'Говорить без умолку, болтать без остановки.',
      meaningPt: 'Falar excessivamente e sem parar.',
      originStoryRu: 'Образ человека, который в запале речи постоянно трогает или толкает собеседника локтем, чтобы привлечь внимание.',
      examplePt: 'A minha vizinha é muito simpática, mas quando começa fala pelos cotovelos!',
      exampleRu: 'Моя соседка очень милая, но когда начинает — болтает без остановки!',
      dialect: 'all',
      category: IdiomCategory.corpo,
      illustrationEmoji: '🗣️',
    ),

    // 11. Custar os olhos da cara
    PortugueseIdiom(
      id: 'idiom_olhos_da_cara',
      expressionPt: 'Custar os olhos da cara',
      literalTranslationRu: 'Стоить глаз с лица',
      meaningRu: 'Стоить безумных денег, баснословно дорого.',
      meaningPt: 'Ser extraordinariamente caro ou dispendioso.',
      originStoryRu: 'Глаза — самое ценное чувство человека. Отдать за вещь свои глаза означает заплатить непомерную цену.',
      examplePt: 'Aquele apartamento com vista para o Tejo custa os olhos da cara.',
      exampleRu: 'Та квартира с видом на реку Тежу стоит целое состояние.',
      dialect: 'all',
      category: IdiomCategory.corpo,
      illustrationEmoji: '👀',
    ),

    // 12. Dar com a língua nos dentes
    PortugueseIdiom(
      id: 'idiom_lingua_nos_dentes',
      expressionPt: 'Dar com a língua nos dentes',
      literalTranslationRu: 'Ударить языком по зубам',
      meaningRu: 'Проболтаться, не удержать секрет, выдать тайну.',
      meaningPt: 'Revelar um segredo ou falar de algo que devia ser mantido em segredo.',
      originStoryRu: 'Метафора языка, который не слушается воли хозяина и выбалтывает лишнее сквозь зубы.',
      examplePt: 'A festa era surpresa, mas o irmão dele deu com a língua nos dentes.',
      exampleRu: 'Вечеринка была сюрпризом, но его брат проболтался.',
      dialect: 'all',
      category: IdiomCategory.corpo,
      illustrationEmoji: '👅',
    ),

    // 13. Ficar a ver navios
    PortugueseIdiom(
      id: 'idiom_ver_navios',
      expressionPt: 'Ficar a ver navios',
      literalTranslationRu: 'Остаться смотреть на корабли',
      meaningRu: 'Остаться ни с чем, быть обманутым в ожиданиях, напрасно прождать.',
      meaningPt: 'Ficar desiludido, enganado ou esperando por algo que nunca chega.',
      originStoryRu: 'Связано с битвой при Эль-Ксар-эль-Кебире (1578), где погиб юный португальский король Себастьян. Народ годами выходил на берег в тумане смотреть на корабли, веря в его чудесное возвращение (Себастьянизм).',
      examplePt: 'Prometeram pagar-lhe o bónus no fim do mês, mas ele ficou a ver navios.',
      exampleRu: 'Ему обещали выплатить премию в конце месяца, но он остался с носом.',
      dialect: 'pt_PT',
      category: IdiomCategory.vida,
      illustrationEmoji: '⛵',
    ),

    // 14. Chorar sobre o leite derramado
    PortugueseIdiom(
      id: 'idiom_leite_derramado',
      expressionPt: 'Chorar sobre o leite derramado',
      literalTranslationRu: 'Плакать над пролитым молоком',
      meaningRu: 'Бесполезно сокрушаться о том, что уже произошло и чего не исправить.',
      meaningPt: 'Lamentar-se inutilmente por um erro ou prejuízo irreparável.',
      originStoryRu: 'Универсальная пословица о том, что пролитое на землю молоко уже невозможно собрать обратно в кувшин.',
      examplePt: 'O voo já partiu, agora não adianta chorar sobre o leite derramado.',
      exampleRu: 'Рейс уже улетел, теперь бесполезно плакать над пролитым молоком.',
      dialect: 'all',
      category: IdiomCategory.vida,
      illustrationEmoji: '🥛',
    ),

    // 15. Fazer tempestade em copo d'água
    PortugueseIdiom(
      id: 'idiom_tempestade_copo',
      expressionPt: "Fazer tempestade em copo d'água",
      literalTranslationRu: 'Устроить бурю в стакане воды',
      meaningRu: 'Раздувать трагедию из незначительного повода, делать из мухи слона.',
      meaningPt: 'Exagerar a gravidade de uma pequena dificuldade ou contratempo.',
      originStoryRu: 'Аллегория огромного морского шторма, сжатого в крошечный объем стакана с водой.',
      examplePt: 'Foi só um atraso de dez minutos, não precisas de fazer tempestade em copo de água.',
      exampleRu: 'Это было всего лишь десятиминутное опоздание, не нужно делать из мухи слона.',
      dialect: 'all',
      category: IdiomCategory.vida,
      illustrationEmoji: '⛈️',
    ),

    // 16. Bater as botas
    PortugueseIdiom(
      id: 'idiom_bater_as_botas',
      expressionPt: 'Bater as botas',
      literalTranslationRu: 'Стучать сапогами',
      meaningRu: 'Умереть, сыграть в ящик, отдать концы (разговорное).',
      meaningPt: 'Falecer, morrer (expressão coloquial e informal).',
      originStoryRu: 'Военное происхождение: во время битв солдаты падали замертво, ударяя подошвами сапог о землю.',
      examplePt: 'O velho carro dele finalmente bateu as botas ontem na subida da serra.',
      exampleRu: 'Его старая машина вчера окончательно отдала концы на подъеме в гору.',
      dialect: 'all',
      category: IdiomCategory.vida,
      illustrationEmoji: '👢',
    ),
  ];
}
