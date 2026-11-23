import '../../domain/entities/architecture_entities.dart';

class ArchitectureSeedData {
  static List<ArchitecturalMonumentEntity> getMonuments() {
    return const [
      ArchitecturalMonumentEntity(
        id: 'catedral-brasilia',
        title: 'Catedral Metropolitana de Brasília',
        city: 'Brasília, Distrito Federal',
        country: 'Brasil',
        dialect: 'pt_BR',
        yearCompleted: '1970',
        architect: 'Oscar Niemeyer',
        styleId: 'modernismo-br',
        styleName: 'Modernismo Brasileiro & Futurismo',
        category: ArchitectureCategory.modernUrban,
        accentEmoji: '⛪',
        shortDescription:
            'Obra-prima de concreto armado em forma de coroa de espinhos ou mãos erguidas em oração.',
        fullDescription:
            'Inaugurada em 1970 no coração do Plano Piloto de Brasília, a Catedral Metropolitana Nossa Senhora Aparecida é um dos maiores símbolos da arquitetura moderna mundial. A sua estrutura circular em concreto armado apoia-se em 16 colunas hiperboloides com curvatura elegante de noventa toneladas cada. Os visitantes entram por uma galeria subterrânea escura e emergem num salão inundado de luz natural através de imensos vitrais azuis, verdes e brancos criados pela artista Marianne Peretti. No centro do teto, flutuam três anjos escultóricos de Alfredo Ceschiatti suspensos por cabos de aço.',
        architecturalFeatures: [
          '16 colunas hiperboloides simétricas de concreto armado',
          'Vitrais em fibra de vidro com tons de azul e esmeralda de Marianne Peretti',
          'Acesso subterrâneo gerando contraste entre escuridão e iluminação celeste',
          'Espelho d\'água reflexivo que ajuda na climatização do ar seco do Cerrado',
          'Quatro esculturas de bronze dos Evangelistas na entrada externa de Dante Croce',
        ],
        historicalSignificance:
            'Marco fundador da nova capital federal, sintetizou a utopia modernista brasileira e rendeu a Oscar Niemeyer o cobiçado Prêmio Pritzker de Arquitetura em 1988.',
        audioSnippet:
            'A Catedral de Brasília ergue-se com dezesseis colunas curvas de concreto armado, criando uma atmosfera etérea iluminada por vitrais monumentais.',
        vocabulary: [
          ArchitectVocabEntity(
            id: 'arch-concreto-armado',
            termPt: 'Concreto armado',
            translationRu: 'Железобетон',
            definition:
                'Material de construção composto por concreto reforçado com armaduras de barras de aço.',
            exampleSentence:
                'Oscar Niemeyer revolucionou o uso do concreto armado com curvas poéticas e arrojadas.',
            dialect: 'pt_BR',
            dialectNote: 'Em Portugal diz-se predominantemente "betão armado".',
          ),
          ArchitectVocabEntity(
            id: 'arch-pilotis',
            termPt: 'Pilotis',
            translationRu: 'Колонны-опоры первого этажа',
            definition:
                'Pilares estruturais que sustentam uma edificação, deixando o piso térreo livre para circulação pública.',
            exampleSentence:
                'Os blocos residenciais das superquadras de Brasília são elevados sobre pilotis.',
            dialect: 'all',
          ),
          ArchitectVocabEntity(
            id: 'arch-plano-piloto',
            termPt: 'Plano Piloto',
            translationRu: 'Генеральный план города (Бразилиа)',
            definition:
                'Projeto urbanístico estruturante da cidade concebido pelo arquiteto e urbanista Lúcio Costa.',
            exampleSentence:
                'O Plano Piloto de Brasília foi desenhado em formato de avião ou cruz.',
            dialect: 'pt_BR',
          ),
        ],
      ),
      ArchitecturalMonumentEntity(
        id: 'mosteiro-jeronimos',
        title: 'Mosteiro dos Jerónimos',
        city: 'Lisboa, Santa Maria de Belém',
        country: 'Portugal',
        dialect: 'pt_PT',
        yearCompleted: '1501–1601',
        architect: 'Diogo de Boitaca & João de Castilho',
        styleId: 'manuelino',
        styleName: 'Estilo Manuelino (Gótico Tardio Português)',
        category: ArchitectureCategory.monument,
        accentEmoji: '🏛️',
        shortDescription:
            'Apogeu do manuelino erguido com riquezas das Grandes Navegações e talhado na nobre pedra lioz.',
        fullDescription:
            'Construído por ordem do rei D. Manuel I no início do século XVI para comemorar a viagem de Vasco da Gama à Índia, o Mosteiro dos Jerónimos é o expoente máximo da arquitetura manuelina. As suas paredes e colunas de pedra lioz exibem uma profusão minuciosa de elementos decorativos marítimos: cabos de marinharia, cordas esculpidas em pedra, astrolábios armilares, motivos botânicos e animais exóticos. A igreja de Santa Maria de Belém ostenta uma colossal abóbada em cruzaria de ogivas sustentada por finos pilares octogonais que desafiaram as leis da física da época e resistiram bravamente ao Terramoto de 1755.',
        architecturalFeatures: [
          'Abóbada única em cruzaria de ogivas sem pilares intermédios na nave principal',
          'Claustro de dois andares com decoração filigranada em pedra lioz',
          'Elementos marítimos esculpidos: esferas armilares, cabos náuticos e nós',
          'Portal Sul monumental com esculturas de santos e do Infante D. Henrique',
          'Túmulos memoriais de Luís de Camões e Vasco da Gama na igreja',
        ],
        historicalSignificance:
            'Classificado como Património Mundial da UNESCO em 1983, é a principal jóia da Era dos Descobrimentos e testemunho da expansão marítima portuguesa.',
        audioSnippet:
            'O Mosteiro dos Jerónimos é a máxima expressão do estilo manuelino, com claustros lavrados em pedra lioz e motivos náuticos esculpidos.',
        vocabulary: [
          ArchitectVocabEntity(
            id: 'arch-pedra-lioz',
            termPt: 'Pedra lioz',
            translationRu: 'Известняк лиоз (португальский мраморовидный камень)',
            definition:
                'Calcário de tom bege claro e alta densidade, típico da região de Lisboa e Sintra.',
            exampleSentence:
                'Os Jerónimos e a Torre de Belém foram inteiramente esculpidos na resistente pedra lioz.',
            dialect: 'pt_PT',
          ),
          ArchitectVocabEntity(
            id: 'arch-abobada-ogival',
            termPt: 'Abóbada de nervuras',
            translationRu: 'Нервюрный свод',
            definition:
                'Estrutura em arco sustentada por arcos diagonais cruzados, característica do estilo gótico e manuelino.',
            exampleSentence:
                'A audaciosa abóbada de nervuras da igreja surpreendeu os engenheiros renascentistas.',
            dialect: 'all',
          ),
          ArchitectVocabEntity(
            id: 'arch-claustro',
            termPt: 'Claustro',
            translationRu: 'Клуатр (внутренний монастырский двор)',
            definition:
                'Pátio interno cercado por galerias cobertas com arcadas, destinado ao recolhimento e oração.',
            exampleSentence:
                'O claustro do mosteiro é considerado um dos mais belos e harmoniosos da Europa.',
            dialect: 'all',
          ),
        ],
      ),
      ArchitecturalMonumentEntity(
        id: 'casa-da-musica',
        title: 'Casa da Música',
        city: 'Porto, Boavista',
        country: 'Portugal',
        dialect: 'pt_PT',
        yearCompleted: '2005',
        architect: 'Rem Koolhaas (OMA)',
        styleId: 'escola-porto',
        styleName: 'Arquitetura Contemporânea & Desconstrutivismo',
        category: ArchitectureCategory.contemporary,
        accentEmoji: '🎼',
        shortDescription:
            'Audacioso poliedro facetado em betão branco com acústica primorosa e vidro ondulado.',
        fullDescription:
            'Projetada pelo arquiteto holandês Rem Koolhaas para o evento Porto Capital Europeia da Cultura 2001 e finalizada em 2005 na Rotunda da Boavista, a Casa da Música redefiniu o panorama arquitetónico contemporâneo de Portugal. Com a sua forma poliédrica esculpida em betão branco e rasgada por enormes superfícies de vidro ondulado, o edifício convida o exterior para dentro das salas de concerto. No seu interior, a Sala Suggia destaca-se pela acústica impecável, revestimentos dourados de madeira com padrões ampliados e uma surpreendente sala VIP forrada a painéis de azulejos tradicionais portugueses pintados à mão.',
        architecturalFeatures: [
          'Forma monolítica poliédrica sem fachadas tradicionais convencionais',
          'Uso extensivo de betão branco à vista e estruturas de aço inovadoras',
          'Paredes de vidro acústico ondulado com 6 metros de altura',
          'Sala VIP com diálogo entre desconstrutivismo e azulejos barrocos',
          'Plataforma pública em travertino que se funde com a praça envolvente',
        ],
        historicalSignificance:
            'Eleito pelo jornal The New York Times como um dos edifícios de salas de concerto mais importantes do último século.',
        audioSnippet:
            'A Casa da Música no Porto destaca-se pelo seu volume arrojado em betão branco, paredes de vidro ondulado e salas com acústica lendária.',
        vocabulary: [
          ArchitectVocabEntity(
            id: 'arch-betao-vista',
            termPt: 'Betão à vista',
            translationRu: 'Открытый бетон (брутализм/чистый бетон)',
            definition:
                'Acabamento construtivo em que a superfície do concreto permanece aparente sem revestimentos.',
            exampleSentence:
                'A Casa da Música exibe superfícies geométricas imponentes em betão à vista.',
            dialect: 'pt_PT',
            dialectNote: 'No Brasil utiliza-se a expressão "concreto aparente".',
          ),
          ArchitectVocabEntity(
            id: 'arch-vidro-ondulado',
            termPt: 'Vidro ondulado',
            translationRu: 'Волнистое акустическое стекло',
            definition:
                'Painéis envidraçados curvados que combinam resistência mecânica e propriedades de difusão acústica.',
            exampleSentence:
                'O vidro ondulado permite que a luz natural invada a grande sala de espetáculos.',
            dialect: 'all',
          ),
          ArchitectVocabEntity(
            id: 'arch-isolamento-acustico',
            termPt: 'Isolamento acústico',
            translationRu: 'Звукоизоляция / акустическая защита',
            definition:
                'Conjunto de técnicas e materiais projetados para atenuar a propagação de ruídos sonoros indesejados.',
            exampleSentence:
                'O isolamento acústico da sala principal garante silêncio absoluto mesmo junto ao trânsito.',
            dialect: 'all',
          ),
        ],
      ),
      ArchitecturalMonumentEntity(
        id: 'pelourinho-salvador',
        title: 'Pelourinho & Igreja de São Francisco',
        city: 'Salvador, Bahia',
        country: 'Brasil',
        dialect: 'pt_BR',
        yearCompleted: '1723',
        architect: 'Manuel de Andrade & Frei Jerônimo da Graça',
        styleId: 'barroco-colonial',
        styleName: 'Barroco Baiano & Talha Dourada',
        category: ArchitectureCategory.colonial,
        accentEmoji: '✨',
        shortDescription:
            'Apogeu do ouro colonial em Salvador com fachadas pastéis e interiores folheados a ouro.',
        fullDescription:
            'O Centro Histórico de Salvador e o Largo do Pelourinho formam o mais rico conjunto de arquitetura civil e religiosa barroca colonial das Américas. A Igreja e Convento de São Francisco, conhecida como a "Igreja de Ouro", possui um interior inteiramente revestido por talha dourada barroca em madeira de jacarandá recoberta com folhas de ouro, exibindo anjos, volutas, flores e cariátides. No claustro conventual, um magnífico acervo de trinta e sete painéis de azulejos azuis e brancos encomendados em Lisboa no século XVIII reproduz sentenças latinas inspiradas nos emblemas do filósofo Horácio.',
        architecturalFeatures: [
          'Fachada em pedra de cantaria nobre com duas torres sineiras piramidais',
          'Interior quase inteiramente revestido de talha dourada rococó e barroca',
          'Conjunto de azulejos portugueses monocromáticos com fábulas e alegorias morais',
          'Casario colonial ao redor com ladeiras de calçamento pé-de-moleque',
          'Janelas com gelosias e balcões de ferro forjado de época',
        ],
        historicalSignificance:
            'Primeira capital do Brasil colonial e patrimônio da humanidade da UNESCO desde 1985, simbolizando o sincretismo e a ancestralidade baiana.',
        audioSnippet:
            'A Igreja de São Francisco em Salvador impressiona pela suntuosa talha dourada no interior e pelo magnífico claustro forrado de azulejos azuis.',
        vocabulary: [
          ArchitectVocabEntity(
            id: 'arch-talha-dourada',
            termPt: 'Talha dourada',
            translationRu: 'Золочёная резьба по дереву',
            definition:
                'Técnica escultórica em madeira ricamente entalhada e recoberta com finíssimas lâminas de ouro.',
            exampleSentence:
                'A talha dourada das igrejas de Salvador reflete a imensa riqueza do período colonial.',
            dialect: 'all',
          ),
          ArchitectVocabEntity(
            id: 'arch-frontao',
            termPt: 'Frontão',
            translationRu: 'Фронтон',
            definition:
                'Elemento arquitetônico de remate superior triangular ou curvo colocado sobre fachadas ou portais.',
            exampleSentence:
                'O frontão barroco da igreja é ornado com volutas esculpidas e cruz central.',
            dialect: 'all',
          ),
          ArchitectVocabEntity(
            id: 'arch-pe-de-moleque',
            termPt: 'Calçamento pé-de-moleque',
            translationRu: 'Мостовая из булыжника неравномерной формы',
            definition:
                'Tipo rústico de pavimentação feito com pedras redondas de rio assentadas em terra.',
            exampleSentence:
                'As ladeiras íngremes do Pelourinho são cobertas pelo clássico calçamento pé-de-moleque.',
            dialect: 'pt_BR',
            dialectNote: 'Em Portugal o equivalente comum é a "calçada portuguesa".',
          ),
        ],
      ),
      ArchitecturalMonumentEntity(
        id: 'teatro-amazonas',
        title: 'Teatro Amazonas',
        city: 'Manaus, Amazonas',
        country: 'Brasil',
        dialect: 'pt_BR',
        yearCompleted: '1896',
        architect: 'Celestial Sacardim & Gabinete Português',
        styleId: 'barroco-colonial',
        styleName: 'Ecletismo & Belle Époque Amazônica',
        category: ArchitectureCategory.monument,
        accentEmoji: '🎭',
        shortDescription:
            'A opulência da era da borracha no coração da selva com cúpula de 36 mil azulejos.',
        fullDescription:
            'Erguido no final do século XIX durante o faustoso Ciclo da Borracha na Amazônia, o Teatro Amazonas personifica o requinte da Belle Époque europeia transplantado para a floresta equatorial. A sua famosa cúpula externa é composta por trinta e seis mil peças de cerâmica vidrada importadas da Alsácia, organizadas nas cores da bandeira nacional brasileira (verde, amarela, azul e branca). O salão de espetáculos possui quatro pavimentos de camarotes com ferragens de ferro fundido de Glasgow, teto abobadado pintado por Crispim do Amaral e assoalho nobre com marchetaria combinando pau-brasil, jacarandá e pau-marfim.',
        architecturalFeatures: [
          'Cúpula monumental com mosaico cerâmico vidrado multicolorido',
          'Piso de marchetaria com madeiras nobres amazônicas sem uso de pregos ou cola',
          'Colunas de ferro fundido encomendadas nas fundições escocesas de Glasgow',
          'Cortina de pano de boca com a alegoria da "Junção das Águas dos Rios Negro e Solimões"',
          'Espelhos de cristal e lustres requintados de Murano na Sala de Espelhos',
        ],
        historicalSignificance:
            'Tombado como Patrimônio Histórico Nacional, recebe óperas internacionais e preserva o legado cultural cosmopolita da Amazônia.',
        audioSnippet:
            'O Teatro Amazonas simboliza o fausto da borracha em Manaus, com sua cúpula reluzente e chão requintado de marchetaria na selva.',
        vocabulary: [
          ArchitectVocabEntity(
            id: 'arch-cupula',
            termPt: 'Cúpula',
            translationRu: 'Купол',
            definition:
                'Estrutura hemisférica ou curvada que cobre o topo de um edifício ou rotunda.',
            exampleSentence:
                'A cúpula do Teatro Amazonas brilha sob a intensa luz solar equatorial.',
            dialect: 'all',
          ),
          ArchitectVocabEntity(
            id: 'arch-marchetaria',
            termPt: 'Marchetaria',
            translationRu: 'Маркетри (мозаика из ценных пород дерева)',
            definition:
                'Arte ou técnica de embutir pedaços de madeiras nobres coloridas para formar desenhos decorativos.',
            exampleSentence:
                'O piso do salão de espetáculos é um dos mais primorosos trabalhos de marchetaria do mundo.',
            dialect: 'all',
          ),
          ArchitectVocabEntity(
            id: 'arch-camarotes',
            termPt: 'Camarotes',
            translationRu: 'Ложи (в театре или оперном зале)',
            definition:
                'Compartimentos reservados nas ordens superiores de um teatro com vista privilegiada para o palco.',
            exampleSentence:
                'Os quatro níveis de camarotes acomodavam a elite dos seringalistas manauaras.',
            dialect: 'all',
          ),
        ],
      ),
      ArchitecturalMonumentEntity(
        id: 'palacio-pena',
        title: 'Palácio Nacional da Pena',
        city: 'Sintra, Lisboa',
        country: 'Portugal',
        dialect: 'pt_PT',
        yearCompleted: '1854',
        architect: 'Wilhelm Ludwig von Eschwege & D. Fernando II',
        styleId: 'manuelino',
        styleName: 'Romantismo Revivalista do Século XIX',
        category: ArchitectureCategory.monument,
        accentEmoji: '🏰',
        shortDescription:
            'Fantasia romântica no topo da serra mesclando neo-manuelino, mourisco e torres coloridas.',
        fullDescription:
            'Erguido no cume escarpado da Serra de Sintra sobre as ruínas de um mosteiro jerónimo quinhentista danificado pelo terramoto, o Palácio da Pena é o expoente máximo do Romantismo arquitetónico europeu do século XIX. Concebido pelo rei-artista D. Fernando II de Saxe-Coburgo-Gota em colaboração com o barão alemão Eschwege, o palácio é uma colagem deliberadamente exótica e pitoresca de referências revivalistas: torres cilíndricas cor-de-rosa e amarelas, ameias defensivas medievais, arcos neo-mouriscos em ferradura e o célebre Pórtico do Tritão, uma monstruosa figura mitológica meio-homem, meio-peixe sustentando uma janela neo-manuelina.',
        architecturalFeatures: [
          'Pórtico do Tritão alegórico emergindo de uma concha sobre ramos de videira',
          'Policromia viva combinando tons intensos de ocre amarelo e rosa terracota',
          'Mistura estilística de gótico, neo-manuelino, neo-árabe e renascentista',
          'Caminho de ronda com ameias medievais e vistas para o Oceano Atlântico',
          'Parque circundante exuberante com espécies arbóreas trazidas dos quatro cantos do globo',
        ],
        historicalSignificance:
            'Inspirador dos castelos de conto de fadas da Europa romântica (como Neuschwanstein) e Património Mundial da UNESCO na Paisagem Cultural de Sintra.',
        audioSnippet:
            'O Palácio da Pena em Sintra é um castelo dos sonhos com cores vibrantes, torres góticas e o enigmático Pórtico do Tritão.',
        vocabulary: [
          ArchitectVocabEntity(
            id: 'arch-ameias',
            termPt: 'Ameias',
            translationRu: 'Зубцы крепостной стены (мерлоны)',
            definition:
                'Aberturas e parapeitos dentados no topo de muralhas ou torres para vigilância e defesa.',
            exampleSentence:
                'O visitante pode passear pelo adarve cercado por ameias coloridas no Palácio da Pena.',
            dialect: 'all',
          ),
          ArchitectVocabEntity(
            id: 'arch-estilo-mourisco',
            termPt: 'Estilo mourisco',
            translationRu: 'Мавританский стиль / нео-мудехар',
            definition:
                'Estilo influenciado pelas formas e ornamentos da arte islâmica e árabe na Península Ibérica.',
            exampleSentence:
                'Os arcos em ferradura do pátio interno remetem diretamente ao estilo mourisco.',
            dialect: 'all',
          ),
          ArchitectVocabEntity(
            id: 'arch-torre-sineira',
            termPt: 'Torre sineira',
            translationRu: 'Колокольня',
            definition:
                'Torre erguida para abrigar sinos, pontuando a silhueta das cidades históricas.',
            exampleSentence:
                'A torre sineira amarela do palácio é visível desde a vila de Sintra.',
            dialect: 'all',
          ),
        ],
      ),
    ];
  }

  static List<ArchitecturalStyleEntity> getStyles() {
    return const [
      ArchitecturalStyleEntity(
        id: 'manuelino',
        name: 'Estilo Manuelino (Gótico Tardio)',
        period: 'Séculos XV – XVI (Era dos Descobrimentos)',
        icon: '🧭',
        description:
            'O estilo arquitetônico mais exclusivo de Portugal, nascido no reinado de D. Manuel I. Combina estruturas góticas com rica ornamentação naturalista e elementos marítimos alusivos à expansão marítima ultramarina.',
        keyCharacteristics: [
          'Cordas esculpidas em pedra, cabos náuticos e nós marítimos',
          'Esferas armilares e cruzes da Ordem de Cristo',
          'Motivos botânicos exuberantes: folhas de louro, alcachofras e algas marinhas',
          'Arcos polilobados e colunas torsas imitando troncos de árvores',
        ],
        prominentExamples: [
          'Mosteiro dos Jerónimos (Lisboa)',
          'Torre de Belém (Lisboa)',
          'Janela do Capítulo do Convento de Cristo (Tomar)',
          'Mosteiro da Batalha (Capelas Imperfeitas)',
        ],
      ),
      ArchitecturalStyleEntity(
        id: 'modernismo-br',
        name: 'Modernismo Brasileiro & Concreto Armado',
        period: 'Décadas de 1930 – 1970',
        icon: '📐',
        description:
            'Uma das mais influentes escolas de arquitetura do século XX, liderada por Oscar Niemeyer, Lúcio Costa e Affonso Eduardo Reidy. Caracteriza-se pela exploração plástica das curvas no concreto armado e harmonia com a luz tropical.',
        keyCharacteristics: [
          'Uso plástico e poético de curvas sinuosas no concreto armado',
          'Elevação dos edifícios sobre pilotis, liberando o espaço térreo para pedestres',
          'Fachadas livres com brises-soleil (quebra-sóis) e amplas vidraças',
          'Integração com painéis artísticos de azulejos (Athos Bulcão, Portinari) e jardins tropicais (Burle Marx)',
        ],
        prominentExamples: [
          'Catedral Metropolitana e Congresso Nacional (Brasília)',
          'Igreja de São Francisco de Assis na Pampulha (Belo Horizonte)',
          'Museu de Arte Contemporânea - MAC (Niterói)',
          'Edifício Copan e MASP (São Paulo)',
        ],
      ),
      ArchitecturalStyleEntity(
        id: 'barroco-colonial',
        name: 'Barroco & Rococó Colonial',
        period: 'Séculos XVII – XVIII',
        icon: '⚜️',
        description:
            'Floresceu nas ricas cidades coloniais impulsionado pelos ciclos do açúcar no Nordeste e do ouro em Minas Gerais. Destaca-se pelo contraste entre fachadas de cantaria e interiores feéricos cobertos de talha dourada.',
        keyCharacteristics: [
          'Talha dourada em madeira recobrindo altares e tetos com profusão de anjos',
          'Fachadas com frontões curvilíneos imponentes e torres sineiras simétricas',
          'Paredes decoradas com azulejos portugueses barrocos em azul e branco',
          'Uso expressivo de pedra-sabão em esculturas e pórticos (obra de Aleijadinho)',
        ],
        prominentExamples: [
          'Igreja de São Francisco no Pelourinho (Salvador)',
          'Igreja de São Francisco de Assis (Ouro Preto)',
          'Santuário do Bom Jesus de Matosinhos (Congonhas)',
          'Mosteiro de São Bento (Rio de Janeiro)',
        ],
      ),
      ArchitecturalStyleEntity(
        id: 'escola-porto',
        name: 'Escola do Porto & Arquitetura Contemporânea',
        period: 'Século XX – Atualidade',
        icon: '🏢',
        description:
            'Corrente arquitetônica portuguesa de renome mundial, laureada com dois Prêmios Pritzker (Álvaro Siza Vieira e Eduardo Souto de Moura). Pauta-se pelo rigor formal, respeito ao sítio geográfico, economia de meios e pureza espacial.',
        keyCharacteristics: [
          'Linhas puras, volumes geométricos claros e diálogo silencioso com a paisagem',
          'Valorização da luz natural como elemento construtivo fundamental',
          'Uso honesto dos materiais: granito, mármore, madeira e betão aparente',
          'Reinterpretação contemporânea de elementos ancestrais portugueses',
        ],
        prominentExamples: [
          'Museu de Serralves (Porto - Álvaro Siza)',
          'Estádio Municipal de Braga (Braga - Eduardo Souto de Moura)',
          'Casa da Música (Porto - Rem Koolhaas / OMA)',
          'Pavilhão de Portugal na Expo 98 (Lisboa - Álvaro Siza)',
        ],
      ),
    ];
  }

  static List<ArchitectureQuizQuestion> getQuizzes() {
    return const [
      ArchitectureQuizQuestion(
        id: 'quiz-arch-1',
        question:
            'Qual material de construção foi moldado em formas curvilíneas por Oscar Niemeyer para construir a Catedral de Brasília?',
        options: [
          'Pedra lioz lavrada',
          'Concreto armado (betão armado)',
          'Ferro fundido escocês',
          'Tijolo maciço aparente',
        ],
        correctIndex: 1,
        explanation:
            'Niemeyer utilizou a plasticidade do concreto armado para erguer as 16 colunas curvas da Catedral, dispensando paredes pesadas.',
        dialect: 'all',
      ),
      ArchitectureQuizQuestion(
        id: 'quiz-arch-2',
        question:
            'Como se chama em Portugal o acabamento da construção onde a estrutura de cimento fica visível sem reboco, equivalente ao "concreto aparente" no Brasil?',
        options: [
          'Betão à vista',
          'Calçada portuguesa',
          'Talha dourada',
          'Pedra-sabão',
        ],
        correctIndex: 0,
        explanation:
            'Em Portugal, diz-se "betão à vista", muito utilizado em obras contemporâneas como a Casa da Música e os projetos da Escola do Porto.',
        dialect: 'pt_PT',
      ),
      ArchitectureQuizQuestion(
        id: 'quiz-arch-3',
        question:
            'Que motivo ornamental é uma marca inconfundível do estilo manuelino esculpido no Mosteiro dos Jerónimos?',
        options: [
          'Cariátides greco-romanas',
          'Cordas marinheiras e esferas armilares',
          'Mosaicos de azulejos modernistas',
          'Tijolos de vidro ondulado',
        ],
        correctIndex: 1,
        explanation:
            'O estilo manuelino celebrava as grandes navegações com motivos esculpidos em pedra de cabos náuticos, nós marinheiros e esferas armilares.',
        dialect: 'pt_PT',
      ),
      ArchitectureQuizQuestion(
        id: 'quiz-arch-4',
        question:
            'Qual destas características define o interior barroco da Igreja de São Francisco no Pelourinho em Salvador?',
        options: [
          'Paredes brancas minimalistas sem enfeites',
          'Uso de vigas industriais aparentes',
          'Intensa talha dourada recobrindo paredes e altares com ouro',
          'Grandes claraboias de fibra de vidro colorida',
        ],
        correctIndex: 2,
        explanation:
            'A Igreja de São Francisco é célebre por sua riquíssima talha dourada em madeira de jacarandá recoberta com folhas de ouro fino.',
        dialect: 'pt_BR',
      ),
      ArchitectureQuizQuestion(
        id: 'quiz-arch-5',
        question:
            'Como se chamam os pilares que sustentam um edifício elevando-o do solo, liberando a circulação sob o prédio como em Brasília?',
        options: [
          'Pilotis',
          'Ameias',
          'Gárgulas',
          'Frontões',
        ],
        correctIndex: 0,
        explanation:
            'Os "pilotis" são um dos 5 pontos da nova arquitetura moderna, amplamente adotados nas superquadras e ministérios de Brasília.',
        dialect: 'all',
      ),
      ArchitectureQuizQuestion(
        id: 'quiz-arch-6',
        question:
            'O que cobre a cúpula do Teatro Amazonas em Manaus, chamando a atenção no meio da floresta amazônica?',
        options: [
          'Placas de cobre oxidado verde',
          'Trinta e seis mil azulejos nas cores da bandeira do Brasil',
          'Vidro transparente espelhado',
          'Madeira nobre de pau-brasil envernizada',
        ],
        correctIndex: 1,
        explanation:
            'A cúpula do Teatro Amazonas ostenta 36.000 peças de cerâmica vidrada nas cores verde, amarela, azul e branca formando a bandeira nacional.',
        dialect: 'pt_BR',
      ),
    ];
  }
}
