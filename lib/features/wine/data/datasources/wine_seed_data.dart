import '../../domain/entities/wine_entities.dart';

class WineSeedData {
  static List<WineRegionEntity> getRegions() {
    return const [
      WineRegionEntity(
        id: 'douro-porto',
        name: 'Vale do Douro & Vinho do Porto',
        category: WineCategory.vinhoFortificado,
        subRegion: 'Cima Corgo & Douro Superior',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '🍷',
        shortSummary:
            'A primeira região demarcada e regulamentada do mundo (1756), com vinhedos plantados em socalcos vertiginosos de xisto.',
        fullDescription:
            'O Alto Douro Vinhateiro, Património Mundial da UNESCO, é uma paisagem cultural esculpida pelo trabalho hercúleo de gerações ao longo das margens íngremes do rio Douro. Delimitada pelo Marquês de Pombal em 1756, a região é o berço do Vinho do Porto, vinho generoso fortificado com aguardente vínica durante a fermentação para preservar os açúcares naturais da uva. Os barris desciam o rio nos pitorescos barcos rabelos até às caves de Vila Nova de Gaia para estagiar em pipas de carvalho. As castas autóctones, adaptadas aos solos pedregosos de xisto e verões escaldantes, dão origem a Portos lendários como os Tawnies envelhecidos em madeira e os raros Vintages engarrafados nos melhores anos.',
        keyCastas: [
          'Touriga Nacional (a rainha das castas lusas)',
          'Touriga Franca (elegância floral e estrutura)',
          'Tinta Roriz / Aragonez (taninos firmes)',
          'Tinta Barroca (cor intensa e doçura frutada)',
        ],
        tastingProfile:
            'Aromas opulentos de ameixa seca, figos confitados, nozes tostadas e notas balsâmicas de esteva, com final aveludado e persistência interminável.',
        audioNarration:
            'Nos socalcos do Douro, as uvas sobrevivem ao calor intenso nas fendas do xisto, originando um Vinho do Porto potentíssimo e aromático.',
        vocabulary: [
          WineVocabEntity(
            id: 'wne-socalco',
            termPt: 'Socalco de xisto',
            translationRu: 'Сланцевая терраса на крутых склонах Дору',
            definition:
                'Degrau em socalcos sustentado por muros de pedra solta construído para viabilizar o cultivo da vinha nas encostas íngremes.',
            exampleSentence:
                'Os socalcos milenares do Douro serpenteiam pelas montanhas até tocarem o leito do rio.',
            dialect: 'pt_PT',
          ),
          WineVocabEntity(
            id: 'wne-vinho-generoso',
            termPt: 'Vinho generoso',
            translationRu: 'Крепленое благородное десертное вино',
            definition:
                'Designação legal em Portugal para vinhos licorosos fortificados de teor alcoólico elevado protegidos por Denominação de Origem.',
            exampleSentence:
                'O Vinho do Porto é o vinho generoso mais célebre do mundo ocidental.',
            dialect: 'pt_PT',
          ),
          WineVocabEntity(
            id: 'wne-estagio-casco',
            termPt: 'Estágio em casco de carvalho',
            translationRu: 'Выдержка в дубовых бочках (пипах)',
            definition:
                'Período em que o vinho descansa em tonéis de madeira noble, ganhando complexidade oxidativa e notas amadeiradas.',
            exampleSentence:
                'O Porto Tawny ganha sua tonalidade aloirada após longo estágio em casco de carvalho.',
            dialect: 'all',
          ),
        ],
      ),
      WineRegionEntity(
        id: 'vinho-verde-minho',
        name: 'Vinho Verde & Rota do Alvarinho',
        category: WineCategory.vinhoVerdeBranco,
        subRegion: 'Monção, Melgaço & Vale do Lima',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '🍾',
        shortSummary:
            'Vinhos jovens, estaladiços e vibrantes do verdejante Minho, famosos pela sua acidez fresca e elegância mineral.',
        fullDescription:
            'A Região dos Vinhos Verdes estende-se pelo noroeste de Portugal, entre os rios Minho e Douro, numa paisagem verdejante de influência atlântica e brisas marítimas húmidas. O termo "Verde" não se refere à cor do vinho, mas sim à juventude e frescura do seu perfil, em contraste com vinhos maduros encorpados. Na sub-região de Monção e Melgaço, a casta nobre Alvarinho atinge o ápice de expressão mineral com notas de pêssego branco e flor de laranjeira, enquanto o Loureiro no Vale do Lima oferece um perfil aromático floral arrebatador. Os vinhos verdes brancos são celebrados internacionalmente pela sua leveza frisante natural (a famosa "agulha") e acidez gastronómica perfeita para acompanhar pratos de peixe fresco e marisco.',
        keyCastas: [
          'Alvarinho (corpo nobre, mineralidade e complexidade cítrica)',
          'Loureiro (aromas intensos de louro, jasmim e maçã verde)',
          'Trajadura (suavidade e equilíbrio alcoólico)',
          'Avesso (untuosidade e frescura na transição para o interior)',
        ],
        tastingProfile:
            'Aroma límpido e cítrico de lima, toranja e pedras molhadas, palato vivíssimo, crocante e mineral com final refrescante e ligeira efervescência.',
        audioNarration:
            'O Vinho Verde Alvarinho desliza pela taça com aromas cítricos de toranja e flor de laranjeira, exibindo uma frescura oceânica inigualável.',
        vocabulary: [
          WineVocabEntity(
            id: 'wne-agulha',
            termPt: 'Agulha natural',
            translationRu: 'Легкая природная покалывающая газация (фризанте)',
            definition:
                'Pequeníssima quantidade de gás carbónico residual que confere ao vinho uma sensação picante e refrescante na língua.',
            exampleSentence:
                'A agulha discreta deste Vinho Verde torna cada golo incrivelmente apetecível no verão.',
            dialect: 'pt_PT',
          ),
          WineVocabEntity(
            id: 'wne-estaladico',
            termPt: 'Vinho estaladiço',
            translationRu: 'Хрустящее, звеняще-свежее вино (с высокой кислотностью)',
            definition:
                'Vinho branco com acidez marcada, limpa e revigorante que desperta imediatamente o palato.',
            exampleSentence:
                'Servimos um Alvarinho estaladiço e bem gelado para acompanhar as amêijoas à Bulhão Pato.',
            dialect: 'pt_PT',
          ),
          WineVocabEntity(
            id: 'wne-enforcado',
            termPt: 'Vinha em enforcado / Ramada',
            translationRu: 'Традиционная высокая шпалера (лоза, вьющаяся по деревьям)',
            definition:
                'Sistema ancestral minhoto de condução da videira em altura sobre árvores ou pérgulas para libertar o solo para outras culturas.',
            exampleSentence:
                'Nas quintas antigas do Minho ainda se avistam vinhas em enforcado subindo pelos carvalhos.',
            dialect: 'pt_PT',
          ),
        ],
      ),
      WineRegionEntity(
        id: 'azeite-alentejo',
        name: 'Azeite Virgem Extra do Alentejo & Trás-os-Montes',
        category: WineCategory.azeiteVirgemExtra,
        subRegion: 'Moura, Serpa & Mirandela',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '🫒',
        shortSummary:
            'O ouro líquido alentejano e transmontano: azeites de acidez quase nula, prensados a frio a partir de oliveiras centenárias.',
        fullDescription:
            'Portugal é o quarto maior exportador de azeite do planeta, com mais de 70% da sua produção concentrada nas planícies ensolaradas do Alentejo e nos vales protegidos de Trás-os-Montes. O azeite virgem extra de Denominação de Origem Protegida (DOP) destaca-se pela sua pureza química extrema, com níveis de acidez livre frequentemente inferiores a 0,2%. A colheita precoce das azeitonas das castas Cobrançosa, Galega e Cordovil, aliada à moenda mecânica a frio em lagares ecológicos nas primeiras 24 horas após a apanha, preserva polifenóis e antioxidantes preciosos. O azeite resultante possui cor verde-dourada límpida, notas de erva fresca cortada, folha de tomateiro e um final picante e amargo harmonioso.',
        keyCastas: [
          'Cobrançosa (aroma herbáceo de erva recém-cortada e final picante)',
          'Galega Vulgar (doçura de maçã madura e azeitona verde)',
          'Cordovil de Serpa (frutado verde intenso e notas de casca de banana)',
          'Madural e Verdeal Transmontana (frescura amendoada do norte)',
        ],
        tastingProfile:
            'Aroma frutado verde potente com toques de folha de oliveira e tomateiro, entrada doce na boca que evolui para um amargo nobre e picante persistente na garganta.',
        audioNarration:
            'O azeite virgem extra do Alentejo brilhava na taça de prova com notas herbáceas puríssimas e uma textura aveludada impecável.',
        vocabulary: [
          WineVocabEntity(
            id: 'wne-prensagem-frio',
            termPt: 'Primeira extração a frio',
            translationRu: 'Первый холодный механический отжим',
            definition:
                'Processo puramente mecânico de extração do azeite a temperaturas controladas inferiores a 27°C sem solventes químicos.',
            exampleSentence:
                'O azeite obtido por primeira extração a frio mantém intactas todas as suas vitaminas e aromas nativos.',
            dialect: 'all',
          ),
          WineVocabEntity(
            id: 'wne-acidez-livre',
            termPt: 'Acidez livre',
            translationRu: 'Кислотность оливкового масла (в % олеиновой кислоты)',
            definition:
                'Índice químico que mede a percentagem de ácidos gordos livres; quanto mais baixa, mais nobre e saudável é o azeite.',
            exampleSentence:
                'Este lote especial de Moura atingiu uma acidez livre incrível de apenas 0,1%.',
            dialect: 'all',
          ),
          WineVocabEntity(
            id: 'wne-polifenois',
            termPt: 'Polifenóis antioxidantes',
            translationRu: 'Полифенолы (природные антиоксиданты оливкового масла)',
            definition:
                'Compostos bioativos vegetais responsáveis pela estabilidade oxidativa do azeite e pela sensação de picor salutar na garganta.',
            exampleSentence:
                'A riqueza em polifenóis garante a longevidade do azeite e protege a saúde cardiovascular.',
            dialect: 'all',
          ),
        ],
      ),
      WineRegionEntity(
        id: 'vinho-madeira',
        name: 'Vinho da Madeira: O Elixir Vulcânico dos Mares',
        category: WineCategory.vinhoFortificado,
        subRegion: 'Funchal, Câmara de Lobos & São Vicente',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '🏝️',
        shortSummary:
            'O vinho indestrutível que viajou pelos trópicos nos galeões e resiste por mais de dois séculos em garrafa.',
        fullDescription:
            'Plantadas em encostas vulcânicas quase verticais sobre o oceano Atlântico, as vinhas da ilha da Madeira produzem um dos néctares mais lendários e longevos da civilização. No século XVII, descobriu-se que os barris de vinho fortificado que cruzavam o equador nos porões quentes dos navios (os chamados Vinhos de Torna-Viagem) regressavam muito mais ricos, macios e caramelizados. Nasceu assim o processo único de envelhecimento em "canteiro" (estágio em pipas nos sótãos quentes das adegas sob o calor natural do sol) e em estufas térmicas. O Vinho da Madeira sobrevive aberto por décadas sem se degradar e desdobra-se em quatro estilos nobres: Sercial (seco), Verdelho (meio-seco), Bual (meio-doce) e Malvasia (doce sumptuoso).',
        keyCastas: [
          'Sercial (seco, acidez vulcânica penetrante e casca de limão)',
          'Verdelho (meio-seco, notas de avelã e caramelo tostado)',
          'Bual / Boal (meio-doce, uva passa, tabaco e chocolate amargo)',
          'Malvasia Cândida (doce aveludado, melaço de cana e café)',
        ],
        tastingProfile:
            'Aroma inebriante de noz moscada, casca de laranja cristalizada, fumo de charuto e iodo marinho, com acidez vulcânica vibrante que corta a doçura com mestria.',
        audioNarration:
            'Com séculos de maturação sob o sol da ilha, o Vinho da Madeira exala notas complexas de frutos secos e uma acidez viva eletrizante.',
        vocabulary: [
          WineVocabEntity(
            id: 'wne-canteiro',
            termPt: 'Sistema de canteiro',
            translationRu: 'Выдержка кантейру (в бочках на чердаках виноделен под солнцем)',
            definition:
                'Método tradicional madeirense de repousar as pipas de carvalho sobre vigas de madeira no último piso das adegas sob calor solar.',
            exampleSentence:
                'Os vinhos de canteiro estagiam pelo menos quatro anos antes de serem engarrafados.',
            dialect: 'pt_PT',
          ),
          WineVocabEntity(
            id: 'wne-acidez-vulcanica',
            termPt: 'Acidez vulcânica',
            translationRu: 'Вулканическая минеральная кислотность',
            definition:
                'Frescura acídica penetrante herdada dos solos basálticos ricos em minerais da ilha da Madeira.',
            exampleSentence:
                'A acidez vulcânica equilibra perfeitamente a doçura natural do Malvasia centenário.',
            dialect: 'pt_PT',
          ),
          WineVocabEntity(
            id: 'wne-torna-viagem',
            termPt: 'Vinho de Torna-Viagem',
            translationRu: 'Вино возвращенного плавания (состаренное в трюмах кораблей)',
            definition:
                'Vinho histórico que realizava a viagem de ida e volta marítima pelas Índias ou Américas para apurar sabor.',
            exampleSentence:
                'Uma garrafa de torna-viagem do século XIX é uma das relíquias mais cobiçadas em leilões mundiais.',
            dialect: 'pt_PT',
          ),
        ],
      ),
      WineRegionEntity(
        id: 'serra-gaucha-brasil',
        name: 'Vale dos Vinhedos & Serra Gaúcha',
        category: WineCategory.vinhoBrasileiroAltitude,
        subRegion: 'Bento Gonçalves, Garibaldi & Pinto Bandeira',
        country: 'Brasil',
        dialect: 'pt_BR',
        accentEmoji: '🥂',
        shortSummary:
            'A capital brasileira dos espumantes premiados e tintos de altitude, forjada pela herança dos imigrantes italianos.',
        fullDescription:
            'Encravado nas colinas onduladas do Rio Grande do Sul a altitudes entre 600 e 800 metros, o Vale dos Vinhedos foi a primeira região vitivinícola do Brasil a obter a prestigiosa Denominação de Origem (D.O.). Colonizada por imigrantes do Vêneto e Trento no final do século XIX, a região transformou-se na maior produtora de vinhos finos e espumantes da América do Sul. A cidade de Garibaldi destaca-se internacionalmente pela elaboração de espumantes pelo Método Tradicional (segunda fermentação na garrafa) com uvas Chardonnay e Pinot Noir, conquistando medalhas de ouro em concursos mundiais em França e Inglaterra. O clima temperado de noites frescas propicia tintos elegantes de Merlot e brancos aromáticos de Moscato de grande tipicidade.',
        keyCastas: [
          'Chardonnay (base para espumantes finos de grande cremosidade)',
          'Pinot Noir (estrutura, frescura e notas de frutos vermelhos silvestres)',
          'Merlot (a casta tinta emblemática da D.O. Vale dos Vinhedos)',
          'Moscato Branco (espumantes moscatéis doces e florais de Pinto Bandeira)',
        ],
        tastingProfile:
            'Perlage finíssima e persistente, aromas frescos de maçã verde, brioche tostado e leveduras nobres, com boca cremosa, acidez equilibrada e final mineral.',
        audioNarration:
            'Nas colinas da Serra Gaúcha, as taças de espumante método tradicional borbulham com perlage finíssima e aromas de leveduras frescas.',
        vocabulary: [
          WineVocabEntity(
            id: 'wne-metodo-tradicional',
            termPt: 'Método Tradicional / Champenoise',
            translationRu: 'Классический метод шампанизации (брожение в бутылке)',
            definition:
                'Processo em que a segunda fermentação ocorre dentro da própria garrafa selada, repousando longos meses sobre as leveduras.',
            exampleSentence:
                'O espumante brut passou trinta e seis meses em contato com as leveduras pelo método tradicional.',
            dialect: 'all',
          ),
          WineVocabEntity(
            id: 'wne-perlage',
            termPt: 'Perlage fina e persistente',
            translationRu: 'Перляж (тонкая и стойкая игра пузырьков игристого)',
            definition:
                'Conjunto de bolhas de gás carbónico que sobem em colunas ordenadas do fundo da taça até à superfície.',
            exampleSentence:
                'A perlage deste espumante gaúcho é delicadíssima, formando uma coroa de espuma cremosa.',
            dialect: 'all',
          ),
          WineVocabEntity(
            id: 'wne-adega-familiar',
            termPt: 'Adega familiar / Cantina',
            translationRu: 'Семейная винодельня / винный погреб',
            definition:
                'Vinícola de produção artesanal gerida por descendentes de imigrantes com foco em vinhos de autor.',
            exampleSentence:
                'Visitamos a adega familiar centenária para degustar os vinhos diretamente das barricas de carvalho.',
            dialect: 'pt_BR',
          ),
        ],
      ),
      WineRegionEntity(
        id: 'vale-sao-francisco',
        name: 'Vinhos Tropicais do Vale do São Francisco',
        category: WineCategory.vinhoBrasileiroAltitude,
        subRegion: 'Petrolina (Pernambuco) & Juazeiro (Bahia)',
        country: 'Brasil',
        dialect: 'pt_BR',
        accentEmoji: '☀️',
        shortSummary:
            'A incrível viticultura irrigada do sertão semiárido, onde o sol pleno permite realizar de duas a três safras por ano.',
        fullDescription:
            'Situado no coração do sertão nordestino a apenas 9 graus da linha do equador, o Vale do Submédio São Francisco realizou um milagre agronómico inédito no planeta. Em pleno bioma da Caatinga, onde chove menos de 400 milímetros por ano, a água abundante do rio São Francisco irriga vinhedos por gotejamento computadorizado sob mais de 3.000 horas de insolação anual. Sem inverno climático para adormecer as videiras, os enólogos controlam a poda e a irrigação para colher cachos perfeitos em qualquer mês do ano. A região consolidou-se na produção de espumantes tropicais exuberantes com a casta Moscatel e vinhos tintos generosos de Syrah e Touriga Nacional com taninos maduros e macios.',
        keyCastas: [
          'Syrah (a grande estrela tinta tropical com notas de especiarias e amoras)',
          'Touriga Nacional (adaptou-se com vigor surpreendente ao sol do sertão)',
          'Moscatel / Moscato Canelli (espumantes tropicais perfumados e alegres)',
          'Chenin Blanc (brancos frescos com aromas de abacaxi e maracujá)',
        ],
        tastingProfile:
            'Cores rubi profundas, aromas exuberantes de amoras maduras, compota de ameixa, pimenta-do-reino e cacau, palato caloroso com taninos doces e redondos.',
        audioNarration:
            'Sob o sol resplandecente do sertão, as águas do Velho Chico irrigam vinhedos tropicais que produzem safras de uvas saborosíssimas todo o ano.',
        vocabulary: [
          WineVocabEntity(
            id: 'wne-viticultura-tropical',
            termPt: 'Viticultura tropical',
            translationRu: 'Тропическое виноградарство (без зимнего покоя лозы)',
            definition:
                'Ramo da viticultura praticado em baixas latitudes onde as videiras permanecem ativas vegetativamente o ano inteiro.',
            exampleSentence:
                'O Vale do São Francisco é o polo mais inovador de viticultura tropical do planeta.',
            dialect: 'pt_BR',
          ),
          WineVocabEntity(
            id: 'wne-irrigacao-gotejamento',
            termPt: 'Irrigação por gotejamento',
            translationRu: 'Капельное орошение виноградников',
            definition:
                'Sistema hidráulico que deposita gotas precisas de água e nutrientes diretamente na raiz de cada videira.',
            exampleSentence:
                'A irrigação por gotejamento economiza água e permite regular a quantidade exata de hidratação das uvas.',
            dialect: 'all',
          ),
          WineVocabEntity(
            id: 'wne-duas-safras',
            termPt: 'Múltiplas safras anuais',
            translationRu: 'Два-три сбора урожая винограда в год',
            definition:
                'Capacidade agronómica de podar e colher diferentes parcelas de vinhedo em meses distintos ao longo dos doze meses.',
            exampleSentence:
                'Enquanto a Europa colhe apenas em setembro, o sertão realiza múltiplas safras anuais sem interrupção.',
            dialect: 'pt_BR',
          ),
        ],
      ),
    ];
  }

  static List<TastingGuideEntity> getTastingGuides() {
    return const [
      TastingGuideEntity(
        id: 'guide-porto-tawny',
        title: 'Degustação de Vinho do Porto Tawny 20 Anos',
        beverageType: 'Vinho do Porto (Generoso)',
        visualStagePt:
            'Examine a tonalidade aloirada límpida (tawny) com reflexos âmbar e auréola alaranjada na borda do cálice.',
        olfactoryStagePt:
            'Gire suavemente o cálice para que se libertem aromas terciários sedutores de nozes, casca de laranja confeitada, melaço e baunilha.',
        gustatoryStagePt:
            'Sinta o ataque doce e aveludado na boca, contrabalançado por uma acidez viva que não deixa o final ficar enjoativo.',
        sommelierRecommendationPt:
            'Recomendo que você sirva este Tawny ligeiramente refrescado (entre 12°C e 14°C) para que a graduação alcoólica não mascare os aromas delicados de frutos secos.',
        subjunctiveGrammarNote:
            'Presente do Subjuntivo em Recomendações: "Recomendo que você sirva" (servir -> sirva), "para que se libertem" (libertar -> libertem), "para que não mascare" (mascarar -> mascare).',
        pairingRu:
            'Harmonização perfeita com queijo Serra da Estrela amanteigado, pudim Abade de Priscos ou tarte de nozes.',
        icon: '🍷',
      ),
      TastingGuideEntity(
        id: 'guide-alvarinho-minho',
        title: 'Análise Sensorial de Vinho Verde Alvarinho',
        beverageType: 'Vinho Branco Mineral',
        visualStagePt:
            'Observe a cor amarelo-palha brilhante com reflexos citrinos esverdeados e a limpidez cristalina do vinho.',
        olfactoryStagePt:
            'Aproxime o nariz sem agitar a taça; sinta notas primárias puras de pêssego branco, maracujá, casca de lima e pedreira molhada.',
        gustatoryStagePt:
            'Sinta a explosão de acidez estaladiça que faz salivar de imediato, acompanhada de textura untuosa e final mineral prolongado.',
        sommelierRecommendationPt:
            'É fundamental que a garrafa permaneça a cerca de 10°C e que você prove o vinho acompanhado de mariscos frescos do Atlântico.',
        subjunctiveGrammarNote:
            'Presente do Subjuntivo após Expressões Impessoais de Certeza/Necessidade: "É fundamental que permaneça" (permanecer -> permaneça) e "que você prove" (provar -> prove).',
        pairingRu:
            'Combinação celestial com percebes de Sagres, arroz de tamboril ou peixe robalo grelhado com azeite virgem extra.',
        icon: '🍾',
      ),
      TastingGuideEntity(
        id: 'guide-azeite-alentejo',
        title: 'Prova Oficial de Azeite Virgem Extra do Alentejo',
        beverageType: 'Azeite Virgem Extra DOP',
        visualStagePt:
            'Na prova técnica oficial o azeite é servido em copo azul escuro para que a cor verde ou amarela não influencie o provador.',
        olfactoryStagePt:
            'Aqueça o fundo do copo com a palma da mão para que os aromas voláteis de erva recém-cortada e tomateiro se desprendam.',
        gustatoryStagePt:
            'Aspire o azeite com ar pela boca (técnica do slurping); avalie o equilíbrio entre o doce inicial, o amargo mediano e o picante final.',
        sommelierRecommendationPt:
            'Sugiro que você use este azeite cru sobre pratos quentes logo antes de servir, para que o calor do alimento exale os polifenóis aromáticos.',
        subjunctiveGrammarNote:
            'Presente do Subjuntivo com Verbos de Sugestão e Finalidade: "Sugiro que você use" (usar -> use) e "para que o calor exale" (exalar -> exale).',
        pairingRu:
            'Ideal para regar sobre migas alentejanas de pão, bacalhau cozido com grão-de-bico ou simplesmente no pão alentejano rústico.',
        icon: '🫒',
      ),
      TastingGuideEntity(
        id: 'guide-espumante-gaucho',
        title: 'Degustação de Espumante Brut da Serra Gaúcha',
        beverageType: 'Espumante Método Tradicional',
        visualStagePt:
            'Aprecie o colar cremoso de espuma persistente e as correntes ininterruptas de bolhas microscópicas que sobem verticalmente.',
        olfactoryStagePt:
            'Respire as notas elegantes de leveduras maduras, pão tostado com manteiga, maçã dourada e flores brancas primaveris.',
        gustatoryStagePt:
            'Sinta a mousse aveludada preencher toda a cavidade bucal com efervescência cremosa, acidez refrescante e final seco e elegante.',
        sommelierRecommendationPt:
            'Prefiro que você utilize uma taça bojudinha tipo tulipa em vez de uma flûte estreita, para que o espumante respire e revele toda a sua complexidade.',
        subjunctiveGrammarNote:
            'Presente do Subjuntivo em Preferências: "Prefiro que você utilize" (utilizar -> utilize), "para que o espumante respire" (respirar -> respire) e "revele" (revelar -> revele).',
        pairingRu:
            'Perfeito com ostras frescas de Santa Catarina, risoto de cogumelos selvagens ou queijos artesanais da serra.',
        icon: '🥂',
      ),
    ];
  }

  static List<WineQuizQuestion> getQuizzes() {
    return const [
      WineQuizQuestion(
        id: 'quiz-wne-1',
        question:
            'Em que ano foi criada a Região Demarcada do Douro pelo Marquês de Pombal, tornando-se a primeira região vinícola regulamentada do mundo?',
        options: [
          '1756',
          '1492',
          '1888',
          '1922',
        ],
        correctIndex: 0,
        explanation:
            'Em 1756, o Marquês de Pombal instituiu a Real Companhia Geral da Agricultura das Vinhas do Alto Douro, demarcando e classificando os vinhedos com marcos de pedra (feitorias).',
        dialect: 'pt_PT',
        contextCategory: 'História do Vinho do Porto',
        accentEmoji: '🍷',
      ),
      WineQuizQuestion(
        id: 'quiz-wne-2',
        question:
            'Como se conjuga o verbo "servir" no Presente do Subjuntivo para a recomendação: "O escanção recomenda que o cliente _____ o vinho a 12°C"?',
        options: [
          'sirva',
          'serve',
          'servisse',
          'servirá',
        ],
        correctIndex: 0,
        explanation:
            'O verbo "servir" é irregular no Presente do Subjuntivo: que eu sirva, que tu sirvas, que ele/você sirva, que nós sirvamos, que eles sirvam.',
        dialect: 'all',
        contextCategory: 'Gramática: Presente do Subjuntivo',
        accentEmoji: '📚',
      ),
      WineQuizQuestion(
        id: 'quiz-wne-3',
        question:
            'Por que o Vinho Verde se chama "Verde"?',
        options: [
          'Porque deve ser bebido jovem e fresco, em referência à juventude do vinho e à paisagem verdejante do Minho',
          'Porque é feito exclusivamente com uvas verdes não maduras colhidas fora de época',
          'Porque leva infusão de ervas aromáticas e clorofila na fermentação',
          'Porque a garrafa é obrigatoriamente de vidro verde escuro',
        ],
        correctIndex: 0,
        explanation:
            'A designação "Vinho Verde" alude ao perfil fresco e jovem do vinho (em oposição aos vinhos maduros encorpados) e à luxuriante vegetação do noroeste de Portugal.',
        dialect: 'pt_PT',
        contextCategory: 'Vinho Verde & Terroir',
        accentEmoji: '🍾',
      ),
      WineQuizQuestion(
        id: 'quiz-wne-4',
        question:
            'O que é o sistema de "canteiro", exclusivo da elaboração do lendário Vinho da Madeira?',
        options: [
          'Estágio das pipas de carvalho nos sótãos quentes das adegas sob o calor natural do sol da ilha',
          'Armazenamento das garrafas em grutas submarinas sob pressão oceânica',
          'Enterro dos barris de madeira no solo de cinzas vulcânicas da montanha',
          'Processo de congelamento das uvas antes da prensagem mecânica',
        ],
        correctIndex: 0,
        explanation:
            'No sistema de canteiro, os vinhos mais nobres descansam nos sótãos das adegas onde as temperaturas quentes oxidam e caramelizam lentamente o néctar por anos.',
        dialect: 'pt_PT',
        contextCategory: 'Vinho da Madeira',
        accentEmoji: '🏝️',
      ),
      WineQuizQuestion(
        id: 'quiz-wne-5',
        question:
            'Qual é a região brasileira que obteve a primeira Denominação de Origem (D.O.) do país e é líder na produção de espumantes finos pelo método tradicional?',
        options: [
          'Vale dos Vinhedos (Serra Gaúcha, RS)',
          'Chapada Diamantina (Bahia)',
          'Pantanal Matogrossense (Mato Grosso)',
          'Ilha de Marajó (Pará)',
        ],
        correctIndex: 0,
        explanation:
            'O Vale dos Vinhedos, localizado entre Bento Gonçalves, Garibaldi e Monte Belo do Sul, conquistou a primeira D.O. do Brasil e produz espumantes premiados internacionalmente.',
        dialect: 'pt_BR',
        contextCategory: 'Vinhos Brasileiros de Altitude',
        accentEmoji: '🥂',
      ),
      WineQuizQuestion(
        id: 'quiz-wne-6',
        question:
            'O que torna a viticultura do Vale do São Francisco (Petrolina/Juazeiro) única no mundo?',
        options: [
          'A irrigação por gotejamento e o sol equatorial pleno permitem realizar de duas a três safras de uvas no mesmo ano',
          'É o único lugar do mundo onde as uvas crescem dentro da água do rio',
          'Os vinhedos são cobertos por estufas de gelo artificial no sertão',
          'As uvas só podem ser colhidas durante a noite de lua cheia',
        ],
        correctIndex: 0,
        explanation:
            'No semiárido nordestino, a abundância de água do rio São Francisco e a ausência de inverno frio possibilitam controlar a poda para colher uvas em qualquer época do ano.',
        dialect: 'pt_BR',
        contextCategory: 'Viticultura Tropical',
        accentEmoji: '☀️',
      ),
    ];
  }
}
