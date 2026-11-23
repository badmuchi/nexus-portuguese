# План разработки: Portuguese App

## 1. Завершённые фичи

### Фича 1: Интерактивный тренажёр фонетики и носовых гласных (`lib/features/phonetics/`)
- [x] Domain-модели: `MinimalPairItem`, `DialectComparison`, `PhoneticExercise`, `PhoneticMastery`.
- [x] Drift: таблица `PhoneticMasteryEntries` (схема v2).
- [x] Cubit & State: `PhoneticsTrainerCubit` с тестами `test/features/phonetics_trainer_cubit_test.dart`.
- [x] UI: `PhoneticsTrainerScreen` с декомпозицией на приватные `StatelessWidget`.
- [x] Интеграция с `PhoneticsScreen`, DI в `main.dart`.

### Фича 2: Живые сцены Португалии и Бразилии (`lib/features/scenes/`)
- [x] Domain-модели: `PortugueseLifeScene`, `SceneDialogueLine`, `SceneKeyWord`, `SceneChallenge`.
- [x] Drift: таблица `SceneProgressEntries` (схема v3).
- [x] Сиды: 6 аутентичных ситуаций (`portuguese_scenes_seed_data.dart`).
- [x] Cubit & State: `ScenesCubit`, интеграция с FSRS и Sentence X-Ray морфологией.
- [x] UI: `ScenesCatalogScreen`, `SceneDetailScreen`, `SceneWordCard`, `SceneChallengeCard`, `ScenePhraseTile`.
- [x] Тесты: `test/features/scenes_test.dart`, `test/features/scenes_cubit_test.dart` (100% pass).

### Фича 3: Diagnóstico CEFR (Тест на определение уровня A1–B2) (`lib/features/assessment/`)
- [x] Drift: таблица `AssessmentResultEntries` (схема v4).
- [x] Domain-модели: `CefrLevel`, `SkillFocus`, `LevelQuizQuestion`, `LevelQuizResult`.
- [x] Data-слой: 15 калиброванных вопросов, `AssessmentRepositoryImpl`.
- [x] Cubit & State: `AssessmentCubit`, вычисление профиля навыков и 1-tap FSRS.
- [x] UI: `LevelAssessmentScreen`, `LevelCertificateCard`.
- [x] Тесты: `test/features/assessment_test.dart`, `test/features/assessment_cubit_test.dart` (100% pass).

### Фича 4: VerboSprint (Скоростной тренажёр спряжения глаголов) (`lib/features/verb_trainer/`)
- [x] Domain-модели: `VerbExercise`, `VerbTrainerConfig`, `VerbTrainerSessionResult`.
- [x] Data-слой: `VerbExerciseGenerator`, `VerbTrainerRepositoryImpl`.
- [x] Cubit & State: `VerbTrainerCubit` с таймером, множителем комбо и FSRS.
- [x] UI: `VerbTrainerScreen`, `VerbTrainerConfigSheet`, `VerbSessionSummaryCard`.
- [x] Тесты: `test/features/verb_trainer_test.dart`, `test/features/verb_trainer_cubit_test.dart` (100% pass).

### Фича 5: Construtor de Frases (Конструктор предложений и синтаксиса) (`lib/features/sentence_builder/`)
- [x] Domain-модели: `SentencePuzzle`, `SentenceBuilderResult`.
- [x] Data-слой: 20 калиброванных предложений A1-B1, `SentenceBuilderRepositoryImpl`.
- [x] Cubit & State: `SentenceBuilderCubit` с анимацией сборки чипов, проверкой и FSRS.
- [x] UI: `SentenceBuilderScreen` с Sentence X-Ray рентгеном и аудио.
- [x] Тесты: `test/features/sentence_builder_test.dart`, `test/features/sentence_builder_cubit_test.dart` (100% pass).

### Фича 6: Centro de Conquistas & Fluência (Центр беглости, стриков и достижений) (`lib/features/progress/`)
- [x] Domain-сущности: `PortugueseBadge` (12 культурных наград: Elétrico 28, Garota de Ipanema, Mestre do Til, Relâmpago dos Verbos, Cirurgião da Crase, Poliglota B1, Fogo Sagrado и др.).
- [x] Data-слой: multi-table Drift-агрегация, расчет реального динамического стрика по календарным дням, формула беглости (0-100%).
- [x] UI: `FluencyScoreCard`, `StreakFlameCard` (шкала Пн-Вс), `BadgesGridSection`.
- [x] Тесты: `test/features/progress_test.dart` (100% pass).

### Фича 7: Auditório & Shadowing (Микро-подкасты и теневой повтор) (`lib/features/auditorio/`)
- [x] Domain-сущности: `PodcastTrack`, `TranscriptSnippet`, `ShadowingEvaluationEntity`.
- [x] Data-слой: 6 культурных микро-подкастов (`AuditorioSeedData`), `AuditorioRepositoryImpl` с логированием в Drift.
- [x] Cubit & State: `AuditorioCatalogCubit`, `PodcastPlayerCubit` (скорость 0.75x–1.25x, зацикливание фразы, распознавание и обратная связь по словам).
- [x] UI: `AuditorioCatalogScreen`, `PodcastPlayerScreen`, синхронная транскрипция, быстрый тултип слова, 1-tap FSRS.
- [x] Тесты: `test/features/auditorio_test.dart`, `test/features/auditorio_cubit_test.dart` (100% pass).

### Фича 8: Diário de Bordo (Интерактивный дневник с AI-анализатором) (`lib/features/diary/`)
- [x] Drift: таблица `DiaryEntries` (схема v5 с миграцией).
- [x] Domain & Service: `PortugueseDiaryAnalyzer` (детекция PT-BR vs PT-PT, поиск пропущенной диакритики `ã/õ/ç/á/ê`, слияний предлогов `de o -> do`, ловушек рода, подсчет слов и оценка CEFR).
- [x] Cubit & State: `DiaryCubit`, темы дня (`DiaryPromptsSeed`), голосовой ввод.
- [x] UI: `DiaryCatalogScreen`, `DiaryEditorScreen`, `PortugueseDiacriticsBar`, `DiaryAnalysisSheet`.
- [x] Тесты: `test/features/diary_test.dart`, `test/features/diary_cubit_test.dart` (100% pass).

### Фича 9: Arena de Duelos Culturais (Баттл диалектов: PT-BR vs PT-PT) (`lib/features/duels/`)
- [x] Domain-модели: `DuelQuestion`, `DuelCategory` (vocabulario, gramatica, falsosAmigos, girias), `DuelSessionResultEntity`.
- [x] Data-слой: 20 калиброванных вопросов-ловушек (`DuelQuestionsSeed`), `DuelsRepositoryImpl`.
- [x] Cubit & State: `DuelsCubit` с таймером 15 сек, комбо-множителем (2x, 3x), озвучкой обоих диалектов и титулами.
- [x] UI: `DuelsLobbyScreen`, `DuelGameplayScreen`, `DuelOptionButton`, `DialectComparisonCard`, `DuelResultScreen`.
- [x] Тесты: `test/features/duels_test.dart`, `test/features/duels_cubit_test.dart` (100% pass).

### Фича 10: Laboratório de Expressões Idiomáticas (`lib/features/idioms/`)
- [x] Domain-модели: `PortugueseIdiom`, `IdiomCategory` (animais, comida, corpo, vida), `IdiomQuizQuestion`.
- [x] Data-слой: 16 идиом с этимологией и диалектными пометками (`IdiomsSeedData`), `IdiomsRepositoryImpl`.
- [x] Cubit & State: `IdiomsCubit` с фильтрами, поиском, режимом квиза (4 варианта) и записью попыток.
- [x] UI: `IdiomsCatalogScreen`, `IdiomCard`, `IdiomDetailSheet`, `IdiomQuizView` с 1-tap FSRS экспортом.
- [x] Тесты: `test/features/idioms_test.dart`, `test/features/idioms_cubit_test.dart` (100% pass).

### Фича 11: Trilha Sonora da Língua (`lib/features/music_lab/`)
- [x] Domain-модели: `PortugueseSong`, `SongLyricLine`, `MusicGenre` (Bossa Nova, Fado, Samba, MPB, Forró).
- [x] Data-слой: 6 аутентичных шедевров с синхронизированными строками и поэтическими комментариями (`MusicLabSeedData`), `MusicRepositoryImpl`.
- [x] Cubit & State: `MusicCatalogCubit`, `SongPlayerCubit` (управление строками, скорость 0.75x–1.25x, караоке-автопроигрывание, TTS с диалектом, режим вставки слов `maskedTextPt`).
- [x] UI: `SongPlayerScreen`, `MusicCatalogScreen`, вращающийся винил, `KaraokeLyricTile`, `SongQuizTile`, `MusicControlsBar`, 1-tap FSRS экспорт.
- [x] Тесты: `test/features/music_lab_test.dart`, `test/features/music_lab_cubit_test.dart` (184/184 тестов pass, `flutter analyze` 0 warnings).

### Фича 12: Simulador de Redes & WhatsApp (`lib/features/chat_simulator/`)
- [x] Domain-модели: `ChatScenarioEntity`, `ChatMessageEntity`, `ChatAbbreviation`, `ChatUserChoiceEntity`, `ChatDialogStepEntity`.
- [x] Data-слой: 6 ветвящихся аутентичных сценариев (Airbnb Lisboa, iFood SP, Churrasco Rio, Slack Porto, Uber Copacabana, Farmácia Cascais) (`ChatSimulatorSeedData`), `ChatSimulatorRepositoryImpl` с логированием в Drift.
- [x] Cubit & State: `ChatCatalogCubit`, `ChatConversationCubit` (ветвление реплик, таймер печати "digitando...", голосовые сообщения (voice notes) с визуальным волноводом, оценка естественности фраз).
- [x] UI: `ChatRoomScreen`, `ChatCatalogScreen`, стилизация пузырей под WhatsApp/iMessage, `ChatTypingIndicator`, `AbbreviationDetailSheet` с 1-tap FSRS, `ChatChoicePanel`.
- [x] Тесты: `test/features/chat_simulator_test.dart`, `test/features/chat_simulator_cubit_test.dart` (198/198 тестов pass, `flutter analyze` 0 warnings).

### Фича 13: Guia de Sobrevivência & Burocracia Lusófona (`lib/features/survival_guide/`)
- [x] Domain-модели: `SurvivalQuestEntity`, `SurvivalStepEntity`, `SurvivalPhraseEntity`, `CulturalTipEntity`, `SurvivalCategory`.
- [x] Data-слой: 4 интерактивных квеста (NIF Finanças Lisboa, Aluguel e Fiador Porto, Bilhete Santa Apolónia, CPF Receita Federal Rio), 20 экспресс-фраз по категориям с пометками SOS, 5 практических советов по этикету (`SurvivalGuideSeedData`), `SurvivalGuideRepositoryImpl`.
- [x] Cubit & State: `SurvivalCatalogCubit` (поиск, фильтры категорий, диалектов, вкладки), `SurvivalQuestCubit` (шаги, интерактивный выбор, проверка оптимальности, озвучка реплик через TTS, сохранение прогресса в Drift).
- [x] UI: `SurvivalGuideCatalogScreen`, `SurvivalQuestScreen`, `SurvivalQuestCard`, `SurvivalPhraseTile` (копирование в буфер, озвучка и 1-tap FSRS), `CulturalTipCard`, `QuestStepView`.
- [x] Тесты: `test/features/survival_guide_test.dart`, `test/features/survival_guide_cubit_test.dart` (229/229 тестов pass, `flutter analyze` 0 warnings).

### Фича 14: Mercado de Trabalho, Carreira & Entrevistas (`lib/features/career/`)
- [x] Domain-модели: `InterviewScenarioEntity`, `InterviewQuestionEntity`, `InterviewAnswerOption`, `BusinessPhraseEntity`, `CvGuideItemEntity`, `CareerCategory` (tech, sales, hospitality, marketing, general).
- [x] Data-слой: 3 полноценных трека собеседований (Software Engineer в scale-up Лиссабона [PT-PT], Gerente de Contas B2B в Сан-Паулу [PT-BR], Rececionista в бутик-отеле Алгарве [PT-PT]), 11 деловых фраз и email-шаблонов, 3 руководства по резюме и трудовым режимам (CLT vs PJ в Бразилии, 14 зарплат и subsídio de refeição в Португалии) (`CareerSeedData`), `CareerRepositoryImpl` с сохранением результатов в Drift.
- [x] Cubit & State: `CareerCatalogCubit` (поиск по ролям и навыкам, фильтры категорий, регионов BR/PT, типов фраз), `InterviewSimulatorCubit` (STAR-оценка ответов, подсчет баллов, озвучка реплик интервьюера с диалектом через TTS, разбор фидбэка рекрутера).
- [x] UI: `CareerCatalogScreen`, `InterviewSimulatorScreen`, `InterviewScenarioCard`, `BusinessPhraseTile` (копирование, озвучка, 1-tap FSRS), `CvGuideCard`, `InterviewDialogView` с бейджами +10 pts и анализом ответа.
- [x] Тесты: `test/features/career_test.dart`, `test/features/career_cubit_test.dart` (240/240 тестов pass, `flutter analyze` 0 warnings).

### Фича 15: Cozinha Lusófona & Gastronomia (`lib/features/gastronomy/`)
- [x] Domain-модели: `RecipeEntity`, `RecipeIngredient`, `RecipeStepEntity`, `CulinaryTermEntity`, `CulinaryTermType` (cookingVerb, utensil, measurement, dialectFood).
- [x] Data-слой: 6 аутентичных рецептов (Pastel de Nata [Lisboa], Pão de Queijo [Minas Gerais], Bacalhau à Brás [Lisboa], Moqueca Baiana [Bahia], Caldo Verde [Minho], Feijoada Completa [Rio de Janeiro]), 16 терминов кулинарной лексики и контрастов (chávena vs xícara, fiambre vs presunto, frigorífico vs geladeira, varinha mágica vs mixer), `GastronomyRepositoryImpl` с логированием в Drift.
- [x] Cubit & State: `GastronomyCatalogCubit` (поиск, фильтры диалектов BR/PT, сложности Fácil/Médio/Avançado, типов лексики), `RecipeCookCubit` (пошаговый интерактивный кулинарный режим, интерактивный таймер варки/запекания, чек-лист ингредиентов, озвучка шагов через TTS).
- [x] UI: `GastronomyCatalogScreen`, `RecipeDetailScreen`, `RecipeCookingScreen`, `RecipeCard`, `CulinaryTermTile` (копирование, озвучка, 1-tap FSRS), `RecipeIngredientsView` (чек-лист и экспорт в FSRS), `RecipeStepView` (с таймером, глаголами готовки и звуковым алертом).
- [x] Тесты: `test/features/gastronomy_test.dart`, `test/features/gastronomy_cubit_test.dart` (263/263 тестов pass, `flutter analyze` 0 warnings).

### Фича 16: Clube de Cinema & Telenovelas (`lib/features/cinema/`)
- [x] Domain-модели: `MovieSceneEntity`, `CinemaDialogueLineEntity`, `CinemaQuoteEntity`.
- [x] Data-слой: 5 культовых киносцен с историческим контекстом и сленгом (Cidade de Deus [2002], Central do Brasil [1998], O Auto da Compadecida [2000], Capitães de Abril [2000], Glória [2021]), 10 легендарных крылатых киноцитат («Se correr o bicho pega...», «Pede pra sair!», «Não sei, só sei que foi assim!», «Grândola, Vila Morena»), `CinemaRepositoryImpl` с логированием в Drift.
- [x] Cubit & State: `CinemaCatalogCubit` (поиск, фильтры диалектов BR/PT, жанров Crime/Drama/Comédia/Histórico/Suspense), `ScenePlayerCubit` (построчный аудиоплеер с автопроигрыванием, режим дубляжа и теневого повтора, озвучка реплик через TTS).
- [x] UI: `CinemaCatalogScreen`, `ScenePlayerScreen`, `MovieSceneCard`, `CinemaDialogueBubble` (подсветка сленга и культурного подтекста, озвучка, 1-tap FSRS), `CinemaQuoteCard`, `ScenePlaybackControls` (дубляж, автопроигрывание, перемотка).
- [x] Тесты: `test/features/cinema_test.dart`, `test/features/cinema_cubit_test.dart` (286/286 тестов pass, `flutter analyze` 0 warnings).

### Фича 17: Viagem & Geografia Lusófona (`lib/features/travel_guide/`)
- [x] Domain-модели: `LusophoneCountryEntity`, `CountryLinguisticFeature`, `TravelPhraseEntity`, `TravelPhraseCategory` (airportCustoms, transport, hotelLodging, restaurantDining, emergencies, localCourtesies), `GeographyQuizQuestion`.
- [x] Data-слой: 9 стран и территорий CPLP (Португалия, Бразилия, Ангола, Мозамбик, Кабо-Верде, Сан-Томе и Принсипи, Гвинея-Бисау, Восточный Тимор, Макао) с культурным обзором, столицами, валютами, национальными блюдами и местными диалектизмами (`TravelGuideSeedData`), 18 практических фраз для путешествий, 8 географических вопросов викторины, `TravelGuideRepositoryImpl` с логированием в Drift.
- [x] Cubit & State: `TravelCatalogCubit` (поиск, фильтры континентов, категорий фраз, диалектов BR/PT), `GeographyQuizCubit` (викторина "Passaporte Lusófono", подсчёт баллов, коллекция штампов в паспорте, озвучка вопросов через TTS).
- [x] UI: `TravelCatalogScreen`, `CountryDetailScreen`, `GeographyQuizScreen`, `CountryCard`, `TravelPhraseTile` (озвучка, копирование, 1-tap FSRS), `PassportStampBadge`.
- [x] Тесты: `test/features/travel_guide_test.dart`, `test/features/travel_guide_cubit_test.dart` (312/312 тестов pass, `flutter analyze` 0 warnings).

---

### Фича 18: Expresso Literário & Poesia (`lib/features/literature/`)
- [x] Domain-модели: `LiteraryWorkEntity`, `LiteraryPassageEntity`, `LiteraryVocabularyEntity`, `LiteraryQuoteEntity`.
- [x] Data-слой: 6 шедевров португалоязычной литературы (Fernando Pessoa [Álvaro de Campos] — «Tabacaria», Clarice Lispector — «A Hora da Estrela», Luís de Camões — «Amor é um fogo que arde sem se ver», Machado de Assis — «Memórias Póstumas de Brás Cubas», Vinicius de Moraes — «Soneto de Fidelidade», Florbela Espanca — «Eu Quero Amar, Amar Perdidamente!») (`LiteratureSeedData`), 6 афоризмов и философских цитат (José Saramago, Mia Couto, Guimarães Rosa, Carlos Drummond de Andrade, Eça de Queirós, Fernando Pessoa), `LiteratureRepositoryImpl` с логированием в Drift.
- [x] Cubit & State: `LiteratureCatalogCubit` (поиск, фильтры диалектов BR/PT, жанров Поэзия/Проза/Сонет, вкладки), `ReaderCubit` (построфный интерактивный режим чтения со старинной эстетикой, выразительная декламация через TTS на скорости 0.9x с учётом диалекта автора, разбор грамматики и поэтических фигур, экспорт терминов в FSRS).
- [x] UI: `LiteratureCatalogScreen`, `ReaderScreen`, `LiteraryWorkCard`, `LiteraryQuoteCard`, `LiteraryVocabSheet` с 1-tap FSRS добавлением.
- [x] Тесты: `test/features/literature_test.dart`, `test/features/literature_cubit_test.dart` (336/336 тестов pass, `flutter analyze` 0 warnings).

---

### Фича 19: Gira do Futebol & Torcida (`lib/features/football/`)
- [x] Domain-модели: `FootballMatchEntity`, `MatchMomentEntity`, `FootballTermEntity`, `FootballTermCategory` (positions, rules, movesAndSkills, slangAndJargon), `FanChantEntity`, `FootballQuizQuestion`.
- [x] Data-слой: 4 сценария матчей (Fla-Flu no Maracanã [Rio, PT-BR], O Clássico Benfica vs Porto [Lisboa, PT-PT], Final da Libertadores [Montevidéu, PT-BR], Seleção das Quinas na Eurocopa [Lisboa, PT-PT]) (`FootballSeedData`), 16 футбольных терминов со скрупулёзным сравнением PT-PT vs PT-BR (guarda-redes vs goleiro, fora-de-jogo vs impedimento, pontapé de canto vs escanteio, baliza vs trave, finta vs drible, remate vs chute, relvado vs gramado, equipa vs time, camisola vs camisa, adeptos vs torcedores, cueca vs caneta, mister vs professor), 6 легендарных кричалок торсид, 8 вопросов викторины «Quiz da Pelada», `FootballRepositoryImpl` с логированием в Drift.
- [x] Cubit & State: `FootballCatalogCubit` (поиск, фильтры диалектов BR/PT, категорий терминов, вкладки), `MatchSimulatorCubit` (симулятор комментатора матча в реальном времени с табло счёта, бегущими минутами, экспрессивной озвучкой через TTS на скорости 1.05x и разбором диалектных контрастов момента), `FootballQuizCubit` (викторина футбольного сленга с подсчётом баллов и трофеем).
- [x] UI: `FootballCatalogScreen`, `MatchSimulatorScreen`, `FootballQuizScreen`, `FootballMatchCard`, `FootballTermCard` (парная карточка сравнения PT/BR, озвучка и 1-tap FSRS), `FanChantCard`.
- [x] Тесты: `test/features/football_test.dart`, `test/features/football_cubit_test.dart` (368/368 тестов pass, `flutter analyze` 0 warnings).

---

### Фича 20: Rádio Novela & Podcast Drama (`lib/features/radionovela/`)
- [x] Domain-модели: `AudioDramaEntity`, `DramaCharacterEntity`, `DramaSceneEntity`, `DramaLineEntity`, `DramaInteractiveChoice`.
- [x] Data-слой: 4 атмосферных радиоспектакля («O Mistério da Alfama» [Lisboa, PT-PT], «Amor e Vento no Sertão» [Bahia, PT-BR], «O Farol da Guia na Noite de Tempestade» [Cascais, PT-PT], «O Golpe da Avenida Paulista» [São Paulo, PT-BR]) (`RadioNovelaSeedData`) с профессиональными театральными ремарками, сленгом (*não dar tréguas, quem anda à chuva molha-se, oxente, errar feio, mar bravio, passar batido, viajar na maionese*), интерактивными развилками выбора и аудиосценами, `RadioNovelaRepositoryImpl` с логированием в Drift.
- [x] Cubit & State: `RadioNovelaCatalogCubit` (поиск, фильтры диалектов BR/PT, жанров Нуар/Романс/Саспенс), `RadioPlayerCubit` (построчный/посценный аудиоплеер, стилизация радиоволны FM 98.4, регулировка скорости 0.85x–1.15x, переключатель театральных ремарок и перевода, сюжетный выбор на развилках, экспорт реплик в FSRS).
- [x] UI: `RadioNovelaCatalogScreen`, `RadioPlayerScreen`, `DramaEpisodeCard`, `DramaLineBubble` (аватар актера, ремарки, озвучка и 1-tap FSRS), интерактивная карточка сюжетного поворота.
- [x] Тесты: `test/features/radionovela_test.dart`, `test/features/radionovela_cubit_test.dart` (388/388 тестов pass, `flutter analyze` 0 warnings).

---

### Фича 21: Bazar & Feira Livre (`lib/features/bazar/`)
- [x] Domain-модели: `MarketItemEntity`, `MarketStallEntity`, `MarketplaceEntity`, `MarketPhraseEntity`, `BargainStepEntity`, `BargainScenarioEntity`.
- [x] Data-слой: 4 культовых рынка (Feira da Ladra [Lisboa, PT-PT], Mercadão Municipal [São Paulo, PT-BR], Mercado do Bolhão [Porto, PT-PT], Feira de São Cristóvão [Rio de Janeiro, PT-BR]) (`BazarSeedData`), 16 аутентичных ярмарочных выражений по категориям (приветствия, меры веса/объема, дегустация, искусство торга) с контрастами PT/BR, 2 пошаговых сценария торга (Azulejo Antigo в Лиссабоне, Frutas Exóticas в Сан-Паулу), `BazarRepositoryImpl` с логированием в Drift.
- [x] Cubit & State: `BazarCatalogCubit` (поиск, фильтры диалектов PT/BR, категорий фраз, переключение вкладок), `BargainSimulatorCubit` (пошаговый симулятор торга с прогрессом скидки, расчетом честной цены, озвучкой реплик покупателя и торговца через `HybridAudioPlaybackService`, сохранением прогресса покупки).
- [x] UI: `BazarCatalogScreen` (3 вкладки: Рынки, Торг, Фразы), `MarketDetailScreen` (баннер рынка, лавки, кричалки торговцев, корзина покупок с подсчетом стоимости), `BargainSimulatorScreen` (шкала торга, скидка, интерактивные раунды), `MarketplaceCard`, `MarketPhraseTile` (озвучка, копирование, 1-tap FSRS), `BargainScenarioCard`.
- [x] Тесты: `test/features/bazar_test.dart`, `test/features/bazar_cubit_test.dart` (407/407 тестов pass, `flutter analyze` 0 warnings).

---

### Фича 22: Humor Lusófono & Piadas de Boteco (`lib/features/humor/`)
- [x] Domain-модели: `JokeEntity`, `JokeVocabEntity`, `TrocadilhoEntity`, `HumorQuizEntity`, `JokeCategory` (boteco, alentejano, trocadilho, meme).
- [x] Data-слой: 8 аутентичных анекдотов («O Bêbado e o Espelho» [BR], «A Mosca na Sopa» [PT], «O Alentejano e o Caracol» [PT], «Manuel e a Árvore do Parque» [PT], «O Livro de Matemática» [All], «O Peixe e a Filosofia» [All], «É Sobre Isso e Tá Tudo Bem» [BR], «Com Certeza, Mas Depende» [PT]) (`HumorSeedData`), 6 каламбуров и загадок-трокадилью с лингвистическим разбором игры слов, 4 вопроса интерактивной викторины «Complete a Piada», `HumorRepositoryImpl` с логированием в Drift и интеграцией с FSRS.
- [x] Cubit & State: `HumorCatalogCubit` (поиск, фильтры категорий, диалектов PT/BR, переключение табов), `JokeReaderCubit` (интерактивное чтение с занавесом панчлайна, озвучка завязки и развязки через `HybridAudioPlaybackService`, разбор юмора «В чём соль?», оценка «Смешно/Так себе», 1-tap FSRS экспорт лексики), `HumorQuizCubit` (викторина панчлайнов с подсчетом очков и разбором).
- [x] UI: `HumorCatalogScreen` (3 вкладки: Анекдоты, Игра слов, Викторина), `JokeDetailScreen` (завязка, анимация открытия панчлайна, реакции, культурный разбор, термины), `HumorQuizScreen` (интерактивный квиз), `JokeCard`, `TrocadilhoCard` (интерактивный ответ и разбор созвучий).
- [x] Тесты: `test/features/humor_test.dart`, `test/features/humor_cubit_test.dart` (429/429 тестов pass, `flutter analyze` 0 warnings).

---

---

### Фича 23: Trilhas da Natureza & Ecoturismo (`lib/features/nature/`)
- [x] Domain-модели: `NatureReserveEntity`, `NatureTrailEntity`, `SpeciesEntity`, `EcoQuizQuestion`, `SpeciesCategory` (fauna, flora).
- [x] Data-слой: 6 легендарных биосферных зон и национальных парков (Parque Nacional da Chapada Diamantina [BR], Parque Nacional de Anavilhanas & Amazônia [BR], Parque Nacional da Peneda-Gerês [PT], Parque Nacional do Pantanal Matogrossense [BR], Parque Natural de São Miguel & Sete Cidades [Açores, PT], Parque Natural da Serra da Estrela [PT]) (`NatureSeedData`), 12 видов флоры и фауны (onça-pintada, boto-cor-de-rosa, vitória-régia, tuiuiú, capivara, garrano, lobo-ibérico, lírio-do-gerês, cachalote, priolo, cão da serra da estrela, hortênsia-azul), 6 вопросов эко-викторины, `NatureRepositoryImpl` с логированием в Drift и интеграцией с FSRS.
- [x] Cubit & State: `NatureCatalogCubit` (поиск, фильтры диалектов PT/BR, фильтры флоры/фауны, переключение вкладок), `NatureReserveCubit` (детали парка, озвучка описаний через `HybridAudioPlaybackService`, сохранение прохождения треков и добавление видов в FSRS), `EcoQuizCubit` (викторина с подсчетом баллов и разбором экологических терминов).
- [x] UI: `NatureCatalogScreen` (3 вкладки: Заповедники, Флора & Фауна, Эко-викторина), `NatureDetailScreen` (баннер биома, достопримечательности, треки с дистанцией и перепадом высот, редкие виды), `EcoQuizScreen` (интерактивный тест), `ReserveCard`, `TrailCard` (чипы дистанции/времени, советы безопасности, отметка прохождения), `SpeciesCard` (статус вида, любопытные факты, озвучка и 1-tap FSRS).
- [x] Тесты: `test/features/nature_test.dart`, `test/features/nature_cubit_test.dart` (452/452 тестов pass, `flutter analyze` 0 warnings).

---

### Фича 24: Mestres da Pintura, Azulejos & Artes Plásticas (`lib/features/art/`)
- [x] Domain-модели: `ArtworkEntity`, `ArtStyleEntity`, `ArtVocabEntity`, `ArtQuizQuestion`, `ArtPeriod`.
- [x] Data-слой: 6 шедевров и памятников искусства (*Abaporu* [Tarsila do Amaral], *Painéis de São Bento* [Jorge Colaço], *Os Doze Profetas* [Aleijadinho], *Guerra e Paz* [Candido Portinari], *Lince Ibérico* [Bordalo II], *Canção Popular a Russa e o Fígaro* [Amadeo de Souza-Cardoso]), 4 художественных стиля (Modernismo Brasileiro, Azulejaria Tradicional, Barroco Colonial & Rococó, Arte Urbana & Street Art), 12 искусствоведческих терминов, 6 вопросов арт-викторины (`ArtSeedData`), `ArtRepositoryImpl` с логированием в Drift и интеграцией с FSRS.
- [x] Cubit & State: `ArtCatalogCubit` (поиск, фильтры стилей, диалектов PT/BR, переключение вкладок), `ArtworkDetailCubit` (исследование шедевра, озвучка описания, экспорт терминов в FSRS, отметка об изучении), `ArtQuizCubit` (викторина стилей и полотен с интерактивным разбором).
- [x] UI: `ArtCatalogScreen` (3 вкладки: Шедевры, Направления, Арт-викторина), `ArtworkDetailScreen` (палитра, композиционный анализ, лексика, исторический экскурс), `ArtQuizScreen`, `ArtworkCard`, `ArtStyleCard`.
- [x] Тесты: `test/features/art_test.dart`, `test/features/art_cubit_test.dart` (473/473 тестов pass, `flutter analyze` 0 warnings).

---

## 2. Итог выполнения очереди:
- [x] **Опция 2: «Rádio Novela & Podcast Drama»** — завершена (`d66a380`).
- [x] **Опция 3: «Bazar & Feira Livre»** — завершена (`98b47a2`).
- [x] **Опция 1: «Humor Lusófono & Piadas de Boteco»** — завершена (`c27446a`).
- [x] **Фича 23: «Trilhas da Natureza & Ecoturismo»** — завершена (`765adee`).
- [x] **Фича 24: «Mestres da Pintura, Azulejos & Artes Plásticas»** — завершена.

---

## 3. Следующие шаги и идеи развития:
1. **«Arquitetura & Cidades Modernas»**: От колониального Оуру-Прету и белемского мануэлино до футуризма Нимейера в Бразилиа и современной архитектуры Порту (Сиза Виейра) — архитектурные стили, урбанистика, планировка городов.
2. **«Festas Populares & Tradições Folclóricas»**: Карнавал (Рио и Салвадор), Festa Junina, Festas de Santo António в Лиссабоне, São João в Порту, Bumba Meu Boi — фольклор, обрядовые песни, традиционные танцы и сленг праздников.
3. **«Mercado Financeiro, Startups & Economia Lusófona»**: Терминология инвестиций, финтех-бум (Nubank, Pix, MB Way), стартап-экосистема Лиссабона (Web Summit), ведение бизнеса и переговоров.
