import '../../domain/entities/fashion_entities.dart';

class FashionSeedData {
  static List<FashionTopicEntity> getTopics() {
    return const [
      FashionTopicEntity(
        id: 'spfw-brasil',
        title: 'São Paulo Fashion Week & Design Autoral',
        category: FashionCategory.altaCostura,
        region: 'São Paulo (Parque Ibirapuera)',
        country: 'Brasil',
        dialect: 'pt_BR',
        accentEmoji: '👠',
        shortSummary:
            'A maior semana de moda da América Latina e o quinto maior evento de alta-costura do mundo, celebrando a identidade tropical.',
        fullDescription:
            'Criada em 1996 sob a liderança visionária de Paulo Borges, a São Paulo Fashion Week (SPFW) transformou o Brasil em uma potência global de design de vestuário. Ocupando os pavilhões modernistas de Oscar Niemeyer no Parque Ibirapuera, a semana de moda consolidou estilistas autorais lendários como Alexandre Herchcovitch, Ronaldo Fraga e Lino Villaventura. A passarela brasileira destaca-se pela ousadia cromática, valorização de matérias-primas nativas sustentáveis (como fibras de buriti, látex da Amazônia e algodão colorido da Paraíba) e constante reinvenção das silhuetas tropicais com alfaiataria desconstruída.',
        keyHighlights: [
          'Maior vitrine de moda do hemisfério sul, lançando tendências globais de Primavera-Verão',
          'Pioneirismo em sustentabilidade têxtil e inclusão de modelos de diversas etnias brasileiras',
          'Integração de artesanato indígena e ribeirinho em peças conceituais de passarela',
          'Exportação de marcas autorais consagradas para Paris, Milão e Nova York',
        ],
        culturalSignificance:
            'Afirmação da autoimagem contemporânea do Brasil, combinando sofisticação cosmopolita com raízes ancestrais populares.',
        audioNarration:
            'Na passarela da São Paulo Fashion Week, as modelos desfilavam peças elegantíssimas com tecidos naturais e cores vibrantes da Amazônia.',
        vocabulary: [
          ScienceVocabPlaceholder(
            id: 'fsh-passarela',
            termPt: 'Passarela de desfile',
            translationRu: 'Подиум для показа мод',
            definition:
                'Palco elevado e comprido onde os modelos exibem as novas coleções conceituais dos estilistas.',
            exampleSentence:
                'O estilista aplaudiu de pé no encerramento do desfile na passarela principal.',
            dialect: 'all',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-estilista-autoral',
            termPt: 'Estilista autoral',
            translationRu: 'Авторский дизайнер-модельер',
            definition:
                'Criador de moda que desenvolve peças exclusivas guiadas por visão estética própria, fora do fast fashion em massa.',
            exampleSentence:
                'O estilista autoral resgatou bordados artesanais em sua coleção cápsula.',
            dialect: 'all',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-alfaiataria',
            termPt: 'Alfaiataria desconstruída',
            translationRu: 'Деконструированный индивидуальный пошив',
            definition:
                'Corte de ternos e blazers que quebra a rigidez clássica, oferecendo caimento leve e fluidez tropical.',
            exampleSentence:
                'A alfaiataria desconstruída combinava linho puro e cortes assimétricos moderníssimos.',
            dialect: 'pt_BR',
          ),
        ],
      ),
      FashionTopicEntity(
        id: 'calcado-portugues',
        title: 'Calçado Português: A Indústria mais Sexy da Europa',
        category: FashionCategory.calcadoCouro,
        region: 'São João da Madeira & Felgueiras',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '👞',
        shortSummary:
            'Tradição secular de manufatura de sapatos de luxo que combina mestria artesanal de sapateiros com tecnologia de precisão.',
        fullDescription:
            'Conhecida pela campanha internacional "The Portuguese Shoes: The Sexiest Industry in Europe", a indústria calçadista portuguesa é uma das mais respeitadas e prestigiadas do mercado de luxo internacional. Concentrada no norte do país, nas cidades de São João da Madeira e Felgueiras, a produção distingue-se pelo uso de couros nobres de curtume ecológico, palmilhas anatómicas respiráveis e técnicas ancestrais de costura como o método Goodyear Welted. Portugal exporta mais de 90% dos seus sapatos para capitais da moda como Paris, Tóquio e Berlim, calçando celebridades, realeza europeia e atletas de topo.',
        keyHighlights: [
          'Segundo preço médio de exportação mais alto do mundo no segmento de calçado de couro',
          'Museu do Calçado em São João da Madeira preservando séculos de história da arte sapataria',
          'Pioneirismo em sapatos veganos e calçado ergonómico feito com casca de sobreiro (cortiça)',
          'Fabricação artesanal de solas cosidas à mão por mestres sapateiros com décadas de experiência',
        ],
        culturalSignificance:
            'Símbolo de excelência, elegância duradoura e capacidade industrial de transformar um saber-fazer operário tradicional em artigo de luxo supremo.',
        audioNarration:
            'Os mestres sapateiros de São João da Madeira cosiam o cabedal macio à mão, garantindo um sapato confortabilíssimo e duradouro.',
        vocabulary: [
          ScienceVocabPlaceholder(
            id: 'fsh-cabedal',
            termPt: 'Cabedal nobre',
            translationRu: 'Благородная натуральная кожа для верха обуви',
            definition:
                'Couro de alta qualidade tratado e polido usado na confeção da parte superior do sapato.',
            exampleSentence:
                'O sapato foi confecionado com cabedal nobre de flor integral e acabamento brilhante.',
            dialect: 'pt_PT',
            dialectNote: 'Em Portugal usa-se "cabedal"; no Brasil é mais comum dizer "couro".',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-sapateiro',
            termPt: 'Mestre sapateiro',
            translationRu: 'Мастер-сапожник / обувщик',
            definition:
                'Artesão especializado no molde, corte e montagem manual de calçado sob medida.',
            exampleSentence:
                'O mestre sapateiro ajustou a forma de madeira para garantir o assentamento perfeito.',
            dialect: 'all',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-pesponto',
            termPt: 'Pesponto reforçado',
            translationRu: 'Укреплённая отделочная строчка',
            definition:
                'Costura visível e resistente feita com linha encerada para unir as partes do calçado com precisão milimétrica.',
            exampleSentence:
                'O pesponto duplo conferiu uma resistência extraordinária à bota de montanha.',
            dialect: 'all',
          ),
        ],
      ),
      FashionTopicEntity(
        id: 'rendas-bilros',
        title: 'Rendas de Bilros: Da Foz do Ave ao Litoral Cearense',
        category: FashionCategory.rendasTecidos,
        region: 'Vila do Conde (Portugal) & Aquiraz (Ceará, Brasil)',
        country: 'Portugal / Brasil',
        dialect: 'all',
        accentEmoji: '🧵',
        shortSummary:
            'A dança ágil dos bilros de madeira sobre a almofada que tece rendas vazadas de delicadeza incomparável.',
        fullDescription:
            'As rendas de bilros são uma das mais poéticas expressões têxteis do mundo lusófono. Trazidas de Portugal para o Brasil durante o período colonial, floresceram entre as mulheres de pescadores tanto em Vila do Conde e Peniche como nas dunas do Ceará, Maranhão e Santa Catarina. A rendilheira trabalha com dezenas de pequenos fusos de madeira torneada (bilros) que seguram os fios de linho ou algodão. Movimentando as mãos com velocidade hipnótica, cruza os bilros ao redor de alfinetes cravados num cartão perfurado preso à almofada cilíndrica, criando toalhas, golas e vestidos nupciais de leveza sem igual.',
        keyHighlights: [
          'Maior renda de bilros do mundo tecida em Vila do Conde, inscrita no Livro Guinness',
          'Tradição feminina comunitária cantada em cantigas de roda no litoral do Nordeste brasileiro',
          'Peças de alta-costura incorporadas por designers internacionais em vestidos de noiva e alta-roda',
          'Centros de artesanato e museus dedicados a manter vivos os pontos tradicionais (ponto de trança, cocadinha)',
        ],
        culturalSignificance:
            'Ponte viva de herança imaterial compartilhada entre as comunidades costeiras de Portugal e do Brasil.',
        audioNarration:
            'Ao som ritmado dos bilros de madeira batendo uns nos outros, as rendilheiras criavam tecidos finíssimos de renda pura.',
        vocabulary: [
          ScienceVocabPlaceholder(
            id: 'fsh-bilro',
            termPt: 'Bilro de madeira',
            translationRu: 'Коклюшка (деревянная палочка для плетения кружев)',
            definition:
                'Haste de madeira torneada com uma cabeça esférica onde se enrola a linha usada na feitura da renda.',
            exampleSentence:
                'O estalar veloz dos bilros ecoava pelas ruelas da vila marítima.',
            dialect: 'all',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-almofada-renda',
            termPt: 'Almofada de renda',
            translationRu: 'Подушка (валик) для кружевоплетения',
            definition:
                'Suporte cilíndrico estofado com palha onde a rendilheira fixa o desenho perfurado e espeta os alfinetes.',
            exampleSentence:
                'A artesã apoiou a almofada no cavalete de madeira para iniciar o novo desenho floral.',
            dialect: 'all',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-rendilheira',
            termPt: 'Rendilheira / Rendeira',
            translationRu: 'Кружевница',
            definition:
                'Mulher que domina a arte milenar de tecer rendas à mão com paciência e perícia geométrica.',
            exampleSentence:
                'A jovem rendeira cearense aprendeu os pontos mais complexos com a sua avó.',
            dialect: 'all',
            dialectNote: 'Em Portugal diz-se habitualmente "rendilheira"; no Brasil o termo popular é "rendeira".',
          ),
        ],
      ),
      FashionTopicEntity(
        id: 'chita-brasileira',
        title: 'Chita: A Alma Colorida e Popular do Brasil',
        category: FashionCategory.rendasTecidos,
        region: 'Nordeste e Minas Gerais',
        country: 'Brasil',
        dialect: 'pt_BR',
        accentEmoji: '🌺',
        shortSummary:
            'O tecido de algodão estampado com flores gigantes e cores puras que veste o povo, o São João e o teatro popular.',
        fullDescription:
            'Nenhum tecido encarna tão intensamente a alegria visual e a exuberância cultural brasileira quanto a chita. Originária dos tecidos de algodão estampados da Índia medieval (os "chintz"), a chita foi aclimatada e reinventada nas tecelagens mineiras e paulistas do século XIX. Caracterizada por sua trama de algodão simples (morim) e estampas de grandes flores tropicais, pássaros e folhagens com cores primárias saturadas sem meios-tons, a chita tornou-se o traje oficial das quadrilhas juninas, do maracatu, do bumba meu boi e da cenografia teatral do Brasil.',
        keyHighlights: [
          'Estampa icônica de flores grandiosas (hibiscos, margaridas e cravos) sobre fundos vermelhos, azuis e amarelos',
          'Transição cultural de tecido de baixo custo operário para elemento nobre de decoração de interiores e alta-costura',
          'Símbolo do movimento Tropicalista nos anos 60 e da identidade visual alegre do Nordeste',
          'Resistência ao desbotamento e versatilidade em vestidos rodados, toalhas de mesa e adereços carnavalescos',
        ],
        culturalSignificance:
            'Manifesto visual de exuberância cromática, criatividade popular e orgulho das tradições rurais e festivais comunitários.',
        audioNarration:
            'Com seus vestidos de chita floridíssimos, as dançarinas giravam na quadrilha sob a luz dos balões juninos.',
        vocabulary: [
          ScienceVocabPlaceholder(
            id: 'fsh-estampa-floral',
            termPt: 'Estampa floral exuberante',
            translationRu: 'Яркий цветочный принт',
            definition:
                'Padrão decorativo impresso no tecido com desenhos botânicos generosos e cores primárias contrastantes.',
            exampleSentence:
                'A saia com estampa floral chamava a atenção de todos na feira de artesanato.',
            dialect: 'all',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-trama-algodao',
            termPt: 'Trama de algodão',
            translationRu: 'Хлопчатобумажное переплетение нитей',
            definition:
                'Estrutura dos fios cruzados no tear que forma a base têxtil resistente e fresca do tecido.',
            exampleSentence:
                'A trama de algodão respirável é ideal para o clima quente do sertão.',
            dialect: 'all',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-morim',
            termPt: 'Morim / Algodão cru',
            translationRu: 'Миткаль / необработанный ситец',
            definition:
                'Tecido simples e rústico de algodão que serve de matéria-prima para a estampagem industrial da chita.',
            exampleSentence:
                'Antigamente, o morim branco era tingido com pigmentos vegetais extraídos de cascas de árvores.',
            dialect: 'pt_BR',
          ),
        ],
      ),
      FashionTopicEntity(
        id: 'filigrana-gondomar',
        title: 'Filigrana Portuguesa: Fios de Ouro de Gondomar',
        category: FashionCategory.ourivesariaDesign,
        region: 'Gondomar & Viana do Castelo',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '✨',
        shortSummary:
            'A arte ancestral de entrelaçar e soldar fios finíssimos de ouro e prata como rendas preciosas reluzentes.',
        fullDescription:
            'A filigrana é a joia identitária de Portugal por excelência. Praticada há mais de dois milénios na bacia do rio Douro, a técnica atinge o auge da perfeição oficinal nas oficinas familiares de Gondomar e na tradição do traje folclórico de Viana do Castelo. O ourives funde o ouro e passa-o por fieiras até obter fios microscópicos, quase tão finos como cabelos. Estes fios são depois torcidos a dois e achatados antes de preencherem minuciosamente armações em forma de Coração de Viana, Brincos de Rainha ou caravelas, sendo unidos por soldaduras impercetíveis a altas temperaturas.',
        keyHighlights: [
          'O Coração de Viana: peça icónica que simboliza o amor filial, a dedicação espiritual e a gratidão',
          'Uso cerimonial no "Traje à Vianesa", onde as noivas do Minho carregam quilos de peças de ouro ao peito',
          'Certificação oficial de Indicação Geográfica Protegida para a Filigrana de Portugal',
          'Fusão contemporânea com peças de alta joalharia e vestuário de gala internacional',
        ],
        culturalSignificance:
            'Expressão máxima do requinte orfebre luso, transmitida como herança de família e testemunho de brio das mulheres do norte.',
        audioNarration:
            'Com pinças precisas, o ourives dobrava fios de ouro finíssimos, criando um Coração de Viana perfeitíssimo e brilhante.',
        vocabulary: [
          ScienceVocabPlaceholder(
            id: 'fsh-ourivesaria',
            termPt: 'Ourivesaria tradicional',
            translationRu: 'Традиционное ювелирное искусство / золотое дело',
            definition:
                'Arte e ofício de trabalhar metais preciosos (ouro e prata) na criação de joias e adornos sagrados.',
            exampleSentence:
                'A ourivesaria de Gondomar é reconhecida pela pureza do seu ouro de 19,2 quilates.',
            dialect: 'pt_PT',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-coracao-viana',
            termPt: 'Coração de Viana',
            translationRu: 'Сердце Вианы (символ португальской филиграни)',
            definition:
                'Pendente de ouro rendilhado com topo em forma de chamas e centro ornamentado com volutas espirais.',
            exampleSentence:
                'A noiva minhota trazia ao pescoço um magnífico Coração de Viana em filigrana pura.',
            dialect: 'pt_PT',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-soldadura',
            termPt: 'Soldadura meticulosa',
            translationRu: 'Скрупулёзная пайка тончайших нитей',
            definition:
                'União térmica delicada das extremidades dos fios de metal através de pó de solda sem derreter o desenho.',
            exampleSentence:
                'A soldadura meticulosa exige anos de prática diante da chama do maçarico.',
            dialect: 'all',
          ),
        ],
      ),
      FashionTopicEntity(
        id: 'eco-design-textil',
        title: 'Eco-Design & Têxteis Sustentáveis do Vale do Ave',
        category: FashionCategory.altaCostura,
        region: 'Guimarães, Famalicão & Porto',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '🌿',
        shortSummary:
            'A revolução verde da indústria têxtil: fios de plástico marinho, tingimentos botânicos e circularidade de ponta.',
        fullDescription:
            'O Vale do Ave, berço histórico da revolução industrial portuguesa no norte do país, transformou-se no mais avançado laboratório de inovação têxtil sustentável da Europa. Empresas de Guimarães e Famalicão combinam a longa tradição de tecelagem com química verde e economia circular. Em vez de corantes sintéticos poluentes, utilizam resíduos agrícolas (cascas de romã, borras de café e bolota de sobreiro) para tingir algodão orgânico e linho ecológico. Fios inovadores desenvolvidos na região reaproveitam toneladas de redes de pesca recolhidas no litoral português para produzir tecidos técnicos de alto desempenho desportivo e alfaiataria sustentável.',
        keyHighlights: [
          'Desenvolvimento de tecidos com certificação GOTS (Global Organic Textile Standard)',
          'Tingimentos vegetais que economizam até 80% de água em comparação com métodos convencionais',
          'Parcerias com gigantes da moda mundial para fornecimento de malhas recicladas rastreadas via blockchain',
          'Transformação de sobras fabris em novos fios através de processos mecânicos sem aditivos químicos',
        ],
        culturalSignificance:
            'Demonstração da liderança europeia de Portugal na transição ecológica da moda e valorização da indústria de ciclo fechado.',
        audioNarration:
            'Nas tecelagens do Vale do Ave, fios reciclados e tinturas naturais dão origem a tecidos ecológicos limpíssimos e inovadores.',
        vocabulary: [
          ScienceVocabPlaceholder(
            id: 'fsh-tingimento-vegetal',
            termPt: 'Tingimento botânico',
            translationRu: 'Ботаническое / растительное крашение тканей',
            definition:
                'Processo de coloração têxtil que emprega extratos naturais de folhas, cascas de frutos e raízes.',
            exampleSentence:
                'O tingimento botânico conferiu à camisa um tom ocre suave e totalmente biodegradável.',
            dialect: 'all',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-economia-circular',
            termPt: 'Economia circular têxtil',
            translationRu: 'Циркулярная текстильная экономика (безотходное производство)',
            definition:
                'Modelo produtivo em que roupas e retalhos velhos são reciclados continuamente em novos fios sem gerar lixo.',
            exampleSentence:
                'A marca portuguesa adotou a economia circular têxtil como princípio norteador.',
            dialect: 'all',
          ),
          ScienceVocabPlaceholder(
            id: 'fsh-fibra-reciclada',
            termPt: 'Fio de poliéster reciclado',
            translationRu: 'Нить из переработанного пластика',
            definition:
                'Filamento têxtil produzido a partir de garrafas PET e redes de pesca recolhidas nos oceanos.',
            exampleSentence:
                'O blusão corta-vento foi confecionado inteiramente com fio de poliéster reciclado.',
            dialect: 'all',
          ),
        ],
      ),
    ];
  }

  static List<TextileCraftEntity> getTextileCrafts() {
    return const [
      TextileCraftEntity(
        id: 'craft-bilros',
        title: 'Manufatura de Renda de Bilros Tradicional',
        region: 'Vila do Conde & Ceará',
        materialPt: 'Linha fina de algodão ou linho cru, bilros torneados em buxo ou jacarandá, alfinetes de latão e almofada de palha.',
        techniqueDescriptionPt:
            'A rendilheira manuseia os bilros dois a dois com rapidez desconcertante. O cruzamento dos fios segue furos previamente calculados num cartão vegetal, construindo tramas arejadas e flores rendilhadas.',
        techniqueDescriptionRu:
            'Кружевница перебирает коклюшки попарно с поразительной скоростью. Перекрещивание нитей следует по отверстиям на сколке, создавая воздушные сетки и ажурные цветы.',
        stepByStepGuide: [
          'Prende-se o picotado (cartão perfurado com o desenho geométrico) sobre a almofada cilíndrica bem compacta.',
          'Enrolam-se os fios de linho nos pares de bilros de madeira com nós corredios firmes.',
          'Espetam-se os alfinetes nos primeiros pontos de guia para ancorar as laçadas iniciais.',
          'Executam-se os movimentos fundamentais: torcer (passar o bilro direito sobre o esquerdo) e cruzar (passar o bilro do meio).',
          'Avança-se linha por linha, transferindo os alfinetes à medida que o padrão de renda se consolida.',
        ],
        grammarInsight:
            'Graus dos Adjetivos: As rendas de bilros são finíssimas (superlativo absoluto sintético de fino) e muito mais delicadas do que (comparativo de superioridade) os tecidos industriais comuns.',
        icon: '🧵',
      ),
      TextileCraftEntity(
        id: 'craft-calcado',
        title: 'Montagem Goodyear Welted no Calçado Artesanal',
        region: 'São João da Madeira (Portugal)',
        materialPt: 'Couro bovino de flor integral curtido vegetalmente, vira de couro, palmilha de montagem e fio de linho encerado.',
        techniqueDescriptionPt:
            'Processo de montagem de calçado de altíssimo prestígio que une o cabedal, a palmilha interior e uma tira de couro perimetral (vira) através de dupla costura impermeável.',
        techniqueDescriptionRu:
            'Престижный метод рантовой сборки обуви, соединяющий верх, внутреннюю стельку и кожаный рант через водонепроницаемый двойной шов.',
        stepByStepGuide: [
          'Molda-se o cabedal humedecido sobre a forma anatómica de madeira, esticando a pele com alicates de sapateiro.',
          'Aplica-se a vira de couro ao redor de toda a borda inferior do sapato com cola natural.',
          'Executa-se a primeira costura Goodyear, ligando a vira, o cabedal e a reentrância da palmilha interior.',
          'Preenche-se o espaço oco entre a palmilha e a sola com uma camada amortecedora de pasta de cortiça portuguesa.',
          'Aplica-se a sola de sola grossa de couro e faz-se a costura exterior final com linha encerada reforçada.',
        ],
        grammarInsight:
            'Graus dos Adjetivos: Um sapato com construção Goodyear é tão durável quanto (comparativo de igualdade) elegante, resultando num produto durabilíssimo (superlativo de durável) e nobilíssimo (superlativo de nobre).',
        icon: '👞',
      ),
      TextileCraftEntity(
        id: 'craft-filigrana',
        title: 'Moldagem e Soldadura do Coração de Viana',
        region: 'Gondomar (Norte de Portugal)',
        materialPt: 'Ouro português de 19,2 quilates (toque 800), maçarico de joalheiro, pó de solda de prata e pinças de ponta fina.',
        techniqueDescriptionPt:
            'O ourives cria primeiramente o esqueleto exterior (esqueleto da peça) em lâmina de metal e preenche os espaços internos torcendo fios espiralados minúsculos sem deixar folgas.',
        techniqueDescriptionRu:
            'Ювелир сначала создает внешний каркас украшения, а затем плотно заполняет внутреннее пространство тончайшими спиралевидными нитями.',
        stepByStepGuide: [
          'Puxa-se o fio de ouro através da fieira de diamante até atingir a espessura de um décimo de milímetro.',
          'Torcem-se dois fios juntos para criar o efeito granulado serrilhado característico da filigrana lusa.',
          'Dobra-se a lâmina externa mais grossa para delinear a silhueta clássica do coração e das chamas superiores.',
          'Com uma pinça minúscula, o artesão enrola os fios torcidos em caracóis (volutas) e acomoda-os no interior da armação.',
          'Polvilha-se o pó de solda sobre a peça e aquece-se cuidadosamente com o maçarico até a solda fundir sem deformar os fios.',
        ],
        grammarInsight:
            'Graus dos Adjetivos: A filigrana portuguesa é a mais complexa de todas (superlativo relativo de superioridade). Os fios são finíssimos e a solda é perfeitíssima (superlativos sintéticos em -íssimo).',
        icon: '✨',
      ),
      TextileCraftEntity(
        id: 'craft-chita',
        title: 'Estamparia Tradicional de Chita em Blocos de Madeira',
        region: 'Minas Gerais & Nordeste',
        materialPt: 'Tecido de morim de algodão alvejado, matrizes entalhadas em madeira de lei (xilogravura têxtil) e tintas minerais vivas.',
        techniqueDescriptionPt:
            'Impressão manual seriada de padrões florais vibrantes através de blocos de madeira gravados à mão, aplicando uma cor de cada vez sobre a tela de algodão.',
        techniqueDescriptionRu:
            'Ручная набойка ярких цветочных узоров деревянными штампами, наносящими каждый цвет поочередно на хлопковое полотно.',
        stepByStepGuide: [
          'Estica-se o tecido de algodão lavado sobre a longa mesa forrada de feltro para absorver o impacto.',
          'Entalham-se os relevos dos contornos florais nos blocos de madeira com goivas e formões afiados.',
          'Passa-se o rolo com a tinta vermelha sobre a primeira matriz de madeira.',
          'Pressiona-se o bloco contra o tecido com um martelo de borracha para transferir a estampa com firmeza.',
          'Repete-se o processo com os blocos das folhas verdes e do miolo amarelo, alinhando as matrizes com rigor visual.',
        ],
        grammarInsight:
            'Graus dos Adjetivos: As cores da chita são vivíssimas (superlativo de vivo). O tecido é menos caro do que a seda (comparativo de inferioridade), mas tão expressivo como (comparativo de igualdade) qualquer brocado nobre.',
        icon: '🌺',
      ),
    ];
  }

  static List<FashionQuizQuestion> getQuizzes() {
    return const [
      ScienceQuizQuestionPlaceholder(
        id: 'quiz-fsh-1',
        question:
            'Qual é a cidade do norte de Portugal considerada a capital do calçado de luxo e sede do Museu do Calçado?',
        options: [
          'São João da Madeira',
          'Coimbra',
          'Évora',
          'Faro',
        ],
        correctIndex: 0,
        explanation:
            'São João da Madeira é o principal polo da indústria de calçado de alto valor agregado em Portugal, famosa por exportar sapatos sofisticados para o mundo todo.',
        dialect: 'pt_PT',
        contextCategory: 'Calçado & Couro Português',
        accentEmoji: '👞',
      ),
      ScienceQuizQuestionPlaceholder(
        id: 'quiz-fsh-2',
        question:
            'Como se forma o superlativo absoluto sintético do adjetivo "fino", muito comum ao descrever rendas e fios de ouro?',
        options: [
          'Finíssimo',
          'Mais fino de todos',
          'Muito fino',
          'Finérrimo',
        ],
        correctIndex: 0,
        explanation:
            'O superlativo absoluto sintético de "fino" forma-se adicionando o sufixo "-íssimo", resultando em "finíssimo".',
        dialect: 'all',
        contextCategory: 'Gramática: Graus dos Adjetivos',
        accentEmoji: '📚',
      ),
      ScienceQuizQuestionPlaceholder(
        id: 'quiz-fsh-3',
        question:
            'Qual é a joia mais célebre e representativa da filigrana tradicional portuguesa de Viana do Castelo e Gondomar?',
        options: [
          'O Coração de Viana',
          'A Estrela de Sintra',
          'A Caravela dos Mares',
          'A Rosa do Alentejo',
        ],
        correctIndex: 0,
        explanation:
            'O Coração de Viana, com suas chamas rendilhadas e volutas de fios de ouro de 19,2 quilates, é o símbolo maior da ourivesaria e identidade visual do Minho.',
        dialect: 'pt_PT',
        contextCategory: 'Ourivesaria & Filigrana',
        accentEmoji: '✨',
      ),
      ScienceQuizQuestionPlaceholder(
        id: 'quiz-fsh-4',
        question:
            'Qual tecido de algodão de cores primárias fortes e flores gigantes simboliza as festas juninas e a alma popular do Brasil?',
        options: [
          'A Chita',
          'O Veludo cotelê',
          'O Tweed escocês',
          'A Seda selvagem',
        ],
        correctIndex: 0,
        explanation:
            'A chita é o tecido nacional por excelência no folclore brasileiro, marcando presença obrigatória em vestidos de quadrilha, no maracatu e no artesanato do Nordeste.',
        dialect: 'pt_BR',
        contextCategory: 'Tecidos Tradicionais & Folclore',
        accentEmoji: '🌺',
      ),
      ScienceQuizQuestionPlaceholder(
        id: 'quiz-fsh-5',
        question:
            'Na frase: "O sapato artesanal é mais durável do que o sapato industrial", qual grau do adjetivo está empregado?',
        options: [
          'Comparativo de superioridade ("mais... do que")',
          'Comparativo de igualdade ("tão... quanto")',
          'Superlativo relativo de inferioridade',
          'Superlativo absoluto analítico',
        ],
        correctIndex: 0,
        explanation:
            'A estrutura "mais + adjetivo + (do) que" expressa o Comparativo de Superioridade na língua portuguesa.',
        dialect: 'all',
        contextCategory: 'Gramática: Comparativos',
        accentEmoji: '🧵',
      ),
      ScienceQuizQuestionPlaceholder(
        id: 'quiz-fsh-6',
        question:
            'Que instrumento essencial as artesãs de Vila do Conde e do Ceará utilizam aos pares para tecer a renda sobre a almofada?',
        options: [
          'Os bilros de madeira torneada',
          'Agulhas de crochê de aço',
          'Teares manuais de pedal',
          'Máquinas a vapor circulares',
        ],
        correctIndex: 0,
        explanation:
            'As rendas de bilros recebem este nome exatamente pelo uso dos bilros (pequenos fusos de madeira torneada em pares) que entrelaçam os fios na almofada.',
        dialect: 'all',
        contextCategory: 'Rendas & Artesanato Lusófono',
        accentEmoji: '🧶',
      ),
    ];
  }
}

// Aliases for cleaner seed definitions
typedef ScienceVocabPlaceholder = FashionVocabEntity;
typedef ScienceQuizQuestionPlaceholder = FashionQuizQuestion;
