import '../../domain/entities/cultural_tip_entity.dart';
import '../../domain/entities/survival_phrase_entity.dart';
import '../../domain/entities/survival_quest_entity.dart';
import '../../domain/entities/survival_step_entity.dart';

class SurvivalGuideSeedData {
  // 1. Интерактивные квесты
  static const List<SurvivalQuestEntity> quests = [
    // Квест 1: NIF в Лиссабоне
    SurvivalQuestEntity(
      id: 'quest_nif_lisboa',
      titlePt: 'Tirando o NIF nas Finanças em Lisboa',
      titleRu: 'Оформление NIF в налоговой (Finanças)',
      category: SurvivalCategory.bureaucracy,
      dialect: 'pt_PT',
      cefrLevel: 'A2',
      estimatedMinutes: 5,
      iconEmoji: '📋',
      overviewRu: 'NIF (Número de Identificação Fiscal) — первый и главный документ в Португалии. Без него нельзя арендовать жилье, купить SIM-карту или открыть счет в банке. Вы пришли в отделение Autoridade Tributária.',
      requiredDocumentsRu: [
        'Заграничный паспорт',
        'Подтверждение адреса в стране гражданства (выписка из банка с адресом)',
        'Налоговый представитель (если вы не являетесь резидентом ЕС)',
      ],
      steps: [
        SurvivalStepEntity(
          id: 'step_nif_1',
          speakerRole: 'Guarda da entrada (Охранник у автомата талонов)',
          promptPt: 'Bom dia. Vem para que serviço? Tem agendamento prévio ou vem tirar senha?',
          promptRu: 'Доброе утро. По какому вы вопросу? У вас есть предварительная запись или берете талон?',
          culturalNoteRu: 'В государственных службах Португалии всегда нужно брать талон (senha). Разные буквы отвечают за разные отделы.',
          options: [
            SurvivalStepOption(
              textPt: 'Bom dia! Não tenho agendamento, vim tirar senha para pedir o NIF de não residente pela primeira vez.',
              translationRu: 'Доброе утро! Записи нет, я пришел взять талон, чтобы оформить NIF нерезидента впервые.',
              isOptimal: true,
              feedbackRu: 'Идеально! Вы четко назвали услугу ("NIF de não residente") и объяснили, что записи нет.',
            ),
            SurvivalStepOption(
              textPt: 'Oi cara, me dá um papel aí pra eu tirar meu CPF.',
              translationRu: 'Привет чувак, дай мне бумажку оформить CPF.',
              isOptimal: false,
              feedbackRu: 'В Португалии документ называется NIF, а не CPF. Обращение "cara" к охраннику неуместно.',
            ),
          ],
        ),
        SurvivalStepEntity(
          id: 'step_nif_2',
          speakerRole: 'Funcionária das Finanças (Сотрудница налоговой)',
          promptPt: 'Senha C42. Faça o favor de se sentar. Trouxe o passaporte e o comprovativo de morada original?',
          promptRu: 'Талон С42. Присаживайтесь, пожалуйста. Вы принесли загранпаспорт и оригинал подтверждения адреса?',
          culturalNoteRu: 'Comprovativo de morada — ключевой португальский термин для любого документа, подтверждающего прописку/адрес.',
          options: [
            SurvivalStepOption(
              textPt: 'Com certeza. Aqui tem o meu passaporte e a declaração bancária traduzida com a minha morada.',
              translationRu: 'Конечно. Вот мой паспорт и переведенная банковская выписка с моим адресом.',
              isOptimal: true,
              feedbackRu: 'Точно в цель! Вы использовали вежливое "Com certeza" и термин "morada" (адрес).',
            ),
            SurvivalStepOption(
              textPt: 'Eu esqueci o papel, mas posso te mostrar uma foto no WhatsApp?',
              translationRu: 'Я забыл бумагу, но могу показать фото в вотсапе?',
              isOptimal: false,
              feedbackRu: 'В португальских Finanças требуют физический оригинал или заверенную копию документа.',
            ),
          ],
        ),
        SurvivalStepEntity(
          id: 'step_nif_3',
          speakerRole: 'Funcionária das Finanças (Сотрудница налоговой)',
          promptPt: 'Está tudo em conformidade. O documento provisório com o seu NIF já está emitido. Pode assinar aqui, por favor?',
          promptRu: 'Все в порядке. Предварительный документ с вашим NIF уже сформирован. Распишитесь здесь, пожалуйста?',
          culturalNoteRu: 'NIF выдается сразу в виде бумажного листа формата А4 с 9-значным номером налогоплательщика.',
          options: [
            SurvivalStepOption(
              textPt: 'Muito obrigado pela sua atenção! Posso usar este documento imediatamente para abrir conta bancária?',
              translationRu: 'Большое спасибо за помощь! Я могу использовать этот документ прямо сейчас для открытия счета в банке?',
              isOptimal: true,
              feedbackRu: 'Отличный вопрос! Лист с NIF действует мгновенно с момента подписания.',
            ),
            SurvivalStepOption(
              textPt: 'Assinei. Cadê o cartão de plástico?',
              translationRu: 'Подписал. А где пластиковая карточка?',
              isOptimal: false,
              feedbackRu: 'Отдельной пластиковой карты для иностранного NIF нет — выдается официальный лист с номером.',
            ),
          ],
        ),
      ],
    ),

    // Квест 2: Аренда квартиры в Порту
    SurvivalQuestEntity(
      id: 'quest_rent_porto',
      titlePt: 'Alugando um Apartamento no Porto',
      titleRu: 'Переговоры об аренде квартиры (Contrato e Fiador)',
      category: SurvivalCategory.housing,
      dialect: 'pt_PT',
      cefrLevel: 'B1',
      estimatedMinutes: 6,
      iconEmoji: '🏠',
      overviewRu: 'Вы нашли хорошую квартиру T1 в районе Bonfim в Порту. Хозяин сдает квартиру официально по контракту, но требует местного поручителя (fiador) или увеличение залога.',
      requiredDocumentsRu: [
        'NIF',
        'Трудовой контракт или подтверждение доходов',
        'Залоговый депозит (caução) и арендная плата за первый месяц (renda)',
      ],
      steps: [
        SurvivalStepEntity(
          id: 'step_rent_1',
          speakerRole: 'Senhorio (Собственник квартиры)',
          promptPt: 'Gostou do apartamento? A renda mensal são 750 euros. Exijo duas rendas adiantadas e um fiador com rendimentos em Portugal.',
          promptRu: 'Вам понравилась квартира? Аренда составляет 750 евро в месяц. Я требую оплату за два месяца вперед и поручителя с доходами в Португалии.',
          culturalNoteRu: 'Fiador — традиционный португальский гарант договора. Иностранцы часто заменяют его дополнительным депозитом (caução).',
          options: [
            SurvivalStepOption(
              textPt: 'O apartamento é excelente! Como sou estrangeiro e ainda não tenho fiador cá, seria possível pagar três meses de caução em vez de apresentar fiador?',
              translationRu: 'Квартира отличная! Так как я иностранец и у меня еще нет местного поручителя, возможно ли внести залог за три месяца вместо поручителя?',
              isOptimal: true,
              feedbackRu: 'Блестящее решение! Это стандартная и очень эффективная практика переговоров об аренде в Португалии.',
            ),
            SurvivalStepOption(
              textPt: 'Não tenho fiador nem quero pagar caução. Vamos fechar sem contrato nenhum?',
              translationRu: 'У меня нет поручителя и залог платить не хочу. Давайте заключим сделку вообще без договора?',
              isOptimal: false,
              feedbackRu: 'Аренда без договора оставляет вас без защиты закона и не позволяет получить подтверждение адреса (Atestado de Residência).',
            ),
          ],
        ),
        SurvivalStepEntity(
          id: 'step_rent_2',
          speakerRole: 'Senhorio (Собственник квартиры)',
          promptPt: 'Posso aceitar os três meses de caução. As despesas de água, luz e internet ficam por sua conta. O contrato é de um ano renovável. Emite NIF para as faturas?',
          promptRu: 'Я согласен на залог за три месяца. Расходы на воду, свет и интернет на вас. Договор на один год с продлением. Предоставите NIF для квитанций?',
          culturalNoteRu: 'В Португалии официальные квитанции за аренду (recibos de renda eletrónicos) регистрируются на портале Portal das Finanças.',
          options: [
            SurvivalStepOption(
              textPt: 'Sim, claro! Já tenho o meu NIF e quero registar o contrato no Portal das Finanças para emitir os recibos de renda eletrónicos.',
              translationRu: 'Да, конечно! У меня уже есть NIF, и я хочу зарегистрировать договор на Portal das Finanças для формирования электронных квитанций.',
              isOptimal: true,
              feedbackRu: 'Юридически грамотный ответ! Наличие электронных квитанций необходимо для легализации и налогового вычета.',
            ),
            SurvivalStepOption(
              textPt: 'Pode deixar o contrato no seu nome mesmo, eu te pago em dinheiro vivo todo mês.',
              translationRu: 'Оставьте договор на ваше имя, я буду платить наличкой каждый месяц.',
              isOptimal: false,
              feedbackRu: 'Оплата наличными без чека лишает вас доказательства проживания для иммиграционных служб.',
            ),
          ],
        ),
      ],
    ),

    // Квест 3: Покупка билета на вокзале Santa Apolónia
    SurvivalQuestEntity(
      id: 'quest_train_ticket',
      titlePt: 'Comprando Bilhete de Comboio em Santa Apolónia',
      titleRu: 'Покупка билета на скоростной поезд в Лиссабоне',
      category: SurvivalCategory.transport,
      dialect: 'pt_PT',
      cefrLevel: 'A2',
      estimatedMinutes: 4,
      iconEmoji: '🚆',
      overviewRu: 'Вы на главном историческом вокзале Лиссабона — Estação de Santa Apolónia. Вам нужно купить билет на скоростной поезд Alfa Pendular до Порту, выбрав класс и удобное место.',
      requiredDocumentsRu: ['Паспорт или документ с датой рождения (для молодежной/возрастной скидки)'],
      steps: [
        SurvivalStepEntity(
          id: 'step_tr_1',
          speakerRole: 'Funcionário da Bilheteira da CP (Кассир железных дорог)',
          promptPt: 'Bom dia. Para onde deseja viajar e a que horas?',
          promptRu: 'Доброе утро. Куда желаете поехать и во сколько?',
          culturalNoteRu: 'CP (Comboios de Portugal) делит поезда на Alfa Pendular (самый быстрый с Wi-Fi) и Intercidades (чуть медленнее, но дешевле).',
          options: [
            SurvivalStepOption(
              textPt: 'Bom dia! Queria um bilhete para o Porto no comboio Alfa Pendular das 14h, em classe turística, se faz favor.',
              translationRu: 'Доброе утро! Я хотел бы билет в Порту на поезд Alfa Pendular на 14:00, во 2-й класс (turística), пожалуйста.',
              isOptimal: true,
              feedbackRu: 'Превосходно! Вежливая форма "Queria" (я хотел бы) и четкое указание поезда и класса.',
            ),
            SurvivalStepOption(
              textPt: 'Me vende uma passagem pro trem bala agora.',
              translationRu: 'Продай мне билет на скоростной поезд сейчас.',
              isOptimal: false,
              feedbackRu: 'В Португалии поезд — "o comboio" (а не "o trem"), а вежливая форма требует "Queria... se faz favor".',
            ),
          ],
        ),
        SurvivalStepEntity(
          id: 'step_tr_2',
          speakerRole: 'Funcionário da Bilheteira da CP',
          promptPt: 'Prefere lugar à janela ou ao corredor? E deseja ida e volta? A viagem de ida e volta tem 10% de desconto.',
          promptRu: 'Предпочитаете место у окна или у прохода? И хотите туда-обратно? Поездка туда-обратно дает 10% скидки.',
          culturalNoteRu: 'Места в поездах Alfa Pendular бронируются с точным номером вагона (carruagem) и места (lugar).',
          options: [
            SurvivalStepOption(
              textPt: 'Prefiro lugar à janela, com regresso no domingo às 18h. Muito obrigado pelo desconto de ida e volta!',
              translationRu: 'Предпочитаю место у окна с возвращением в воскресенье в 18:00. Большое спасибо за скидку туда-обратно!',
              isOptimal: true,
              feedbackRu: 'Идеальный выбор: место у окна ("à janela") и точное время обратного поезда ("regresso").',
            ),
            SurvivalStepOption(
              textPt: 'Qualquer um serve, sento no chão se estiver lotado.',
              translationRu: 'Любое пойдет, сяду на пол, если будет забито.',
              isOptimal: false,
              feedbackRu: 'В поездах Alfa Pendular места строго закреплены за пассажиром, стоячие билеты не продаются.',
            ),
          ],
        ),
      ],
    ),

    // Квест 4: Оформление CPF в Рио
    SurvivalQuestEntity(
      id: 'quest_cpf_rio',
      titlePt: 'Tirando o CPF no Rio de Janeiro',
      titleRu: 'Оформление CPF в Бразилии (Receita Federal)',
      category: SurvivalCategory.bureaucracy,
      dialect: 'pt_BR',
      cefrLevel: 'A2',
      estimatedMinutes: 5,
      iconEmoji: '🇧🇷',
      overviewRu: 'CPF (Cadastro de Pessoas Físicas) — главный документ в Бразилии. Без него нельзя купить билет на междугородний автобус, зарегистрироваться в приложении или купить кофе в супермаркете.',
      requiredDocumentsRu: ['Загранпаспорт', 'Квитанция об оплате пошлины в Correios или Banco do Brasil'],
      steps: [
        SurvivalStepEntity(
          id: 'step_cpf_1',
          speakerRole: 'Atendente dos Correios (Сотрудник почты)',
          promptPt: 'Bom dia! Vai fazer inscrição de CPF de estrangeiro? Trouxe o passaporte original?',
          promptRu: 'Доброе утро! Будете оформлять регистрацию CPF иностранца? Принесли оригинал загранпаспорта?',
          culturalNoteRu: 'В Бразилии первый шаг оформления CPF для иностранцев часто делается в отделении почты Correios или Banco do Brasil.',
          options: [
            SurvivalStepOption(
              textPt: 'Bom dia! Sim, trouxe o meu passaporte original. Quanto custa a taxa de emissão?',
              translationRu: 'Доброе утро! Да, принес оригинал паспорта. Сколько стоит пошлина за выпуск?',
              isOptimal: true,
              feedbackRu: 'Отлично! Пошлина в Correios составляет символические R\$ 7,00.',
            ),
            SurvivalStepOption(
              textPt: 'Não tenho passaporte, serve o meu bilhete de metrô?',
              translationRu: 'Паспорта нет, подойдет мой проездной на метро?',
              isOptimal: false,
              feedbackRu: 'Для государственных процедур принимается только загранпаспорт с действующей визой/штампом въезда.',
            ),
          ],
        ),
        SurvivalStepEntity(
          id: 'step_cpf_2',
          speakerRole: 'Atendente dos Correios',
          promptPt: 'A taxa é de 7 reais. Qual é o seu e-mail para receber o comprovante e o número do protocolo?',
          promptRu: 'Пошлина 7 реалов. На какой e-mail отправить квитанцию и номер протокола?',
          culturalNoteRu: 'После оплаты на почте присваивается номер протокола, по которому на сайте Receita Federal генерируется номер CPF.',
          options: [
            SurvivalStepOption(
              textPt: 'Posso pagar em dinheiro vivo ou no Pix? O meu e-mail é contato@email.com.',
              translationRu: 'Могу оплатить наличными или по Pix? Мой e-mail contato@email.com.',
              isOptimal: true,
              feedbackRu: 'Отлично! Почта принимает как наличные, так и Pix, а номер CPF часто готов уже в тот же день.',
            ),
            SurvivalStepOption(
              textPt: 'Não tenho e-mail, me manda uma carta na minha casa.',
              translationRu: 'У меня нет e-mail, отправьте мне письмо на дом.',
              isOptimal: false,
              feedbackRu: 'Современная Receita Federal работает в цифровом виде через сайт и e-mail.',
            ),
          ],
        ),
      ],
    ),
  ];

  // 2. Экспресс-шпаргалки (фразы выживания)
  static const List<SurvivalPhraseEntity> phrases = [
    // Бюрократия
    SurvivalPhraseEntity(
      id: 'p_bur_1',
      textPt: 'Vim pedir o meu NIF de não residente, por favor.',
      translationRu: 'Я пришел оформить NIF нерезидента, пожалуйста.',
      contextNoteRu: 'Первая фраза, которую вы говорите у стойки налоговой (Finanças) в Португалии.',
      category: SurvivalCategory.bureaucracy,
      dialect: 'pt_PT',
    ),
    SurvivalPhraseEntity(
      id: 'p_bur_2',
      textPt: 'Qual é o prazo estimado para a emissão deste documento?',
      translationRu: 'Каков ориентировочный срок выдачи этого документа?',
      contextNoteRu: 'Универсальный вопрос в любом ведомстве или банке.',
      category: SurvivalCategory.bureaucracy,
    ),
    SurvivalPhraseEntity(
      id: 'p_bur_3',
      textPt: 'Preciso de tirar o CPF para abrir uma conta bancária.',
      translationRu: 'Мне нужно получить CPF, чтобы открыть банковский счет.',
      contextNoteRu: 'Стандартная цель визита в Correios или Receita Federal в Бразилии.',
      category: SurvivalCategory.bureaucracy,
      dialect: 'pt_BR',
    ),
    SurvivalPhraseEntity(
      id: 'p_bur_4',
      textPt: 'Onde posso tirar a certidão / o atestado de residência?',
      translationRu: 'Где я могу получить справку о месте жительства?',
      contextNoteRu: 'В Португалии выдается в Junta de Freguesia вашего района.',
      category: SurvivalCategory.bureaucracy,
      dialect: 'pt_PT',
    ),

    // Аренда и жилье
    SurvivalPhraseEntity(
      id: 'p_hous_1',
      textPt: 'As despesas de água, luz, gás e condomínio estão incluídas na renda?',
      translationRu: 'Коммунальные расходы (вода, свет, газ) и кондоминиум включены в аренду?',
      contextNoteRu: 'Критически важный вопрос перед подписанием договора аренды.',
      category: SurvivalCategory.housing,
      dialect: 'pt_PT',
    ),
    SurvivalPhraseEntity(
      id: 'p_hous_2',
      textPt: 'Quantos meses de caução e de adiantamento são necessários?',
      translationRu: 'Сколько месяцев залога и предоплаты требуется?',
      contextNoteRu: 'Caução — залог/депозит за сохранность имущества.',
      category: SurvivalCategory.housing,
    ),
    SurvivalPhraseEntity(
      id: 'p_hous_3',
      textPt: 'O senhor emite recibos de renda eletrónicos no Portal das Finanças?',
      translationRu: 'Вы выдаете официальные электронные квитанции об аренде в Portal das Finanças?',
      contextNoteRu: 'Официальные чеки обязательны для легального статуса проживания в Португалии.',
      category: SurvivalCategory.housing,
      dialect: 'pt_PT',
    ),
    SurvivalPhraseEntity(
      id: 'p_hous_4',
      textPt: 'O apartamento tem vaga de garagem inclusa no valor do condomínio?',
      translationRu: 'В стоимость кондоминиума включено парковочное место?',
      contextNoteRu: 'Очень актуально при аренде квартиры в крупных городах Бразилии (SP/Rio).',
      category: SurvivalCategory.housing,
      dialect: 'pt_BR',
    ),

    // Транспорт
    SurvivalPhraseEntity(
      id: 'p_trans_1',
      textPt: 'Um bilhete de ida e volta para Coimbra em classe turística, se faz favor.',
      translationRu: 'Один билет туда и обратно в Коимбру во второй класс, пожалуйста.',
      contextNoteRu: 'В португальских поездах 2-й класс называется "classe turística", а 1-й — "classe conforto".',
      category: SurvivalCategory.transport,
      dialect: 'pt_PT',
    ),
    SurvivalPhraseEntity(
      id: 'p_trans_2',
      textPt: 'A que linha / plataforma chega o comboio das 15h30?',
      translationRu: 'На какой путь / платформу прибывает поезд в 15:30?',
      contextNoteRu: 'В Португалии ж/д путь называют "linha", в Бразилии — "plataforma".',
      category: SurvivalCategory.transport,
    ),
    SurvivalPhraseEntity(
      id: 'p_trans_3',
      textPt: 'Como faço para recarregar o meu passe Navegante / Andante?',
      translationRu: 'Как мне пополнить мой проездной билет Navegante / Andante?',
      contextNoteRu: 'Navegante — единый проездной Лиссабона, Andante — проездной в Порту.',
      category: SurvivalCategory.transport,
      dialect: 'pt_PT',
    ),
    SurvivalPhraseEntity(
      id: 'p_trans_4',
      textPt: 'O carro tem dispositivo de Via Verde para as portagens automáticas?',
      translationRu: 'В машине установлен транспондер Via Verde для автоматической оплаты платных дорог?',
      contextNoteRu: 'В Португалии на многих трассах (Scuts) нет будок оплаты — только электронные рамки Via Verde.',
      category: SurvivalCategory.transport,
      dialect: 'pt_PT',
    ),

    // Здоровье и экстренные службы
    SurvivalPhraseEntity(
      id: 'p_heal_1',
      textPt: 'Estou com uma dor aguda no peito e falta de ar. Chame o 112 imediatamente!',
      translationRu: 'У меня острая боль в груди и нехватка воздуха. Вызовите 112 немедленно!',
      contextNoteRu: '112 — единый номер экстренных служб в Португалии и ЕС.',
      category: SurvivalCategory.health,
      dialect: 'pt_PT',
      isEmergency: true,
    ),
    SurvivalPhraseEntity(
      id: 'p_heal_2',
      textPt: 'Preciso de uma ambulância urgente! Ligue para o 192 (SAMU)!',
      translationRu: 'Срочно нужна скорая помощь! Звоните 192 (SAMU)!',
      contextNoteRu: '192 — телефон скорой помощи (SAMU) в Бразилии.',
      category: SurvivalCategory.health,
      dialect: 'pt_BR',
      isEmergency: true,
    ),
    SurvivalPhraseEntity(
      id: 'p_heal_3',
      textPt: 'Tem algum remédio para baixar a febre e aliviar as dores sem receita médica?',
      translationRu: 'Есть какое-нибудь лекарство сбить температуру и снять боль без рецепта врача?',
      contextNoteRu: 'Для покупки парацетамола или ибупрофена в аптеках рецепт не требуется.',
      category: SurvivalCategory.health,
    ),
    SurvivalPhraseEntity(
      id: 'p_heal_4',
      textPt: 'Qual é a farmácia de serviço aberta 24 horas nesta freguesia / bairro?',
      translationRu: 'Какая дежурная аптека открыта круглосуточно в этом районе?',
      contextNoteRu: 'Farmácia de serviço — дежурная круглосуточная аптека.',
      category: SurvivalCategory.health,
    ),

    // Банки и финансы
    SurvivalPhraseEntity(
      id: 'p_bank_1',
      textPt: 'Pode passar a fatura com o meu número de contribuinte (NIF)?',
      translationRu: 'Можете выбить чек с моим номером налогоплательщика (NIF)?',
      contextNoteRu: 'В Португалии эту фразу говорят в каждом магазине, кафе и супермаркете.',
      category: SurvivalCategory.banking,
      dialect: 'pt_PT',
    ),
    SurvivalPhraseEntity(
      id: 'p_bank_2',
      textPt: 'Qual é a sua chave Pix para eu transferir o valor agora?',
      translationRu: 'Какой у вас ключ Pix, чтобы я перевел сумму прямо сейчас?',
      contextNoteRu: 'Pix — мгновенная и бесплатная государственная система платежей в Бразилии.',
      category: SurvivalCategory.banking,
      dialect: 'pt_BR',
    ),
    SurvivalPhraseEntity(
      id: 'p_bank_3',
      textPt: 'Aceitam pagamento por Multibanco ou MBWay?',
      translationRu: 'Вы принимаете оплату через Multibanco или MBWay?',
      contextNoteRu: 'Многие мелкие кафе в Португалии не принимают карты Visa/Mastercard, но принимают португальский Multibanco.',
      category: SurvivalCategory.banking,
      dialect: 'pt_PT',
    ),
    SurvivalPhraseEntity(
      id: 'p_bank_4',
      textPt: 'Onde fica a agência bancária ou o caixa eletrónico mais próximo?',
      translationRu: 'Где находится ближайшее отделение банка или банкомат?',
      contextNoteRu: 'В Португалии банкомат называют "Multibanco", в Бразилии — "caixa eletrônico".',
      category: SurvivalCategory.banking,
    ),
  ];

  // 3. Практические советы по выживанию и этикету
  static const List<CulturalTipEntity> tips = [
    CulturalTipEntity(
      id: 'tip_nif_culture',
      titlePt: 'Por que o NIF é sagrado em Portugal?',
      titleRu: 'Магия NIF: почему его просят даже за чашку кофе',
      category: SurvivalCategory.bureaucracy,
      dialect: 'pt_PT',
      iconEmoji: '🧾',
      contentRu: 'В Португалии в 99% магазинов и ресторанов на кассе звучит вопрос: «Quer NIF na fatura?» (Внести NIF в чек?). Государство поощряет сбор чеков возвратом части налогов (IRS) и участием в лотерее «Fatura da Sorte».',
      bulletPointsRu: [
        'Всегда называйте свой NIF при покупках в супермаркетах, аптеках и автосервисах.',
        'Расходы на здоровье, рестораны и образование дают налоговый вычет в конце года.',
        'Без NIF невозможно оформить контракт на домашний интернет или аренду.',
      ],
    ),
    CulturalTipEntity(
      id: 'tip_senhas_portugal',
      titlePt: 'A Cultura das Senhas em Portugal',
      titleRu: 'Система талонов (Senhas) в Португалии',
      category: SurvivalCategory.bureaucracy,
      dialect: 'pt_PT',
      iconEmoji: '🔢',
      contentRu: 'В Португалии талонная система автоматизирована практически везде — от мясных лавок в супермаркетах Continente до аптек и банков. Попытка подойти без талона вызовет вежливое, но строгое замечание.',
      bulletPointsRu: [
        'Буквы имеют значение: "A" часто обычные вопросы, "C" — сложные процедуры, "E" — касса.',
        'Существует закон об Atendimento Prioritário: инвалиды, пожилые старше 65 лет и беременные обслуживаются вне общей очереди.',
        'Многие ведомства открывают запись онлайн на портале ePortugal или Siga.',
      ],
    ),
    CulturalTipEntity(
      id: 'tip_gorjetas',
      titlePt: 'Gorjetas: Portugal vs Brasil',
      titleRu: 'Чаевые: португальский счет vs бразильские 10%',
      category: SurvivalCategory.banking,
      dialect: 'all',
      iconEmoji: '🪙',
      contentRu: 'В Португалии и Бразилии совершенно разное отношение к чаевым (gorjeta). Понимание этого избавит от неловких пауз в кафе и ресторанах.',
      bulletPointsRu: [
        'Португалия: чаевые не обязательны. При хорошем обслуживании в тавернах округляют счет на 1-2 евро, в ресторанах оставляют 5-10% наличными.',
        'Бразилия: в счет почти всегда автоматически включены «os 10%» (taxa de serviço). Если вы согласны, оплачиваете по счету без доплат.',
        'В такси и Uber в обеих странах чаевые оставляют через приложение по желанию.',
      ],
    ),
    CulturalTipEntity(
      id: 'tip_addressing_people',
      titlePt: 'Como tratar as pessoas com respeito',
      titleRu: 'Как обращаться к людям: ловушка слова «Você»',
      category: SurvivalCategory.bureaucracy,
      dialect: 'all',
      iconEmoji: '🤝',
      contentRu: 'Главная ловушка между Бразилией и Португалией. В Бразилии «você» — универсальное теплое «ты/вы». В Португалии обращение на «você» к незнакомцу может показаться пренебрежительным или слишком фамильярным!',
      bulletPointsRu: [
        'В Португалии к незнакомцам обращаются без местоимения в 3-м лице: «O senhor pode ajudar-me?» / «A senhora tem o documento?»',
        'К людям с высшим образованием в Португалии принято обращаться «Senhor Doutor / Senhora Doutora».',
        'В Бразилии обращение «Você» абсолютно естественно везде, а к пожилым людям уважительно говорят «o senhor / a senhora».',
      ],
    ),
    CulturalTipEntity(
      id: 'tip_via_verde',
      titlePt: 'Portagens e Via Verde em Portugal',
      titleRu: 'Платные дороги и электронные рамки (Scuts)',
      category: SurvivalCategory.transport,
      dialect: 'pt_PT',
      iconEmoji: '🛣️',
      contentRu: 'В Португалии одна из самых развитых сетей автобанов, но многие трассы (бывшие SCUT) оснащены исключительно электронными камерами без привычных пунктов со шлагбаумами.',
      bulletPointsRu: [
        'При аренде авто в Португалии ВСЕГДА подключайте транспондер Via Verde (около 1.5–2 евро/день).',
        'Без транспондера придется оплачивать проезд на почте CTT через 2 дня, иначе грозит крупный штраф.',
        'Трасса A22 в Алгарве и A28 на севере работают только по электронной системе.',
      ],
    ),
  ];
}
