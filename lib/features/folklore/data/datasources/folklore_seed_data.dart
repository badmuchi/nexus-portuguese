import '../../domain/entities/folklore_entities.dart';

class FolkloreSeedData {
  static List<MythicalEntity> getMyths() {
    return const [
      MythicalEntity(
        id: 'saci-perere',
        name: 'Saci-Pererê',
        aliasRu: 'Саси-Перере (одноногий проказник в красном колпаке)',
        origin: FolkloreOrigin.urbanoMisto,
        region: 'Sudeste e Centro-Oeste do Brasil',
        dialect: 'pt_BR',
        accentEmoji: '🌪️',
        shortSummary:
            'Menino travesso de uma perna só que se locomove em redemoinhos de vento com seu gorro vermelho mágico.',
        fullLegend:
            'O Saci-Pererê é a criatura mais icônica do folclore brasileiro, fruto da fusão de lendas indígenas, africanas e portuguesas. Descrito como um jovem negro de uma perna só, ele fuma um cachimbo de barro e usa uma carapuça vermelha mágica que lhe confere poderes mágicos e o dom da invisibilidade. Ele surge dentro de redemoinhos de poeira e vento nas matas e estradas rurais. Adora aprontar travessuras inofensivas: azedar o leite das cozinhas, queimar a comida na panela, esconder tesouras, trançar a crina dos cavalos durante a noite e assustar viajantes. Para capturar um Saci, a lenda manda jogar uma peneira sobre o redemoinho e prender a criatura dentro de uma garrafa de vidro com uma rolha marcada com uma cruz.',
        magicalPowers: [
          'Capacidade de se teletransportar dentro de redemoinhos de vento',
          'Invisibilidade e poderes mágicos concedidos pelo gorro vermelho',
          'Ilusionismo e mimetismo com os sons da floresta',
          'Aparência fugaz e velocidade extrema saltando numa única perna',
        ],
        moralOrMeaning:
            'Simboliza a irreverência, a criatividade do povo brasileiro e a explicação lúdica para pequenos incidentes domésticos inexplicáveis.',
        audioNarration:
            'O Saci-Pererê rodopiava num redemoinho de poeira, assobiando baixinho enquanto trançava a crina dos cavalos na escuridão da noite.',
        vocabulary: [
          FolkloreVocabEntity(
            id: 'folk-redemoinho',
            termPt: 'Redemoinho',
            translationRu: 'Вихрь / пылевой смерч',
            definition:
                'Movimento circular rápido do vento ou da água em espiral, considerado no folclore o veículo do Saci.',
            exampleSentence:
                'Quando viu o redemoinho se aproximar da porteira, o fazendeiro preparou a peneira para caçar o Saci.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-travessura',
            termPt: 'Travessura',
            translationRu: 'Шалость / проказа',
            definition:
                'Ato brincalhão ou travesso feito para provocar risos ou pequenas confusões sem maldade real.',
            exampleSentence:
                'O Saci adorava fazer travessuras, como esconder os sapatos e apagar a chama do fogão a lenha.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-carapuca',
            termPt: 'Carapuça / Gorro mágico',
            translationRu: 'Красный колпак (источник магической силы Саси)',
            definition:
                'Gorro cônico vermelho que concede dons sobrenaturais e invisibilidade a quem o possui.',
            exampleSentence:
                'Se alguém conseguir tirar a carapuça do Saci, ele perde todos os seus poderes mágicos.',
            dialect: 'all',
          ),
        ],
      ),
      MythicalEntity(
        id: 'curupira',
        name: 'Curupira',
        aliasRu: 'Курупира (дух-защитник леса с огненными волосами и вывернутыми стопами)',
        origin: FolkloreOrigin.indigena,
        region: 'Floresta Amazônica e Mata Atlântica',
        dialect: 'pt_BR',
        accentEmoji: '🔥',
        shortSummary:
            'Guardião implacável das matas com cabelos de fogo e pés virados para trás que despistam caçadores.',
        fullLegend:
            'O Curupira é uma das lendas indígenas mais antigas do Brasil, registrada pelo padre José de Anchieta logo no século XVI. Descrito como um anão de força colossal, cabelos flamejantes vermelhos e pés voltados para trás (os calcanhares para frente e os dedos para trás), ele é o senhor e protetor absoluto da flora e fauna nativas. O Curupira defende os animais contra a caça predatória e árvores contra o desmatamento ilegal. Quando um caçador persegue suas pegadas, na verdade caminha na direção contrária e acaba irremediavelmente perdido na selva densa. Ele emite assobios agudos fantasmagóricos que enlouquecem os invasores da mata e bate com força nos troncos das árvores para avisar que a tempestade se aproxima.',
        magicalPowers: [
          'Pegadas invertidas que criam pistas falsas e desorientam qualquer rastreador',
          'Assobio ultrassônico estridente que ecoa em todas as direções desorientando quem ouve',
          'Dom de ressuscitar animais caçados injustamente se os ossos estiverem inteiros',
          'Capacidade de prever grandes temporais tocando na casca das árvores',
        ],
        moralOrMeaning:
            'Representa a sabedoria ancestral da conservação ecológica e a retaliação da natureza contra a ganância humana predatória.',
        audioNarration:
            'O Curupira corria pelas matas com seus pés virados para trás, enganando os caçadores gananciosos com seus assobios mágicos.',
        vocabulary: [
          FolkloreVocabEntity(
            id: 'folk-pegada-invertida',
            termPt: 'Pegada invertida',
            translationRu: 'Вывернутый назад след ноги',
            definition:
                'Impressão dos pés no solo voltada para a direção contrária da caminhada real da criatura.',
            exampleSentence:
                'O caçador seguiu a pegada invertida pensando que avançava, mas afastava-se da saída da mata.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-assobio',
            termPt: 'Assobio agudo',
            translationRu: 'Пронзительный свист',
            definition:
                'Som sibilante de alta frequência emitido para intimidar intrusos e comunicar-se na floresta.',
            exampleSentence:
                'Um assobio agudo e misterioso paralisou de medo os invasores da reserva ecológica.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-guardiao-mata',
            termPt: 'Guardião da mata',
            translationRu: 'Хранитель / дух-покровитель леса',
            definition:
                'Entidade espiritual reverenciada pelas etnias indígenas como zeladora sagrada da vida silvestre.',
            exampleSentence:
                'Os povos originários pedem permissão ao guardião da mata antes de colher ervas medicinais.',
            dialect: 'all',
          ),
        ],
      ),
      MythicalEntity(
        id: 'iara-mae-dagua',
        name: 'Iara (Mãe-d\'Água)',
        aliasRu: 'Яра / Мать вод (прекрасная речная сирена Амазонки)',
        origin: FolkloreOrigin.indigena,
        region: 'Bacia Amazônica e Rio Negro',
        dialect: 'pt_BR',
        accentEmoji: '🧜‍♀️',
        shortSummary:
            'Sereia encantadora dos rios amazônicos de canto hipnótico que atrai canoeiros para o fundo das águas.',
        fullLegend:
            'De acordo com o mito de origem tupi, Iara era uma jovem guerreira indígena corajosa, admirada por sua bravura na tribo e pela beleza fascinante de seus olhos e cabelos negros. Invejosos de sua glória, seus irmãos tentaram assassiná-la em uma emboscada na floresta, mas ela defendeu-se e acabou por matá-los. Assustada, refugiou-se nas margens do rio, mas foi capturada e atirada nas águas profundas do encontro dos rios. Os peixes e espíritos das águas, compadecidos de sua sina, salvaram-na e a transformaram na Mãe-d\'Água: metade mulher radiante, metade peixe cintilante. Ao entardecer, Iara senta-se sobre pedras à beira dos igarapés, penteia seus cabelos longos com um pente de ouro e entoa melodias hipnóticas irresistíveis.',
        magicalPowers: [
          'Voz mágica com canto sedutor irresistível que hipnotiza quem o ouve',
          'Comunicação telepática com cardumes, botos e criaturas aquáticas',
          'Natação em velocidades assombrosas nas correntezas amazônicas',
          'Criação de redemoinhos fluviais que submergem canoas em segundos',
        ],
        moralOrMeaning:
            'Expressa o respeito e temor dos povos ribeirinhos pelo poder misterioso, sedutor e imprevisível das águas dos grandes rios.',
        audioNarration:
            'Nas tardes quentes do Rio Negro, a voz doce de Iara ecoava pelos igarapés, atraindo os pescadores incautos para as profundezas.',
        vocabulary: [
          FolkloreVocabEntity(
            id: 'folk-canto-hipnotico',
            termPt: 'Canto hipnótico',
            translationRu: 'Гипнотическое пение (песнь сирены)',
            definition:
                'Melodia de beleza sobrenatural que priva a pessoa ouvinte de sua vontade e lucidez.',
            exampleSentence:
                'O canoeiro escutou o canto hipnótico e largou os remos, fitando o reflexo das águas escuras.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-igarape',
            termPt: 'Igarapé',
            translationRu: 'Игарапе (узкий лесной речной проток в Амазонии)',
            definition:
                'Curso de água estreito que corre pela mata de terra firme na região amazônica, navegável por pequenas canoas.',
            exampleSentence:
                'Navegamos suavemente pelo igarapé ouvindo o murmúrio da água entre as vitórias-régias.',
            dialect: 'pt_BR',
          ),
          FolkloreVocabEntity(
            id: 'folk-sereia-rios',
            termPt: 'Mãe-d\'água',
            translationRu: 'Речная дева / Мать вод',
            definition:
                'Divindade ou espírito feminino aquático protetor dos rios, lagos e mananciais fluviais.',
            exampleSentence:
                'Os ribeirinhos deixam oferendas de flores perfumadas nas margens para agradar a Mãe-d\'água.',
            dialect: 'pt_BR',
          ),
        ],
      ),
      MythicalEntity(
        id: 'boitata',
        name: 'Boitatá',
        aliasRu: 'Бойтата (огненный змей — страж против лесных пожаров)',
        origin: FolkloreOrigin.indigena,
        region: 'Pantanal, Amazônia e Cerrado',
        dialect: 'pt_BR',
        accentEmoji: '🐍',
        shortSummary:
            'Serpente colossal de fogo que protege as matas contra incêndios criminosos, cegando os agressores.',
        fullLegend:
            'A lenda do Boitatá ("mboi-tatá", que na língua tupi significa literalmente "cobra de fogo") é uma das mais antigas narrativas mitológicas do continente americano. O Boitatá é uma gigantesca serpente luminosa cujas escamas brilham com chamas azuis e douradas que não queimam a relva natural, mas incendeiam instantaneamente aqueles que destroem as matas por ambição. Os olhos do Boitatá são dois faróis ardentes de pura luz. A criatura sobreviveu ao mítico grande dilúvio escondendo-se em cavernas profundas e alimentando-se dos olhos de animais caídos, acumulando assim o brilho solar em seu corpo. Ele vagueia pelos campos e margens de rios à noite para vigiar quem ateia fogo nos campos.',
        magicalPowers: [
          'Visão incandescente capaz de cegar ou deixar louco quem o encara de frente',
          'Fogo místico que viaja sobre a água sem se extinguir',
          'Camuflagem perfeita como tronco de árvore carvoeiro incandescente',
          'Defesa mágica contra o fogo destrutivo humano',
        ],
        moralOrMeaning:
            'Mitologia de proteção ambiental que explica o fenômeno natural do fogo-fátuo e pune a destruição impensada das florestas.',
        audioNarration:
            'O Boitatá deslizava silencioso como uma chama viva pelas margens alagadas, protegendo a mata dos caçadores de fogo.',
        vocabulary: [
          FolkloreVocabEntity(
            id: 'folk-serpente-fogo',
            termPt: 'Serpente de fogo',
            translationRu: 'Огненный змей',
            definition:
                'Réptil mitológico coberto de chamas resplandecentes que personifica o fogo sagrado da natureza.',
            exampleSentence:
                'O Boitatá surgiu na curva do rio como uma colossal serpente de fogo que iluminou toda a escuridão.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-fogo-fatuo',
            termPt: 'Fogo-fátuo',
            translationRu: 'Блуждающий огонь (болотные фосфоресцирующие огни)',
            definition:
                'Chama fugaz gerada pela combustão espontânea de gases de matéria orgânica vegetal em decomposição.',
            exampleSentence:
                'A ciência explica o fogo-fátuo pelos gases dos pântanos, mas o folclore vê ali a presença viva do Boitatá.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-incendio',
            termPt: 'Queimada criminosa',
            translationRu: 'Умышленный поджог леса',
            definition:
                'Ato ilícito de incendiar pastagens ou florestas, enfrentado pelo Boitatá na mitologia tradicional.',
            exampleSentence:
                'Quem provoca queimadas criminosas atrai a fúria do guardião Boitatá.',
            dialect: 'all',
          ),
        ],
      ),
      MythicalEntity(
        id: 'mula-sem-cabeca',
        name: 'Mula sem Cabeça',
        aliasRu: 'Мула без головы (проклятое существо, изрыгающее пламя)',
        origin: FolkloreOrigin.iberico,
        region: 'Interior de São Paulo, Minas Gerais e Goiás',
        dialect: 'pt_BR',
        accentEmoji: '🐴',
        shortSummary:
            'Maldição que transforma mulheres em uma besta noturna galopante que expele fogo pelo pescoço.',
        fullLegend:
            'Com fortes raízes no catolicismo medieval ibérico transplantado para o Brasil colonial, a lenda da Mula sem Cabeça narra a maldição que recai sobre qualquer mulher que se apaixona e tem um romance proibido com um sacerdote. Nas noites de quinta para sexta-feira, ela transforma-se magicamente num animal assombroso: uma mula de porte descomunal que, no lugar da cabeça decepada, expele labaredas ardentes de fogo. Ela percorre em desespero sete povoados galopando velozmente com ferraduras brilhantes de ferro e prata, emitindo um relincho ensurdecedor misturado a gemidos de sofrimento. Para quebrar a terrível maldição, alguém corajoso deve tirar o freio de ferro de sua boca ou espetá-la com um alfinete de prata para extrair uma gota de sangue.',
        magicalPowers: [
          'Chamas inextinguíveis vomitando pelo pescoço decapitado',
          'Galope ultrarrápido com ferraduras de prata que soltam faíscas nas pedras',
          'Relincho aterrorizante que paralisa de medo qualquer ser vivente',
          'Invulnerabilidade a golpes comuns de madeira ou lâminas de ferro simples',
        ],
        moralOrMeaning:
            'Reflexo da moralidade religiosa do período colonial e conto de advertência contra a violação de dogmas sociais e eclesiásticos.',
        audioNarration:
            'Na calada da noite de quinta-feira, ouviu-se o galope pesado da Mula sem Cabeça soltando faíscas na calçada de pedra.',
        vocabulary: [
          FolkloreVocabEntity(
            id: 'folk-maldicao',
            termPt: 'Maldição / Feitiço',
            translationRu: 'Проклятие / колдовские чары',
            definition:
                'Praga ou encantamento que condena a pessoa a sofrer uma transformação monstruosa e dolorosa.',
            exampleSentence:
                'A pobre mulher tentava rezar para escapar da maldição que a atormentava nas noites de quinta-feira.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-relincho',
            termPt: 'Relincho assombroso',
            translationRu: 'Жуткое ржание (лошади или мула)',
            definition:
                'Grito estridente característico dos equinos, que na lenda ressoa de forma fantasmagórica.',
            exampleSentence:
                'O relincho assombroso ecoou pelas ruas desertas da pequena cidade histórica.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-ferradura',
            termPt: 'Ferradura de prata',
            translationRu: 'Серебряная подкова',
            definition:
                'Peça de metal curvada presa ao casco do animal, que na lenda brilha faiscante ao tocar as pedras.',
            exampleSentence:
                'O galope feroz com ferraduras de prata riscava o chão com faíscas incandescentes.',
            dialect: 'all',
          ),
        ],
      ),
      MythicalEntity(
        id: 'galo-de-barcelos',
        name: 'O Galo de Barcelos',
        aliasRu: 'Петух из Барселуша (чудо жареного петуха — символ справедливости Португалии)',
        origin: FolkloreOrigin.iberico,
        region: 'Barcelos, Minho',
        dialect: 'pt_PT',
        accentEmoji: '🐓',
        shortSummary:
            'O milagre do galo assado que cantou na mesa do juiz para salvar um peregrino inocente da forca.',
        fullLegend:
            'A lenda do Galo de Barcelos remonta ao século XIV na região do Minho, no norte de Portugal, e deu origem ao mais célebre símbolo turístico e identitário do país: o galo de cerâmica preta ricamente decorado com corações vermelhos e florões policromados. A narrativa conta que os moradores de Barcelos andavam apavorados com um roubo misterioso cometido na vila. Um jovem peregrino galego que viajava rumo a Santiago de Compostela para pagar uma promessa foi acusado injustamente do crime pelas autoridades e condenado à forca. Como último pedido antes da execução, pediu para ser levado perante o juiz da terra, que se encontrava em pleno banquete com amigos. Diante de um galo assado servido na travessa, o peregrino clamou: "É tão certo eu estar inocente como é certo esse galo cantar quando me enforcarem!". Na hora da execução, para assombro de todos, o galo assado ergueu-se na travessa e cantou em alto e bom som. O juiz correu à forca e salvou o peregrino.',
        magicalPowers: [
          'Ressurreição milagrosa e canto divino de um pássaro já assado e temperado',
          'Manifestação sobrenatural da justiça perante falsas acusações',
          'Símbolo de proteção, esperança, fé inabalável e boa sorte para quem possui sua estatueta',
        ],
        moralOrMeaning:
            'Celebração da fé humilde contra o preconceito da autoridade, transformada em emblema de generosidade e acolhimento do povo português.',
        audioNarration:
            'No banquete do juiz, o galo assado na travessa ergueu-se milagrosamente e cantou, provando a inocência do peregrino de Santiago.',
        vocabulary: [
          FolkloreVocabEntity(
            id: 'folk-peregrino',
            termPt: 'Peregrino de Santiago',
            translationRu: 'Паломник (пилигрим на пути в Сантьяго-де-Компостела)',
            definition:
                'Viajante devoto que percorre longos caminhos sagrados a pé por motivos de fé ou promessa espiritual.',
            exampleSentence:
                'O peregrino trazia a vieira bordada na capa enquanto caminhava pelo Minho.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-galo-assado',
            termPt: 'Galo assado',
            translationRu: 'Жареный петух',
            definition:
                'Ave assada servida no banquete do magistrado, protagonista do milagre divino de Barcelos.',
            exampleSentence:
                'O galo assado pôs-se em pé na travessa de barro e cantou com vigor inegável.',
            dialect: 'all',
          ),
          FolkloreVocabEntity(
            id: 'folk-ceramica-barcelos',
            termPt: 'Olaria de Barcelos',
            translationRu: 'Гончарное ремесло Барселуша',
            definition:
                'Arte tradicional portuguesa de modelar cerâmica de barro pintada com cores vivas e motivos florais.',
            exampleSentence:
                'O galo de olaria de Barcelos é a lembrança mais famosa que os turistas trazem de Portugal.',
            dialect: 'pt_PT',
          ),
        ],
      ),
    ];
  }

  static List<FolkloreTaleSnippet> getTaleSnippets() {
    return const [
      FolkloreTaleSnippet(
        id: 'snippet-saci',
        title: 'O Redemoinho na Encruzilhada',
        characterName: 'Saci-Pererê',
        narrativePt:
            'A noite caía silenciosa sobre a mata fechada. De repente, um redemoinho de folhas secas começou a girar velozmente. No centro das folhas, o jovem travesso pulava numa perna só, soltando baforadas de fumo do seu cachimbo.',
        translationRu:
            'Ночь тихо опускалась на глухой лес. Внезапно вихрь сухих листьев начал быстро кружиться. В центре кружащейся листвы озорной мальчуган скакал на одной ножке, выпуская клубы дыма из своей трубки.',
        grammarInsight:
            'Observe o contraste: "A noite caía" (Pretérito Imperfeito — описание фонового состояния) versus "um redemoinho começou" (Pretérito Perfeito — внезапное точечное действие).',
        icon: '🌪️',
      ),
      FolkloreTaleSnippet(
        id: 'snippet-curupira',
        title: 'A Floresta que Engana os Passos',
        characterName: 'Curupira',
        narrativePt:
            'O caçador caminhava pela trilha escura procurando as pegadas do cervo. Encontrou pegadas estranhas na terra úmida e resolveu segui-las com pressa. Mal sabia ele que o Curupira tinha os pés virados para trás.',
        translationRu:
            'Охотник шел по темной тропе в поисках следов оленя. Он нашел странные следы на влажной земле и решил поспешно пойти по ним. Он и не догадывался, что у Курупиры ступни были вывернуты назад.',
        grammarInsight:
            'O verbo "caminhava" e "tinha" descrevem processos e características contínuas (Imperfeito), enquanto "encontrou" e "resolveu" marcam decisões completadas no passado (Perfeito).',
        icon: '👣',
      ),
      FolkloreTaleSnippet(
        id: 'snippet-barcelos',
        title: 'O Canto Inesperado no Banquete',
        characterName: 'Galo de Barcelos',
        narrativePt:
            'Enquanto o magistrado comia calmamente com seus ilustres convidados, os guardas preparavam a corda no cadafalso. Naquele instante exato, o galo assado abriu as asas e cantou sonoramente diante de todos os presentes.',
        translationRu:
            'В то время как судья спокойно обедал со своими знатными гостями, стражники готовили веревку на эшафоте. В этот самый миг жареный петух расправил крылья и звонко запел на глазах у всех присутствующих.',
        grammarInsight:
            'A conjunção "Enquanto" requer o Pretérito Imperfeito ("comia", "preparavam") para ações simultâneas em progresso, interrompidas pelo Pretérito Perfeito ("abriu", "cantou").',
        icon: '🐓',
      ),
      FolkloreTaleSnippet(
        id: 'snippet-iara',
        title: 'O Reflexo Dourado nas Águas',
        characterName: 'Iara',
        narrativePt:
            'O sol poente tingia as águas mansas do rio de dourado e púrpura. Sentada na margem, a bela moça penteava as madeixas compridas quando avistou a pequena canoa solitária que deslizava na correnteza.',
        translationRu:
            'Заходящее солнце окрашивало тихие воды реки в золотые и пурпурные тона. Сидя на берегу, прекрасная дева расчесывала длинные пряди, когда заметила одинокое каноэ, скользившее по течению.',
        grammarInsight:
            '"Tingia" e "penteava" retratam o cenário poético contínuo (Imperfeito), interrompido pela ação perceptiva "avistou" (Perfeito).',
        icon: '🧜‍♀️',
      ),
    ];
  }

  static List<FolkloreQuizQuestion> getQuizzes() {
    return const [
      FolkloreQuizQuestion(
        id: 'quiz-folk-1',
        question:
            'Qual criatura do folclore brasileiro tem cabelos vermelhos de fogo e pés virados para trás para enganar caçadores?',
        options: [
          'O Curupira',
          'O Saci-Pererê',
          'O Boitatá',
          'O Boto-cor-de-rosa',
        ],
        correctIndex: 0,
        explanation:
            'O Curupira é o protetor indígena das florestas que possui os pés invertidos (calcanhares para frente) para despistar os caçadores.',
        dialect: 'pt_BR',
      ),
      FolkloreQuizQuestion(
        id: 'quiz-folk-2',
        question:
            'De onde vêm os poderes mágicos de teletransporte e invisibilidade do Saci-Pererê?',
        options: [
          'Do seu gorro vermelho mágico (carapuça)',
          'Do seu cachimbo de ouro',
          'De uma varinha de jacarandá',
          'De um anel encontrado no rio',
        ],
        correctIndex: 0,
        explanation:
            'A carapuça ou gorro vermelho do Saci é a fonte mágica dos seus poderes; sem ela, ele perde suas habilidades sobrenaturais.',
        dialect: 'pt_BR',
      ),
      FolkloreQuizQuestion(
        id: 'quiz-folk-3',
        question:
            'Qual é a famosa lenda portuguesa de Barcelos que deu origem ao galo de cerâmica colorido, símbolo nacional do país?',
        options: [
          'Um galo assado que cantou na mesa do juiz para provar a inocência de um peregrino',
          'Um galo mágico que botava ovos de ouro no castelo medieval',
          'Um galo que acordou o rei antes de uma batalha contra piratas',
          'Um galo que voou pelos ares anunciando a descoberta das Índias',
        ],
        correctIndex: 0,
        explanation:
            'A lenda narra o milagre do galo assado que se ergueu na travessa de banquete do juiz e cantou, salvando o peregrino inocente da forca.',
        dialect: 'pt_PT',
      ),
      FolkloreQuizQuestion(
        id: 'quiz-folk-4',
        question:
            'Qual é o papel ecológico do mítico Boitatá nas florestas e rios do Brasil?',
        options: [
          'Proteger a mata contra queimadas e caçadores que incendeiam a vegetação',
          'Cavar túneis subterrâneos para drenar a água das cheias',
          'Ensinar os animais a nadar contra a correnteza',
          'Construir represas naturais de madeira nas cachoeiras',
        ],
        correctIndex: 0,
        explanation:
            'O Boitatá, a serpente de fogo brilhante, pune quem destrói as matas e queima a vegetação sem respeito pela vida silvestre.',
        dialect: 'pt_BR',
      ),
      FolkloreQuizQuestion(
        id: 'quiz-folk-5',
        question:
            'Na narrativa folclórica em português: "O caçador caminhava pela floresta quando ouviu um ruído", quais tempos verbais são usados?',
        options: [
          'Pretérito Imperfeito ("caminhava" - ação contínua) e Pretérito Perfeito ("ouviu" - ação pontual)',
          'Ambos estão no Futuro do Presente',
          'Presente do Indicativo e Imperativo',
          'Pretérito Mais-Que-Perfeito e Condicional',
        ],
        correctIndex: 0,
        explanation:
            'O Pretérito Imperfeito expressa a ação contínua de fundo ("caminhava"), enquanto o Pretérito Perfeito expressa o fato pontual que interrompeu a ação ("ouviu").',
        dialect: 'all',
      ),
      FolkloreQuizQuestion(
        id: 'quiz-folk-6',
        question:
            'Como é descrita a sereia Iara (Mãe-d\'Água) nas lendas dos rios da Amazônia?',
        options: [
          'Uma mulher formosa de cabelos negros que atrai canoeiros com um canto irresistível',
          'Uma criatura alada que voa no topo das castanheiras',
          'Uma onça mágica que protege os ninhos dos pássaros',
          'Uma fada invisível que só aparece durante a tempestade',
        ],
        correctIndex: 0,
        explanation:
            'Iara é a Mãe-d\'Água, sereia dos igarapés amazônicos cujo canto hipnótico atrai pescadores e canoeiros para o mundo subaquático.',
        dialect: 'pt_BR',
      ),
    ];
  }
}
