import '../../domain/entities/chat_abbreviation_entity.dart';
import '../../domain/entities/chat_dialog_step_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_scenario_entity.dart';
import '../../domain/entities/chat_user_choice_entity.dart';

class ChatSimulatorSeedData {
  // Список распространенных сокращений
  static const abbrVc = ChatAbbreviation(
    shortForm: 'vc',
    fullWordPt: 'você',
    translationRu: 'ты / вы',
    explanationRu: 'Самое частое сокращение в переписке на португальском языке.',
  );

  static const abbrTbm = ChatAbbreviation(
    shortForm: 'tbm',
    fullWordPt: 'também',
    translationRu: 'тоже / также',
    explanationRu: 'Часто сокращается как "tbm" или просто "tb".',
  );

  static const abbrBlz = ChatAbbreviation(
    shortForm: 'blz',
    fullWordPt: 'beleza',
    translationRu: 'ладно / договорились / всё круто',
    explanationRu: 'Бразильское разговорное "ок, супер, договорились".',
    dialect: 'pt_BR',
  );

  static const abbrFds = ChatAbbreviation(
    shortForm: 'fds',
    fullWordPt: 'fim de semana',
    translationRu: 'выходные',
    explanationRu: 'Обозначение субботы и воскресенья в чатах.',
  );

  static const abbrPq = ChatAbbreviation(
    shortForm: 'pq',
    fullWordPt: 'porque / por que',
    translationRu: 'почему / потому что',
    explanationRu: 'Универсальное сокращение для вопросов и ответов.',
  );

  static const abbrMto = ChatAbbreviation(
    shortForm: 'mto',
    fullWordPt: 'muito',
    translationRu: 'очень / много',
    explanationRu: 'Встречается также в женском роде "mta" (muita).',
  );

  static const abbrObg = ChatAbbreviation(
    shortForm: 'obg',
    fullWordPt: 'obrigado / obrigada',
    translationRu: 'спасибо',
    explanationRu: 'Стандартное быстрое спасибо в SMS и мессенджерах.',
  );

  static const abbrPff = ChatAbbreviation(
    shortForm: 'pff',
    fullWordPt: 'por favor',
    translationRu: 'пожалуйста',
    explanationRu: 'Очень распространено в переписке в Португалии.',
    dialect: 'pt_PT',
  );

  static const abbrFlw = ChatAbbreviation(
    shortForm: 'flw',
    fullWordPt: 'falou',
    translationRu: 'до связи / пока',
    explanationRu: 'Бразильское неформальное прощание ("договорились, пока").',
    dialect: 'pt_BR',
  );

  static const abbrTo = ChatAbbreviation(
    shortForm: 'tô',
    fullWordPt: 'estou',
    translationRu: 'я (нахожусь/делаю)',
    explanationRu: 'Разговорная форма глагола estar в 1-м лице.',
  );

  static const abbrCtz = ChatAbbreviation(
    shortForm: 'ctz',
    fullWordPt: 'certeza',
    translationRu: 'точно / наверняка',
    explanationRu: 'Сокращение от слова certeza (уверенность).',
  );

  static const abbrFixe = ChatAbbreviation(
    shortForm: 'fixe',
    fullWordPt: 'fixe',
    translationRu: 'круто / здорово',
    explanationRu: 'Главный сленг европейского португальского (в Бразилии говорят "legal").',
    dialect: 'pt_PT',
  );

  // Каталог сценариев
  static const List<ChatScenarioEntity> scenarios = [
    // 1. Аренда в Лиссабоне
    ChatScenarioEntity(
      id: 'lisboa_airbnb',
      titlePt: 'Apartamento em Lisboa',
      titleRu: 'Аренда квартиры в Лиссабоне',
      channelName: 'WhatsApp',
      contactName: 'João Martins (Host)',
      avatarEmoji: '🇵🇹',
      dialect: 'pt_PT',
      cefrLevel: 'A2',
      scenarioContextRu: 'Вы только что приземлились в аэропорту Лиссабона. Нужно связаться с хозяином жилья, сообщить о прибытии и узнать код от сейфа с ключами.',
      initialStepId: 'step_1',
      steps: {
        'step_1': ChatDialogStepEntity(
          stepId: 'step_1',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm1_1',
              senderId: 'contact',
              senderName: 'João Martins',
              textPt: 'Olá! Tudo bem? O vosso voo já aterrou em Lisboa?',
              translationRu: 'Здравствуйте! Всё хорошо? Ваш рейс уже приземлился в Лиссабоне?',
              isUser: false,
              timestampStr: '14:02',
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c1_1',
              textPt: 'Olá, João! Sim, acabámos de aterrar. Já estamos a recolher as malas.',
              translationRu: 'Здравствуйте, Жоау! Да, только что сели. Уже забираем чемоданы.',
              isNaturalChoice: true,
              feedbackNoteRu: 'Идеально! Конструкция "acabámos de" (только что) и "estamos a recolher" (процесс в PT-PT) звучат абсолютно естественно.',
              nextStepId: 'step_2',
            ),
            ChatUserChoiceEntity(
              id: 'c1_2',
              textPt: 'Oi João! Sim, o avião pousou. Tô pegando a mala agora.',
              translationRu: 'Привет, Жоау! Да, самолет сел. Я беру чемодан сейчас.',
              isNaturalChoice: false,
              feedbackNoteRu: 'Грамматически понятно, но "Oi", "pousou" и "tô pegando" — чисто бразильский стиль, в Португалии привычнее "Olá" и "estou a apanhar".',
              nextStepId: 'step_2',
            ),
          ],
        ),
        'step_2': ChatDialogStepEntity(
          stepId: 'step_2',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm2_1',
              senderId: 'contact',
              senderName: 'João Martins',
              textPt: 'Ótimo! O apartamento fica no Chiado. Como vêm para cá, de metro ou de Uber?',
              translationRu: 'Отлично! Квартира в районе Шиаду. Как вы поедете сюда, на метро или на Uber?',
              isUser: false,
              timestampStr: '14:05',
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c2_1',
              textPt: 'Vamos apanhar um Uber para ser mais rápido. Devemos chegar em 25 minutos.',
              translationRu: 'Мы возьмем Uber, чтобы было быстрее. Должны приехать минут через 25.',
              isNaturalChoice: true,
              feedbackNoteRu: 'Превосходно: в Португалии такси и транспорт берут глаголом "apanhar" (в Бразилии — "pegar").',
              nextStepId: 'step_3',
            ),
            ChatUserChoiceEntity(
              id: 'c2_2',
              textPt: 'Vou pegar o metrô linha vermelha. Quanto custa o bilhete?',
              translationRu: 'Поеду на метро по красной линии. Сколько стоит билет?',
              isNaturalChoice: false,
              feedbackNoteRu: 'В Португалии ударение на первый слог — "o metro" (без циркумфлекса).',
              nextStepId: 'step_3',
            ),
          ],
        ),
        'step_3': ChatDialogStepEntity(
          stepId: 'step_3',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm3_1',
              senderId: 'contact',
              senderName: 'João Martins',
              textPt: 'Perfeito! Deixei a chave no cofre ao lado da porta. Vou enviar uma mensagem de voz com o código.',
              translationRu: 'Идеально! Я оставил ключ в сейфе рядом с дверью. Отправлю голосовое с кодом.',
              isUser: false,
              timestampStr: '14:08',
            ),
            ChatMessageEntity(
              id: 'm3_2',
              senderId: 'contact',
              senderName: 'João Martins',
              textPt: 'O código do cofre é 4-8-2-1. Gira a rodinha para baixo para abrir. Se precisares de alguma coisa, avisa, pff!',
              translationRu: 'Код сейфа 4-8-2-1. Поверни колесико вниз, чтобы открыть. Если что-то понадобится, дай знать, пожалуйста!',
              isUser: false,
              timestampStr: '14:09',
              isVoiceNote: true,
              voiceDurationSeconds: 8,
              abbreviations: [abbrPff],
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c3_1',
              textPt: 'Recebido! Muito obrigado pela ajuda, João. Qualquer coisa digo-te. Até já!',
              translationRu: 'Принято! Большое спасибо за помощь, Жоау. Если что, напишу тебе. До скорого!',
              isNaturalChoice: true,
              feedbackNoteRu: '"Até já" (до скорого) и "digo-te" — вежливый и дружелюбный тон в Лиссабоне.',
              nextStepId: 'step_finish',
              abbreviations: [abbrObg],
            ),
            ChatUserChoiceEntity(
              id: 'c3_2',
              textPt: 'Blz cara, valeu mesmo! Falou!',
              translationRu: 'Ок чувак, от души! Бывай!',
              isNaturalChoice: false,
              feedbackNoteRu: 'Слишком фамильярно для первого контакта с хозяином в Португалии ("cara" и "blz" в Португалии не используют).',
              nextStepId: 'step_finish',
              abbreviations: [abbrBlz, abbrFlw],
            ),
          ],
        ),
        'step_finish': ChatDialogStepEntity(
          stepId: 'step_finish',
          isFinal: true,
          incomingMessages: [
            ChatMessageEntity(
              id: 'm_fin',
              senderId: 'contact',
              senderName: 'João Martins',
              textPt: 'Boa estadia em Lisboa! Aproveitem a cidade! 🇵🇹✨',
              translationRu: 'Приятного пребывания в Лиссабоне! Наслаждайтесь городом!',
              isUser: false,
              timestampStr: '14:11',
            ),
          ],
          concludingNoteRu: 'Вы успешно договорились о заселении на чистом европейском португальском, разобрали код сейфа из голосового и правильно применили формы "apanhar" и "até já".',
        ),
      },
    ),

    // 2. Курьер iFood в Сан-Паулу
    ChatScenarioEntity(
      id: 'sp_ifood_delivery',
      titlePt: 'Entrega do iFood em SP',
      titleRu: 'Курьер iFood у кондоминиума',
      channelName: 'iFood Chat',
      contactName: 'Rodrigo Motoboy',
      avatarEmoji: '🛵',
      dialect: 'pt_BR',
      cefrLevel: 'A2',
      scenarioContextRu: 'Вы заказали ужин в iFood в Сан-Паулу. Курьер на мотоцикле подъехал к дому, но консьерж требует код подтверждения из приложения.',
      initialStepId: 'step_1',
      steps: {
        'step_1': ChatDialogStepEntity(
          stepId: 'step_1',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm1_sp',
              senderId: 'contact',
              senderName: 'Rodrigo Motoboy',
              textPt: 'Opa chefe, tô aqui na frente do prédio. Pode descer na portaria?',
              translationRu: 'Привет, шеф! Я тут у входа в дом. Можешь спуститься к консьержу?',
              isUser: false,
              timestampStr: '20:15',
              abbreviations: [abbrTo],
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c1_sp_1',
              textPt: 'Opa, Rodrigo! Tô descendo pelo elevador agora mesmo. 1 minutinho!',
              translationRu: 'Привет, Родриго! Спускаюсь на лифте прямо сейчас. Одну минутку!',
              isNaturalChoice: true,
              feedbackNoteRu: 'Идеальный дружелюбный ответ с типичным бразильским уменьшительным "minutinho" и "tô descendo".',
              nextStepId: 'step_2',
              abbreviations: [abbrTo],
            ),
            ChatUserChoiceEntity(
              id: 'c1_sp_2',
              textPt: 'Não posso descer. Suba até o meu apartamento, por favor.',
              translationRu: 'Я не могу спуститься. Поднимитесь ко мне в квартиру, пожалуйста.',
              isNaturalChoice: false,
              feedbackNoteRu: 'В Бразилии в кондоминиумах курьеры iFood почти никогда не поднимаются на этажи из соображений безопасности — жильцы спускаются к portaria.',
              nextStepId: 'step_2',
            ),
          ],
        ),
        'step_2': ChatDialogStepEntity(
          stepId: 'step_2',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm2_sp',
              senderId: 'contact',
              senderName: 'Rodrigo Motoboy',
              textPt: 'Blz! Passa o código de confirmação por aqui pra adiantar, por favor?',
              translationRu: 'Лады! Скинь код подтверждения сюда, чтобы ускорить, пожалуйста?',
              isUser: false,
              timestampStr: '20:16',
              abbreviations: [abbrBlz],
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c2_sp_1',
              textPt: 'O código são os 4 últimos dígitos do meu telefone: 8 9 2 0. Já cheguei na portaria!',
              translationRu: 'Код — 4 последние цифры моего номера: 8 9 2 0. Я уже у консьержа!',
              isNaturalChoice: true,
              feedbackNoteRu: 'В iFood код почти всегда совпадает с 4 последними цифрами телефона покупателя — знание реального контекста на высоте!',
              nextStepId: 'step_finish',
            ),
            ChatUserChoiceEntity(
              id: 'c2_sp_2',
              textPt: 'O código é 8920, mas só entrego depois que eu conferir o pedido.',
              translationRu: 'Код 8920, но назову только после того, как проверю заказ.',
              isNaturalChoice: false,
              feedbackNoteRu: 'Звучит излишне подозрительно и агрессивно для быстрой передачи еды.',
              nextStepId: 'step_finish',
            ),
          ],
        ),
        'step_finish': ChatDialogStepEntity(
          stepId: 'step_finish',
          isFinal: true,
          incomingMessages: [
            ChatMessageEntity(
              id: 'm3_sp',
              senderId: 'contact',
              senderName: 'Rodrigo Motoboy',
              textPt: 'Fechou irmão! Pedido entregue. Bom apetite e bom fds pra vc! Flw ✌️🛵',
              translationRu: 'Договорились, брат! Заказ отдал. Приятного аппетита и хороших выходных! Пока!',
              isUser: false,
              timestampStr: '20:18',
              abbreviations: [abbrFds, abbrVc, abbrFlw],
            ),
          ],
          concludingNoteRu: 'Вы с легкостью решили задачу доставки в бразильском мессенджере: поняли обращение "chefe", сокращения "tô", "blz", "fds" и правила кондоминиумов.',
        ),
      },
    ),

    // 3. Сбор на чурраско в Рио (групповой чат)
    ChatScenarioEntity(
      id: 'rio_churrasco_group',
      titlePt: 'Churrasco da Galera no Rio',
      titleRu: 'Сбор на чурраско в Рио (Групповой чат)',
      channelName: 'WhatsApp (Grupo)',
      contactName: 'Galera do Churrasco',
      avatarEmoji: '🥩',
      dialect: 'pt_BR',
      cefrLevel: 'B1',
      scenarioContextRu: 'Суббота в Рио-де-Жанейро! Друзья обсуждают покупку мяса (picanha) и напитков для вечеринки на террасе и скидываются через Pix.',
      initialStepId: 'step_1',
      steps: {
        'step_1': ChatDialogStepEntity(
          stepId: 'step_1',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm1_ch_1',
              senderId: 'contact',
              senderName: 'Matheus',
              textPt: 'Fala galera! O sol tá estalando na Zona Sul ☀️ Quem vem pro churrasco hoje?',
              translationRu: 'Привет народ! Солнце жарит в Зона Сул! Кто идет сегодня на чурраско?',
              isUser: false,
              timestampStr: '11:15',
            ),
            ChatMessageEntity(
              id: 'm1_ch_2',
              senderId: 'contact',
              senderName: 'Camila',
              textPt: 'Eu vou com ctz! Mas a gente precisa comprar picanha e carvão ainda, tá sem nada lá.',
              translationRu: 'Я точно иду! Но нам еще нужно купить пиканью и уголь, там ничего нет.',
              isUser: false,
              timestampStr: '11:16',
              abbreviations: [abbrCtz],
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c1_ch_1',
              textPt: 'Tô dentro! Posso passar no mercado e levar o carvão e a farofa.',
              translationRu: 'Я в деле! Могу заехать в магазин и взять уголь и фарофу.',
              isNaturalChoice: true,
              feedbackNoteRu: '"Tô dentro!" — популярнейшее бразильское выражение готовности пойти на тусовку ("я с вами / я в деле").',
              nextStepId: 'step_2',
              abbreviations: [abbrTo],
            ),
            ChatUserChoiceEntity(
              id: 'c1_ch_2',
              textPt: 'Eu confirmo a minha presença com toda certeza absoluta.',
              translationRu: 'Я подтверждаю свое присутствие с абсолютной уверенностью.',
              isNaturalChoice: false,
              feedbackNoteRu: 'Очень канцеляристски для дружеского чата. "Tô dentro" звучит куда теплее.',
              nextStepId: 'step_2',
            ),
          ],
        ),
        'step_2': ChatDialogStepEntity(
          stepId: 'step_2',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm2_ch_1',
              senderId: 'contact',
              senderName: 'Matheus',
              textPt: 'Boa! Fiz as contas aqui: deu 45 reais por cabeça. Mandem no Pix por favor!',
              translationRu: 'Красава! Я тут посчитал: вышло по 45 реалов с носа. Закиньте по Pix, пожалуйста!',
              isUser: false,
              timestampStr: '11:20',
            ),
            ChatMessageEntity(
              id: 'm2_ch_2',
              senderId: 'contact',
              senderName: 'Matheus',
              textPt: 'Chave Pix (celular): 21988776655. Avisem aqui quando mandarem, vlw!',
              translationRu: 'Ключ Pix (телефон): 21988776655. Маякните сюда, как скинете, спс!',
              isUser: false,
              timestampStr: '11:21',
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c2_ch_1',
              textPt: 'Pix feito Matheus! Te mandei o comprovante no privado. Que horas a gente cola aí?',
              translationRu: 'Пикс скинул, Матеус! Отправил квитанцию в личку. Во сколько подтягиваться?',
              isNaturalChoice: true,
              feedbackNoteRu: 'Жаргон "colar aí" (подтягиваться, заглянуть) и отправка чека в личку — эталон неформального бразильского общения.',
              nextStepId: 'step_finish',
            ),
            ChatUserChoiceEntity(
              id: 'c2_ch_2',
              textPt: 'Transferência efetuada com sucesso via sistema financeiro bancário.',
              translationRu: 'Перевод успешно совершен через банковскую систему.',
              isNaturalChoice: false,
              feedbackNoteRu: 'Звучит как автоматическое уведомление банка, друзья будут шутить весь вечер!',
              nextStepId: 'step_finish',
            ),
          ],
        ),
        'step_finish': ChatDialogStepEntity(
          stepId: 'step_finish',
          isFinal: true,
          incomingMessages: [
            ChatMessageEntity(
              id: 'm3_ch_fin',
              senderId: 'contact',
              senderName: 'Camila',
              textPt: 'A partir das 14h já tem pagode rolando! Tragam protetor solar pq o calor tá bravo kkkk Até daqui a pouco! 🍻🥩',
              translationRu: 'С 14:00 уже играет пагоде! Берите крем от солнца, жара лютая ахаха До скорого!',
              isUser: false,
              timestampStr: '11:25',
              abbreviations: [abbrPq],
            ),
          ],
          concludingNoteRu: 'Вы блестяще влились в бразильскую компанию: освоили сленг "tô dentro", культуру расчетов по Pix, сокращения "vlw", "ctz" и дружеские подколки.',
        ),
      },
    ),

    // 4. Slack в Порту (рабочий чат)
    ChatScenarioEntity(
      id: 'porto_slack_work',
      titlePt: 'Alinhamento de Trabalho no Porto',
      titleRu: 'Срочный вопрос в Slack в Порту',
      channelName: 'Slack',
      contactName: 'Duarte Ferreira (Colega)',
      avatarEmoji: '💼',
      dialect: 'pt_PT',
      cefrLevel: 'B1',
      scenarioContextRu: 'Пятница, 16:30. Коллега Дуарте из офиса в Порту пишет вам в Slack по поводу финального отчета для клиента и зовет на кофе после работы.',
      initialStepId: 'step_1',
      steps: {
        'step_1': ChatDialogStepEntity(
          stepId: 'step_1',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm1_po',
              senderId: 'contact',
              senderName: 'Duarte Ferreira',
              textPt: 'Viva! Tens um minuto pff? Como estamos com o relatório da reunião com a equipa de Madrid?',
              translationRu: 'Привет! Есть минутка, пожалуйста? Как у нас с отчетом со встречи с мадридской командой?',
              isUser: false,
              timestampStr: '16:32',
              abbreviations: [abbrPff],
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c1_po_1',
              textPt: 'Olá Duarte! Estou mesmo a finalizar o documento. Envio-te por email em 10 minutos.',
              translationRu: 'Привет, Дуарте! Я как раз заканчиваю документ. Скину тебе на почту минут через 10.',
              isNaturalChoice: true,
              feedbackNoteRu: '"Estou a finalizar" — идеальный португальский инфинитивный континуус для рабочего контекста.',
              nextStepId: 'step_2',
            ),
            ChatUserChoiceEntity(
              id: 'c1_po_2',
              textPt: 'Oi cara! Tô terminando aqui, relaxa que já mando no zap.',
              translationRu: 'Привет чувак! Я заканчиваю, расслабься, щас скину в вотсап.',
              isNaturalChoice: false,
              feedbackNoteRu: 'Слишком фамильярно для европейского португальского офиса ("cara", "zap").',
              nextStepId: 'step_2',
            ),
          ],
        ),
        'step_2': ChatDialogStepEntity(
          stepId: 'step_2',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm2_po',
              senderId: 'contact',
              senderName: 'Duarte Ferreira',
              textPt: 'Espetáculo, muito obrigado! Depois de enviares, apetece-te ir beber um cimbalino ali ao café da esquina?',
              translationRu: 'Потрясающе, большое спасибо! Как отправишь, не хочешь пойти выпить эспрессо в кафе за углом?',
              isUser: false,
              timestampStr: '16:35',
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c2_po_1',
              textPt: 'Parece-me muito bem! Um cimbalino a esta hora cai mesmo bem. Encontro-te na receção às 17h.',
              translationRu: 'Отличная идея! Чашечка эспрессо в этот час будет очень кстати. Встретимся на ресепшене в 17:00.',
              isNaturalChoice: true,
              feedbackNoteRu: 'Точный культурный код: в Порту эспрессо называют именно "cimbalino" (в Лиссабоне — "bica"). Выражение "cai mesmo bem" звучит очень по-европейски.',
              nextStepId: 'step_finish',
            ),
            ChatUserChoiceEntity(
              id: 'c2_po_2',
              textPt: 'O que é cimbalino? Eu só tomo cafezinho com açúcar.',
              translationRu: 'Что такое симбалино? Я пью только кофеёк с сахаром.',
              isNaturalChoice: false,
              feedbackNoteRu: '"Cafezinho" — бразильская реальность, а в Порту эспрессо из машины Cimbali гордо зовут "cimbalino".',
              nextStepId: 'step_finish',
            ),
          ],
        ),
        'step_finish': ChatDialogStepEntity(
          stepId: 'step_finish',
          isFinal: true,
          incomingMessages: [
            ChatMessageEntity(
              id: 'm3_po_fin',
              senderId: 'contact',
              senderName: 'Duarte Ferreira',
              textPt: 'Combinado! Fico à tua espera na receção. Bom trabalho e até já! ☕️🇵🇹',
              translationRu: 'Договорились! Жду тебя на ресепшене. Хорошей работы и до скорого!',
              isUser: false,
              timestampStr: '16:38',
            ),
          ],
          concludingNoteRu: 'Вы проявили безупречный деловой этикет Португалии: использовали "Viva!", конструкцию "estar a + inf", ответили на предложение выпить "cimbalino" и договорились о встрече.',
        ),
      },
    ),

    // 5. Uber в ливень в Копакабане
    ChatScenarioEntity(
      id: 'uber_copacabana_rain',
      titlePt: 'Uber no Temporal em Copacabana',
      titleRu: 'Поездка на Uber под тропическим ливнем',
      channelName: 'Uber Chat',
      contactName: 'Seu Marcos (Motorista)',
      avatarEmoji: '🚗',
      dialect: 'pt_BR',
      cefrLevel: 'A2',
      scenarioContextRu: 'В Рио хлынул знаменитый тропический ливень. Улица залита водой, вы прячетесь под козырьком отеля, а водитель Uber остановился напротив.',
      initialStepId: 'step_1',
      steps: {
        'step_1': ChatDialogStepEntity(
          stepId: 'step_1',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm1_ub',
              senderId: 'contact',
              senderName: 'Seu Marcos',
              textPt: 'Amigo, tô parado no sinal em frente ao quiosque. Não consigo encostar aí por causa do alagamento.',
              translationRu: 'Дружище, я стою на светофоре напротив киоска. Не могу прижаться к обочине из-за лужи.',
              isUser: false,
              timestampStr: '18:40',
              abbreviations: [abbrTo],
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c1_ub_1',
              textPt: 'Oi, Seu Marcos! Tô te vendo daqui. Tô de capa amarela debaixo do toldo, já vou atravessar!',
              translationRu: 'Здравствуйте, сеньор Маркос! Я вас вижу отсюда. Я в желтом дождевике под навесом, сейчас перейду!',
              isNaturalChoice: true,
              feedbackNoteRu: 'Уважительное обращение "Seu Marcos" к пожилому водителю и четкие визуальные ориентиры — именно так общаются в Рио.',
              nextStepId: 'step_2',
              abbreviations: [abbrTo],
            ),
            ChatUserChoiceEntity(
              id: 'c1_ub_2',
              textPt: 'Você precisa vir até aqui na porta, eu não vou me molhar.',
              translationRu: 'Вы должны подъехать к самой двери, я не буду мокнуть.',
              isNaturalChoice: false,
              feedbackNoteRu: 'Во время ливня в Рио улицы быстро затапливает, грубый тон может привести к отмене поездки водителем.',
              nextStepId: 'step_2',
            ),
          ],
        ),
        'step_2': ChatDialogStepEntity(
          stepId: 'step_2',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm2_ub',
              senderId: 'contact',
              senderName: 'Seu Marcos',
              textPt: 'Cuidado ao pisar no meio-fio! Liguei o pisca-alerta do Corolla prata pra vc me achar.',
              translationRu: 'Осторожнее ступайте на бордюр! Я включил аварийку на серебристой Королле, чтобы вы меня увидели.',
              isUser: false,
              timestampStr: '18:42',
              abbreviations: [abbrVc],
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c2_ub_1',
              textPt: 'Vi o pisca-alerta! Chegando no carro agora, muito obrigado pela paciência!',
              translationRu: 'Увидел аварийку! Подхожу к машине, большое спасибо за терпение!',
              isNaturalChoice: true,
              feedbackNoteRu: 'Теплый тон, слова благодарности водителям в непогоду в Бразилии всегда вознаграждаются отличной поездкой.',
              nextStepId: 'step_finish',
            ),
            ChatUserChoiceEntity(
              id: 'c2_ub_2',
              textPt: 'Entrei no carro.',
              translationRu: 'Я сел в машину.',
              isNaturalChoice: false,
              feedbackNoteRu: 'Слишком сухо и лаконично.',
              nextStepId: 'step_finish',
            ),
          ],
        ),
        'step_finish': ChatDialogStepEntity(
          stepId: 'step_finish',
          isFinal: true,
          incomingMessages: [
            ChatMessageEntity(
              id: 'm3_ub_fin',
              senderId: 'contact',
              senderName: 'Seu Marcos',
              textPt: 'Boa noite! Pode entrar, o ar-condicionado tá ligado. Partiu! 🚗🌧️',
              translationRu: 'Добрый вечер! Садитесь, кондиционер включен. Поехали!',
              isUser: false,
              timestampStr: '18:44',
            ),
          ],
          concludingNoteRu: 'Вы успешно сориентировались в реальной городской ситуации Рио: применили уважительное "Seu", поняли слова "alagamento", "meio-fio", "pisca-alerta" и "partiu".',
        ),
      },
    ),

    // 6. Аптека в Кашкайше
    ChatScenarioEntity(
      id: 'cascais_pharmacy',
      titlePt: 'WhatsApp da Farmácia em Cascais',
      titleRu: 'Заказ лекарств в аптеке в Кашкайше',
      channelName: 'WhatsApp Farmácia',
      contactName: 'Farmácia Central de Cascais',
      avatarEmoji: '💊',
      dialect: 'pt_PT',
      cefrLevel: 'B1',
      scenarioContextRu: 'После серфинга на ветреном пляже Гиншу у вас разболелось горло. Вы пишете в WhatsApp дежурной аптеки в Кашкайше, чтобы заказать пастилки и спрей.',
      initialStepId: 'step_1',
      steps: {
        'step_1': ChatDialogStepEntity(
          stepId: 'step_1',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm1_fa',
              senderId: 'contact',
              senderName: 'Farmácia Central',
              textPt: 'Boa tarde! Bem-vindo à Farmácia Central de Cascais. Em que podemos ajudar hoje?',
              translationRu: 'Добрый день! Добро пожаловать в Центральную аптеку Кашкайша. Чем мы можем помочь сегодня?',
              isUser: false,
              timestampStr: '12:00',
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c1_fa_1',
              textPt: 'Boa tarde! Estou com muitas dores de garganta e alguma tosse. Têm pastilhas ou spray sem receita médica?',
              translationRu: 'Добрый день! У меня сильно болит горло и небольшой кашель. У вас есть пастилки или спрей без рецепта?',
              isNaturalChoice: true,
              feedbackNoteRu: 'Очень точная медицинская лексика PT-PT: "dores de garganta" (во множественном числе), "tosse", "pastilhas", "sem receita médica".',
              nextStepId: 'step_2',
            ),
            ChatUserChoiceEntity(
              id: 'c1_fa_2',
              textPt: 'Oi, minha garganta tá doendo pra caramba. Me dá um remédio forte aí.',
              translationRu: 'Привет, у меня жесть как болит горло. Дайте какое-нибудь сильное лекарство.',
              isNaturalChoice: false,
              feedbackNoteRu: 'Слишком грубо и разговорно для аптеки, тем более в европейской Португалии.',
              nextStepId: 'step_2',
            ),
          ],
        ),
        'step_2': ChatDialogStepEntity(
          stepId: 'step_2',
          incomingMessages: [
            ChatMessageEntity(
              id: 'm2_fa',
              senderId: 'contact',
              senderName: 'Farmácia Central',
              textPt: 'Sim, com certeza. Recomendamos as pastilhas Strepsils de mel e limão e um spray anti-inflamatório. Quer que façamos a entrega ao domicílio?',
              translationRu: 'Да, конечно. Рекомендуем пастилки Стрепсилс с медом и лимоном и противовоспалительный спрей. Хотите, чтобы мы оформили доставку на дом?',
              isUser: false,
              timestampStr: '12:03',
            ),
          ],
          choices: [
            ChatUserChoiceEntity(
              id: 'c2_fa_1',
              textPt: 'Sim, pff! A morada é Rua dos Pescadores 14, 2º Direito. Pode ser pago por Multibanco ou MBWay na entrega?',
              translationRu: 'Да, пожалуйста! Адрес — Rua dos Pescadores 14, 2-й этаж направо. Можно оплатить картой (Multibanco) или MBWay при доставке?',
              isNaturalChoice: true,
              feedbackNoteRu: 'Великолепное знание португальских реалий: "morada" (адрес), обозначение квартир "2º Direito" и популярнейшие платежные системы Multibanco и MBWay.',
              nextStepId: 'step_finish',
              abbreviations: [abbrPff],
            ),
            ChatUserChoiceEntity(
              id: 'c2_fa_2',
              textPt: 'Sim, meu endereço é Rua dos Pescadores. Vou pagar no Pix.',
              translationRu: 'Да, мой адрес Rua dos Pescadores. Заплачу по Pix.',
              isNaturalChoice: false,
              feedbackNoteRu: 'В Португалии адрес называют "morada", а платежной системы Pix там нет — в Португалии используют MBWay и Multibanco!',
              nextStepId: 'step_finish',
            ),
          ],
        ),
        'step_finish': ChatDialogStepEntity(
          stepId: 'step_finish',
          isFinal: true,
          incomingMessages: [
            ChatMessageEntity(
              id: 'm3_fa_fin',
              senderId: 'contact',
              senderName: 'Farmácia Central',
              textPt: 'Perfeito! O estafeta leva o terminal de Multibanco e chega em cerca de 30 minutos. As melhoras rápidas! 🌿💊',
              translationRu: 'Идеально! Курьер возьмет терминал Multibanco и будет примерно через 30 минут. Скорейшего выздоровления!',
              isUser: false,
              timestampStr: '12:06',
            ),
          ],
          concludingNoteRu: 'Вы идеально справились с реальным бытовым вопросом в Португалии: назвали симптомы, использовали формулу адреса и знали местные способы оплаты (MBWay/Multibanco).',
        ),
      },
    ),
  ];
}
