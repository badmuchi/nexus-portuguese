import '../../domain/entities/ancestral_entities.dart';

class AncestralSeedData {
  static List<TraditionalCommunityEntity> getCommunities() {
    return const [
      TraditionalCommunityEntity(
        id: 'ribeirinhos-amazonas',
        title: 'Ribeirinhos dos Rios Solimões e Negro',
        category: CommunityCategory.ribeirinhos,
        region: 'Bacia Amazônica (Amazonas e Pará)',
        country: 'Brasil',
        dialect: 'pt_BR',
        emoji: '🛶',
        shortSummary:
            'Populações tradicionais das várzeas e igapós que constroem a vida ao ritmo das cheias e secas dos rios amazônicos.',
        fullDescription:
            'Os povos ribeirinhos da Amazônia habitam as margens dos grandes rios e igarapés, vivendo em harmonia intrínseca com o ciclo das águas. Suas casas sobre palafitas de madeira se adaptam à subida anual das águas de até dez metros. Mestres da navegação em pequenas canoas e "bajaras", os ribeirinhos possuem um conhecimento milenar sobre o manejo do açaí, da castanha-da-amazônia, da farinha de mandioca d\'água e a pesca seletiva do pirarucu e tambaqui. O transporte e o comércio dependem do "regatão" — barco mercantil ambulante que abastece comunidades isoladas. O vocabulário ribeirinho é impregnado de termos de origem tupi e da vivência aquática cotidiana.',
        lifestyleHighlights: [
          'Habitações em palafitas erguidas em esteios de madeira de lei',
          'Calendário biológico orientado pela "enchente", "cheia", "vazante" e "seca"',
          'Pesca artesanal com caniço, zagaia, malhadeira e tarrafa',
          'Manejo sustentável de açaizais nativos e roças de subsistência',
        ],
        vocabulary: [
          AncestralVocabEntity(
            id: 'anc-palafita',
            termPt: 'Palafita amazônica',
            translationRu: 'Дом на сваях над водой',
            definition:
                'Habitação de madeira suspensa por troncos para resistir ao transbordamento sazonal dos rios.',
            exampleSentence:
                'Na época da cheia, a água do rio quase beijava as tábuas da palafita.',
            dialect: 'pt_BR',
          ),
          AncestralVocabEntity(
            id: 'anc-igarape',
            termPt: 'Igarapé',
            translationRu: 'Лесной речной приток / протока в джунглях',
            definition:
                'Curso d\'água de floresta navegável por pequenas canoas, termo de origem tupi (caminho de canoa).',
            exampleSentence:
                'Navegamos suavemente pelo igarapé estreito sob a copa das samaúmas.',
            dialect: 'pt_BR',
          ),
          AncestralVocabEntity(
            id: 'anc-regatao',
            termPt: 'Regatão',
            translationRu: 'Плавучая торговая лавка (баржа-купец на реке)',
            definition:
                'Comerciante que viaja de barco pelos rios vendendo mantimentos, ferramentas e tecidos para comunidades remotas.',
            exampleSentence:
                'O apito do regatão anunciou a chegada de tecidos e sal na comunidade ribeirinha.',
            dialect: 'pt_BR',
          ),
        ],
        audioNarration:
            'O silêncio do amanhecer na Amazônia é quebrado apenas pelo deslizar do remo do pescador ribeirinho entre os igapós espelhados.',
      ),
      TraditionalCommunityEntity(
        id: 'caicaras-litoral',
        title: 'Caiçaras do Litoral Paulista e Fluminense',
        category: CommunityCategory.caicaras,
        region: 'Litoral Sul e Sudeste (Ubatuba, Ilhabela, Paraty, Cananéia)',
        country: 'Brasil',
        dialect: 'pt_BR',
        emoji: '🌊',
        shortSummary:
            'Comunidades costeiras nascidas da fusão entre indígenas tupis e colonos portugueses, guardiãs da pesca artesanal da tainha e do fandango.',
        fullDescription:
            'A cultura caiçara floresceu entre as encostas da Serra do Mar e o Oceano Atlântico. Descendentes de indígenas tupis e portugueses litorâneos, os caiçaras desenvolveram uma relação sagrada com a floresta de Mata Atlântica e o mar. Suas embarcações tradicionais — as canoas de voga — são esculpidas em um único tronco nobre (geralmente jequitibá ou guapuruvu). Durante os meses de inverno, a chegada dos cardumes de tainha mobiliza a praia inteira no ritual do "cerco flutuante" e da vigia no alto das pedras. À noite, celebram a vida ao som da viola caiçara de machete, da rabeca artesanal e do compasso sapateado do fandango.',
        lifestyleHighlights: [
          'Fabricação artesanal de canoas de tronco inteiriço com enxó',
          'Pesca cooperativa da tainha com vigia nas pedras e divisão igualitária',
          'Fandango caiçara: baile tradicional com tamancos de madeira e afinação própria',
          'Culinária à base de peixe com banana-ouro (azul-marinho) e farinha de mandioca',
        ],
        vocabulary: [
          AncestralVocabEntity(
            id: 'anc-canoa-voga',
            termPt: 'Canoa de voga / Canoa de tronco',
            translationRu: 'Традиционная лодка-долбленка из цельного ствола дерева',
            definition:
                'Embarcação costeira escavada manualmente a partir de um único tronco de árvore nativa.',
            exampleSentence:
                'Os pescadores empurraram a canoa de voga para enfrentar a arrebentação das ondas.',
            dialect: 'pt_BR',
          ),
          AncestralVocabEntity(
            id: 'anc-fandango',
            termPt: 'Fandango caiçara',
            translationRu: 'Кайсарский танец и музыкальный фольклорный жанр',
            definition:
                'Manifestação cultural com sapateado ritmado, violas fandangueiras de cinco cordas e cantigas populares.',
            exampleSentence:
                'O baile de fandango durou a noite inteira ao som ritmado dos tamancos.',
            dialect: 'pt_BR',
          ),
          AncestralVocabEntity(
            id: 'anc-cerco',
            termPt: 'Cerco flutuante',
            translationRu: 'Плавающая ловушка / сеть для ловли мигрирующей рыбы',
            definition:
                'Armadilha de rede de origem ancestral japonesa e caiçara fixada no mar para captura de peixes em passagem.',
            exampleSentence:
                'Ao romper da aurora, recolhemos o cerco farto de robalos e tainhas prateadas.',
            dialect: 'pt_BR',
          ),
        ],
        audioNarration:
            'Nas enseadas protegidas de Paraty e Ubatuba, a batida do pé no chão de terra do fandango celebra a fartura da pesca comunitária.',
      ),
      TraditionalCommunityEntity(
        id: 'vaqueiros-sertao',
        title: 'Vaqueiros e Sertanejos da Caatinga',
        category: CommunityCategory.sertanejos,
        region: 'Sertão Nordestino (Piauí, Ceará, Bahia, Pernambuco)',
        country: 'Brasil',
        dialect: 'pt_BR',
        emoji: '🌵',
        shortSummary:
            'Guerreiros do semiárido vestidos com armadura de couro cru que conduzem o gado e entoam o aboio nas brenhas da Caatinga.',
        fullDescription:
            'O vaqueiro sertanejo é a figura mítica que domou o interior árido do Nordeste brasileiro. Enfrentando a vegetação espinhosa e agressiva da Caatinga (como mandacarus, xiquexiques e juremas), o vaqueiro se reveste da cabeça aos pés com o "gibão" — armadura de couro cru de bode ou boi composta por chapéu de aba curva, guarda-peito, perneiras e botas. Para localizar e conduzir as reses desgarradas na mata fechada, utiliza o "aboio", canto melancólico e potente sem palavras que acalma o gado e ecoa pelas serras. O sertanejo desenvolveu uma sabedoria única de sobrevivência, conhecendo plantas de reserva hídrica e os sinais meteorológicos da natureza.',
        lifestyleHighlights: [
          'Indumentária completa de couro curtido para proteção contra espinhos pontiagudos',
          'O aboio: canto ancestral de comunicação pastoral e pastoreio à distância',
          'Pega de boi no mato: corrida a cavalo pelas brenhas da Caatinga atrás da rês',
          'Medicina popular com raízes e cascas de jurema-preta, aroeira e entrecasca',
        ],
        vocabulary: [
          AncestralVocabEntity(
            id: 'anc-gibao',
            termPt: 'Gibão de couro',
            translationRu: 'Кожаная защитная куртка / доспех ковбоя сертана',
            definition:
                'Casaco rústico de couro cru resistente usado pelos vaqueiros para proteger o tronco dos espinhos da Caatinga.',
            exampleSentence:
                'O vaqueiro vestiu o gibão curtido para adentrar a caatinga fechada.',
            dialect: 'pt_BR',
          ),
          AncestralVocabEntity(
            id: 'anc-aboio',
            termPt: 'Aboio',
            translationRu: 'Протяжная пастушья песня / клич сертанежу для скота',
            definition:
                'Canto modulado e melancólico entoado sem palavras pelo vaqueiro para conduzir a boiada.',
            exampleSentence:
                'O eco do aboio do vaqueiro anunciava o retorno das reses ao curral ao entardecer.',
            dialect: 'pt_BR',
          ),
          AncestralVocabEntity(
            id: 'anc-mandacaru',
            termPt: 'Mandacaru',
            translationRu: 'Мандакару (величественный кактус-символ сертана)',
            definition:
                'Cacto nativo gigante da Caatinga com propriedades medicinais e reserva de água para o gado na estiagem.',
            exampleSentence:
                'Quando o mandacaru floresce na seca, o sertanejo sabe que a chuva há de chegar.',
            dialect: 'pt_BR',
          ),
        ],
        audioNarration:
            'A voz solitária do vaqueiro ergue-se no aboio ancestral, guiando a boiada entre as pedras aquecidas e os cactos do sertão.',
      ),
      TraditionalCommunityEntity(
        id: 'quilombolas-ribeira',
        title: 'Quilombolas do Vale do Ribeira e Palmares',
        category: CommunityCategory.quilombolas,
        region: 'Vale do Ribeira (SP/PR) e Alagoas',
        country: 'Brasil',
        dialect: 'pt_BR',
        emoji: '🌿',
        shortSummary:
            'Comunidades afrodescendentes remanescentes de quilombos que preservam o sistema agrícola tradicional de coivara e a ancestralidade.',
        fullDescription:
            'As comunidades quilombolas são territórios de resistência cultural e preservação ecológica secular. Estabelecidas por africanos escravizados que conquistaram a liberdade nas matas densas, preservam tradições agrícolas consagradas como Patrimônio Cultural do Brasil, como o Sistema Agrícola Tradicional de Roça de Coivara. Este sistema milenar envolve a queima controlada em pequenas clareiras, policultivo de mandioca, cará e milho crioulo, e longos períodos de repouso da terra (pousio) que regeneram a floresta tropical. As decisões comunitárias são tomadas em assembleias cooperativas ("mutirões"), onde o trabalho coletivo e o respeito aos anciãos ("griôs") são pilares inegociáveis.',
        lifestyleHighlights: [
          'Roça de coivara ecológica com rotatividade de terrenos e bancos de sementes nativas',
          'Mutirão comunitário para colheita, construção de casas e fabricação de farinha',
          'Artesanato em fibra de taquara, cipó e sementes de tento e açaí',
          'Oralidade preservada através das histórias dos mestres e anciãos da comunidade',
        ],
        vocabulary: [
          AncestralVocabEntity(
            id: 'anc-mutirao',
            termPt: 'Mutirão comunitário',
            translationRu: 'Коллективная взаимопомощь / совместный общинный труд',
            definition:
                'Mobilização solidária da comunidade para realizar uma tarefa pesada em benefício mútuo, sem remuneração monetária.',
            exampleSentence:
                'No sábado fizemos um grande mutirão para reparar a cobertura da casa de farinha.',
            dialect: 'all',
          ),
          AncestralVocabEntity(
            id: 'anc-coivara',
            termPt: 'Roça de coivara',
            translationRu: 'Традиционное подсечно-огневое экологическое земледелие',
            definition:
                'Método ancestral de cultivo em clareiras temporárias com queima de biomassa e descanso prolongado do solo.',
            exampleSentence:
                'A roça de coivara garante a fertilidade da terra sem o uso de defensivos químicos.',
            dialect: 'pt_BR',
          ),
          AncestralVocabEntity(
            id: 'anc-grio',
            termPt: 'Griô / Mestre de saberes',
            translationRu: 'Хранитель устной традиции / старейшина общины',
            definition:
                'Ancião reconhecido pela comunidade pela sua sabedoria oral, memória histórica e ensinamentos espirituais.',
            exampleSentence:
                'As crianças sentavam-se em roda para escutar as histórias sagradas do mestre griô.',
            dialect: 'pt_BR',
          ),
        ],
        audioNarration:
            'A terra no quilombo não é propriedade particular mercantil, mas sim um corpo vivo acolhedor cultivado em mutirão pelas famílias.',
      ),
      TraditionalCommunityEntity(
        id: 'pastores-serra-estrela',
        title: 'Pastores da Transumância da Serra da Estrela',
        category: CommunityCategory.pastores,
        region: 'Região Centro (Serra da Estrela e planícies do Alentejo)',
        country: 'Portugal',
        dialect: 'pt_PT',
        emoji: '🐑',
        shortSummary:
            'A transumância milenar entre as pastagens de altitude e os vales temperados, berço do Queijo Serra da Estrela e dos cães de guarda.',
        fullDescription:
            'A transumância é uma das práticas pastoris mais arcaicas da Europa meridional, sobrevivendo nas serras agrestes de Portugal. Todo o ano, quando a neve invernal e o calor tórrido do estio se alternam, os pastores serranos conduzem rebanhos de ovelhas bordaleiras pelas ancestrais "canadas" e quelhas de pedra entre os cumes da Serra da Estrela e as campinas abrigadas do Alentejo ou Idanha. Empunhando o cajado de freixo e vestidos com a tradicional "croça" ou capote de burel de lã impermeável, os pastores contam com a fidelidade intrépida do Cão da Serra da Estrela para proteger o gado dos lobos-ibéricos. O leite das ovelhas alimentadas com ervas selvagens dá origem ao célebre Queijo Serra da Estrela curado com flor de cardo.',
        lifestyleHighlights: [
          'Marcha pastoral a pé pelas canadas históricas ao longo de dezenas de quilómetros',
          'Uso do burel: tecido artesanal de lã de ovelha prensada resistente à chuva e ao gelo',
          'Manejo de rebanhos bordaleiros com o auxílio do Cão de Castro Laboreiro e da Estrela',
          'Coagulação vegetal tradicional do leite de ovelha utilizando infusão de flor de cardo',
        ],
        vocabulary: [
          AncestralVocabEntity(
            id: 'anc-transumancia',
            termPt: 'Transumância',
            translationRu: 'Сезонный перегон овечьих отар между горами и долинами',
            definition:
                'Deslocamento sazonal periódico de rebanhos em busca de pastos verdes e clima ameno.',
            exampleSentence:
                'Os rebanhos iniciaram a transumância descendo das alturas glaciares da serra.',
            dialect: 'pt_PT',
          ),
          AncestralVocabEntity(
            id: 'anc-burel',
            termPt: 'Burel de lã',
            translationRu: 'Бурель (традиционное португальское валяное сукно из шерсти)',
            definition:
                'Tecido artesanal espesso de pura lã de ovelha submetido a batedeira mecânica com água quente tornando-o impermeável.',
            exampleSentence:
                'A capa de burel protegia o pastor do vento cortante e do granizo na montanha.',
            dialect: 'pt_PT',
          ),
          AncestralVocabEntity(
            id: 'anc-cajado',
            termPt: 'Cajado de pastor',
            translationRu: 'Пастуший посох с крюком',
            definition:
                'Vara comprida de madeira nobre talhada à mão usada como apoio de caminhada e para alcançar animais desviados.',
            exampleSentence:
                'O velho pastor apoiou o corpo cansado no cajado envernizado pelo tempo.',
            dialect: 'all',
          ),
        ],
        audioNarration:
            'O eco dos chocalhos de latão ao pescoço das ovelhas bordaleiras rompe o nevoeiro denso das quelhas da Serra da Estrela.',
      ),
      TraditionalCommunityEntity(
        id: 'mariscadoras-aveiro-algarve',
        title: 'Mariscadoras e Pescadores da Ria de Aveiro e Ria Formosa',
        category: CommunityCategory.mariscadores,
        region: 'Litoral Atlântico (Aveiro e Algarve)',
        country: 'Portugal',
        dialect: 'pt_PT',
        emoji: '🐚',
        shortSummary:
            'Mulheres do mar e barqueiros moliceiros que recolhem bivalves nos sapais e conservam os segredos das marés vivas.',
        fullDescription:
            'Nas zonas lagunares de Portugal, como os esteiros da Ria de Aveiro e o labirinto de lodaçais da Ria Formosa em Olhão e Tavira, desenvolveu-se uma cultura marítima singular dominada pela sabedoria feminina das mariscadoras. Conhecedoras exímias das fases da lua e das correntes das marés vazantes, estas mulheres entram com água pela cintura nos esteiros lodosos ("sapais") para apanhar manualmente amêijoas-boas, berbigões, lingueirões e ostras com auxílio do ancinho e da faca de mariscar. Historicamente, os barcos moliceiros de proas coloridas e pinturas populares pícaras colhiam o moliço (algas marinhas) para fertilizar as dunas de areia, tornando a agricultura do litoral fértil e viva.',
        lifestyleHighlights: [
          'Apanha artesanal de bivalves à mão e com arrasto de cintura respeitando tamanhos mínimos',
          'Barcos moliceiros de madeira policromada com quadras poéticas na proa',
          'Conhecimento instintivo do calendário astronómico de marés vivas e marés mortas',
          'Secagem tradicional de polvos, carapaus e lulas ao sol à beira-mar',
        ],
        vocabulary: [
          AncestralVocabEntity(
            id: 'anc-mariscadora',
            termPt: 'Mariscadora da ria',
            translationRu: 'Женщина-сборщица моллюсков в приливных лагунах',
            definition:
                'Trabalhadora que apanha marisco manualmente na vaza durante a baixa-mar.',
            exampleSentence:
                'A mariscadora curvava-se sobre o lodo à procura das amêijoas escondidas na areia.',
            dialect: 'pt_PT',
          ),
          AncestralVocabEntity(
            id: 'anc-moliceiro',
            termPt: 'Barco moliceiro',
            translationRu: 'Молисейру (традиционная красочная лодка с загнутым носом в Авейру)',
            definition:
                'Embarcação elegante e esguia da Ria de Aveiro usada primitivamente na apanha do moliço (lodo fertilizante).',
            exampleSentence:
                'O barco moliceiro deslizava suavemente pelos canais da ria impulsionado pela vara comprida.',
            dialect: 'pt_PT',
          ),
          AncestralVocabEntity(
            id: 'anc-sapal',
            termPt: 'Sapal costeiro',
            translationRu: 'Затопляемый солончаковый марш / илистая лагуна',
            definition:
                'Terreno baixo alagadiço sujeito à ação rítmica das marés salgadas, berçário da vida marinha.',
            exampleSentence:
                'Centenas de flamingos cor-de-rosa descansavam nas águas mansas do sapal.',
            dialect: 'pt_PT',
          ),
        ],
        audioNarration:
            'Ao baixar da maré na ria, o marisco revela-se na lama e as mariscadoras iniciam com mestria a sua colheita paciente e silenciosa.',
      ),
    ];
  }

  static List<HerbalRemedyEntity> getHerbalRemedies() {
    return const [
      HerbalRemedyEntity(
        id: 'oleo-copaiba',
        plantNamePt: 'Óleo-resina de Copaíba',
        nameRu: 'Копайский бальзам (смола копаибы)',
        scientificName: 'Copaifera langsdorffii',
        traditionalUsePt:
            'Considerado o "bálsamo da Amazônia", é utilizado há séculos pelos povos indígenas e ribeirinhos como cicatrizante natural potentíssimo, antibacteriano e anti-inflamatório das vias respiratórias e articulares.',
        preparationInstructionsPt:
            'Tome duas ou três gotas diluídas numa colher de mel ou água morna pela manhã. Não exceda a dosagem recomendada. Para ferimentos externos, aplique algumas gotas diretamente sobre a pele previamente lavada.',
        imperativeGrammarNote:
            'Foco no Modo Imperativo: "Tome" (você - afirmativo), "Não exceda" (você - negativo com subjuntivo), "Aplique" (você - afirmativo). Atenção à regra: o imperativo negativo forma-se com "Não" + Presente do Subjuntivo.',
        precautionsRu:
            'Não indicado para gestantes ou pessoas com sensibilidade gástrica aguda. Uso interno requer estrita moderação.',
        icon: '🌳',
      ),
      HerbalRemedyEntity(
        id: 'cha-poejo',
        plantNamePt: 'Infusão de Poejo Alentejano',
        nameRu: 'Настой мяты блошиной (полея) по-алентежански',
        scientificName: 'Mentha pulegium',
        traditionalUsePt:
            'Erva emblemática do montado alentejano e da gastronomia lusitana, a infusão de poejo é célebre por combater cólicas, facilitar a digestão pesada e acalmar tosses e constipações de inverno.',
        preparationInstructionsPt:
            'Ferva duzentos mililitros de água de nascente. Deite uma colher de folhas e flores secas no bule. Tape o recipiente e deixe repousar durante sete minutos. Beba a infusão morna depois do jantar.',
        imperativeGrammarNote:
            'Verbos no Imperativo Afirmativo: "Ferva" (ferver -> ferva), "Deite" (deitar -> deite), "Tape" (tapar -> tape), "Deixe" (deixar -> deixe), "Beba" (beber -> beba). Em português europeu, expressa instrução polida e conselho de saúde.',
        precautionsRu:
            'Evitar o consumo excessivo contínuo e em doses elevadas durante a gravidez.',
        icon: '🍃',
      ),
      HerbalRemedyEntity(
        id: 'macela-serrana',
        plantNamePt: 'Chá de Macela / Marcela do Campo',
        nameRu: 'Чай из соцветий маселы (ромашки саванн)',
        scientificName: 'Achyrocline satureioides',
        traditionalUsePt:
            'Tradicionalmente colhida antes do nascer do sol na Sexta-Feira Santa pelos povos do campo no Sul e Sudeste, é o remédio popular soberano contra distúrbios digestivos, azia, nervosismo e dores de cabeça.',
        preparationInstructionsPt:
            'Não ferva as flores diretamente no fogo. Coloque as flores amarelas numa chávena e verta a água recém-fervida sobre elas. Abafe com um pires por dez minutos. Tome o chá sem açúcar para obter pleno efeito terapêutico.',
        imperativeGrammarNote:
            'Imperativo com negação e pronomes: "Não ferva" (negação com radical do subjuntivo: ferver -> não ferva), "Coloque" (colocar -> coloque), "Verta" (verter -> verta), "Abafe" (abafar -> abafe), "Tome" (tomar -> tome).',
        precautionsRu:
            'Planta aromática segura para uso diário em doses moderadas.',
        icon: '🌼',
      ),
      HerbalRemedyEntity(
        id: 'laranjeira-cidreira',
        plantNamePt: 'Tisana de Laranjeira e Erva-Cidreira',
        nameRu: 'Успокаивающий сбор из листьев померанца и мелиссы',
        scientificName: 'Citrus aurantium & Melissa officinalis',
        traditionalUsePt:
            'Receita dos ervanários tradicionais de aldeia de Portugal para promover o sono repousante, tranquilizar crises de ansiedade e reduzir a palpitação cardíaca após dias de cansaço intenso.',
        preparationInstructionsPt:
            'Junte folhas frescas de laranjeira-azeda e ramos tenros de erva-cidreira. Esmague levemente as folhas entre os dedos para que libertem os óleos essenciais. Adicione água quente e aguarde alguns instantes antes de tomar.',
        imperativeGrammarNote:
            'Foco no Modo Imperativo: construções imperativas e orações de finalidade: "Junte" (juntar), "Esmague" (esmagar), "Adicione" (adicionar), "Aguarde" (aguardar). Note a conjunção "para que libertem" exigindo o Presente do Subjuntivo.',
        precautionsRu:
            'Não substitui acompanhamento médico em casos de insônia crônica ou depressão severa.',
        icon: '🍊',
      ),
    ];
  }

  static List<AncestralQuizQuestion> getQuizzes() {
    return const [
      AncestralQuizQuestion(
        id: 'q-anc-1',
        question:
            'Como se chama a armadura rústica de couro cru usada pelos vaqueiros sertanejos para se protegerem dos espinhos pontiagudos da Caatinga?',
        options: [
          'Gibão de couro',
          'Burel da serra',
          'Palafita entalhada',
          'Poncho gaúcho',
        ],
        correctIndex: 0,
        explanation:
            'O gibão é o casaco e traje protetor de couro cru de bode ou boi sem o qual nenhum vaqueiro pode atravessar a vegetação impenetrável da Caatinga.',
      ),
      AncestralQuizQuestion(
        id: 'q-anc-2',
        question:
            'Qual é a forma correta do Imperativo Negativo para o verbo "ferver" ao dar uma instrução sobre o chá de macela na forma "você"?',
        options: [
          'Não ferve as flores diretamente.',
          'Não ferva as flores diretamente.',
          'Não ferver as flores diretamente.',
          'Não fervei as flores diretamente.',
        ],
        correctIndex: 1,
        explanation:
            'O imperativo negativo na 3ª pessoa (você) forma-se identicamente ao Presente do Subjuntivo: que você ferva -> Não ferva.',
      ),
      AncestralQuizQuestion(
        id: 'q-anc-3',
        question:
            'Qual manifestação cultural típica dos pescadores caiçaras envolve sapateado com tamancos de madeira e violas fandangueiras?',
        options: [
          'Fandango caiçara',
          'Frevo pernambucano',
          'Maracatu de baque virado',
          'Chula minhota',
        ],
        correctIndex: 0,
        explanation:
            'O fandango caiçara é o baile comunitário tradicional do litoral sul-sudeste, caracterizado pelo som percussivo dos tamancos de madeira contra o assoalho.',
      ),
      AncestralQuizQuestion(
        id: 'q-anc-4',
        question:
            'O que caracteriza o secular Sistema Agrícola Tradicional de Roça de Coivara praticado pelos quilombolas do Vale do Ribeira?',
        options: [
          'Irrigação por satélite e monocultura intensiva',
          'Policultivo em pequenas clareiras com cinzas nutritivas e longo pousio para regeneração da mata',
          'Arado mecânico pesado e adubação química sintética',
          'Cultivo submarino em esteiros salgados',
        ],
        correctIndex: 1,
        explanation:
            'A roça de coivara é uma prática agroflorestal ancestral sustentável: a queima controlada fertiliza o solo, cultivam-se variedades nativas e a clareira descansa por anos (pousio) recompondo a floresta.',
      ),
      AncestralQuizQuestion(
        id: 'q-anc-5',
        question:
            'Como se denomina o tecido artesanal impermeável de lã de ovelha prensada com água quente usado pelos pastores da Serra da Estrela?',
        options: [
          'Burel',
          'Chita',
          'Filigrana',
          'Cabedal',
        ],
        correctIndex: 0,
        explanation:
            'O burel é o tecido secular de pura lã de ovelha bordaleira batida nos pisões de água, célebre pela sua impermeabilidade contra o frio, gelo e chuva da serra.',
      ),
      AncestralQuizQuestion(
        id: 'q-anc-6',
        question:
            'Qual é a função do "barco moliceiro" tradicional com proas decoradas com pinturas populares na Ria de Aveiro?',
        options: [
          'Corrida de regata oceânica em mar aberto',
          'Apanha histórica do moliço (algas e vegetação aquática) para fertilizar as terras arenosas do litoral',
          'Transporte exclusivo de madeira nobre para os estaleiros de Lisboa',
          'Caça à baleia nas fendas abissais',
        ],
        correctIndex: 1,
        explanation:
            'Os barcos moliceiros recolhiam o moliço na laguna da Ria de Aveiro com compridas varas, adubando os campos de cultivo arenosos do noroeste português.',
      ),
    ];
  }
}
