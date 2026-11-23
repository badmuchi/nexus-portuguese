import '../../domain/entities/finance_entities.dart';

class FinanceSeedData {
  static List<FinanceTopicEntity> getTopics() {
    return const [
      FinanceTopicEntity(
        id: 'fintech-pix-brasil',
        title: 'Pix & Pagamentos Instantâneos',
        category: FinanceCategory.fintech,
        region: 'Todo o Brasil',
        country: 'Brasil',
        dialect: 'pt_BR',
        accentEmoji: '⚡',
        shortDescription:
            'A revolução financeira que aposentou o dinheiro vivo: transferências gratuitas em segundos 24/7.',
        fullDescription:
            'Criado pelo Banco Central do Brasil em novembro de 2020, o Pix transformou radicalmente a economia e o cotidiano brasileiro. Trata-se de um meio de pagamento instantâneo pelo qual recursos são transferidos entre contas bancárias em menos de dez segundos, a qualquer hora do dia ou da noite, inclusive em feriados e finais de semana. O sistema funciona por meio de "Chaves Pix" (CPF, número de telefone celular, e-mail ou chave aleatória criptográfica) ou leitura de QR Codes. Hoje em dia, o Pix é aceito em absolutamente todos os lugares no Brasil: desde grandes redes de supermercados até o vendedor de água de coco na praia e feirantes.',
        keyMechanisms: [
          'Chaves Pix fáceis de memorizar: CPF, e-mail, telefone celular ou chave aleatória',
          'Pagamento instantâneo via QR Code estático (para comerciantes locais) e dinâmico',
          'Liquidação financeira imediata pelo Sistema de Pagamentos Instantâneos (SPI) do Banco Central',
          'Gratuidade total para pessoas físicas na grande maioria das operações',
          'Mecanismo Especial de Devolução (MED) para casos de fraude ou golpe comprovado',
        ],
        culturalTips: [
          'No Brasil, você ouvirá constantemente a expressão: "Aceita Pix?" ou "Me passa a sua chave!"',
          'Evite usar o CPF como chave em compras com desconhecidos na rua; prefira a chave aleatória para proteger seus dados pessoais',
          'Existe um limite noturno de segurança (geralmente R\$ 1.000 entre 20h e 6h) que você pode configurar no app do seu banco',
        ],
        audioSnippet:
            'O Pix tornou-se o meio de pagamento mais popular do Brasil, permitindo transferências imediatas sem custo a qualquer hora.',
        vocabulary: [
          FinanceVocabEntity(
            id: 'fin-chave-pix',
            termPt: 'Chave Pix',
            translationRu: 'Ключ Pix (идентификатор банковского счёта)',
            definition:
                'Identificador único (CPF, celular, e-mail ou código alfanumérico) que vincula os dados da conta bancária para receber transferências.',
            exampleSentence:
                'Você pode me mandar os vinte reais pelo Pix? A minha chave é o número do meu celular.',
            dialect: 'pt_BR',
          ),
          FinanceVocabEntity(
            id: 'fin-ted-doc',
            termPt: 'TED / DOC',
            translationRu: 'Традиционные межбанковские переводы (устаревшие)',
            definition:
                'Antigas modalidades bancárias de transferência de fundos que cobravam taxas e só funcionavam em horário comercial.',
            exampleSentence:
                'O Pix substituiu quase totalmente o TED e o DOC no dia a dia dos brasileiros.',
            dialect: 'pt_BR',
          ),
          FinanceVocabEntity(
            id: 'fin-comprovante',
            termPt: 'Comprovante de pagamento',
            translationRu: 'Квитанция / чек об оплате',
            definition:
                'Documento digital gerado pelo aplicativo bancário que atesta a efetivação da transação financeira.',
            exampleSentence:
                'Assim que o Pix foi concluído, enviei o comprovante pelo WhatsApp para a loja.',
            dialect: 'all',
          ),
        ],
      ),
      FinanceTopicEntity(
        id: 'fintech-mbway-portugal',
        title: 'MB WAY & A Rede Multibanco',
        category: FinanceCategory.fintech,
        region: 'Portugal',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '📲',
        shortDescription:
            'A rede bancária mais avançada da Europa: levantar dinheiro sem cartão e pagar pelo telemóvel.',
        fullDescription:
            'Portugal possui uma das redes de caixas automáticos e serviços interbancários mais integradas e avançadas do mundo, gerida pela SIBS (Multibanco). A aplicação MB WAY levou essa infraestrutura para o telemóvel, tornando-se indispensável. Com o MB WAY, é possível enviar dinheiro instantaneamente apenas sabendo o contacto telefónico do destinatário, dividir despesas de almoço ou jantar entre amigos de forma automática, gerar cartões virtuais MB NET para compras online seguras e até mesmo "levantar dinheiro" num caixa Multibanco gerando um código temporário de 6 dígitos no ecrã do telemóvel, sem necessidade de cartão físico.',
        keyMechanisms: [
          'Envio imediato de fundos para qualquer número de telemóvel associado',
          'Divisão automática de faturas de restaurantes com múltiplos contactos (*dividir a conta*)',
          'Levantamento de notas em caixas Multibanco sem cartão físico com código de 6 dígitos',
          'Geração de cartões virtuais MB NET (cartão de utilização única ou comerciantes recorrentes)',
          'Pagamento de compras em lojas físicas aproximando o telemóvel ou por código QR',
        ],
        culturalTips: [
          'Em Portugal, quando um grupo termina uma refeição, é clássico alguém perguntar: "Mando-te o dinheiro por MB WAY?"',
          'Para pagar faturas de eletricidade, água ou compras online em lojas tugas, utiliza-se a "Entidade e Referência Multibanco"',
          'Ao pedir uma bica ou pastel numa pastelaria pequena, verifique se aceitam Multibanco para valores inferiores a 5 euros',
        ],
        audioSnippet:
            'O MB WAY em Portugal permite enviar dinheiro pelo número de telemóvel e levantar notas no Multibanco sem cartão físico.',
        vocabulary: [
          FinanceVocabEntity(
            id: 'fin-referencia-mb',
            termPt: 'Entidade e Referência Multibanco',
            translationRu: 'Реквизиты платежа Multibanco (код организации и номер счета)',
            definition:
                'Sistema numérico de 5 e 9 dígitos usado para liquidar compras online, serviços públicos e impostos em Portugal.',
            exampleSentence:
                'Selecionei o pagamento por Multibanco e recebi a entidade e a referência para pagar no homebanking.',
            dialect: 'pt_PT',
          ),
          FinanceVocabEntity(
            id: 'fin-levantar-dinheiro',
            termPt: 'Levantar dinheiro',
            translationRu: 'Снимать наличные (в банкомате)',
            definition:
                'Retirar notas de dinheiro físico num terminal bancário ou caixa automático.',
            exampleSentence:
                'Preciso de levantar vinte euros no Multibanco da esquina para comprar o bilhete.',
            dialect: 'pt_PT',
            dialectNote: 'No Brasil diz-se "sacar dinheiro" no caixa eletrônico.',
          ),
          FinanceVocabEntity(
            id: 'fin-dividir-conta',
            termPt: 'Pagar a meias / Dividir a conta',
            translationRu: 'Разделить счет пополам / поровну',
            definition:
                'Partilhar equitativamente o valor total de uma despesa ou refeição entre as pessoas do grupo.',
            exampleSentence:
                'Vamos pagar a meias o jantar e eu transfiro a minha parte por MB WAY.',
            dialect: 'pt_PT',
            dialectNote: 'No Brasil é muito comum a gíria "rachar a conta".',
          ),
        ],
      ),
      FinanceTopicEntity(
        id: 'startups-web-summit-lisboa',
        title: 'Startups, Unicórnios & Web Summit',
        category: FinanceCategory.startups,
        region: 'Lisboa (Parque das Nações & Hub Criativo do Beato)',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '🚀',
        shortDescription:
            'A capital portuguesa como polo europeu de inovação, unicórnios tecnológicos e capital de risco.',
        fullDescription:
            'Desde que acolheu a Web Summit em 2016, Lisboa consolidou-se como um dos polos tecnológicos e de empreendedorismo mais dinâmicos da Europa. A cidade atrai fundadores internacionais, programadores e fundos de capital de risco atraídos pela qualidade de vida, talento qualificado e programas de apoio como a Startup Lisboa e a Fábrica de Unicórnios no Hub Criativo do Beato. Portugal gerou unicórnios de escala global (empresas avaliadas em mais de mil milhões de dólares), como a OutSystems (plataforma low-code), Feedzai (prevenção de fraudes financeiras com IA) e Sword Health (fisioterapia digital).',
        keyMechanisms: [
          'Rondas de investimento: Pré-seed, Seed, Série A, Série B até ao IPO',
          'Incubadoras e aceleradoras municipais com mentoria e espaço de coworking',
          'Vistos para empreendedores e nómadas digitais (Digital Nomad Visa)',
          'Pitch competitions perante investidores anjo e fundos de Venture Capital internacionais',
          'Rede de business angels e benefícios fiscais para inovação tecnológica',
        ],
        culturalTips: [
          'O ecossistema em Lisboa é altamente cosmopolita e combina o inglês de negócios com o português acolhedor',
          'A Web Summit reúne mais de 70 mil participantes todos os anos no mês de novembro na MEO Arena e FIL',
          'Expressões em inglês como "pitch", "funding", "seed round" e "bootstrapping" são usadas correntemente pelos fundadores portugueses',
        ],
        audioSnippet:
            'Lisboa transformou-se numa vibrante capital de startups, sediando a Web Summit e gerando unicórnios tecnológicos globais.',
        vocabulary: [
          FinanceVocabEntity(
            id: 'fin-investidor-anjo',
            termPt: 'Investidor anjo',
            translationRu: 'Бизнес-ангел (частный ранний инвестор)',
            definition:
                'Indivíduo com capital próprio que investe financeiramente e apoia mentorando startups nas fases iniciais.',
            exampleSentence:
                'A startup portuguesa conseguiu cem mil euros com um investidor anjo após a apresentação do pitch.',
            dialect: 'all',
          ),
          FinanceVocabEntity(
            id: 'fin-rodada-investimento',
            termPt: 'Ronda de financiamento',
            translationRu: 'Раунд инвестиций / финансирования',
            definition:
                'Etapa formal na qual uma empresa capta fundos financeiros de investidores em troca de participação societária.',
            exampleSentence:
                'A empresa fechou uma ronda de financiamento Série A no valor de dez milhões de euros.',
            dialect: 'pt_PT',
            dialectNote: 'No Brasil escreve-se "rodada de financiamento / investimento".',
          ),
          FinanceVocabEntity(
            id: 'fin-avaliacao-valuation',
            termPt: 'Avaliação / Valuation',
            translationRu: 'Оценка рыночной стоимости компании',
            definition:
                'Processo financeiro de estimar o valor de mercado de uma empresa para efeitos de investimento ou venda.',
            exampleSentence:
                'Com o novo aporte de capital, a startup alcançou uma avaliação superior a quinhentos milhões.',
            dialect: 'all',
          ),
        ],
      ),
      FinanceTopicEntity(
        id: 'startups-farialima-sp',
        title: 'Faria Lima & O Mercado Financeiro Brasileiro',
        category: FinanceCategory.startups,
        region: 'São Paulo (Av. Brigadeiro Faria Lima & B3)',
        country: 'Brasil',
        dialect: 'pt_BR',
        accentEmoji: '🏙️',
        shortDescription:
            'A Wall Street latino-americana: bancos digitais, fundos de investimento e a B3 em São Paulo.',
        fullDescription:
            'A Avenida Brigadeiro Faria Lima em São Paulo é o epicentro do poder econômico e da tecnologia financeira na América Latina. Ali concentram-se bancos de investimento, gestoras de patrimônio, fundos de Venture Capital e as sedes dos maiores gigantes digitais da região, como o Nubank (banco digital pioneiro), o iFood, o QuintoAndar e o Mercado Livre. Na região central da cidade opera a B3 (Brasil, Bolsa, Balcão), uma das maiores bolsas de valores do mundo em capitalização, onde são negociadas ações de companhias abertas, contratos futuros e fundos imobiliários.',
        keyMechanisms: [
          'Mercado acionário na B3 negociando papéis das maiores empresas do continente',
          'Mercado de Venture Capital concentrando mais de 50% dos investimentos da América Latina',
          'Cultura corporativa dos "Faria Limers" com vestimenta casual-chique e jargão do mercado',
          'Bancos digitais ("neobanks") com abertura de conta em minutos sem taxa de manutenção',
          'Oferta Pública Inicial (IPO) para captação de recursos no mercado de capitais',
        ],
        culturalTips: [
          'O termo "Faria Limer" tornou-se meme nacional, retratando profissionais do mercado com colete de nylon e patinete elétrico',
          'São Paulo é o centro financeiro que dita os rumos dos negócios e da inovação no Brasil',
          'Gírias de dinheiro abundam no cotidiano paulistano: "grana", "bufunfa", "tostão", "pila"',
        ],
        audioSnippet:
            'A Avenida Faria Lima em São Paulo concentra os maiores fundos de investimento e fintechs da América Latina.',
        vocabulary: [
          FinanceVocabEntity(
            id: 'fin-aporte',
            termPt: 'Aporte financeiro',
            translationRu: 'Финансовое вливание / транш инвестиций',
            definition:
                'Injeção de recursos monetários realizada por sócios ou investidores no caixa de uma sociedade empresária.',
            exampleSentence:
                'A fintech recebeu um aporte de cinquenta milhões de dólares de um fundo internacional.',
            dialect: 'all',
          ),
          FinanceVocabEntity(
            id: 'fin-abertura-capital',
            termPt: 'Abertura de capital (IPO)',
            translationRu: 'Первичное публичное размещение акций (IPO)',
            definition:
                'Momento em que uma empresa privada passa a vender suas ações ao público geral na bolsa de valores.',
            exampleSentence:
                'A abertura de capital do banco digital movimentou bilhões de reais na bolsa de Nova York.',
            dialect: 'all',
          ),
          FinanceVocabEntity(
            id: 'fin-faria-limer',
            termPt: 'Faria Limer',
            translationRu: 'Фариа-лаймер (сленг: работник финансового сектора Сан-Паулу)',
            definition:
                'Expressão cultural brasileira para descrever os profissionais do mercado financeiro e startups da Av. Faria Lima.',
            exampleSentence:
                'O restaurante no Itaim Bibi estava lotado de faria limers conversando sobre juros e investimentos.',
            dialect: 'pt_BR',
          ),
        ],
      ),
      FinanceTopicEntity(
        id: 'salarios-impostos-portugal',
        title: 'Salários, 14 Meses, IRS & e-Fatura',
        category: FinanceCategory.personalFinance,
        region: 'Portugal',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '🧾',
        shortDescription:
            'Como funciona a vida financeira em Portugal: ordenado bruto vs líquido, subsídios e NIF nas faturas.',
        fullDescription:
            'Viver e trabalhar em Portugal requer compreender a mecânica de remuneração e impostos locais. A maioria dos contratos de trabalho em Portugal paga catorze salários ao ano (os chamados 14 meses): doze ordenados mensais habituais, acrescidos do Subsídio de Férias (pago antes do verão) e do Subsídio de Natal (pago em novembro/dezembro). Do ordenado bruto são deduzidos mensalmente a contribuição para a Segurança Social (taxa fixa de 11% para o trabalhador) e a Retenção na Fonte de IRS (Imposto sobre o Rendimento das Pessoas Singulares), que é progressiva. Um hábito cívico fundamental é pedir sempre fatura com o seu NIF (Número de Identificação Fiscal) nas compras para obter deduções fiscais no portal e-fatura.',
        keyMechanisms: [
          'Regime de 14 salários: 12 ordenados mensais + Subsídio de Férias + Subsídio de Natal',
          'Diferença substancial entre ordenado bruto (acordado) e ordenado líquido (que cai na conta)',
          'Segurança Social com desconto obrigatório de 11% do trabalhador e 23,75% da entidade patronal',
          'IRS progressivo com tabelas de retenção na fonte em função do rendimento e agregado familiar',
          'Benefício fiscal do e-fatura: abatimento de despesas de saúde, educação, habitação e restauração',
        ],
        culturalTips: [
          'Em qualquer café, farmácia ou restaurante em Portugal, a primeira pergunta no caixa é: "Deseja fatura com contribuinte (NIF)?"',
          'Pedir fatura com NIF na restauração e alojamento devolve 15% do IVA suportado como dedução no imposto anual',
          'Ao negociar um emprego em Portugal, pergunte sempre pelo valor "bruto anual" ou se os valores falados já incluem subsídios em duodécimos',
        ],
        audioSnippet:
            'Em Portugal, o ano de trabalho é pago em catorze salários, incluindo os subsídios de férias e de Natal, com descontos de IRS e Segurança Social.',
        vocabulary: [
          FinanceVocabEntity(
            id: 'fin-vencimento-bruto',
            termPt: 'Ordenado bruto / Vencimento',
            translationRu: 'Оклад брутто (до вычета налогов)',
            definition:
                'Remuneração total contratual antes dos descontos fiscais de IRS e contribuições para a Segurança Social.',
            exampleSentence:
                'O ordenado bruto parecia atrativo, mas após os descontos fiscais o valor líquido é bem diferente.',
            dialect: 'pt_PT',
            dialectNote: 'No Brasil utiliza-se a palavra "salário bruto".',
          ),
          FinanceVocabEntity(
            id: 'fin-subsidio-ferias',
            termPt: 'Subsídio de férias e de Natal',
            translationRu: 'Отпускные и рождественские выплаты (13-я и 14-я зарплаты)',
            definition:
                'Prestações remuneratórias obrigatórias por lei em Portugal pagas adicionalmente aos doze meses normais.',
            exampleSentence:
                'No mês de junho recebi o ordenado normal juntamente com o subsídio de férias.',
            dialect: 'pt_PT',
          ),
          FinanceVocabEntity(
            id: 'fin-nif-fatura',
            termPt: 'Fatura com NIF',
            translationRu: 'Чек/фактура с указанием налогового номера (NIF)',
            definition:
                'Recibo fiscal registrado eletronicamente no sistema da Autoridade Tributária associado ao número do contribuinte.',
            exampleSentence:
                'Peço sempre fatura com NIF no supermercado para abater no meu IRS anual.',
            dialect: 'pt_PT',
          ),
        ],
      ),
      FinanceTopicEntity(
        id: 'investimentos-clt-pj-brasil',
        title: 'CLT vs PJ & Investimentos no Brasil',
        category: FinanceCategory.business,
        region: 'Brasil',
        country: 'Brasil',
        dialect: 'pt_BR',
        accentEmoji: '💼',
        shortDescription:
            'A escolha entre carteira assinada e empresa própria, Tesouro Direto e a taxa Selic.',
        fullDescription:
            'O mercado profissional brasileiro é estruturado em dois grandes modelos de contratação: o regime da CLT (Consolidação das Leis do Trabalho) e a contratação como PJ (Pessoa Jurídica). O trabalhador CLT tem carteira de trabalho assinada e direitos legais garantidos (FGTS, 13º salário, 30 dias de férias remuneradas com acréscimo de 1/3 e aviso prévio). Já o profissional PJ abre uma microempresa (como MEI ou ME no Simples Nacional), emite notas fiscais de prestação de serviços e negocia um valor líquido mais elevado, assumindo sua própria previdência e custos. No campo dos investimentos, a taxa Selic (taxa básica de juros) baliza o rendimento da renda fixa, como o Tesouro Direto, os CDBs e o CDI.',
        keyMechanisms: [
          'CLT: segurança jurídica, FGTS de 8% mensal retido, 13º salário e rescisão indenizada',
          'PJ: flexibilidade contratual, menor tributação via Simples Nacional e maior remuneração imediata',
          'Taxa Selic: taxa mãe da economia brasileira que determina o custo do crédito e o retorno dos investimentos',
          'Renda fixa brasileira: Tesouro Selic, Tesouro IPCA (proteção contra inflação) e CDBs bancários',
          'Bolsa de Valores (B3): compra de ações e fundos de investimento imobiliário (FIIs)',
        ],
        culturalTips: [
          'Muitos profissionais de tecnologia e serviços qualificados no Brasil preferem o modelo PJ devido à menor carga tributária',
          'Ao receber uma proposta PJ, a regra prática é exigir pelo menos 30% a 50% a mais do que o salário CLT equivalente para compensar os benefícios',
          'Investir no Tesouro Direto é acessível a partir de cerca de trinta reais pela plataforma oficial do Tesouro Nacional',
        ],
        audioSnippet:
            'No Brasil, a decisão entre ser contratado como CLT ou atuar como PJ envolve equilibrar benefícios garantidos e flexibilidade tributária.',
        vocabulary: [
          FinanceVocabEntity(
            id: 'fin-clt-carteira',
            termPt: 'CLT (Carteira assinada)',
            translationRu: 'Трудовой кодекс CLT / работа по трудовой книжке',
            definition:
                'Regime legal de trabalho com vínculo empregatício formal e garantia de todos os direitos trabalhistas constitucionais.',
            exampleSentence:
                'Trabalhar sob o regime da CLT garante o depósito mensal do Fundo de Garantia (FGTS).',
            dialect: 'pt_BR',
          ),
          FinanceVocabEntity(
            id: 'fin-pj-simples',
            termPt: 'Pessoa Jurídica (PJ)',
            translationRu: 'Юридическое лицо / работа по контракту B2B',
            definition:
                'Modelo em que o profissional atua como empresa prestadora de serviços, emitindo nota fiscal sem vínculo de emprego direto.',
            exampleSentence:
                'O desenvolvedor sênior optou pelo contrato PJ por permitir uma remuneração líquida superior.',
            dialect: 'pt_BR',
          ),
          FinanceVocabEntity(
            id: 'fin-taxa-selic',
            termPt: 'Taxa Selic',
            translationRu: 'Ключевая ставка Selic (ставка рефинансирования ЦБ Бразилии)',
            definition:
                'Taxa básica de juros da economia brasileira definida periodicamente pelo Comitê de Política Monetária (Copom).',
            exampleSentence:
                'Quando a taxa Selic sobe, os investimentos em renda fixa tornam-se extremamente atrativos no Brasil.',
            dialect: 'pt_BR',
          ),
        ],
      ),
    ];
  }

  static List<FintechSimulatorEntity> getSimulators() {
    return const [
      FintechSimulatorEntity(
        id: 'sim-pix',
        title: 'Fazer um Pix na Feira ou no Restaurante',
        platform: 'Pix (Brasil)',
        dialect: 'pt_BR',
        icon: '⚡',
        scenario:
            'Você acabou de almoçar num boteco em São Paulo e quer pagar a sua conta de forma rápida e sem taxas usando o aplicativo do banco.',
        steps: [
          'Abra o app do seu banco no smartphone e toque no ícone "Pix".',
          'Escolha entre "Ler QR Code" da maquininha ou "Transferir por Chave".',
          'Se for por chave, digite o CPF, e-mail ou número de telefone do estabelecimento.',
          'Confira atentamente o nome completo e os dados do destinatário na tela de confirmação.',
          'Digite a sua senha de segurança ou confirme com biometria facial.',
          'Mostre a tela do comprovante com o código de autenticação para o garçom.',
        ],
        practicalAdvice:
            'Sempre confirme o nome do titular da conta antes de autenticar a transação com sua senha.',
      ),
      FintechSimulatorEntity(
        id: 'sim-mbway',
        title: 'Dividir a Conta e Enviar por MB WAY',
        platform: 'MB WAY (Portugal)',
        dialect: 'pt_PT',
        icon: '📲',
        scenario:
            'Jantou com amigos numa tasca em Lisboa e um deles pagou a fatura total. Agora você quer transferir a sua parte exata.',
        steps: [
          'Abra a aplicação MB WAY ou o aplicativo do seu banco em Portugal.',
          'Toque em "Enviar Dinheiro" e selecione o contacto telefónico do seu amigo da agenda.',
          'Introduza o valor exato da sua parcela em euros (ex: 14,50 €).',
          'Escreva uma mensagem descritiva opcional (ex: "Jantar na tasca").',
          'Valide a operação com o seu PIN MB WAY ou Touch ID / Face ID.',
          'O seu amigo recebe uma notificação instantânea e o dinheiro entra na conta dele de imediato.',
        ],
        practicalAdvice:
            'O MB WAY não cobra comissões na maioria das operações entre particulares com contas bancárias portuguesas.',
      ),
      FintechSimulatorEntity(
        id: 'sim-multibanco',
        title: 'Pagar Serviços por Entidade e Referência',
        platform: 'Multibanco (Portugal)',
        dialect: 'pt_PT',
        icon: '🏧',
        scenario:
            'Você comprou um bilhete de comboio no site da CP e escolheu pagar por Multibanco.',
        steps: [
          'Guarde os dados emitidos pelo comerciante: Entidade (5 dígitos), Referência (9 dígitos) e Montante.',
          'Aceda a um caixa Multibanco físico ou abra o seu homebanking no telemóvel.',
          'Selecione a opção "Pagamentos" e em seguida "Pagamento de Serviços / Compras".',
          'Digite o código da Entidade e a Referência de 9 dígitos.',
          'Confira se o valor exibido confere com o total da sua compra.',
          'Confirme o pagamento e guarde o talão de comprovativo digital.',
        ],
        practicalAdvice:
            'As referências Multibanco costumam ter um prazo de validade (geralmente entre 24h e 48h) para serem pagas.',
      ),
      FintechSimulatorEntity(
        id: 'sim-fatura-nif',
        title: 'Pedir Fatura com NIF para o e-Fatura',
        platform: 'Autoridade Tributária (Portugal)',
        dialect: 'pt_PT',
        icon: '🧾',
        scenario:
            'Fez compras no supermercado ou pagou uma consulta médica e quer garantir as deduções fiscais no IRS anual.',
        steps: [
          'No momento de pagar no caixa, o operador perguntará: "Deseja fatura com NIF?".',
          'Responda afirmativamente e dite o seu número de contribuinte de 9 dígitos (ex: 299 123 456).',
          'O operador insere o seu NIF e emite a fatura impressa ou digital.',
          'A informação é comunicada automaticamente pelo comerciante ao portal das Finanças (e-fatura).',
          'Mais tarde, consulte a app do e-fatura para validar a categoria correta da despesa (Saúde, Educação, etc.).',
        ],
        practicalAdvice:
            'Despesas em restauração e alojamento devolvem 15% do IVA suportado como dedução no imposto.',
      ),
    ];
  }

  static List<FinanceQuizQuestion> getQuizzes() {
    return const [
      FinanceQuizQuestion(
        id: 'quiz-fin-1',
        question:
            'No Brasil, qual é o meio de pagamento instantâneo criado pelo Banco Central que opera 24 horas por dia gratuitamente por meio de chaves?',
        options: [
          'O Pix',
          'O MB WAY',
          'O Boleto bancário',
          'O DOC',
        ],
        correctIndex: 0,
        explanation:
            'O Pix foi criado pelo Banco Central do Brasil em 2020 e permite transferências instantâneas a qualquer hora usando chaves ou QR Code.',
        dialect: 'pt_BR',
      ),
      FinanceQuizQuestion(
        id: 'quiz-fin-2',
        question:
            'Como se chama em Portugal a aplicação móvel que permite levantar dinheiro no Multibanco sem cartão e enviar fundos pelo número de telemóvel?',
        options: [
          'MB WAY',
          'Pix Portugal',
          'Nubank Europa',
          'Boleto Mobile',
        ],
        correctIndex: 0,
        explanation:
            'O MB WAY é a solução móvel da rede Multibanco (SIBS) que possibilita pagamentos, transferências por contacto e levantamento sem cartão.',
        dialect: 'pt_PT',
      ),
      FinanceQuizQuestion(
        id: 'quiz-fin-3',
        question:
            'Quantos salários anuais são tradicionalmente pagos na maioria dos contratos de trabalho em Portugal, incluindo os subsídios legais?',
        options: [
          '14 salários (12 meses + Subsídio de Férias e de Natal)',
          '12 salários exatos',
          '13 salários com bônus único',
          '16 salários quadrimestrais',
        ],
        correctIndex: 0,
        explanation:
            'Em Portugal vigora o regime de 14 meses, onde além dos 12 ordenados mensais o trabalhador recebe o Subsídio de Férias e o Subsídio de Natal.',
        dialect: 'pt_PT',
      ),
      FinanceQuizQuestion(
        id: 'quiz-fin-4',
        question:
            'Qual é a principal diferença entre ser contratado sob o regime da CLT e atuar como PJ (Pessoa Jurídica) no Brasil?',
        options: [
          'A CLT garante direitos e FGTS formal; o PJ atua como empresa B2B emitindo notas fiscais',
          'O regime CLT não paga impostos; o PJ é isento de contabilidade',
          'Apenas o PJ tem direito a 30 dias de férias remuneradas',
          'O CLT recebe em dólares e o PJ recebe em reais',
        ],
        correctIndex: 0,
        explanation:
            'A CLT é o vínculo empregatício formal com direitos trabalhistas garantidos por lei; o PJ é uma prestação de serviços autônoma entre empresas.',
        dialect: 'pt_BR',
      ),
      FinanceQuizQuestion(
        id: 'quiz-fin-5',
        question:
            'Para que serve fornecer o NIF (Número de Identificação Fiscal) nas faturas de compras do cotidiano em Portugal?',
        options: [
          'Para deduzir despesas no imposto de renda anual (IRS) através do e-fatura',
          'Para pagar automaticamente com juros bancários',
          'Para ter acesso exclusivo a lojas fechadas',
          'Para converter o valor da compra em moeda estrangeira',
        ],
        correctIndex: 0,
        explanation:
            'Ao colocar o NIF na fatura, a despesa é comunicada à Autoridade Tributária e gera deduções fiscais no IRS anual do contribuinte.',
        dialect: 'pt_PT',
      ),
      FinanceQuizQuestion(
        id: 'quiz-fin-6',
        question:
            'Qual conferência global de tecnologia e inovação é sediada anualmente em Lisboa, reunindo dezenas de milhares de fundadores e investidores?',
        options: [
          'Web Summit',
          'Silicon Valley Expo',
          'B3 Finance Forum',
          'Congresso do Pix',
        ],
        correctIndex: 0,
        explanation:
            'A Web Summit é uma das maiores conferências de tecnologia e empreendedorismo do mundo, realizada anualmente em Lisboa desde 2016.',
        dialect: 'pt_PT',
      ),
    ];
  }
}
