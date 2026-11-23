import '../../domain/entities/festas_entities.dart';

class FestasSeedData {
  static List<FestaEntity> getFestas() {
    return const [
      FestaEntity(
        id: 'carnaval-rio',
        title: 'Carnaval do Rio de Janeiro',
        region: 'Rio de Janeiro, Marquês de Sapucaí',
        country: 'Brasil',
        dialect: 'pt_BR',
        seasonDate: 'Fevereiro / Quaresma',
        category: FestaCategory.carnaval,
        accentEmoji: '🎭',
        shortDescription:
            'O maior espetáculo da Terra: desfiles monumentais no Sambódromo e blocos de rua por toda a cidade.',
        fullDescription:
            'O Carnaval do Rio de Janeiro é a celebração popular mais famosa do planeta. Na passarela do Sambódromo da Marquês de Sapucaí, doze escolas de samba do Grupo Especial disputam o título com desfiles grandiosos de até setenta minutos cada. Cada escola narra um enredo histórico ou social por meio de alegorias majestosas, fantasias cintilantes e alas coreografadas. A abertura é liderada pela comissão de frente e embalada pelos tambores ensurdecedores da bateria e pelo puxador de samba. Paralelamente, centenas de blocos carnavalescos arrastam milhões de foliões fantasiados pelas ruas de Copacabana, Santa Teresa e Centro.',
        ritualsAndTraditions: [
          'Entrada do Rei Momo recebendo simbolicamente a chave da cidade do prefeito',
          'Apresentação impactante da comissão de frente e do mestre-sala e porta-bandeira',
          'Apuração tensa das notas dos jurados na Quarta-feira de Cinzas ("Dez, nota dez!")',
          'Desfile das Campeãs no sábado após o Carnaval',
          'Cordão do Bola Preta arrastando mais de um milhão de foliões no centro histórico',
        ],
        foodsAndDrinks: [
          'Feijoada carnavalesca servida nas quadras das escolas de samba',
          'Caipirinha de limão com cachaça e muito gelo',
          'Cerveja estalando de gelada nos ambulantes',
          'Sacolé (chup-chup) artesanal para aliviar o calor',
        ],
        audioSnippet:
            'No Sambódromo da Sapucaí, o coração bate no compasso da bateria e da voz marcante do puxador de samba.',
        vocabulary: [
          FestaVocabEntity(
            id: 'festa-comissao-frente',
            termPt: 'Comissão de frente',
            translationRu: 'Авангард / головная группа школы самбы',
            definition:
                'Primeira ala da escola de samba a pisar na avenida, responsável por apresentar e saudar o público com coreografia teatral inovadora.',
            exampleSentence:
                'A comissão de frente arrancou aplausos emocionados com trocas mágicas de figurino na avenida.',
            dialect: 'pt_BR',
          ),
          FestaVocabEntity(
            id: 'festa-enredo',
            termPt: 'Samba-enredo',
            translationRu: 'Тематическая самба (гимн школы на карнавале)',
            definition:
                'Gênero de samba composto especificamente para narrar e musicalizar o tema temático escolhido pela escola de samba.',
            exampleSentence:
                'A Sapucaí inteira cantou em uníssono os versos do samba-enredo da Mangueira.',
            dialect: 'pt_BR',
          ),
          FestaVocabEntity(
            id: 'festa-puxador',
            termPt: 'Puxador de samba',
            translationRu: 'Главный запевала / солист школы самбы',
            definition:
                'Intérprete vocal principal que comanda o canto na avenida ao microfone do carro de som.',
            exampleSentence:
                'O puxador de samba incitou as arquibancadas com seu grito de guerra contagiante.',
            dialect: 'pt_BR',
          ),
        ],
      ),
      FestaEntity(
        id: 'carnaval-salvador',
        title: 'Carnaval de Salvador da Bahia',
        region: 'Salvador, Circuitos Barra-Ondina & Campo Grande',
        country: 'Brasil',
        dialect: 'pt_BR',
        seasonDate: 'Fevereiro',
        category: FestaCategory.carnaval,
        accentEmoji: '🥁',
        shortDescription:
            'A maior festa de rua participativa do mundo ao som ininterrupto dos trios elétricos e blocos afro.',
        fullDescription:
            'O Carnaval de Salvador é pura energia coletiva e ancestralidade musical afro-brasileira ao longo da costa atlântica. Em vez de arquibancadas fechadas, a festa acontece nas ruas e orlas, dividida em circuitos consagrados como o Dodô (Barra-Ondina) e o Osmar (Campo Grande). Caminhões titânicos de som chamados trios elétricos desfilam tocando axé, frevo e pagode baiano comandados por astros da música. Os foliões podem dançar dentro da corda de isolamento vestindo o "abadá" oficial ou brincar livremente do lado de fora na famosa "pipoca". Os blocos afros, como o Ilê Aiyê e o Olodum, e o afoxé Filhos de Gandhy trazem o ritmo sagrado dos tambores e mensagens de orgulho negro.',
        ritualsAndTraditions: [
          'Saída emocionante do Ilê Aiyê no Curuzu na noite de sábado',
          'Desfile solene com incenso e alfazema do afoxé Filhos de Gandhy vestidos de branco',
          'Descida do trio elétrico ao pôr do sol no Farol da Barra',
          'Pipoca pulando e vibrando em ondas sem cordas em torno dos trios',
          'Arrastão da Quarta-feira de Cinzas fechando a folia com chave de ouro',
        ],
        foodsAndDrinks: [
          'Acarajé quentinho servido na folha pelas baianas',
          'Abará com vatapá, caruru e camarão seco',
          'Água de coco verde gelada na praia',
          'Cravinho (infusão artesanal de cachaça com cravo e canela no Pelourinho)',
        ],
        audioSnippet:
            'Em Salvador, o trio elétrico arrasta a multidão na pipoca com o som poderoso dos tambores do Olodum.',
        vocabulary: [
          FestaVocabEntity(
            id: 'festa-trio-eletrico',
            termPt: 'Trio elétrico',
            translationRu: 'Трио элетрику (движущаяся звуковая платформа с оркестром)',
            definition:
                'Caminhão adaptado com poderosos amplificadores de som, iluminação e palco superior onde bandas e cantores tocam ao vivo pelas ruas.',
            exampleSentence:
                'O trio elétrico arrastou milhares de foliões cantando sucessos de axé até a madrugada.',
            dialect: 'pt_BR',
          ),
          FestaVocabEntity(
            id: 'festa-abada',
            termPt: 'Abadá',
            translationRu: 'Абада (фирменная майка-пропуск в блок)',
            definition:
                'Camiseta temática estilizada que funciona como ingresso e identificação para participar de um bloco fechado com cordas de segurança.',
            exampleSentence:
                'Os foliões customizam o abadá com tesoura, lantejoulas e fitas coloridas.',
            dialect: 'pt_BR',
          ),
          FestaVocabEntity(
            id: 'festa-pipoca',
            termPt: 'Pipoca',
            translationRu: 'Пипока (толпа на улице вне платных ограждений трио)',
            definition:
                'Massa popular de foliões que dança e acompanha os trios elétricos no espaço público fora das cordas dos blocos particulares.',
            exampleSentence:
                'Dançar na pipoca do trio elétrico é a experiência mais pura e democrática da folia baiana.',
            dialect: 'pt_BR',
          ),
        ],
      ),
      FestaEntity(
        id: 'santo-antonio-lisboa',
        title: 'Festas de Santo António em Lisboa',
        region: 'Lisboa, Bairros Históricos (Alfama, Mouraria, Bica)',
        country: 'Portugal',
        dialect: 'pt_PT',
        seasonDate: '12 e 13 de Junho',
        category: FestaCategory.santosPopulares,
        accentEmoji: '🐟',
        shortDescription:
            'A noite mais longa da capital portuguesa com aroma de sardinhas assadas no pão e vasos de manjerico.',
        fullDescription:
            'Na noite de 12 para 13 de junho, véspera do feriado municipal de Lisboa, a cidade transforma-se num imenso arraial a céu aberto. Nos becos e ruelas estreitas de Alfama, Madragoa, Bica e Mouraria, os moradores montam fogareiros às portas das casas para assar sardinhas frescas no carvão, servidas generosamente sobre uma fatia de pão de trigo ou broa de milho. As ruas são enfeitadas com balões, arcos e fitas de papel colorido. É tradição oferecer à pessoa amada um vaso de manjerico (manjericão miúdo) com uma cravina de papel e uma quadra popular rimada de amor. Na Avenida da Liberdade, realizam-se as famosas Marchas Populares, onde cada bairro histórico compete pelo título de melhor cortejo cantado e coreografado.',
        ritualsAndTraditions: [
          'Desfile grandioso das Marchas Populares na Avenida da Liberdade',
          'Casamentos de Santo António na Sé Catedral de Lisboa apadrinhados pelo município',
          'Troca de vasos de manjerico com versos de amor entre namorados',
          'Arraiais animados pelos bairros com música pimba até o nascer do sol',
          'Procissão solene de Santo António saindo da igreja vizinha à Sé',
        ],
        foodsAndDrinks: [
          'Sardinhas assadas na brasa pingando na fatia de pão',
          'Caldo verde tradicional com rodela de chouriço',
          'Bifanas no pão regadas com mostarda',
          'Vinho tinto e sangria fresca em copos de barro',
        ],
        audioSnippet:
            'Na noite de Santo António em Alfama, o cheiro a sardinha assada e a música das marchas tomam conta das vielas floridas.',
        vocabulary: [
          FestaVocabEntity(
            id: 'festa-manjerico',
            termPt: 'Manjerico',
            translationRu: 'Манжерику (горшочек мелколистного базилика с четверостишием)',
            definition:
                'Planta aromática da família do manjericão, de folhas miúdas e formato arredondado, oferecida aos pares românticos nos Santos Populares.',
            exampleSentence:
                'Nunca se deve cheirar o manjerico diretamente com o nariz, mas sim passar a palma da mão nas folhas.',
            dialect: 'pt_PT',
          ),
          FestaVocabEntity(
            id: 'festa-sardinha-assada',
            termPt: 'Sardinha assada',
            translationRu: 'Жареная сардина на гриле',
            definition:
                'Prato símbolo das noites de Santos Populares, assada inteira na brasa e comida sobre uma fatia de pão rústico.',
            exampleSentence:
                'A sardinha assada deve ser gorda e pingar o seu azeite natural na fatia de pão.',
            dialect: 'pt_PT',
          ),
          FestaVocabEntity(
            id: 'festa-marchas-populares',
            termPt: 'Marchas Populares',
            translationRu: 'Маршаш популяреш (костюмированные шествия районов Лиссабона)',
            definition:
                'Concurso e desfile cénico na Avenida da Liberdade onde cada bairro de Lisboa desfila com trajes e cantigas originais.',
            exampleSentence:
                'A marcha de Alfama venceu a competição com coreografias deslumbrantes e arcos floridos.',
            dialect: 'pt_PT',
          ),
        ],
      ),
      FestaEntity(
        id: 'sao-joao-porto',
        title: 'Festa de São João no Porto',
        region: 'Porto, Ribeira & Fontainhas',
        country: 'Portugal',
        dialect: 'pt_PT',
        seasonDate: '23 e 24 de Junho',
        category: FestaCategory.santosPopulares,
        accentEmoji: '🔨',
        shortDescription:
            'Marteladas bem-humoradas na cabeça, balões de ar quente no Douro e alho-porro nas Fontainhas.',
        fullDescription:
            'A noite de 23 de junho no Porto é considerada uma das festividades populares mais alegres, calorosas e participativas da Europa. Centenas de milhares de pessoas saem às ruas armadas com martelinhos plásticos coloridos que apitam estridentemente ao bater amigavelmente na cabeça dos passantes. Outro ritual ancestral é dar a cheirar alho-porro ou bater levemente com ramos de cidreira nas pessoas para desejar boa sorte. Ao soar da meia-noite, o céu sobre o Rio Douro ilumina-se com um espetáculo pirotécnico inesquecível lançado da Ponte D. Luís I e de barcaças, acompanhado por milhares de balões de papel de seda que sobem aos céus impulsionados pelo ar quente.',
        ritualsAndTraditions: [
          'Bater suavemente com os martelinhos de plástico na cabeça de conhecidos e estranhos',
          'Dar a cheirar a flor do alho-porro como símbolo ancestral de fertilidade e proteção',
          'Lançar balões de ar quente acesos com mechas de cera ao longo do Rio Douro',
          'Caminhada festiva a pé desde a Ribeira até às praias da Foz do Douro para ver o amanhecer',
          'Visita às tradicionais Cascatas Sanjoaninas montadas com miniaturas de barro',
        ],
        foodsAndDrinks: [
          'Sardinha assada com pimentos verdes tostados e broa de Avintes',
          'Fêveras de porco grelhadas na brasa',
          'Caldo verde reconfortante',
          'Vinho verde fresco e cerveja imperial',
        ],
        audioSnippet:
            'No São João do Porto, o céu enche-se de balões de papel e a Ribeira ecoa o som contagiante dos martelinhos de plástico.',
        vocabulary: [
          FestaVocabEntity(
            id: 'festa-martelinho',
            termPt: 'Martelinho de São João',
            translationRu: 'Пластиковый пищащий молоточек',
            definition:
                'Brinquedo de plástico flexível com fole sonoro usado para dar pancadinhas brincalhonas na cabeça dos foliões.',
            exampleSentence:
                'O martelinho de plástico substituiu os antigos ramos de alho-porro como brinquedo predileto das crianças e adultos.',
            dialect: 'pt_PT',
          ),
          FestaVocabEntity(
            id: 'festa-alho-porro',
            termPt: 'Alho-porro',
            translationRu: 'Лук-порей (традиционный стебель для благословения)',
            definition:
                'Planta bulbosa campestre com flor esférica, usada ancestralmente para roçar na cara dos transeuntes em sinal de boa sorte.',
            exampleSentence:
                'Os foliões mais velhos preferem passear pela Ribeira ostentando um comprido alho-porro.',
            dialect: 'pt_PT',
          ),
          FestaVocabEntity(
            id: 'festa-balao-sao-joao',
            termPt: 'Balão de São João',
            translationRu: 'Бумажный летающий фонарик (шар на горячем воздухе)',
            definition:
                'Balão feito de papel de seda com uma mecha incandescente que o faz ascender aos céus na noite festiva.',
            exampleSentence:
                'A meia-noite no Porto proporciona uma vista sublime com centenas de balões pontuando o céu sobre o Douro.',
            dialect: 'pt_PT',
          ),
        ],
      ),
      FestaEntity(
        id: 'festa-junina-caruaru',
        title: 'Festa Junina & São João do Nordeste',
        region: 'Caruaru (Pernambuco) & Campina Grande (Paraíba)',
        country: 'Brasil',
        dialect: 'pt_BR',
        seasonDate: 'Mês inteiro de Junho',
        category: FestaCategory.junina,
        accentEmoji: '🌽',
        shortDescription:
            'A maior celebração do interior nordestino com forró pé-de-serra, dança da quadrilha e quitutes de milho.',
        fullDescription:
            'As Festas Juninas no Nordeste do Brasil rivalizam com o Carnaval em tamanho, emoção e identidade cultural. Cidades como Caruaru e Campina Grande disputam o título de "Maior São João do Mundo", com palcos gigantescos, cidades cenográficas e arraiais que funcionam durante trinta dias consecutivos. Ao som do triângulo, da zabumba e da sanfona (acordeom) tocando forró pé-de-serra, baião e xote, grupos com trajes caipiras coloridos encenam a dança da quadrilha e o hilário casamento na roça. Ao redor das fogueiras de São João, saboreiam-se fartos quitutes preparados à base de milho da colheita recente, como pamonha, canjica, curau e bolo de milho.',
        ritualsAndTraditions: [
          'Acendimento ritual da fogueira de São João no dia 23 de junho',
          'Apresentações espetaculares dos festivais de quadrilhas juninas estilizadas',
          'Encenação cómica do Casamento na Roça com o noivo obrigado a casar pelo delegado',
          'Dança coladinha de forró a dois na poeira do terreiro ao som de Luiz Gonzaga',
          'Soltura de fogos de artifício e brincadeira da pescaria nas barracas',
        ],
        foodsAndDrinks: [
          'Pamonha doce e salgada cozida na própria palha do milho',
          'Canjica cremosa salpicada com canela em pó (mungunzá no Ceará)',
          'Quentão de cachaça com gengibre, maçã e especiarias',
          'Milho verde assado na brasa da fogueira com manteiga de garrafa',
        ],
        audioSnippet:
            'Ao som da sanfona e da zabumba, o forró esquenta o terreiro ao redor da fogueira de São João em Caruaru.',
        vocabulary: [
          FestaVocabEntity(
            id: 'festa-quadrilha',
            termPt: 'Quadrilha junina',
            translationRu: 'Кадриль / традиционный хороводный танец июньских праздников',
            definition:
                'Dança folclórica coletiva de origem europeia adaptada no Nordeste, coreografada em pares com comandos ritmados pelo marcador.',
            exampleSentence:
                'O marcador gritou "Olha a chuva! É mentira!" e todos os pares da quadrilha mudaram de direção.',
            dialect: 'pt_BR',
          ),
          FestaVocabEntity(
            id: 'festa-pamonha',
            termPt: 'Pamonha',
            translationRu: 'Памонья (пареное блюдо из свежей кукурузы в початке)',
            definition:
                'Massa cremosa de milho verde ralado misturada com leite de coco e açúcar ou queijo, envolta e cozida na casca do próprio milho.',
            exampleSentence:
                'Não há festa junina completa sem uma pamonha quentinha recheada com queijo coalho.',
            dialect: 'pt_BR',
          ),
          FestaVocabEntity(
            id: 'festa-quentao',
            termPt: 'Quentão',
            translationRu: 'Кентан (горячий глинтвейн на основе кашасы с имбирём)',
            definition:
                'Bebida quente aromática preparada com cachaça fervida com açúcar caramelizado, gengibre, cravo, canela e rodelas de laranja.',
            exampleSentence:
                'Uma caneca de quentão fumegante ajuda a espantar o friozinho das noites juninas.',
            dialect: 'pt_BR',
          ),
        ],
      ),
      FestaEntity(
        id: 'bumba-meu-boi-maranhao',
        title: 'Bumba Meu Boi do Maranhão',
        region: 'São Luís & Interior do Maranhão',
        country: 'Brasil',
        dialect: 'pt_BR',
        seasonDate: 'Junho e Julho',
        category: FestaCategory.folclore,
        accentEmoji: '🐂',
        shortDescription:
            'Patrimônio Cultural Imaterial da UNESCO: auto popular cantado que narra a morte e o renascimento do boi.',
        fullDescription:
            'Reconhecido como Patrimônio Cultural Imaterial da Humanidade pela UNESCO, o Bumba Meu Boi é a mais impressionante ópera popular a céu aberto do Brasil. A celebração reúne influências indígenas, africanas e portuguesas num drama teatral cantado e dançado. A trama relata a história de Catirina, mulher grávida do escravizado Pai Francisco, que sente o desejo incontrolável de comer a língua do boi mais bonito da fazenda. O boi morre, o capataz ameaça Pai Francisco, mas xamãs e pajés indígenas realizam curas místicas e ressuscitam o boi sagrado em meio a uma apoteose festiva. Os grupos dividem-se em "sotaques" distintos (matraca, zabumba, orquestra, costa de mão) e encantam arraiais com figurinos bordados com milhares de canutilhos reluzentes.',
        ritualsAndTraditions: [
          'Ensaio geral dos grupos no mês de maio',
          'Batismo sagrado do boi perante os santos padroeiros no dia 23 de junho',
          'Apresentações nos arraiais de São Luís ao som hipnótico das matracas',
          'Dança dos Cazumbás com máscaras enigmáticas de animais e chocalhos na cintura',
          'Morte simbólica do boi em julho com partilha festiva e promessa de renascimento no ano seguinte',
        ],
        foodsAndDrinks: [
          'Arroz de cuxá típico com vinagreira, camarão seco e gergelim',
          'Torta de camarão maranhense com queijo e ervas',
          'Guaraná Jesus geladinho com sua cor rosa característica',
          'Juçara fresca (versão maranhense do açaí) com farinha d\'água',
        ],
        audioSnippet:
            'O som compassado das matracas e o brilho dos bordados anunciam a chegada triunfal do Bumba Meu Boi.',
        vocabulary: [
          FestaVocabEntity(
            id: 'festa-matraca',
            termPt: 'Matraca',
            translationRu: 'Матрака (деревянные бруски-трещотки для отбивания ритма)',
            definition:
                'Dois pequenos pedaços de madeira maciça que os foliões batem um contra o outro para criar o ritmo rimbombante característico do boi.',
            exampleSentence:
                'Milhares de pessoas batem matracas juntas no Arraial do Ceprama, criando um som eletrizante.',
            dialect: 'pt_BR',
          ),
          FestaVocabEntity(
            id: 'festa-toada',
            termPt: 'Toada',
            translationRu: 'Тоада (традиционная поэтическая песня Бумба-меу-бой)',
            definition:
                'Canção poética e cadenciada composta pelos cantadores para homenagear o boi, os santos e a beleza do Maranhão.',
            exampleSentence:
                'O cantador entoou a nova toada e a plateia acompanhou em coro agitando os braços.',
            dialect: 'pt_BR',
          ),
          FestaVocabEntity(
            id: 'festa-sotaque',
            termPt: 'Sotaque do Boi',
            translationRu: 'Сотаки быка (стиль исполнения / ритмическая школа)',
            definition:
                'Estilo regional que define os instrumentos musicais, o ritmo, as vestimentas e as coreografias de cada grupo de Bumba Meu Boi.',
            exampleSentence:
                'O Bumba Meu Boi da Maioba é o mais célebre representante do sotaque de matraca.',
            dialect: 'pt_BR',
          ),
        ],
      ),
    ];
  }

  static List<FestaTraditionEntity> getTraditions() {
    return const [
      FestaTraditionEntity(
        id: 'trad-manjerico',
        title: 'O Ritual do Manjerico e das Quadras de Amor',
        festaName: 'Festas de Santo António em Lisboa',
        region: 'Lisboa, Portugal',
        icon: '🪴',
        description:
            'Oferecer um pequeno vaso de manjerico à pessoa amada é um costume centenário lisboeta nas noites de Santo António, santo casamenteiro.',
        instructions: [
          'Adquira um vaso viçoso de manjerico com formato redondo perfeito.',
          'Escolha ou componha uma quadra poética rimada de quatro versos em papel recortado.',
          'Espete no topo do vaso uma cravina colorida de papel crepom segurando a quadra.',
          'Ao oferecer, ensine o parceiro a não cheirar direto com o nariz (a tradição diz que a planta seca), mas sim acariciar as folhas com a palma e aspirar a mão.',
        ],
        curiousFact:
            'Diz a crendice popular que o manjerico recebido no Santo António deve ser cuidado com amor durante todo o ano para que o romance floresça.',
      ),
      FestaTraditionEntity(
        id: 'trad-martelinhos',
        title: 'A Batalha dos Martelinhos e Alho-Porro',
        festaName: 'Festa de São João no Porto',
        region: 'Porto, Portugal',
        icon: '🔨',
        description:
            'Bater com martelinhos plásticos e dar a cheirar a flor do alho-porro a quem passa na rua é o ritual mais divertido do Porto.',
        instructions: [
          'Compre um martelo de plástico com fole sonoro nas bancas da Baixa ou da Ribeira.',
          'Caminhe pelas ruas cumprimentando amigos e desconhecidos com uma pancadinha suave na cabeça.',
          'Se encontrar foliões com alho-porro, incline a cabeça para cheirar a flor e desejar saúde e fartura.',
          'Responda sempre com um sorriso sincero, pois as marteladas são gestos de carinho e afeto popular.',
        ],
        curiousFact:
            'O martelinho de plástico foi inventado na década de 1960 por um fabricante de brinquedos portuense e tornou-se instantaneamente febre da festa.',
      ),
      FestaTraditionEntity(
        id: 'trad-casamento-roca',
        title: 'O Casamento na Roça e a Quadrilha Junina',
        festaName: 'Festa Junina & São João do Nordeste',
        region: 'Nordeste do Brasil',
        icon: '👰',
        description:
            'Teatralização cômica do casamento forçado pelo pai da noiva grávida, seguida pela dança animada da quadrilha.',
        instructions: [
          'Vista roupas estampadas de xadrez com retalhos coloridos, chapéu de palha e maquiagem de sardas ou bigode caipira.',
          'Participe da encenação com o padre, o noivo fujão, o delegado armado e o pai enfurecido da noiva.',
          'Após o "sim" arranjado, forme os pares e siga os comandos divertidos do marcador ("Anarriê!", "Alavantú!", "Olha a cobra!").',
          'Dance aos passos do balancê, túnel de braços e grande roda ao redor da fogueira.',
        ],
        curiousFact:
            'Os termos do marcador da quadrilha ("alavantú", "anarriê") são corruptelas populares dos comandos das antigas quadrilhas da corte francesa ("en avant tous", "en arrière").',
      ),
      FestaTraditionEntity(
        id: 'trad-batismo-boi',
        title: 'O Batismo e a Ressurreição do Bumba Meu Boi',
        festaName: 'Bumba Meu Boi do Maranhão',
        region: 'Maranhão, Brasil',
        icon: '🐂',
        description:
            'Cerimônia de consagração e promessa de renascimento que une a fé católica, ritos indígenas e religiosidade de matriz africana.',
        instructions: [
          'Participe da bênção do boi na noite de São João na igreja com padrinhos e madrinhas dedicados.',
          'Acompanhe o cortejo com o cantador puxando as toadas e centenas de pares de matracas marcando o compasso.',
          'Presencie o momento dramático onde o pajé toca o maracá e sopra fumaça para devolver a vida ao boi.',
          'Celebre a ressurreição do animal com danças coletivas até o amanhecer.',
        ],
        curiousFact:
            'A carcaça do boi é feita de madeira leve e coberta com um manto bordado com mais de cem mil miçangas e canutilhos brilhantes.',
      ),
    ];
  }

  static List<FestaQuizQuestion> getQuizzes() {
    return const [
      FestaQuizQuestion(
        id: 'quiz-festa-1',
        question:
            'Como se chama em Salvador a multidão que acompanha os trios elétricos no espaço público da rua, sem comprar o abadá do bloco fechado?',
        options: [
          'A pipoca',
          'A comissão de frente',
          'O cordão de ouro',
          'A bateria mirim',
        ],
        correctIndex: 0,
        explanation:
            'Chama-se "pipoca" a multidão de foliões que pula livremente na rua fora das cordas dos blocos com trios elétricos.',
        dialect: 'pt_BR',
      ),
      FestaQuizQuestion(
        id: 'quiz-festa-2',
        question:
            'O que é oferecido à pessoa amada na noite de Santo António em Lisboa, acompanhado de uma cravina de papel e uma quadra rimada?',
        options: [
          'Um vaso de manjerico',
          'Um martelinho de plástico',
          'Uma pamonha de milho verde',
          'Um cacho de uvas moscatel',
        ],
        correctIndex: 0,
        explanation:
            'O manjerico (manjericão miúdo) com uma quadra popular de amor é o presente tradicional de Santo António na capital portuguesa.',
        dialect: 'pt_PT',
      ),
      FestaQuizQuestion(
        id: 'quiz-festa-3',
        question:
            'Qual é o brinquedo característico usado para bater carinhosamente na cabeça das pessoas durante a festa de São João no Porto?',
        options: [
          'Martelinho de plástico com fole sonoro',
          'Reco-reco de madeira',
          'Pandeiro de couro',
          'Espada de palha de milho',
        ],
        correctIndex: 0,
        explanation:
            'O martelinho de plástico que apita ao bater na cabeça dos transeuntes é a marca registrada e irreverente do São João do Porto.',
        dialect: 'pt_PT',
      ),
      FestaQuizQuestion(
        id: 'quiz-festa-4',
        question:
            'Qual prato tradicional das Festas Juninas no Brasil é preparado com milho verde ralado cozido na própria palha do milho?',
        options: [
          'Pamonha',
          'Sardinha assada',
          'Arroz de cuxá',
          'Pastel de bacalhau',
        ],
        correctIndex: 0,
        explanation:
            'A pamonha, doce ou salgada, é preparada com milho verde fresco envolto na palha e cozido em água fervente.',
        dialect: 'pt_BR',
      ),
      FestaQuizQuestion(
        id: 'quiz-festa-5',
        question:
            'No Carnaval do Rio de Janeiro, qual grupo é o primeiro a entrar na avenida para apresentar e saudar o público com uma coreografia cênica?',
        options: [
          'A comissão de frente',
          'A velha guarda',
          'A ala das baianas',
          'A ala dos passistas',
        ],
        correctIndex: 0,
        explanation:
            'A comissão de frente abre o desfile de cada escola de samba, sintetizando o enredo e impressionando o júri com teatro e dança.',
        dialect: 'pt_BR',
      ),
      FestaQuizQuestion(
        id: 'quiz-festa-6',
        question:
            'Que instrumento de percussão feito com dois pedaços de madeira maciça dá o ritmo acelerado e potente ao Bumba Meu Boi do Maranhão?',
        options: [
          'A matraca',
          'O agogô',
          'A cuíca',
          'O berimbau',
        ],
        correctIndex: 0,
        explanation:
            'As matracas são tocadas batendo um bloco de madeira no outro, gerando a parede sonora eletrizante do boi de matraca maranhense.',
        dialect: 'pt_BR',
      ),
    ];
  }
}
