import '../../domain/entities/business_phrase_entity.dart';
import '../../domain/entities/cv_guide_item_entity.dart';
import '../../domain/entities/interview_question_entity.dart';
import '../../domain/entities/interview_scenario_entity.dart';

class CareerSeedData {
  // 1. Сценарии собеседований
  static const List<InterviewScenarioEntity> scenarios = [
    // IT в Лиссабоне
    InterviewScenarioEntity(
      id: 'sc_it_lisboa',
      jobTitlePt: 'Engenheiro de Software Sénior',
      jobTitleRu: 'Старший инженер-программист',
      companyName: 'Fintech Internacional (Lisboa)',
      category: CareerCategory.tech,
      dialect: 'pt_PT',
      cefrLevel: 'B2',
      workModel: 'Híbrido (2x escritório)',
      salaryContextRu: '14 выплат (ordenado base + subsídio de férias e Natal) + Cartão Refeição de €9.60/dia + Seguro de Saúde Médis + Bónus anual.',
      iconEmoji: '💻',
      questions: [
        InterviewQuestionEntity(
          id: 'q_it_1',
          interviewerRole: 'Tech Lead & Hiring Manager',
          questionPt: 'Pode falar-nos um pouco sobre o seu percurso profissional e destacar o desafio técnico mais complexo que liderou?',
          questionRu: 'Можете рассказать о вашем профессиональном пути и выделить самую сложную техническую задачу, которую вы вели?',
          hrInsightRu: 'Оценивается структурированность самопрезентации (STAR: Situation, Task, Action, Result) и способность говорить на языке бизнес-метрик, а не просто абстрактного кода.',
          options: [
            InterviewAnswerOption(
              textPt: 'Com certeza. Ao longo dos últimos 5 anos, especializei-me em arquiteturas distribuídas e microsserviços. No meu último cargo, liderei a migração do módulo de pagamentos, o que reduziu a latência em 40% e garantiu 99.98% de disponibilidade durante a Black Friday.',
              translationRu: 'Конечно. За последние 5 лет я специализировался на распределенных архитектурах и микросервисах. На прошлой позиции я возглавил миграцию платежного модуля, что снизило задержку на 40% и обеспечило 99.98% аптайма в Черную пятницу.',
              isStrong: true,
              hrFeedbackRu: 'Эталонный ответ! Четкая специализация, лидерская роль, метрики производительности (latência -40%) и бизнес-результат.',
              points: 10,
            ),
            InterviewAnswerOption(
              textPt: 'Eu já passei por várias empresas e sei programar em várias linguagens. Se me derem uma tarefa difícil, eu pesquiso na internet e resolvo.',
              translationRu: 'Я работал во многих компаниях и знаю много языков. Если дадите сложную задачу, поищу в интернете и решу.',
              isStrong: false,
              hrFeedbackRu: 'Слишком поверхностно для senior-позиции: нет конкретных проектов, архитектурного кругозора и измеримых результатов.',
              points: 3,
            ),
          ],
        ),
        InterviewQuestionEntity(
          id: 'q_it_2',
          interviewerRole: 'Recrutadora de RH',
          questionPt: 'Como gere divergências técnicas ou de prazos com a equipa de produto e outros engenheiros?',
          questionRu: 'Как вы управляете техническими разногласиями или вопросами сроков с продуктовой командой и инженерами?',
          hrInsightRu: 'Рекрутер проверяет soft skills: умение слушать, аргументировать через trade-offs и предотвращать конфликты без перехода на личности.',
          options: [
            InterviewAnswerOption(
              textPt: 'Procuro sempre despersonalizar o debate e ancorar a decisão em dados e testes de conceito. Quando há trade-offs entre dívida técnica e prazo de entrega, reúno-me com o Product Manager para expor os riscos com clareza e alinhar prioridades.',
              translationRu: 'Я всегда стремлюсь деперсонализировать дискуссию и опираться на данные и PoC. Когда возникает компромисс между техдолгом и сроками релиза, я встречаюсь с продакт-менеджером, чтобы открыто показать риски и согласовать приоритеты.',
              isStrong: true,
              hrFeedbackRu: 'Превосходно! Зрелый инженерный подход: "despersonalizar o debate" (убрать эмоции), прозрачность рисков и уважение к бизнесу.',
              points: 10,
            ),
            InterviewAnswerOption(
              textPt: 'Eu normalmente imponho a melhor solução técnica porque o pessoal de produto não percebe nada de arquitetura.',
              translationRu: 'Обычно я продавливаю лучшее техническое решение, потому что ребята из продукта ничего не понимают в архитектуре.',
              isStrong: false,
              hrFeedbackRu: 'Огромный красный флаг (Red Flag): пренебрежение к коллегам и неготовность к кросс-функциональному сотрудничеству.',
              points: 0,
            ),
          ],
        ),
        InterviewQuestionEntity(
          id: 'q_it_3',
          interviewerRole: 'Recrutadora de RH',
          questionPt: 'Qual é a sua expectativa salarial bruta anual e como vê o modelo de 14 meses em vigor em Portugal?',
          questionRu: 'Каковы ваши ожидания по годовой брутто-ставке и как вы относитесь к действующей в Португалии модели 14 выплат?',
          hrInsightRu: 'Проверяется адекватность зарплатных ожиданий португальскому рынку и знание структуры 14 зарплат (12 обычных + отпускные в июне + рождественские в ноябре).',
          options: [
            InterviewAnswerOption(
              textPt: 'Considerando a responsabilidade do cargo e a minha experiência sénior, a minha pretensão situa-se entre os 48.000€ e os 55.000€ brutos anuais, já contemplando as 14 mensalidades. Valorizo também o subsídio de alimentação e o plano de saúde.',
              translationRu: 'Учитывая ответственность роли и мой senior-опыт, мои ожидания находятся в диапазоне 48 000€ – 55 000€ брутто в год с учетом 14 выплат. Также ценю компенсацию на питание и медицинскую страховку.',
              isStrong: true,
              hrFeedbackRu: 'Идеальная формулировка! Назван четкий коридор в годовом брутто ("brutos anuais"), упомянуты 14 выплат и стандартные бенефиты.',
              points: 10,
            ),
            InterviewAnswerOption(
              textPt: 'Quero ganhar 4.000 euros limpos na mão por mês e não ligo para benefícios nem para 14 meses.',
              translationRu: 'Хочу получать 4000 евро чистыми на руки каждый месяц, до бенефитов и 14 месяцев мне дела нет.',
              isStrong: false,
              hrFeedbackRu: 'В европейских компаниях зарплату всегда обсуждают в брутто за год (anual bruto), так как чистая сумма (líquido) зависит от семейного положения и ставки налога IRS.',
              points: 4,
            ),
          ],
        ),
      ],
    ),

    // Продажи B2B в Сан-Паулу
    InterviewScenarioEntity(
      id: 'sc_sales_sp',
      jobTitlePt: 'Executivo de Contas B2B (Account Executive)',
      jobTitleRu: 'Менеджер по корпоративным продажам B2B',
      companyName: 'SaaS Enterprise (São Paulo - Faria Lima)',
      category: CareerCategory.sales,
      dialect: 'pt_BR',
      cefrLevel: 'B1',
      workModel: 'Híbrido (3x presencial)',
      salaryContextRu: 'Contratação CLT (Fixo + Comissão sem teto) + Vale-Refeição de R\$ 50/dia + Plano de Saúde e Dental + PLR semestral.',
      iconEmoji: '📈',
      questions: [
        InterviewQuestionEntity(
          id: 'q_sales_1',
          interviewerRole: 'Diretor Comercial',
          questionPt: 'Como você costuma estruturar o seu pipeline de vendas e qual foi o maior contrato que você fechou no último ano?',
          questionRu: 'Как вы обычно выстраиваете свою воронку продаж и какой крупнейший контракт вы закрыли за последний год?',
          hrInsightRu: 'Коммерческий директор ищет системность в пайплайне (BANT, MEDDIC), средний чек (ticket médio) и понимание длинных B2B-сделок.',
          options: [
            InterviewAnswerOption(
              textPt: 'Trabalho com qualificação criteriosa via framework MEDDIC para garantir previsibilidade de receita. No último trimestre, bati 128% da meta anual ao negociar um contrato de R\$ 750 mil com um dos maiores bancos do país, gerindo um ciclo de vendas de 4 meses.',
              translationRu: 'Я работаю с глубокой квалификацией по методологии MEDDIC для обеспечения предсказуемости выручки. В прошлом квартале я выполнил план на 128%, закрыв сделку на 750 тыс. реалов с крупнейшим банком страны при цикле сделки в 4 месяца.',
              isStrong: true,
              hrFeedbackRu: 'Блестяще! Назван методологический фреймворк, процент выполнения плана (128%), сумма контракта и длительность цикла сделки.',
              points: 10,
            ),
            InterviewAnswerOption(
              textPt: 'Eu sou muito comunicativo e vendo qualquer coisa para qualquer um se me derem uma boa comissão.',
              translationRu: 'Я очень общительный и продам что угодно кому угодно, если мне дадут хороший процент.',
              isStrong: false,
              hrFeedbackRu: 'Звучит как устаревший стереотип из 90-х. В корпоративном SaaS B2B ценятся аналитика и консалтинговый подход.',
              points: 3,
            ),
          ],
        ),
        InterviewQuestionEntity(
          id: 'q_sales_2',
          interviewerRole: 'Gerente de Gente & Gestão (RH)',
          questionPt: 'Você tem preferência por modelo de contratação CLT ou regime PJ para esta posição?',
          questionRu: 'Вы предпочитаете трудоустройство по CLT или режим PJ (юрлицо) для этой позиции?',
          hrInsightRu: 'В Бразилии это стандартный вопрос. Рекрутер хочет понять, понимает ли кандидат разницу в налогах, отпускных и защите трудового кодекса.',
          options: [
            InterviewAnswerOption(
              textPt: 'Tenho abertura total para os dois formatos. No modelo CLT, valorizo a segurança dos benefícios e o FGTS; no modelo PJ, considero uma remuneração fixa que compense a ausência de encargos e mantenha a atratividade do pacote total.',
              translationRu: 'Я открыт к обоим форматам. При CLT я ценю стабильность бенефитов и фонд FGTS; при PJ рассчитываю ставку с учетом компенсации налогов и сохранения привлекательности общего пакета.',
              isStrong: true,
              hrFeedbackRu: 'Идеальное понимание бразильского законодательства! Кандидат знает про FGTS и разницу налогообложения.',
              points: 10,
            ),
            InterviewAnswerOption(
              textPt: 'Tanto faz, o que pagar mais dinheiro na hora eu aceito.',
              translationRu: 'Без разницы, где дадут больше денег прямо сейчас, на то и соглашусь.',
              isStrong: false,
              hrFeedbackRu: 'Показывает финансовую неграмотность соискателя.',
              points: 4,
            ),
          ],
        ),
      ],
    ),

    // Гостиничный сервис в Алгарве
    InterviewScenarioEntity(
      id: 'sc_hotel_algarve',
      jobTitlePt: 'Rececionista de Hotel & Guest Relations',
      jobTitleRu: 'Администратор отеля и по работе с гостями',
      companyName: 'Resort 5 Estrelas (Algarve)',
      category: CareerCategory.hospitality,
      dialect: 'pt_PT',
      cefrLevel: 'B1',
      workModel: 'Presencial',
      salaryContextRu: 'Vencimento base + Alojamento para colaboradores + Subsídio de alimentação + Bónus de época balnear.',
      iconEmoji: '🏨',
      questions: [
        InterviewQuestionEntity(
          id: 'q_hot_1',
          interviewerRole: 'Diretor de Alojamento',
          questionPt: 'Como procede quando um hóspede VIP chega muito exaltado à receção reclamando que a suite reservada não tem vista mar?',
          questionRu: 'Как вы поступите, если VIP-гость приходит на ресепшн крайне раздраженным и жалуется, что в его люксе нет вида на море?',
          hrInsightRu: 'Проверяется навык деэскалации, стрессоустойчивость и знание стандартов 5-звездочного сервиса в Португалии.',
          options: [
            InterviewAnswerOption(
              textPt: 'Mantenho a calma, escuto ativamente sem interromper e demonstro empatia genuína. Verifico de imediato a disponibilidade de um upgrade para uma suite superior com vista mar e, enquanto o processo decorre, convido o hóspede a relaxar no lounge com uma bebida cortesia.',
              translationRu: 'Я сохраняю спокойствие, внимательно слушаю гостя не перебивая и проявляю искреннюю эмпатию. Немедленно проверяю возможность бесплатного апгрейда до люкса с видом на море и приглашаю гостя отдохнуть в лаунже с приветственным напитком.',
              isStrong: true,
              hrFeedbackRu: 'Образцовый ответ для премиального отеля! Выдержка, вежливость, быстрое решение проблемы и комплимент гостю.',
              points: 10,
            ),
            InterviewAnswerOption(
              textPt: 'Digo-lhe que a culpa é da agência de viagens onde ele comprou o pacote e que no hotel não há nada a fazer.',
              translationRu: 'Скажу ему, что виновато турагентство, где он покупал тур, и что отель тут ни при чем.',
              isStrong: false,
              hrFeedbackRu: 'Грубейшая ошибка в индустрии гостеприимства: перекладывание вины на клиента гарантирует скандал и плохой отзыв на TripAdvisor.',
              points: 1,
            ),
          ],
        ),
      ],
    ),
  ];

  // 2. Деловые фразы, сильные глаголы и шаблоны писем
  static const List<BusinessPhraseEntity> phrases = [
    // Шаблоны писем (Email Templates)
    BusinessPhraseEntity(
      id: 'bp_email_1',
      textPt: 'Exmo.(a) Sr.(a) [Nome], venho por este meio apresentar a minha candidatura à vaga de [Cargo], publicada no LinkedIn.',
      translationRu: 'Уважаемый(ая) г-н/г-жа [Имя], настоящим письмом направляю свое резюме на вакансию [Должность], опубликованную в LinkedIn.',
      contextNoteRu: 'Классическое официальное открытие сопроводительного письма в Португалии.',
      category: CareerCategory.general,
      phraseType: BusinessPhraseType.emailTemplate,
      dialect: 'pt_PT',
    ),
    BusinessPhraseEntity(
      id: 'bp_email_2',
      textPt: 'Agradeço desde já a oportunidade da entrevista de hoje. Fiquei muito entusiasmado(a) com a visão da empresa e os desafios da posição.',
      translationRu: 'Благодарю за возможность сегодняшнего интервью. Я остался очень воодушевлен видением компании и задачами этой роли.',
      contextNoteRu: 'Письмо-благодарность (Follow-up) в течение 24 часов после собеседования повышает шансы на оффер.',
      category: CareerCategory.general,
      phraseType: BusinessPhraseType.emailTemplate,
    ),
    BusinessPhraseEntity(
      id: 'bp_email_3',
      textPt: 'Gostaria de saber se há alguma atualização relativamente ao processo de recrutamento para o cargo de [Cargo].',
      translationRu: 'Я хотел бы уточнить, есть ли какие-либо новости по процессу отбора на позицию [Должность].',
      contextNoteRu: 'Вежливый запрос статуса, если рекрутер не вышел на связь в обещанный срок.',
      category: CareerCategory.general,
      phraseType: BusinessPhraseType.emailTemplate,
    ),

    // Сильные глаголы для резюме (Action Verbs)
    BusinessPhraseEntity(
      id: 'bp_verb_1',
      textPt: 'Liderei uma equipa multidisciplinar de 8 profissionais, assegurando a entrega do projeto dentro do prazo e orçamento.',
      translationRu: 'Руководил мультидисциплинарной командой из 8 специалистов, обеспечив сдачу проекта в срок и в рамках бюджета.',
      contextNoteRu: 'Глагол "Liderar" подчеркивает управленческие и лидерские качества.',
      category: CareerCategory.general,
      phraseType: BusinessPhraseType.cvActionVerb,
    ),
    BusinessPhraseEntity(
      id: 'bp_verb_2',
      textPt: 'Otimizei os processos operacionais internos, resultando numa redução de 25% nos custos logísticos.',
      translationRu: 'Оптимизировал внутренние операционные процессы, что привело к снижению логистических расходов на 25%.',
      contextNoteRu: 'Глагол "Otimizar" идеален для описания эффективности и экономии средств.',
      category: CareerCategory.general,
      phraseType: BusinessPhraseType.cvActionVerb,
    ),
    BusinessPhraseEntity(
      id: 'bp_verb_3',
      textPt: 'Alavanquei as vendas de novos produtos através de campanhas digitais segmentadas no mercado da América Latina.',
      translationRu: 'Увеличил продажи новых продуктов с помощью таргетированных цифровых кампаний на рынке Латинской Америки.',
      contextNoteRu: '"Alavancar" — популярнейший бразильский бизнес-глагол ("совершить скачок, дать мощный толчок").',
      category: CareerCategory.sales,
      phraseType: BusinessPhraseType.cvActionVerb,
      dialect: 'pt_BR',
    ),
    BusinessPhraseEntity(
      id: 'bp_verb_4',
      textPt: 'Implementei a nova infraestrutura de CI/CD, diminuindo o tempo de deploy de 2 horas para 12 minutos.',
      translationRu: 'Внедрил новую CI/CD инфраструктуру, сократив время развертывания с 2 часов до 12 минут.',
      contextNoteRu: 'Глагол "Implementar" с числовыми показателями до и после.',
      category: CareerCategory.tech,
      phraseType: BusinessPhraseType.cvActionVerb,
    ),

    // Самопрезентация и каверзные вопросы
    BusinessPhraseEntity(
      id: 'bp_pitch_1',
      textPt: 'O meu maior diferencial é a capacidade de traduzir requisitos complexos de negócio em soluções técnicas escaláveis.',
      translationRu: 'Мое ключевое преимущество — умение переводить сложные бизнес-требования в масштабируемые технические решения.',
      contextNoteRu: 'Ответ на вопрос: "Почему мы должны нанять именно вас?".',
      category: CareerCategory.general,
      phraseType: BusinessPhraseType.interviewPitch,
    ),
    BusinessPhraseEntity(
      id: 'bp_pitch_2',
      textPt: 'No passado, tinha dificuldade em delegar tarefas por perfecionismo; hoje utilizo métricas claras e confio na autonomia da equipa.',
      translationRu: 'В прошлом мне было трудно делегировать из-за перфекционизма; сегодня я использую четкие метрики и доверяю автономии команды.',
      contextNoteRu: 'Грамотный ответ на вопрос о слабостях: признание проблемы и демонстрация того, как вы над ней выросли.',
      category: CareerCategory.general,
      phraseType: BusinessPhraseType.interviewPitch,
    ),

    // Переговоры о компенсации
    BusinessPhraseEntity(
      id: 'bp_sal_1',
      textPt: 'Qual é o pacote de benefícios associado a esta vaga (plano de saúde, subsídio de alimentação, bónus por objetivos)?',
      translationRu: 'Каков пакет бенефитов, привязанный к этой вакансии (страховка, карта питания, бонусы за показатели)?',
      contextNoteRu: 'Профессиональный вопрос о совокупном доходе (Total Rewards).',
      category: CareerCategory.general,
      phraseType: BusinessPhraseType.salaryNegotiation,
    ),
    BusinessPhraseEntity(
      id: 'bp_sal_2',
      textPt: 'Estou muito entusiasmado com a proposta! Tendo em conta o mercado, seria possível rever a componente fixa em 10%?',
      translationRu: 'Я очень вдохновлен предложением! С учетом рыночных реалий, возможно ли пересмотреть фиксированную часть на 10%?',
      contextNoteRu: 'Деликатная и аргументированная формула торга по офферу.',
      category: CareerCategory.general,
      phraseType: BusinessPhraseType.salaryNegotiation,
    ),
  ];

  // 3. Руководство по резюме и трудовым режимам
  static const List<CvGuideItemEntity> cvGuides = [
    CvGuideItemEntity(
      id: 'cv_pt_14_months',
      sectionTitlePt: 'O Modelo dos 14 Meses em Portugal',
      sectionTitleRu: 'Как устроены 14 зарплат в Португалии',
      dialect: 'pt_PT',
      iconEmoji: '🇵🇹',
      explanationRu: 'В Португалии законодательно закреплена система 14 выплат в год для всех штатных сотрудников по трудовому договору (Contrato de Trabalho).',
      examplePt: 'Ordenado Base Mensal: 2.000€\nRetribuição Anual Bruta: 2.000€ × 14 = 28.000€\n• Subsídio de Férias: pago em junho antes das férias de verão.\n• Subsídio de Natal: pago em novembro antes do Natal.',
      tipsListRu: [
        'Всегда обсуждайте зарплату в сумме годового брутто (Retribuição Anual Bruta).',
        'В вакансиях часто указывают месячный оклад: чтобы узнать годовой доход, умножайте его на 14, а не на 12!',
        'Subsídio de Alimentação (компенсация питания) выплачивается сверх оклада за каждый отработанный день.',
      ],
    ),
    CvGuideItemEntity(
      id: 'cv_br_clt_vs_pj',
      sectionTitlePt: 'Regime de Trabalho no Brasil: CLT vs PJ',
      sectionTitleRu: 'Трудоустройство в Бразилии: CLT против PJ',
      dialect: 'pt_BR',
      iconEmoji: '🇧🇷',
      explanationRu: 'В Бразилии рынок строго разделен на официальное трудоустройство по Трудовому кодексу (CLT) и работу через собственное юридическое лицо (Pessoa Jurídica / PJ).',
      examplePt: '• CLT: Carteira assinada, 13º salário, férias remuneradas + 1/3, FGTS (8% pago pela empresa), aviso prévio.\n• PJ: Contrato de prestação de serviços (Nota Fiscal). Salário costuma ser 30% a 50% maior para compensar a ausência de benefícios.',
      tipsListRu: [
        'Предложение PJ в R\$ 10.000 примерно эквивалентно окладу CLT в R\$ 7.000 с учетом налогов и бонусов.',
        'Для контракта PJ необходимо открыть CNPJ (часто MEI или Simples Nacional) и выставлять Nota Fiscal.',
        'Многие IT-компании Бразилии предлагают гибридный вариант: "PJ com benefícios" (PJ с отпуском и страховкой).',
      ],
    ),
    CvGuideItemEntity(
      id: 'cv_structure_standard',
      sectionTitlePt: 'Estrutura Ideal do Currículo Lusófono',
      sectionTitleRu: 'Структура резюме для португальского рынка',
      dialect: 'all',
      iconEmoji: '📄',
      explanationRu: 'Стандарт современного резюме в Португалии и Бразилии — четкий 1–2 страничный документ без лишней воды, оптимизированный под ATS (роботов-фильтраторов).',
      examplePt: '1. Dados Pessoais (Nome, LinkedIn, Telemóvel/Celular, Cidade/País)\n2. Resumo Profissional / Perfil (3–4 linhas de impacto)\n3. Experiência Profissional (Cargos, empresas, conquistas em bullets com métricas)\n4. Formação Académica & Certificações\n5. Competências Técnicas & Idiomas',
      tipsListRu: [
        'В Португалии фотография в резюме приветствуется, но должна быть деловой и качественной.',
        'Не указывайте домашний адрес полностью — достаточно указать город и страну (ex.: "Lisboa, Portugal").',
        'Каждую строку опыта начинайте с сильного глагола действия в прошедшем времени ("Desenvolvi", "Liderei", "Otimizei").',
      ],
    ),
  ];
}
