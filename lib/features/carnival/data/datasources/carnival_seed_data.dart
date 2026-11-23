import '../../domain/entities/carnival_entities.dart';

class CarnivalSeedData {
  static List<CarnivalTraditionEntity> getTraditions() {
    return const [
      CarnivalTraditionEntity(
        id: 'frevo-olinda',
        title: 'Frevo de Olinda & Recife',
        category: CarnivalTraditionCategory.frevo,
        region: 'Pernambuco (Ladeiras de Olinda e Ruas do Recife)',
        country: 'Brasil',
        dialect: 'pt_BR',
        emoji: '☂️',
        shortSummary:
            'Ritmo frenético e dança acrobática nascida da capoeira e das marchas militares, Patrimônio Imaterial da Humanidade pela UNESCO.',
        fullDescription:
            'O Frevo surgiu no final do século XIX no Recife, fruto da efervescência popular entre bandas militares e capoeiristas que abriam alas na frente dos blocos carnavalescos. O termo deriva de "ferver" ("frever"), simbolizando o calor humano e a agitação eletrizante das multidões que descem as ladeiras históricas de Olinda. Os passos do frevo (como a tesoura, o parafuso e o saci) exigem incrível destreza atlética, equilibrados com o auxílio da icônica sombrinha colorida, que outrora servia como instrumento de defesa. A música, executada por poderosos naipes de metais (trompetes, trombones, tubas e saxofones) e surdos velozes, arrasta milhões de foliões no Galo da Madrugada — o maior bloco carnavalesco do planeta.',
        keyInstruments: [
          'Metais (trompete, trombone de vara, saxofone alto e tenor, tuba)',
          'Surdo e caixa de guerra aceleradíssimos',
          'Pandeiro e tarol',
        ],
        culturalRituals: [
          'Passos acrobáticos com a sombrinha multicolorida',
          'Desfile da madrugada do Galo da Madrugada abrindo o sábado de Zé Pereira',
          'Encontro tradicional de bonecos gigantes no Alto da Sé em Olinda',
          'Clássicas "troças carnavalescas" que saem de surpresa pelas vielas',
        ],
        vocabulary: [
          CarnivalVocabEntity(
            id: 'crn-sombrinha',
            termPt: 'Sombrinha de frevo',
            translationRu: 'Разноцветный мини-зонтик для балансировки в танце фрево',
            definition:
                'Elemento coreográfico indispensável de tecido colorido e haste curta usado para dar equilíbrio acrobático ao passista.',
            exampleSentence:
                'O passista girou no ar equilibrando a sombrinha de frevo na ponta dos dedos.',
            dialect: 'pt_BR',
          ),
          CarnivalVocabEntity(
            id: 'crn-troca',
            termPt: 'Troça carnavalesca',
            translationRu: 'Стихийное уличное карнавальное шествие / шутовской клуб',
            definition:
                'Agremiação carnavalesca satírica de rua menor que um clube, que desfila de dia pregando peças irreverentes.',
            exampleSentence:
                'A troça Pitombeira dos Quatro Cantos arrastou uma multidão cantando pelas ladeiras.',
            dialect: 'pt_BR',
          ),
          CarnivalVocabEntity(
            id: 'crn-passista',
            termPt: 'Passista de frevo',
            translationRu: 'Танцор фрево, исполняющий акробатические трюки',
            definition:
                'Bailarino solista que executa passos acrobáticos e gingados herdados da capoeira ao som do frevo.',
            exampleSentence:
                'O jovem passista rasgava o chão com passos de tesoura vertiginosos.',
            dialect: 'pt_BR',
          ),
        ],
        audioNarration:
            'O metal estridente dos trompetes ecoa pelas ladeiras de pedra de Olinda, fervendo o sangue de milhares de passistas sob o sol do Nordeste.',
      ),
      CarnivalTraditionEntity(
        id: 'maracatu-baque-virado',
        title: 'Maracatu de Baque Virado & Nações de Pernambuco',
        category: CarnivalTraditionCategory.maracatu,
        region: 'Recife Antigo, Olinda e Nazaré da Mata (PE)',
        country: 'Brasil',
        dialect: 'pt_BR',
        emoji: '👑',
        shortSummary:
            'Cortejo régio afro-brasileiro sagrado em honra aos Reis do Congo, impulsionado pelo trovão sagrado das alfaias e caboclos de lança.',
        fullDescription:
            'O Maracatu de Baque Virado (ou Maracatu Nação) é uma das expressões religiosas e estéticas mais profundas do Brasil, nascida das coroações dos Reis do Congo autorizadas no período colonial. Cada Nação de Maracatu (como a tricentenária Nação Porto Rico ou Leão Coroado) funciona como uma extensão dos terreiros de Candomblé Ketu ou Nagô. À frente do cortejo desfilam o Rei e a Rainha sob o pálio real, cercados por damas de honra que carregam a "Calunga" — boneca mística de madeira que guarda o axé e a ancestralidade da nação. Na retaguarda, o trovão das pesadas alfaias (bombos de corda), taróis, agogôs e gonguês produz um ritmo telúrico e hipnótico irresistível. No interior, o Maracatu Rural (Baque Solto) destaca a figura guerreira do Caboclo de Lança, com seu manto bordado com milhares de lantejoulas e cravo branco entre os dentes.',
        keyInstruments: [
          'Alfaias (grandes tambores de madeira afinados por cordas de sisal)',
          'Gonguê (campânula de ferro percutida com vareta de ferro)',
          'Agbê / Xequerê (cabaça trançada com contas)',
          'Tarol e caixa de guerra',
        ],
        culturalRituals: [
          'Noite dos Tambores Silenciosos no Pátio do Terço à meia-noite da segunda-feira',
          'Consagração e dança ritual da boneca mística Calunga',
          'Evolução guerreira dos Caboclos de Lança com cabeleiras de celofane e cravos brancos',
          'Coroação solene dos Reis do Congo diante dos mastros sagrados',
        ],
        vocabulary: [
          CarnivalVocabEntity(
            id: 'crn-alfaia',
            termPt: 'Alfaia de maracatu',
            translationRu: 'Альфайя (тяжелый басовый барабан с натяжкой канатами)',
            definition:
                'Tambor rústico e grave de madeira leve com peles de cabra tensionadas por cordas, coração percussivo do maracatu.',
            exampleSentence:
                'O peso da alfaia no ombro do batuqueiro ressoa como um trovão ancestral no peito.',
            dialect: 'pt_BR',
          ),
          CarnivalVocabEntity(
            id: 'crn-calunga',
            termPt: 'Boneca Calunga',
            translationRu: 'Калунга (священная ритуальная деревянная кукла нации маракату)',
            definition:
                'Escultura mística de madeira ricamente vestida que encarna a proteção espiritual dos antepassados da nação.',
            exampleSentence:
                'A dama-de-paço baila com reverência conduzindo a sagrada boneca Calunga.',
            dialect: 'pt_BR',
          ),
          CarnivalVocabEntity(
            id: 'crn-caboclo-lanca',
            termPt: 'Caboclo de lança',
            translationRu: 'Кабоклу с копьем (воин-персонаж сельского маракату)',
            definition:
                'Guerreiro místico do Maracatu Rural vestido com gola de lantejoulas, chocalhos nas costas e lança longa enfeitada.',
            exampleSentence:
                'O caboclo de lança saltou agitando o cravo branco entre os lábios e a lança de fitas.',
            dialect: 'pt_BR',
          ),
        ],
        audioNarration:
            'No silêncio sagrado da noite pernambucana, o baque surdo das alfaias ecoa chamando os orixás e coroando os reis negros.',
      ),
      CarnivalTraditionEntity(
        id: 'samba-enredo-sapucai',
        title: 'Samba-Enredo & Desfiles da Marquês de Sapucaí',
        category: CarnivalTraditionCategory.sambaEnredo,
        region: 'Rio de Janeiro e São Paulo (Sambódromo)',
        country: 'Brasil',
        dialect: 'pt_BR',
        emoji: '🥁',
        shortSummary:
            'A maior ópera a céu aberto do planeta: a sinfonia das baterias das escolas de samba, carros alegóricos e a dança nobre do pavilhão.',
        fullDescription:
            'O desfile das Escolas de Samba no Sambódromo da Marquês de Sapucaí é uma das expressões artísticas mais monumentais do mundo contemporâneo. Nascidas nas comunidades dos morros cariocas (como Estácio, Mangueira, Portela e Salgueiro), as escolas de samba transformam a avenida em um espetáculo que une literatura, artes plásticas, dança e percussão. A espinha dorsal é o "Samba-Enredo" — composição poético-musical que narra a temática histórica, social ou mitológica escolhida para o ano. Conduzida pelo "Puxador" (intérprete oficial) e pelo coro de milhares de componentes em alas fantasiadas, a escola é impulsionada pela "Bateria" (composta por mais de 250 ritmistas sob o comando do mestre). O casal de Mestre-Sala e Porta-Bandeira executa o ritual sagrado de proteger e reverenciar o pavilhão da escola sem jamais dar as costas um ao outro.',
        keyInstruments: [
          'Surdos de primeira, segunda e terceira (marcação e corte)',
          'Caixas de guerra e taróis (esteira de sustentação)',
          'Tamborins com carreteiro veloz de três toques',
          'Cuíca (choro e lamento inconfundível do samba)',
          'Repique, chocalho de platinelas e agogô de quatro campânulas',
        ],
        culturalRituals: [
          'Esquenta da Bateria nos boxes antes da largada na avenida',
          'Apresentação da Comissão de Frente trazendo o prólogo do enredo',
          'Evolução protocolar e giros da Porta-Bandeira e Mestre-Sala perante os jurados',
          'Recuo da Bateria para dar passagem triunfal às últimas alegorias e à Velha Guarda',
        ],
        vocabulary: [
          CarnivalVocabEntity(
            id: 'crn-puxador',
            termPt: 'Puxador de samba / Intérprete oficial',
            translationRu: 'Ведущий солист-вокалист школы самбы',
            definition:
                'Cantor principal responsável por inflamar a escola e conduzir o canto uníssono de milhares de foliões na avenida.',
            exampleSentence:
                'O puxador soltou o grito de guerra no microfone e a Sapucaí inteira explodiu em canto.',
            dialect: 'pt_BR',
          ),
          CarnivalVocabEntity(
            id: 'crn-cuica',
            termPt: 'Cuíca',
            translationRu: 'Куика (мембранофон с трением палочки, издающий «плач»)',
            definition:
                'Instrumento de percussão por fricção com haste interna de bambu, cujo som rouco lembra o choro humano ou riso agudo.',
            exampleSentence:
                'O gemido nostálgico da cuíca abriu a introdução do samba-enredo da Mangueira.',
            dialect: 'pt_BR',
          ),
          CarnivalVocabEntity(
            id: 'crn-porta-bandeira',
            termPt: 'Porta-bandeira',
            translationRu: 'Знаменосец (танцовщица, несущая священный флаг школы самбы)',
            definition:
                'Dama nobre que ostenta e gira o pavilhão sagrado da escola de samba em dança harmoniosa com o mestre-sala.',
            exampleSentence:
                'A porta-bandeira rodopiou majestosa com sua saia de plumas brancas e azuis.',
            dialect: 'pt_BR',
          ),
        ],
        audioNarration:
            'O apito do mestre rasga o ar e a bateria descarrega o ritmo cadenciado na Sapucaí, fazendo tremer as arquibancadas do Rio.',
      ),
      CarnivalTraditionEntity(
        id: 'bumba-meu-boi-maranhao',
        title: 'Bumba-Meu-Boi & Autos Juninos do Maranhão',
        category: CarnivalTraditionCategory.bumbameuboi,
        region: 'São Luís e interior do Maranhão',
        country: 'Brasil',
        dialect: 'pt_BR',
        emoji: '🐂',
        shortSummary:
            'A celebração teatral mágica da morte e ressurreição do boi, com orquestras, matracas estridentes e pandeirões.',
        fullDescription:
            'O Bumba-Meu-Boi do Maranhão é uma manifestação lírica, dramática e religiosa de sincretismo indígena, negro e europeu, reconhecida como Patrimônio Cultural Imaterial da Humanidade pela UNESCO. A trama gira em torno da lenda de Catirina, grávida que tem o desejo de comer a língua do boi mais bonito da fazenda; seu marido, Pai Francisco, mata a rês, gerando a fúria do amo e a intervenção milagrosa de xamãs pajés e curandeiros que ressuscitam o boi em meio a cantos e danças. Os grupos ("grupos de bueiros") se distinguem pelos "sotaques" rítmicos: o sotaque de Matraca (onde milhares de pessoas batem pedaços de madeira noite adentro), o de Zabumba (pesado e ancestral), o de Orquestra (com clarinetes e trombones) e o de Pindaré (com pandeiros gigantes).',
        keyInstruments: [
          'Matracas (dois pedaços de madeira de lei batidos ritmicamente)',
          'Zabumbas graves e tambores-onça (fricção)',
          'Pandeirões e maracás indígenas',
          'Instrumentos de sopro (no sotaque de orquestra)',
        ],
        culturalRituals: [
          'Batismo do Boi na véspera de São João por sacerdotes e pajés',
          'Bailado do Amo do Boi improvisando toadas em décimas',
          'Batalha dramática dos vaqueiros e índias guerreiras em volta do boi bordado',
          'Morte e ressurreição festiva da carcaça de veludo cravejada de missangas',
        ],
        vocabulary: [
          CarnivalVocabEntity(
            id: 'crn-matraca',
            termPt: 'Matraca de madeira',
            translationRu: 'Матрака (деревянные бруски, ритмично ударяемые друг о друга)',
            definition:
                'Dois blocos de madeira resistente percutidos pelos participantes no Bumba-meu-boi do Maranhão gerando um mar sonoro ensurdecedor.',
            exampleSentence:
                'Milhares de pessoas batiam as matracas no arraial de São Luís até o sol raiar.',
            dialect: 'pt_BR',
          ),
          CarnivalVocabEntity(
            id: 'crn-toada',
            termPt: 'Toada de boi',
            translationRu: 'Тоада (традиционная поэтическая строфа-песня в празднике быка)',
            definition:
                'Canto poético entoado pelo amo do boi que narra a saga dos personagens, lamentos de amor e exaltação à natureza.',
            exampleSentence:
                'O amo puxou uma toada emocionante louvando as cores do manto do boi de ouro.',
            dialect: 'pt_BR',
          ),
          CarnivalVocabEntity(
            id: 'crn-sotaque-boi',
            termPt: 'Sotaque de boi',
            translationRu: '«Акцент» / стиль исполнения ритма бумба-меу-бой',
            definition:
                'Estilo regional de instrumentos, indumentária e andamento rítmico do Bumba-meu-boi maranhense.',
            exampleSentence:
                'O sotaque de orquestra encantou os turistas com seus arranjos de sopros e violinos.',
            dialect: 'pt_BR',
          ),
        ],
        audioNarration:
            'O bater frenético das matracas de madeira no Maranhão faz estremecer o chão do arraial enquanto o boi ressuscitado dança na noite de São João.',
      ),
      CarnivalTraditionEntity(
        id: 'entrudo-torres-podence',
        title: 'Carnaval de Torres Vedras & Caretos de Podence',
        category: CarnivalTraditionCategory.entrudoPortugues,
        region: 'Oeste (Torres Vedras) e Trás-os-Montes (Macedo de Cavaleiros, Portugal)',
        country: 'Portugal',
        dialect: 'pt_PT',
        emoji: '👹',
        shortSummary:
            'A mais autêntica folia lusa: as matrafonas e cabeçudos satíricos de Torres Vedras e os diabólicos caretos chocalheiros de Podence.',
        fullDescription:
            'O Carnaval em Portugal possui raízes medievais e pré-romanas indeléveis sob o nome de "Entrudo". Em Torres Vedras, celebra-se "o Carnaval mais português de Portugal", avesso ao samba importado e focado na sátira política corrosiva e na espontaneidade popular. As figuras centrais são as "Matrafonas" (homens trajados com roupas femininas extravagantes, barba e peluche, que gozam com as convenções sociais), os "Cabeçudos" e "Zés-Pereiras" com seus bombos ensurdecedores. Já na aldeia transmontana de Podence, os "Caretos" — rapazes mascarados com fatos de franjas de lã vermelhas, amarelas e verdes e máscaras pontiagudas de lata ou couro — saem à solta chocalhando as mulheres solteiras em rituais ancestrais de fertilidade celta e purificação invernal, consagrados pela UNESCO.',
        keyInstruments: [
          'Chocalhos de latão amarrados à cintura com correias de couro (Podence)',
          'Bombos e caixas de rufo dos Zés-Pereiras (Torres Vedras)',
          'Gaitas de foles mirandesas e transmontanas',
        ],
        culturalRituals: [
          'A Chocalhada: corrida dos caretos pelas quelhas de Podence caçando moças para as chocalhar',
          'Cortejo das Matrafonas em salto alto pelas ruas do centro histórico torriense',
          'Queima do Entrudo com julgamento satírico e fogos de artifício na Quarta-feira de Cinzas',
          'Monumento do Carnaval e corsos carnavalescos temáticos sem cordões excludentes',
        ],
        vocabulary: [
          CarnivalVocabEntity(
            id: 'crn-matrafona',
            termPt: 'Matrafona',
            translationRu: 'Матрафона (гротескно переодетый в женское платье мужчина на карнавале)',
            definition:
                'Figura emblemática do Carnaval de Torres Vedras: homem mascarado de mulher com maquiagem pesada e atitude provocadora satírica.',
            exampleSentence:
                'As matrafonas desciam as ruas aos tropeções nos sapatos de salto alto, metendo-se com os transeuntes.',
            dialect: 'pt_PT',
          ),
          CarnivalVocabEntity(
            id: 'crn-careto',
            termPt: 'Careto de Podence',
            translationRu: 'Карету (маскарадный персонаж в костюме из разноцветной шерсти с колокольчиками)',
            definition:
                'Personagem misteriosa e travessa de Trás-os-Montes que corre pelas ruas chocalhando as raparigas no Entrudo.',
            exampleSentence:
                'O careto saltou o muro com máscara vermelha e fez soar os chocalhos da cintura.',
            dialect: 'pt_PT',
          ),
          CarnivalVocabEntity(
            id: 'crn-cabecudo',
            termPt: 'Cabeçudo carnavalesco',
            translationRu: 'Кабесуду (гигантская кукольная голова из папье-маше)',
            definition:
                'Boneco gigante de pasta de papel com cabeça desproporcionada que desfila dançando desajeitadamente atrás dos bombos.',
            exampleSentence:
                'O cabeçudo dançava ao ritmo do bombo abrindo caminho entre as crianças na praça.',
            dialect: 'pt_PT',
          ),
        ],
        audioNarration:
            'O retinir ensurdecedor dos chocalhos de latão dos caretos corta o ar frio transmontano em corridas loucas pelas quelhas de Podence.',
      ),
      CarnivalTraditionEntity(
        id: 'trio-eletrico-salvador',
        title: 'Trio Elétrico & Blocos Afro de Salvador da Bahia',
        category: CarnivalTraditionCategory.trioEletrico,
        region: 'Salvador da Bahia (Circuitos Barra-Ondina e Campo Grande)',
        country: 'Brasil',
        dialect: 'pt_BR',
        emoji: '🚛',
        shortSummary:
            'A maior festa de rua do mundo: caminhões monumentais com paredes de alto-falantes, a energia da pipoca e a ancestralidade negra do Olodum.',
        fullDescription:
            'Nascido em 1950 com a invenção da Fobica por Dodô e Osmar (pequeno Ford 1929 equipado com amplificadores rudimentares e guitarras baianas), o Carnaval de Salvador transformou-se numa usina de som em movimento. Os Trios Elétricos modernos são gigantescas carretas de dois andares com potências de mais de cem mil watts, palcos suspensos e camarotes móveis que desfilam lentamente pelos circuitos à beira-mar. Atrás dos trios agita-se a "Pipoca" — a massa descalça e eletrizada de foliões sem abadá que pula no mesmo ritmo do Axé Music. Em paralelo, a resistência negra pulsa com força histórica inabalável nos Blocos Afro (como o Ilê Aiyê no Curuzu e o Olodum no Pelourinho), com seus tambores de samba-reggae que denunciam o racismo e celebram a herança dos guerreiros iorubás e bantos.',
        keyInstruments: [
          'Guitarra Baiana (instrumento solista de cinco cordas de timbre agudo e elétrico)',
          'Repique e surdos de samba-reggae tocados com duas baquetas plásticas',
          'Timbal (tambor cônico tocado com a palma das mãos nuas em alta tensão)',
          'Bacurinhas e caixas rufadas',
        ],
        culturalRituals: [
          'Saída do Bloco Ilê Aiyê da ladeira do Curuzu na noite de sábado com banho de pipoca sagrado',
          'Descida triunfal do Olodum do Pelourinho ao som estrondoso dos tambores de samba-reggae',
          'Arrastão da Quarta-feira de Cinzas na Barra encerrando o carnaval com todos os trios juntos',
          'Encontro histórico de trios na Praça Castro Alves ao cair da noite',
        ],
        vocabulary: [
          CarnivalVocabEntity(
            id: 'crn-pipoca',
            termPt: 'A Pipoca carnavalesca',
            translationRu: '«Пипока» (свободная толпа танцующих на улице без платных футболок-абада)',
            definition:
                'Multidão de foliões que pula livremente na rua ao redor dos trios elétricos sem estar contida nas cordas de blocos privados.',
            exampleSentence:
                'O cantor mandou desligar as cordas e chamou toda a pipoca para pular junto ao trio elétrico.',
            dialect: 'pt_BR',
          ),
          CarnivalVocabEntity(
            id: 'crn-abada',
            termPt: 'Abadá de bloco',
            translationRu: 'Абада (фирменная карнавальная майка-пропуск в зону вокруг трио)',
            definition:
                'Camiseta temática padronizada que serve como ingresso de acesso à área protegida por cordeiros em torno do trio.',
            exampleSentence:
                'Vestiu o abadá colorido e correu para entrar no bloco antes da curva do Farol da Barra.',
            dialect: 'pt_BR',
          ),
          CarnivalVocabEntity(
            id: 'crn-timbal',
            termPt: 'Timbal baiano',
            translationRu: 'Тимбал (конический перкуссионный барабан из Баии для игры ладонями)',
            definition:
                'Instrumento de percussão cônico de pele muito esticada tocado com as duas mãos, popularizado por Carlinhos Brown e Timbalada.',
            exampleSentence:
                'O estalo seco do timbal fez a multidão erguer os braços em uníssono no Pelourinho.',
            dialect: 'pt_BR',
          ),
        ],
        audioNarration:
            'A guitarra baiana chora notas agudas no topo do trio elétrico enquanto cem mil pessoas pulam como pipoca na brisa morna de Salvador.',
      ),
    ];
  }

  static List<RhythmWorkshopEntity> getRhythmWorkshops() {
    return const [
      RhythmWorkshopEntity(
        id: 'oficina-frevo',
        title: 'Compasso Rasgado no Frevo de Rua',
        genre: 'Frevo de Rua',
        dialect: 'pt_BR',
        tempoBpm: 152,
        rhythmicPatternRu:
            'Сверхбыстрый синкопированный маршевый ритм 2/4 с акцентами на слабую долю и виртуозными пассажами духовых инструментов.',
        lyricsSamplePt:
            '«A multidão vem frevendo na ladeira!\nO passista vai caindo e levantando,\nA orquestra segue tocando sem parar!»',
        lyricsTranslationRu:
            '«Толпа идет, закипая на холме!\nТанцор падает и тут же взмывает,\nА духовой оркестр продолжает играть без остановки!»',
        continuousActionGrammarNote:
            'Gramática: Ações Contínuas em PT-BR (Gerúndio). Em português do Brasil, ações em andamento usam o gerúndio: "vem frevendo", "vai caindo", "segue tocando". Compare com o português europeu: "vem a ferver", "vai a cair", "segue a tocar".',
        icon: '🎺',
      ),
      RhythmWorkshopEntity(
        id: 'oficina-maracatu',
        title: 'Baque Virado das Alfaias',
        genre: 'Maracatu de Baque Virado',
        dialect: 'pt_BR',
        tempoBpm: 104,
        rhythmicPatternRu:
            'Громовой полиритмический бой альфай с резким синкопированным переворотом («baque virado») и металлическим акцентом гонге.',
        lyricsSamplePt:
            '«As alfaias estão retumbando na noite escura,\nA rainha está desfilando sob o manto dourado,\nO trovão dos pretos velhos vai chamando a ancestralidade!»',
        lyricsTranslationRu:
            '«Альфайи гудят в темной ночи,\nКоролева шествует под золотой мантией,\nГром старых духов призывает предков!»',
        continuousActionGrammarNote:
            'Gramática: Estar + Gerúndio (PT-BR) vs Estar a + Infinitivo (PT-PT). No Brasil diz-se: "estão retumbando", "está desfilando", "vai chamando". Em Portugal diz-se: "estão a retumbar", "está a desfilar", "vai a chamar".',
        icon: '🥁',
      ),
      RhythmWorkshopEntity(
        id: 'oficina-samba-enredo',
        title: 'Cadência & Levada da Sapucaí',
        genre: 'Samba-Enredo Carioca',
        dialect: 'pt_BR',
        tempoBpm: 142,
        rhythmicPatternRu:
            'Базовый ритм самбы 2/4 с акцентом сурдо на вторую долю («dois»), синкопой тамбурина и непрерывным шелестом коробок.',
        lyricsSamplePt:
            '«A escola vai entrando na avenida consagrada!\nA cuíca fica chorando no coração da bateria,\nE o povo continua cantando a história da nossa gente!»',
        lyricsTranslationRu:
            '«Школа входит на священную авеню!\nКуика продолжает плакать в самом сердце батареи,\nИ народ продолжает петь историю наших людей!»',
        continuousActionGrammarNote:
            'Gramática: Verbos de Movimento com Gerúndio. Verbos auxiliares como "ir", "ficar", "continuar" combinados com o gerúndio expressam progressão gradual: "vai entrando", "fica chorando", "continua cantando" (em PT-PT: "vai a entrar", "fica a chorar", "continua a cantar").',
        icon: '✨',
      ),
      RhythmWorkshopEntity(
        id: 'oficina-caretos-entrudo',
        title: 'A Chocalhada Transmontana',
        genre: 'Entrudo Chocalheiro Tradicional',
        dialect: 'pt_PT',
        tempoBpm: 126,
        rhythmicPatternRu:
            'Хаотичный и напористый звон сотен латунных колокольчиков на кожаном поясе вприпрыжку под волынку и барабан.',
        lyricsSamplePt:
            '«Os caretos andam a chocalhar pelas quelhas!\nO diabo anda a correr atrás das raparigas,\nE a aldeia fica toda a rir das travessuras do Entrudo!»',
        lyricsTranslationRu:
            '«Каретуш бегают и звенят колокольчиками по переулкам!\nЧерт гонится за девушками,\nИ вся деревня смеется над шутками Энтруду!»',
        continuousActionGrammarNote:
            'Gramática: Construção Padrão em PT-PT (Andar/Ficar a + Infinitivo). Em Portugal, a ação contínua ou iterativa expressa-se preferencialmente com a preposição "a" seguida do infinitivo: "andam a chocalhar", "anda a correr", "fica a rir". No Brasil equivaleria a: "andam chocalhando", "anda correndo", "fica rindo".',
        icon: '🔔',
      ),
    ];
  }

  static List<CarnivalQuizQuestion> getQuizzes() {
    return const [
      CarnivalQuizQuestion(
        id: 'q-crn-1',
        question:
            'Como se expressa em Português Europeu (PT-PT) a frase brasileira "A bateria da escola de samba está tocando na avenida"?',
        options: [
          'A bateria da escola de samba está a tocar na avenida.',
          'A bateria da escola de samba está tocado na avenida.',
          'A bateria da escola de samba fica tocando na avenida.',
          'A bateria da escola de samba vai tocado na avenida.',
        ],
        correctIndex: 0,
        explanation:
            'Em Portugal, o presente contínuo constrói-se com o verbo auxiliar "estar" + preposição "a" + infinitivo ("está a tocar"), em contraste com o gerúndio brasileiro ("está tocando").',
      ),
      CarnivalQuizQuestion(
        id: 'q-crn-2',
        question:
            'Qual é o elemento coreográfico tradicional que os passistas de Frevo em Olinda utilizam para manter o equilíbrio nos saltos acrobáticos?',
        options: [
          'A sombrinha colorida',
          'O ganzá de prata',
          'A matraca de madeira',
          'O bastão de tamborim',
        ],
        correctIndex: 0,
        explanation:
            'A sombrinha colorida de frevo é o acessório emblemático que ajuda o passista a manter o centro de gravidade durante as manobras acrobáticas complexas.',
      ),
      CarnivalQuizQuestion(
        id: 'q-crn-3',
        question:
            'Quem são as "Matrafonas", figuras centrais e satíricas do Carnaval tradicional de Torres Vedras em Portugal?',
        options: [
          'Homens vestidos com roupas femininas extravagantes que satirizam costumes sociais',
          'Guerreiros ancestrais com lanças compridas e cravos na boca',
          'Bonecas místicas de madeira sagradas que guardam os terreiros',
          'Mulheres pescadoras que apanham berbigão na ria',
        ],
        correctIndex: 0,
        explanation:
            'As Matrafonas de Torres Vedras são homens mascarados e vestidos de mulher de forma exagerada e caricata, mantendo a irreverência e a paródia satírica do Entrudo luso.',
      ),
      CarnivalQuizQuestion(
        id: 'q-crn-4',
        question:
            'No Carnaval de Salvador da Bahia, como é chamada a multidão que acompanha os Trios Elétricos nas ruas fora dos blocos fechados e sem abadá?',
        options: [
          'A Pipoca',
          'A Matraca',
          'O Cordão Real',
          'A Bateria',
        ],
        correctIndex: 0,
        explanation:
            'A "Pipoca" é o termo popular e carinhoso para a grande massa popular que pula livremente nas ruas atrás dos trios elétricos sem pagar pelos abadás dos blocos privados.',
      ),
      CarnivalQuizQuestion(
        id: 'q-crn-5',
        question:
            'Qual instrumento por fricção de membrana com haste interna de bambu é famoso pelo seu "choro" característico no samba carioca?',
        options: [
          'A cuíca',
          'O surdo de marcação',
          'O gonguê',
          'A alfaia',
        ],
        correctIndex: 0,
        explanation:
            'A cuíca é o instrumento membranofone de fricção cujo atrito de um pano úmido na haste interna gera sons agudos que simulam lamentos, choros e risadas.',
      ),
      CarnivalQuizQuestion(
        id: 'q-crn-6',
        question:
            'Em qual manifestação cultural do Maranhão milhares de foliões batem pedaços de madeira de lei noite adentro no sotaque mais veloz?',
        options: [
          'Bumba-Meu-Boi no Sotaque de Matraca',
          'Frevo rasgado de Olinda',
          'Caretos de Podence',
          'Cortejo de Maracatu Rural',
        ],
        correctIndex: 0,
        explanation:
            'No Bumba-Meu-Boi de Matraca do Maranhão, os brincantes empunham duas pequenas tábuas de madeira maciça ("matracas"), percutindo-as em uníssono ensurdecedor durante os festejos juninos.',
      ),
    ];
  }
}
