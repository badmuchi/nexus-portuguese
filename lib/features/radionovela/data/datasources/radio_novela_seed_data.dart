import '../../domain/entities/radio_novela_entities.dart';

class RadioNovelaSeedData {
  static const List<AudioDramaEntity> dramas = [
    AudioDramaEntity(
      id: 'misterio_alfama',
      titlePt: 'O Mistério da Alfama',
      titleRu: 'Тайна Алфамы',
      genre: 'Mistério / Noir',
      setting: 'Beco dos Curtumes, Alfama, Lisboa',
      dialect: 'pt_PT',
      coverEmoji: '🕵️‍♂️',
      ambientSoundName: 'rain_tram_lisbon',
      ambientSoundRu: 'Шум ночного дождя на португальской брусчатке, звон трамвая №28 и тихие переборы фаду',
      synopsisRu:
          'Ноябрьская дождливая ночь в лабиринте старого Лиссабона. Инспектор Дуарте находит след пропавшего старинного медальона в маленькой таверне на крутом склоне Алфамы.',
      cefrLevel: 'B2',
      characters: [
        DramaCharacterEntity(
          id: 'duarte',
          namePt: 'Inspetor Duarte',
          roleRu: 'Опытный следователь лиссабонской полиции',
          voiceEmoji: '🕵️‍♂️',
          accentNoteRu: 'Глубокий хрипловатый голос с четким лиссабонским акцентом',
        ),
        DramaCharacterEntity(
          id: 'amalia',
          namePt: 'Dona Amália',
          roleRu: 'Хозяйка таверны и певица фаду',
          voiceEmoji: '👵',
          accentNoteRu: 'Эмоциональный, теплый и чуть ироничный португальский тембр',
        ),
      ],
      scenes: [
        DramaSceneEntity(
          id: 'alf_scene_1',
          sceneNumber: 1,
          sceneTitlePt: 'A Porta Entreaberta',
          sceneTitleRu: 'Приоткрытая дверь',
          atmosphericNoteRu:
          'Ветер задувает свечу на столике. Слышны редкие капли дождя, срывающиеся с черепичной крыши.',
          lines: [
            DramaLineEntity(
              id: 'l_alf_1',
              characterId: 'duarte',
              characterName: 'Inspetor Duarte',
              textPt:
                  'Boa noite, Dona Amália. Peço desculpa pela hora tardia, mas a chuva lá fora não dá tréguas e o assunto não pode esperar por amanhã.',
              translationRu:
                  'Добрый вечер, дона Амалия. Прошу прощения за поздний час, но дождь на улице не утихает, а дело не терпит до утра.',
              stageDirectionRu: 'Отрехает капли с плаща, тяжело садится на деревянный стул',
              slangOrIdiomNoteRu: '«Não dar tréguas» — не давать передышки, не утихать.',
              audioSnippetText:
                  'Boa noite, Dona Amália. Peço desculpa pela hora tardia, mas o assunto não pode esperar.',
            ),
            DramaLineEntity(
              id: 'l_alf_2',
              characterId: 'amalia',
              characterName: 'Dona Amália',
              textPt:
                  'Ora viva, senhor Inspetor. Quem anda à chuva molha-se, não é verdade? Venha daí, sente-se perto da lareira. Quer um copo de vinho tinto para aquecer a alma?',
              translationRu:
                  'Здравствуйте, господин инспектор. Кто гуляет под дождем — тот промокает, верно? Проходите, садитесь поближе к очагу. Хотите бокал красного вина, чтобы согреть душу?',
              stageDirectionRu: 'Наливает густое темное вино в глиняный стакан с легкой усмешкой',
              slangOrIdiomNoteRu: '«Quem anda à chuva molha-se» — пословица: за всё приходится платить / взялся за дело — будь готов к трудностям.',
              audioSnippetText:
                  'Ora viva, senhor Inspetor. Venha daí, sente-se perto da lareira.',
            ),
            DramaLineEntity(
              id: 'l_alf_3',
              characterId: 'duarte',
              characterName: 'Inspetor Duarte',
              textPt:
                  'Agradeço o vinho, mas vim por outra razão. Disseram-me que o rapaz de camisola azul esteve aqui antes de a eletricidade falhar no bairro.',
              translationRu:
                  'Спасибо за вино, но я пришел по другой причине. Мне сказали, что парень в синем свитере был здесь до того, как в районе погас свет.',
              stageDirectionRu: 'Пристально смотрит в глаза хозяйке, понижая голос',
              slangOrIdiomNoteRu: '«Camisola» в Португалии — свитер/кофта, в отличие от Бразилии (где это ночная сорочка).',
              audioSnippetText:
                  'Disseram-me que o rapaz de camisola azul esteve aqui antes de a eletricidade falhar.',
            ),
            DramaLineEntity(
              id: 'l_alf_4',
              characterId: 'amalia',
              characterName: 'Dona Amália',
              textPt:
                  'Esteve cá, sim, senhor... Deixou uma carta lacrada e disse que, se alguém com ar sério viesse à procura dele, eu não desse com a língua nos dentes. Mas conheço-o há muitos anos, senhor Duarte.',
              translationRu:
                  'Был здесь, да, господин... Оставил запечатанное письмо и сказал, что если кто-то с серьезным видом станет искать его, чтобы я держала язык за зубами. Но я же знаю вас много лет, господин Дуарте.',
              stageDirectionRu: 'Оглядывается на темное окно и достает из фартука старинный конверт',
              slangOrIdiomNoteRu: '«Dar com a língua nos dentes» — проболтаться, разболтать тайну.',
              audioSnippetText:
                  'Deixou uma carta lacrada e disse para eu não dar com a língua nos dentes.',
            ),
          ],
          interactiveChoice: DramaInteractiveChoice(
            id: 'choice_alfama',
            promptRu: 'Как инспектор должен поступить с письмом?',
            optionPt: 'Abrir a carta imediatamente à luz da vela',
            optionRu: 'Вскрыть письмо немедленно при свете свечи',
            consequencePt:
                'Duarte rompe o lacre de cera: dentro há uma chave dourada e uma morada no Bairro Alto!',
            consequenceRu:
                'Дуарте ломает сургучную печать: внутри оказывается золотой ключ и адрес в Байрру-Алту!',
          ),
        ),
      ],
    ),
    AudioDramaEntity(
      id: 'amor_sertao',
      titlePt: 'Amor e Vento no Sertão',
      titleRu: 'Любовь и ветер в сертане',
      genre: 'Romance Dramático',
      setting: 'Sertão do São Francisco, Bahia',
      dialect: 'pt_BR',
      coverEmoji: '🌵',
      ambientSoundName: 'wind_crickets_sertao',
      ambientSoundRu: 'Шелест раскаленного ветра в кактусах мандокару, стрекот вечерних цикад и далекий лай собак',
      synopsisRu:
          'Закат в самом сердце баиянского сертана. Странствующий музыкант Зе ду Карму возвращается в родное селение перед праздником Сан-Жуан, чтобы встретить ту, о которой тосковал долгие годы.',
      cefrLevel: 'B1',
      characters: [
        DramaCharacterEntity(
          id: 'ze',
          namePt: 'Zé do Carmo',
          roleRu: 'Странствующий поэт и гитарист сертана',
          voiceEmoji: '🤠',
          accentNoteRu: 'Мягкий певучий северо-восточный акцент с открытыми гласными',
        ),
        DramaCharacterEntity(
          id: 'maria',
          namePt: 'Maria Flor',
          roleRu: 'Гордая девушка с ранчо',
          voiceEmoji: '🌸',
          accentNoteRu: 'Звонкий, темпераментный и искренний голос сертанежи',
        ),
      ],
      scenes: [
        DramaSceneEntity(
          id: 'sertao_scene_1',
          sceneNumber: 1,
          sceneTitlePt: 'O Encontro na Porteira',
          sceneTitleRu: 'Встреча у калитки',
          atmosphericNoteRu:
          'Заходящее красное солнце окрашивает пыльную дорогу. Слышны тихие переборы аккордеона из соседней деревни.',
          lines: [
            DramaLineEntity(
              id: 'l_ser_1',
              characterId: 'ze',
              characterName: 'Zé do Carmo',
              textPt:
                  'Ô Maria! O sol já tá descendo por trás da serra e eu atravessei três léguas de poeira só pra te ver debruçada nessa cancela.',
              translationRu:
                  'О, Мария! Солнце уже садится за гору, а я отмерил три лиги пыльной дороги только ради того, чтобы увидеть тебя у этой калитки.',
              stageDirectionRu: 'Снимает кожаную шляпу-вакейру, вытирая пот со лба',
              slangOrIdiomNoteRu: '«Tá descendo» — разговорное сокращение от está descendo. «Cancela» — деревянная ограда ранчо.',
              audioSnippetText:
                  'Ô Maria! O sol já tá descendo e eu atravessei três léguas de poeira só pra te ver.',
            ),
            DramaLineEntity(
              id: 'l_ser_2',
              characterId: 'maria',
              characterName: 'Maria Flor',
              textPt:
                  'Oxente, Zé! E você acha que pode sumir por dois anos no mundo e voltar feito assombração com esse violão nas costas? Meu coração não é hotel de beira de estrada não, viu?',
              translationRu:
                  'Ой да ладно, Зе! Ты думаешь, можно пропасть на два года невесть где и вернуться как привидение с этой гитарой за спиной? Моё сердце — не придорожная гостиница, понял?',
              stageDirectionRu: 'Скрещивает руки на груди, пытаясь скрыть радостную улыбку',
              slangOrIdiomNoteRu: '«Oxente!» — самое знаменитое баиянское и северо-восточное междометие удивления или возмущения.',
              audioSnippetText:
                  'Oxente, Zé! E você acha que pode sumir por dois anos no mundo e voltar feito assombração?',
            ),
            DramaLineEntity(
              id: 'l_ser_3',
              characterId: 'ze',
              characterName: 'Zé do Carmo',
              textPt:
                  'Sei que errei feio, Maria. Mas não houve um amanhecer que eu não lembrasse do seu cheiro de flor de laranjeira. Eu vim pra ficar, se você me der abrigo.',
              translationRu:
                  'Знаю, что сильно виноват, Мария. Но не было ни единого рассвета, когда бы я не вспоминал твой запах цветов померанца. Я вернулся насовсем, если ты пустишь меня.',
              stageDirectionRu: 'Подходит ближе к калитке, голос звучит нежно и серьезно',
              slangOrIdiomNoteRu: '«Errar feio» — сильно ошибиться, сплоховать.',
              audioSnippetText:
                  'Sei que errei feio, Maria. Mas não houve um amanhecer que eu não lembrasse de você.',
            ),
          ],
          interactiveChoice: DramaInteractiveChoice(
            id: 'choice_sertao',
            promptRu: 'Что ответит Мария Флор?',
            optionPt: 'Abrir a cancela e oferecer um café coado bem quentinho',
            optionRu: 'Открыть калитку и предложить чашку свежесваренного кофе',
            consequencePt:
                'Maria sorri emocionada, abre a cancela e diz: "Entra logo, Zé, que o café tá fresco!"',
            consequenceRu:
                'Мария растроганно улыбается, распахивает калитку и говорит: "Заходи скорей, Зе, кофе как раз свежий!"',
          ),
        ),
      ],
    ),
    AudioDramaEntity(
      id: 'farol_guia',
      titlePt: 'O Farol da Guia na Noite de Tempestade',
      titleRu: 'Маяк Гия в штормовую ночь',
      genre: 'Suspense Marítimo',
      setting: 'Farol da Guia, falésias de Cascais',
      dialect: 'pt_PT',
      coverEmoji: '🌊',
      ambientSoundName: 'storm_lighthouse_ocean',
      ambientSoundRu: 'Грохот океанского прибоя о скалы, свист штормового ветра и мерный гул маячной лампы',
      synopsisRu:
          'Мыс у Кашкайша. Свирепый атлантический шторм бьет о скалы. Старый смотритель маяка замечает на утесе выбившегося из сил человека, сжимающего водонепроницаемый футляр.',
      cefrLevel: 'B2',
      characters: [
        DramaCharacterEntity(
          id: 'tiago',
          namePt: 'Mestre Tiago',
          roleRu: 'Смотритель маяка с сорокалетним стажем',
          voiceEmoji: '⚓',
          accentNoteRu: 'Низкий, закаленный ветрами голос старого португальского моряка',
        ),
        DramaCharacterEntity(
          id: 'naufrago',
          namePt: 'O Náufrago',
          roleRu: 'Спасенный таинственный пассажир',
          voiceEmoji: '🌧️',
          accentNoteRu: 'Задыхающийся, встревоженный шёпот',
        ),
      ],
      scenes: [
        DramaSceneEntity(
          id: 'farol_scene_1',
          sceneNumber: 1,
          sceneTitlePt: 'O Sinal no Mar Alto',
          sceneTitleRu: 'Сигнал в открытом море',
          atmosphericNoteRu:
          'Мощный удар волны сотрясает толстые гранитные стены маяка. Механизм вращения лампы мерно поскрипывает.',
          lines: [
            DramaLineEntity(
              id: 'l_far_1',
              characterId: 'tiago',
              characterName: 'Mestre Tiago',
              textPt:
                  'Valha-nos Deus, que mar bravio! Há trinta anos que não vejo vagas tão altas a varrer estas rochas. Ei, rapaz! Segura-te à corda, não olhes para baixo!',
              translationRu:
                  'Помилуй нас Бог, что за свирепое море! Тридцать лет не видал таких громадных волн, сметающих эти утесы. Эй, парень! Держись за канат, не смотри вниз!',
              stageDirectionRu: 'Кричит сквозь рев бури, бросая спасательный трос',
              slangOrIdiomNoteRu: '«Mar bravio» — бурное, штормовое море. «Valha-nos Deus» — Господи помилуй.',
              audioSnippetText:
                  'Valha-nos Deus, que mar bravio! Segura-te à corda, não olhes para baixo!',
            ),
            DramaLineEntity(
              id: 'l_far_2',
              characterId: 'naufrago',
              characterName: 'O Náufrago',
              textPt:
                  'O barco... o pesqueiro partiu-se em dois junto à Boca do Inferno... Salvei apenas isto... Não deixe ninguém tocar nesta caixa, por favor!',
              translationRu:
                  'Лодка... траулер раскололся надвое у Пасти Дьявола... Я спас только это... Умоляю, не давайте никому притрагиваться к этому ящику!',
              stageDirectionRu: 'Падает на каменный пол башни, судорожно сжимая металлическую шкатулку',
              slangOrIdiomNoteRu: '«Boca do Inferno» — знаменитая скалистая расщелина близ Кашкайша.',
              audioSnippetText:
                  'O barco partiu-se em dois... Não deixe ninguém tocar nesta caixa, por favor!',
            ),
          ],
          interactiveChoice: DramaInteractiveChoice(
            id: 'choice_farol',
            promptRu: 'Что предпримет смотритель маяка?',
            optionPt: 'Ligar o rádio de emergência para a Guarda Costeira',
            optionRu: 'Включить аварийную рацию и связаться с береговой охраной',
            consequencePt:
                'Mestre Tiago liga a rádio: a Capitania de Cascais já enviava botes de socorro!',
            consequenceRu:
                'Мастер Тиагу выходит на связь: спасательные катера Кашкайша уже вышли в море!',
          ),
        ),
      ],
    ),
    AudioDramaEntity(
      id: 'golpe_paulista',
      titlePt: 'O Golpe da Avenida Paulista',
      titleRu: 'Афера на Авенида Паулиста',
      genre: 'Thriller Corporativo',
      setting: 'Edifício Espelho, 32º andar, São Paulo',
      dialect: 'pt_BR',
      coverEmoji: '💼',
      ambientSoundName: 'city_traffic_rain_sp',
      ambientSoundRu: 'Гул трафика ночной Паулисты, шум кондиционера в офисе и стук клавиш ноутбука',
      synopsisRu:
          'Финансовый центр Сан-Паулу. Полночь в стеклянной башне небоскреба. Аудитор Лаура обнаруживает скрытую транзакцию на 50 миллионов реалов прямо перед выходом компании на биржу.',
      cefrLevel: 'B2',
      characters: [
        DramaCharacterEntity(
          id: 'laura',
          namePt: 'Laura Fonseca',
          roleRu: 'Главный аудитор инвестиционного фонда',
          voiceEmoji: '👩‍💼',
          accentNoteRu: 'Уверенный, четкий ритм речи жительницы мегаполиса Сан-Паулу',
        ),
        DramaCharacterEntity(
          id: 'roberto',
          namePt: 'Roberto Prado',
          roleRu: 'Харизматичный CEO финтех-стартапа',
          voiceEmoji: '👨‍💼',
          accentNoteRu: 'Быстрый, убедительный тон с бизнес-жаргоном',
        ),
      ],
      scenes: [
        DramaSceneEntity(
          id: 'paulista_scene_1',
          sceneNumber: 1,
          sceneTitlePt: 'O Balanço Falso',
          sceneTitleRu: 'Фальшивый баланс',
          atmosphericNoteRu:
          'За стеклянной стеной офиса расстилается бескрайнее море огней Сан-Паулу.',
          lines: [
            DramaLineEntity(
              id: 'l_pau_1',
              characterId: 'laura',
              characterName: 'Laura Fonseca',
              textPt:
                  'Roberto, você achou mesmo que essa conta em paraíso fiscal ia passar batido pela auditoria? Amanhã o sino toca na B3 e isso aqui é fraude explícita.',
              translationRu:
                  'Роберто, ты правда думал, что этот офшорный счет проскочит мимо аудита незамеченным? Завтра звенит колокол на бирже B3, а здесь у нас — очевидное мошенничество.',
              stageDirectionRu: 'Поворачивает экран ноутбука лицом к собеседнику',
              slangOrIdiomNoteRu: '«Passar batido» — проскользнуть незамеченным, остаться без внимания. «B3» — фондовая биржа Бразилии в Сан-Паулу.',
              audioSnippetText:
                  'Roberto, você achou mesmo que essa conta ia passar batido pela auditoria?',
            ),
            DramaLineEntity(
              id: 'l_pau_2',
              characterId: 'roberto',
              characterName: 'Roberto Prado',
              textPt:
                  'Calma, Laura, não viaja na maionese! Isso é apenas uma ponte cambial temporária. Se você travar essa operação agora, quinhentas pessoas perdem o emprego na segunda-feira.',
              translationRu:
                  'Спокойно, Лаура, не фантазируй понапрасну! Это всего лишь временный валютный мост. Если ты заблокируешь сделку сейчас, пятьсот человек в понедельник потеряют работу.',
              stageDirectionRu: 'Нервно поправляет галстук, подходя ближе к столу',
              slangOrIdiomNoteRu: '«Viajar na maionese» — пороть чушь, заблуждаться, витать в облаках.',
              audioSnippetText:
                  'Calma, Laura, não viaja na maionese! Isso é apenas uma ponte cambial temporária.',
            ),
          ],
          interactiveChoice: DramaInteractiveChoice(
            id: 'choice_paulista',
            promptRu: 'Какое решение примет Лаура?',
            optionPt: 'Reportar imediatamente a fraude ao comitê de ética',
            optionRu: 'Немедленно сообщить о мошенничестве в комитет по этике',
            consequencePt:
                'Laura clica em "Enviar": a integridade falou mais alto e a verdade prevaleceu!',
            consequenceRu:
                'Лаура нажимает "Отправить": честность оказалась превыше всего, и правда восторжествовала!',
          ),
        ),
      ],
    ),
  ];
}
