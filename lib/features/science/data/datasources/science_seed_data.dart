import '../../domain/entities/science_entities.dart';

class ScienceSeedData {
  static List<ScienceTopicEntity> getTopics() {
    return const [
      ScienceTopicEntity(
        id: 'mar-dos-acores',
        title: 'Oceanografia & Fossas Abissais dos Açores',
        field: ScienceField.oceanografia,
        institution: 'Universidade dos Açores & Instituto Hidrográfico',
        region: 'Dorsal Médio-Atlântica (Açores)',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '🌊',
        shortSummary:
            'Exploração de ecossistemas quimiossintéticos extremos e campos hidrotermais a milhares de metros de profundidade no Atlântico.',
        fullDescription:
            'O mar que circunda o arquipélago dos Açores abriga alguns dos relevos submarinos mais fascinantes do planeta. Localizado sobre o ponto triplo de junção de três placas tectónicas (Norte-Americana, Euroasiática e Africana), o fundo oceânico açoriano possui fontes hidrotermais como Lucky Strike e Menez Gwen, descobertas a mais de 1.700 metros de profundidade. As equipas científicas portuguesas e internacionais utilizam navios oceanográficos e robôs submarinos operados remotamente (ROVs) para recolher amostras de fluidos mineralizados a temperaturas superiores a 300°C. Nestes ambientes sem luz solar, a vida não depende da fotossíntese, mas sim da quimiossíntese de bactérias que oxidam sulfetos de hidrogénio, sustentando comunidades de mexilhões gigantes e camarões cegos.',
        keyDiscoveries: [
          'Campos hidrotermais Lucky Strike e Rainbow com chaminés de sulfetos maciços',
          'Espécies endémicas que sobrevivem em pressões de centenas de atmosferas',
          'Mapeamento batimétrico detalhado da Zona Económica Exclusiva (ZEE) portuguesa',
          'Compostos moleculares marinhos com potencial antibacteriano e farmacológico',
        ],
        scientificImpact:
            'Portugal lidera a expansão da plataforma continental na ONU e estabelece reservas marinhas de grande profundidade para proteção da biodiversidade abissal.',
        audioNarration:
            'As sondas oceanográficas desciam lentamente pelas águas escuras dos Açores, onde foram identificados novos campos hidrotermais cheios de vida.',
        vocabulary: [
          ScienceVocabEntity(
            id: 'sci-campo-hidrotermal',
            termPt: 'Campo hidrotermal',
            translationRu: 'Гидротермальное поле / жерла',
            definition:
                'Fenda na crosta oceânica por onde emergem fluidos geotérmicos superaquecidos ricos em minerais dissolvidos.',
            exampleSentence:
                'O campo hidrotermal Lucky Strike foi exaustivamente estudado pela equipa oceanográfica.',
            dialect: 'all',
          ),
          ScienceVocabEntity(
            id: 'sci-batimetria',
            termPt: 'Batimetria',
            translationRu: 'Батиметрия (измерение глубин водоёмов)',
            definition:
                'Medição e mapeamento topográfico do relevo do fundo oceânico por meio de sonares multifeixe.',
            exampleSentence:
                'Os dados de batimetria revelaram montanhas submarinas desconhecidas a sul da ilha do Faial.',
            dialect: 'all',
          ),
          ScienceVocabEntity(
            id: 'sci-amostragem',
            termPt: 'Amostragem de sedimentos',
            translationRu: 'Отбор проб донных отложений',
            definition:
                'Coleta padronizada de material físico para análises geoquímicas e microbiológicas em laboratório.',
            exampleSentence:
                'A amostragem de água abissal foi realizada a dois mil metros de profundidade.',
            dialect: 'pt_PT',
            dialectNote: 'Em PT usa-se "amostragem", enquanto no Brasil é comum "coleta de amostras".',
          ),
        ],
      ),
      ScienceTopicEntity(
        id: 'instituto-butantan',
        title: 'Instituto Butantan & Venenos Terapêuticos',
        field: ScienceField.biomedicina,
        institution: 'Instituto Butantan (Secretaria da Saúde de SP)',
        region: 'São Paulo',
        country: 'Brasil',
        dialect: 'pt_BR',
        accentEmoji: '🐍',
        shortSummary:
            'Pioneirismo mundial na produção de soros antiofídicos e fármacos derivados de toxinas de animais peçonhentos.',
        fullDescription:
            'Fundado em 1901 pelo médico sanitarista Vital Brazil, o Instituto Butantan é um dos maiores centros de pesquisa biomédica do mundo. A instituição revolucionou a toxinologia ao demonstrar a especificidade dos soros para cada veneno de serpente (como jararaca, cascavel e surucucu). Além de produzir a maior parte dos imunobiológicos e vacinas distribuídos pelo SUS no Brasil, o Butantan isolou na peçonha da jararaca a molécula que originou o Captopril, o primeiro medicamento inibidor da ECA para tratamento da hipertensão arterial no planeta. Atualmente, o laboratório pesquisa toxinas contra o câncer, analgésicos mais potentes que a morfina e novas vacinas contra a dengue.',
        keyDiscoveries: [
          'Princípio da especificidade soroterápica desenvolvido por Vital Brazil',
          'Isolamento de peptídeos hipotensores do veneno da jararaca que deram origem ao Captopril',
          'Desenvolvimento de soros monoclonais e vacina tetravalente contra a dengue',
          'Plataforma biotecnológica de produção em larga escala de vacinas para o SUS',
        ],
        scientificImpact:
            'Salva milhares de vidas anualmente de envenenamentos por picadas de serpentes, escorpiões e aranhas em toda a América Latina.',
        audioNarration:
            'No Instituto Butantan, os pesquisadores purificam as proteínas da peçonha para desenvolver medicamentos inovadores e vacinas seguras.',
        vocabulary: [
          ScienceVocabEntity(
            id: 'sci-soro-antiofidico',
            termPt: 'Soro antiofídico',
            translationRu: 'Противозмеиная сыворотка',
            definition:
                'Solução de anticorpos purificados administrada para neutralizar os efeitos tóxicos do veneno de serpentes.',
            exampleSentence:
                'O soro antiofídico específico foi administrado logo após a chegada do paciente ao hospital.',
            dialect: 'all',
          ),
          ScienceVocabEntity(
            id: 'sci-peconha',
            termPt: 'Animal peçonhento / Peçonha',
            translationRu: 'Ядовитое животное / Зоотоксин',
            definition:
                'Substância tóxica produzida por um animal e inoculada ativamente por meio de dentes, ferrões ou espinhos.',
            exampleSentence:
                'A peçonha da jararaca contém enzimas que afetam a coagulação sanguínea.',
            dialect: 'all',
          ),
          ScienceVocabEntity(
            id: 'sci-ensaio-clinico',
            termPt: 'Ensaio clínico',
            translationRu: 'Клиническое испытание',
            definition:
                'Estudo científico sistemático em seres humanos para avaliar a segurança e eficácia de um novo fármaco ou vacina.',
            exampleSentence:
                'O ensaio clínico de fase 3 confirmou a alta eficácia da nova vacina.',
            dialect: 'all',
          ),
        ],
      ),
      ScienceTopicEntity(
        id: 'windfloat-peniche',
        title: 'Energia Offshore: WindFloat & Ondas de Peniche',
        field: ScienceField.energiaVerde,
        institution: 'EDP Renováveis & WavEC Offshore Renewables',
        region: 'Viana do Castelo & Peniche',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '⚡',
        shortSummary:
            'Tecnologias pioneiras de turbinas eólicas flutuantes em águas profundas e conversão da energia das ondas oceânicas.',
        fullDescription:
            'A costa atlântica de Portugal possui um dos maiores potenciais de energia renovável marinha da Europa. No projeto WindFloat Atlantic, situado a 20 quilómetros de Viana do Castelo, três turbinas eólicas gigantes com pás de 80 metros foram montadas sobre plataformas flutuantes ancoradas a 100 metros de profundidade, uma tecnologia que dispensa fundações cravadas no leito marinho. Em Peniche, projetos-piloto convertem a oscilação das potentes vagas do Atlântico em eletricidade limpa por meio de colunas de água oscilantes e conversores piezoelétricos submarinos. Estas soluções permitem descarbonizar a matriz elétrica e abastecer mais de 60.000 lares com energia oceânica.',
        keyDiscoveries: [
          'Primeiro parque eólico flutuante comercial da Europa continental sem estacas no leito',
          'Sistemas de estabilização de lastro dinâmico contra tempestades de ondas de 20 metros',
          'Integração de conversores de energia das ondas na rede elétrica nacional portuguesa',
          'Redução de custos de instalação e descomissionamento em mar aberto',
        ],
        scientificImpact:
            'Consolida Portugal como polo de vanguarda na transição energética verde e engenharia oceânica profunda.',
        audioNarration:
            'As turbinas do WindFloat flutuam sobre as vagas oceânicas, gerando eletricidade limpa a partir dos ventos atlânticos mais rigorosos.',
        vocabulary: [
          ScienceVocabEntity(
            id: 'sci-eolico-flutuante',
            termPt: 'Plataforma eólica flutuante',
            translationRu: 'Плавучая ветроэнергетическая платформа',
            definition:
                'Estrutura semissubmersível que suporta uma turbina eólica no mar, presa ao fundo apenas por amarras tensionadas.',
            exampleSentence:
                'A plataforma eólica flutuante suportou ventos tempestuosos sem qualquer instabilidade estrutural.',
            dialect: 'pt_PT',
            dialectNote: 'Em Portugal diz-se "aerogerador" ou "turbina eólica".',
          ),
          ScienceVocabEntity(
            id: 'sci-descarbonizacao',
            termPt: 'Descarbonização',
            translationRu: 'Декарбонизация (снижение углеродного следа)',
            definition:
                'Processo de substituição de combustíveis fósseis por fontes renováveis para reduzir as emissões de gases de efeito de estufa.',
            exampleSentence:
                'A energia das ondas e dos ventos marinhos acelera a descarbonização da economia.',
            dialect: 'all',
          ),
          ScienceVocabEntity(
            id: 'sci-amarras',
            termPt: 'Linhas de amarração',
            translationRu: 'Швартовные / якорные тросы платформы',
            definition:
                'Cabos de aço ou fibras sintéticas de alta resistência que fixam a estrutura flutuante a âncoras no leito do mar.',
            exampleSentence:
                'A tensão das linhas de amarração é monitorizada em tempo real por sensores digitais.',
            dialect: 'all',
          ),
        ],
      ),
      ScienceTopicEntity(
        id: 'fiocruz-biomedicina',
        title: 'Fiocruz: Vacinas & Doenças Tropicais',
        field: ScienceField.biomedicina,
        institution: 'Fundação Oswaldo Cruz (Fiocruz / Bio-Manguinhos)',
        region: 'Rio de Janeiro',
        country: 'Brasil',
        dialect: 'pt_BR',
        accentEmoji: '🔬',
        shortSummary:
            'Centro de excelência em saúde pública que erradicou epidemias históricas e produz bilhões de doses de vacinas para o mundo.',
        fullDescription:
            'Criada em 1900 no Castelo Mourisco de Manguinhos no Rio de Janeiro pelo lendário médico Oswaldo Cruz, a Fiocruz foi o baluarte no combate à febre amarela, peste bubônica e varíola no início do século XX. O instituto abrigou cientistas fundamentais como Carlos Chagas, que em 1909 realizou um feito inédito na medicina universal: descreveu por completo uma doença infecciosa (o parasita Trypanosoma cruzi, o inseto transmissor barbeiro e as manifestações clínicas cardíacas). Hoje, seu complexo biotecnológico Bio-Manguinhos é o maior polo de produção de vacina contra a febre amarela do mundo, exportando imunobiológicos para mais de 70 nações com chancela da OMS.',
        keyDiscoveries: [
          'Descoberta integral da Doença de Chagas e ciclo do Trypanosoma cruzi',
          'Liderança global no sequenciamento de variantes genéticas de arbovírus (Dengue, Zika e Chikungunya)',
          'Pesquisa pioneira que comprovou a correlação entre infecção por Zika vírus e microcefalia congênita',
          'Autossuficiência nacional na fabricação de vacinas de RNA mensageiro e vetores virais',
        ],
        scientificImpact:
            'Referência da OMS para febre amarela e arboviroses, salvaguardando a saúde pública tropical no hemisfério sul.',
        audioNarration:
            'Nos laboratórios da Fiocruz, foram decifrados os genomas virais que permitiram conter surtos de febre amarela e Zika em tempo recorde.',
        vocabulary: [
          ScienceVocabEntity(
            id: 'sci-patogeno',
            termPt: 'Patógeno / Agente infeccioso',
            translationRu: 'Патоген / Возбудитель инфекции',
            definition:
                'Microrganismo (vírus, bactéria, protozoário ou fungo) capaz de provocar doenças em hospedeiros vivos.',
            exampleSentence:
                'O patógeno foi rapidamente neutralizado pelos anticorpos produzidos após a vacinação.',
            dialect: 'all',
          ),
          ScienceVocabEntity(
            id: 'sci-vetor-transmissao',
            termPt: 'Vetor de transmissão',
            translationRu: 'Переносчик инфекции (напр., комар Aedes aegypti)',
            definition:
                'Organismo que transporta e transmite um agente causador de doença de um indivíduo para outro.',
            exampleSentence:
                'O mosquito foi identificado como o principal vetor de transmissão do vírus tropical.',
            dialect: 'all',
          ),
          ScienceVocabEntity(
            id: 'sci-imunobiologico',
            termPt: 'Imunobiológico',
            translationRu: 'Иммунобиологический препарат (вакцина, сыворотка)',
            definition:
                'Medicamento produzido a partir de células vivas ou organismos biológicos para estimular a imunidade protetora.',
            exampleSentence:
                'A Fiocruz garante a distribuição de imunobiológicos para todas as regiões do país.',
            dialect: 'all',
          ),
        ],
      ),
      ScienceTopicEntity(
        id: 'alcantara-espacial',
        title: 'Centro Espacial de Alcântara & Satélites CBERS',
        field: ScienceField.aeroespacial,
        institution: 'Agência Espacial Brasileira (AEB) & INPE',
        region: 'Alcântara, Maranhão',
        country: 'Brasil',
        dialect: 'pt_BR',
        accentEmoji: '🚀',
        shortSummary:
            'A base de lançamento de foguetes mais próxima da linha do equador e constelações de satélites de monitoramento da Amazônia.',
        fullDescription:
            'Situado no litoral do Maranhão a apenas 2°18\' ao sul da linha do equador, o Centro de Lançamento de Alcântara (CLA) desfruta da posição geográfica mais privilegiada do planeta para missões espaciais. A rotação da Terra na altura da linha equatorial imprime um impulso cinético natural aos foguetes, permitindo economizar até 30% de combustível na inserção de satélites em órbitas equatoriais e geoestacionárias. Em conjunto com o Instituto Nacional de Pesquisas Espaciais (INPE), o programa desenvolveu os satélites CBERS e o Amazônia-1, que utilizam câmeras multiespectrais para vigiar o desmatamento ilegal na Floresta Amazônica em tempo real, monitorar queimadas e apoiar a navegação marítima.',
        keyDiscoveries: [
          'Vantagem gravitacional e de velocidade angular que barateia o custo de lançamento em até um terço',
          'Lançamento e operação do satélite Amazônia-1 inteiramente projetado e integrado no Brasil',
          'Sistemas de alerta em tempo real DETER para combate a crimes ambientais via sensoriamento remoto',
          'Desenvolvimento de combustíveis propelentes ecológicos e foguetes de sondagem suborbitais',
        ],
        scientificImpact:
            'Torna o Brasil soberano na observação da Terra e posiciona Alcântara como hub espacial comercial internacional.',
        audioNarration:
            'O foguete subiu velozmente a partir da base de Alcântara, posicionando em órbita o satélite de vigilância da Amazônia.',
        vocabulary: [
          ScienceVocabEntity(
            id: 'sci-orbita-geoestacionaria',
            termPt: 'Órbita geoestacionária',
            translationRu: 'Геостационарная орбита',
            definition:
                'Órbita circular a 35.786 km de altitude sobre o equador onde o satélite se mantém parado em relação à superfície da Terra.',
            exampleSentence:
                'O satélite meteorológico foi inserido com precisão na órbita geoestacionária.',
            dialect: 'all',
          ),
          ScienceVocabEntity(
            id: 'sci-sensoriamento-remoto',
            termPt: 'Sensoriamento remoto',
            translationRu: 'Дистанционное зондирование Земли',
            definition:
                'Técnica de obtenção de dados e imagens da superfície terrestre por meio de sensores aéreos ou orbitais sem contato direto.',
            exampleSentence:
                'As imagens de sensoriamento remoto detectaram focos de calor na floresta.',
            dialect: 'pt_BR',
            dialectNote: 'No Brasil diz-se "sensoriamento remoto"; em Portugal costuma-se usar "teledeteção".',
          ),
          ScienceVocabEntity(
            id: 'sci-veiculo-lancador',
            termPt: 'Veículo lançador / Foguete',
            translationRu: 'Ракета-носитель',
            definition:
                'Foguete impulsionado por propelentes químicos projetado para transportar satélites e cargas úteis ao espaço exterior.',
            exampleSentence:
                'O veículo lançador decolou da plataforma costeira pontualmente às seis horas.',
            dialect: 'all',
          ),
        ],
      ),
      ScienceTopicEntity(
        id: 'champalimaud-neurociencia',
        title: 'Fundação Champalimaud & Neurociência Translacional',
        field: ScienceField.biomedicina,
        institution: 'Centro Champalimaud para o Desconhecido',
        region: 'Belém, Lisboa',
        country: 'Portugal',
        dialect: 'pt_PT',
        accentEmoji: '🧠',
        shortSummary:
            'Pesquisas de fronteira em neurobiologia de circuitos cerebrais, tomada de decisão e imunoterapia oncológica avançada.',
        fullDescription:
            'Erguido às margens do rio Tejo onde as caravelas dos descobrimentos partiam, o Centro Champalimaud dedica-se à exploração da fronteira mais enigmática da biologia moderna: o cérebro e a cura do cancro. Cientistas de dezenas de nacionalidades investigam como redes neurais processam sinais sensoriais para produzir decisões comportamentais, empregando optogenética de última geração e imagiologia cerebral funcional. No campo oncológico, o instituto desenvolve terapias celulares personalizadas, onde linfócitos do próprio paciente são reprogramados geneticamente em laboratório para rastrear e destruir micrometástases sem agredir os tecidos saudáveis.',
        keyDiscoveries: [
          'Mapeamento de circuitos corticais envolvidos em mecanismos de recompensa e paciência',
          'Aplicação de optogenética para ativar neurônios específicos com impulsos de luz laser',
          'Ensaios pioneiros de radiocirurgia em dose única com precisão milimétrica',
          'Terapias de imunooncologia que treinam o sistema imunitário contra tumores refratários',
        ],
        scientificImpact:
            'Posiciona Lisboa como centro europeu de prestígio internacional na medicina do futuro e neurociência comportamental.',
        audioNarration:
            'Nos laboratórios de Belém, os neurocientistas observam os disparos sinápticos e desenvolvem tratamentos celulares inovadores contra o cancro.',
        vocabulary: [
          ScienceVocabEntity(
            id: 'sci-circuito-neuronal',
            termPt: 'Circuito neuronal',
            translationRu: 'Нейронная цепь / сеть мозга',
            definition:
                'Conjunto de neurónios interligados por sinapses que processam informações específicas e orquestram comportamentos.',
            exampleSentence:
                'O circuito neuronal da visão foi mapeado detalhadamente com recurso à optogenética.',
            dialect: 'pt_PT',
            dialectNote: 'Em Portugal escreve-se "neurónio" e "neuronal"; no Brasil "neurônio" e "neural".',
          ),
          ScienceVocabEntity(
            id: 'sci-imunoterapia',
            termPt: 'Imunoterapia oncológica',
            translationRu: 'Онкологическая иммунотерапия',
            definition:
                'Tratamento biológico que estimula ou reativa o próprio sistema imunitário do organismo para combater células malignas.',
            exampleSentence:
                'A imunoterapia proporcionou a remissão completa do tumor no paciente.',
            dialect: 'all',
          ),
          ScienceVocabEntity(
            id: 'sci-imagiologia',
            termPt: 'Imagiologia médica',
            translationRu: 'Медицинская визуализация (МРТ, КТ)',
            definition:
                'Conjunto de técnicas diagnósticas (ressonância magnética, tomografia) que produzem imagens de órgãos internos.',
            exampleSentence:
                'Os exames de imagiologia funcional revelaram a atividade do córtex pré-frontal.',
            dialect: 'pt_PT',
            dialectNote: 'Em Portugal usa-se "imagiologia"; no Brasil diz-se "diagnóstico por imagem".',
          ),
        ],
      ),
    ];
  }

  static List<LabExperimentEntity> getLabExperiments() {
    return const [
      LabExperimentEntity(
        id: 'exp-dna-marinho',
        title: 'Extração e Análise de DNA Ambiental (eDNA) do Mar dos Açores',
        field: ScienceField.oceanografia,
        objectivePt:
            'Identificar espécies raras de peixes e corais abissais filtrando vestígios de DNA presentes em garrafas de água recolhidas a 1.500 metros.',
        objectiveRu:
            'Определить редкие виды рыб и глубоководных кораллов фильтрацией следов ДНК из образцов воды с глубины 1500 метров.',
        hypothesisPt:
            'Se a água for filtrada através de membranas micrométricas, sequenciar-se-ão fragmentos genéticos mesmo de criaturas que nunca foram vistas por câmaras.',
        procedureSteps: [
          'Coletam-se cinco litros de água em profundidade com a roseta oceanográfica.',
          'A água é filtrada a vácuo em membranas com poros de 0,22 micrómetros.',
          'As membranas são lisadas e o DNA é extraído com solventes orgânicos.',
          'Realiza-se a amplificação por PCR dos genes mitocondriais 12S e 16S.',
          'Os fragmentos são sequenciados e comparados com bases de dados genómicas mundiais.',
        ],
        conclusionInsight:
            'Confirmou-se a presença de tubarões-da-groenlândia e cefalópodes raros sem a necessidade de capturar qualquer espécime vivo.',
        passiveVoiceGrammarNote:
            'Na linguagem científica, a Voz Passiva Analítica ("é filtrada", "são lisadas", "foi extraído") e a Voz Passiva Sintética ("sequenciar-se-ão", "coletam-se") são essenciais para enfatizar o procedimento metodológico objetivo e impessoal.',
        icon: '🧬',
      ),
      LabExperimentEntity(
        id: 'exp-soro-butantan',
        title: 'Fracionamento e Neutralização de Peçonha no Butantan',
        field: ScienceField.biomedicina,
        objectivePt:
            'Separar as frações proteicas hemorrágicas e neurotóxicas do veneno e mensurar a titulação de anticorpos neutralizantes no plasma equino.',
        objectiveRu:
            'Разделить геморрагические и нейротоксические фракции яда и измерить титр нейтрализующих антител в лошадиной плазме.',
        hypothesisPt:
            'Se os cavalos doadores forem imunizados com doses graduais atenuadas, produzir-se-á plasma com alto título de imunoglobulinas protetoras.',
        procedureSteps: [
          'Inoculam-se pequenas doses do veneno em animais sob estrito acompanhamento veterinário.',
          'Após o período de imunização, colhe-se o sangue e separa-se o plasma celular.',
          'O plasma é submetido a digestão enzimática com pepsina para purificar os fragmentos F(ab\')2.',
          'Eliminam-se as proteínas não específicas por precipitação fracionada.',
          'O soro purificado é submetido a ensaios de esterilidade e potência neutralizante.',
        ],
        conclusionInsight:
            'Obteve-se um lote de soro antiveneno de alta pureza com risco mínimo de reações alérgicas secundárias para os pacientes.',
        passiveVoiceGrammarNote:
            'Observe as formas impessoais de relato experimental: "Inoculam-se" (= São inoculadas), "colhe-se" (= É colhido) e "obteve-se" (= Foi obtido). Esta estrutura gramatical confere rigor universal aos relatórios laboratoriais.',
        icon: '🧪',
      ),
      LabExperimentEntity(
        id: 'exp-vento-flutuante',
        title: 'Teste de Dinâmica Hidrodinâmica da Turbina WindFloat',
        field: ScienceField.energiaVerde,
        objectivePt:
            'Avaliar a resposta estrutural da plataforma flutuante semissubmersível submetida a ondas irregulares de tempestade em tanque de ensaios.',
        objectiveRu:
            'Оценить устойчивость полупогружной плавучей платформы при воздействии штормовых волн в испытательном гидродинамическом бассейне.',
        hypothesisPt:
            'Se o sistema de lastro dinâmico for acionado em menos de 30 segundos, a inclinação da torre não excederá cinco graus durante a rebentação das vagas.',
        procedureSteps: [
          'Instala-se um modelo em escala 1:40 da plataforma no canal de ondas.',
          'Simulam-se condições extremas do inverno atlântico com sensores inerciais de alta precisão.',
          'Acionam-se bombas de lastro que transferem água entre as três colunas flutuantes.',
          'Mede-se a aceleração no topo da nacele e a tração nas três amarras de aço.',
          'Os dados são processados por algoritmos preditivos de dinâmica de fluidos computacional.',
        ],
        conclusionInsight:
            'A estabilidade dinâmica foi comprovada, garantindo que o aerogerador continuará a produzir eletricidade mesmo sob tempestades violentas.',
        passiveVoiceGrammarNote:
            'A hipótese científica utiliza a estrutura condicional clássica de previsão: "Se [verbo no Futuro do Subjuntivo: for acionado], a inclinação [verbo no Futuro do Presente / Futuro Perifrástico: não excederá]".',
        icon: '💨',
      ),
      LabExperimentEntity(
        id: 'exp-satelite-inpe',
        title: 'Calibração Radiométrica dos Sensores do Amazônia-1',
        field: ScienceField.aeroespacial,
        objectivePt:
            'Ajustar os sensores ópticos da câmera multiespectral WFI do satélite para distinguir variações sutis na clorofila e umidade da biomassa florestal.',
        objectiveRu:
            'Откалибровать оптические сенсоры мультиспектральной камеры WFI спутника для фиксации изменений хлорофилла и влажности лесов.',
        hypothesisPt:
            'Se os índices de vegetação por diferença normalizada (NDVI) forem calibrados contra alvos terrestres conhecidos, detectar-se-ão clareiras de desmatamento em minutos.',
        procedureSteps: [
          'O satélite sobrevoa alvos de calibração homogêneos no deserto e na floresta de terra firme.',
          'Os valores de radiância medidos no topo da atmosfera são comparados com medições de campo.',
          'Corrige-se a interferência da dispersão atmosférica por meio de modelos físicos de transferência radiativa.',
          'Gera-se uma matriz de calibração que é enviada ao computador de bordo do satélite.',
          'As imagens corrigidas são disponibilizadas para o monitoramento florestal do IBAMA.',
        ],
        conclusionInsight:
            'A resolução radiométrica permitiu identificar alertas de desmatamento com área inferior a dois hectares em tempo quase real.',
        passiveVoiceGrammarNote:
            'Constatações científicas utilizam a voz passiva no Pretérito Perfeito: "A estabilidade foi comprovada", "As imagens foram disponibilizadas", "Detectou-se uma anomalia".',
        icon: '🛰️',
      ),
    ];
  }

  static List<ScienceQuizQuestion> getQuizzes() {
    return const [
      ScienceQuizQuestion(
        id: 'quiz-sci-1',
        question:
            'Qual descoberta biomédica mundial histórica derivou da pesquisa com veneno de jararaca realizada no Brasil?',
        options: [
          'O desenvolvimento do Captopril, primeiro inibidor da ECA para pressão alta',
          'A descoberta do primeiro antibiótico natural da flora amazônica',
          'A síntese artificial de insulina para tratamento de diabetes',
          'A criação do primeiro analgésico sem efeitos colaterais',
        ],
        correctIndex: 0,
        explanation:
            'Pesquisas brasileiras com o veneno da jararaca isolaram o peptídeo que levou à criação do Captopril, revolucionando o tratamento da hipertensão arterial no mundo.',
        dialect: 'pt_BR',
        contextField: 'Biomedicina & Farmacologia',
        accentEmoji: '🐍',
      ),
      ScienceQuizQuestion(
        id: 'quiz-sci-2',
        question:
            'Por que a localização geográfica do Centro Espacial de Alcântara no Maranhão é considerada uma das melhores do mundo?',
        options: [
          'Fica a apenas 2° da linha do equador, economizando até 30% de combustível pelo impulso da rotação da Terra',
          'É a única base espacial do mundo construída em uma ilha vulcânica isolada',
          'Possui a montanha mais alta do continente para lançamentos em altitude',
          'Está em uma região onde nunca ocorrem nuvens ou ventos fortes',
        ],
        correctIndex: 0,
        explanation:
            'Por estar próxima ao equador, a velocidade tangencial de rotação da Terra é máxima, impulsionando os foguetes para o leste e economizando enorme quantidade de propelente.',
        dialect: 'pt_BR',
        contextField: 'Aeroespacial & Física Orbital',
        accentEmoji: '🚀',
      ),
      ScienceQuizQuestion(
        id: 'quiz-sci-3',
        question:
            'Qual é a grande inovação tecnológica do projeto WindFloat Atlantic instalado no norte de Portugal?',
        options: [
          'Turbinas eólicas montadas sobre plataformas flutuantes em águas profundas sem fundações fixadas no leito',
          'Geradores eólicos que funcionam inteiramente submersos sob a água',
          'Pás de turbina feitas de cerâmica de Barcelos ultrarresistente',
          'Uso de ventos solares espaciais para alimentar a rede elétrica costeira',
        ],
        correctIndex: 0,
        explanation:
            'O WindFloat Atlantic é o primeiro parque eólico flutuante comercial da Europa continental, ancorado a 100 metros de profundidade com amarras tensionadas flexíveis.',
        dialect: 'pt_PT',
        contextField: 'Energia Verde & Engenharia Oceânica',
        accentEmoji: '⚡',
      ),
      ScienceQuizQuestion(
        id: 'quiz-sci-4',
        question:
            'Na frase científica: "As amostras foram analisadas pelos investigadores no laboratório", qual estrutura gramatical está presente?',
        options: [
          'Voz Passiva Analítica com verbo auxiliar "foram" + particípio "analisadas" e agente da passiva "pelos investigadores"',
          'Voz Ativa com objeto indireto preposicionado',
          'Voz Reflexiva com pronome de reciprocidade',
          'Pretérito Mais-Que-Perfeito Composto',
        ],
        correctIndex: 0,
        explanation:
            'A Voz Passiva Analítica é formada por: Sujeito Paciente (As amostras) + Verbo Auxiliar ser (foram) + Particípio concordante (analisadas) + Agente da Passiva (pelos investigadores).',
        dialect: 'all',
        contextField: 'Gramática Científica (Voz Passiva)',
        accentEmoji: '📚',
      ),
      ScienceQuizQuestion(
        id: 'quiz-sci-5',
        question:
            'O que caracteriza os ecossistemas das fontes hidrotermais abissais descobertas no mar dos Açores?',
        options: [
          'A vida sustenta-se por quimiossíntese bacteriana a partir de minerais superaquecidos na ausência de luz solar',
          'Todas as criaturas realizam fotossíntese usando a bioluminescência do fundo do mar',
          'As águas das fontes são congeladas e sem qualquer tipo de salinidade',
          'Apenas espécies vegetais marinhas conseguem sobreviver à pressão abissal',
        ],
        correctIndex: 0,
        explanation:
            'Nos campos hidrotermais açorianos (como Lucky Strike), bactérias quimiossintéticas usam compostos de enxofre e minerais a mais de 300°C para produzir matéria orgânica sem luz solar.',
        dialect: 'pt_PT',
        contextField: 'Oceanografia & Biologia Abissal',
        accentEmoji: '🌊',
      ),
      ScienceQuizQuestion(
        id: 'quiz-sci-6',
        question:
            'Como se formula uma hipótese experimental correta em português usando a correlação modal "Se + Futuro do Subjuntivo"?',
        options: [
          '"Se analisarmos os dados com rigor, descobriremos novos padrões"',
          '"Se analisamos os dados com rigor, descobrimos novos padrões"',
          '"Se tivéssemos analisado os dados, descobriríamos novos padrões"',
          '"Se analisar os dados, descobriu novos padrões"',
        ],
        correctIndex: 0,
        explanation:
            'A correlação condicional padrão de hipótese científica para o futuro é: "Se + Futuro do Subjuntivo (analisarmos), [oração principal no Futuro do Presente: descobriremos]".',
        dialect: 'all',
        contextField: 'Gramática de Hipóteses & Subjuntivo',
        accentEmoji: '🧪',
      ),
    ];
  }
}
