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

---

## 2. Предлагаемые следующие шаги
- [ ] **Опция 1: «Gira do Futebol & Torcida» (Футбол и спортивная страсть Lusofonia)** — футбольный жаргон Португалии (*chuto, finta, guarda-redes, fora-de-jogo*) vs Бразилии (*chute, drible, goleiro, impedimento*), симулятор комментатора матча в реальном времени, кричалки торсиды (*cânticos*) и терминология игры.
- [ ] **Опция 2: «Expresso Literário & Poesia» (Литературная гостиная и великие авторы)** — интерактивный разбор шедевров (*Fernando Pessoa и его гетеронимы, Clarice Lispector, Machado de Assis, Luís de Camões*), глубокий поэтический синтаксис, метафоры и выразительное чтение под музыку.
- [ ] **Опция 3: «Viagem & Geografia Lusófona» (Интерактивный атлас лузофонии)** — путешествие по 9 странам португальского языка (Бразилия, Португалия, Ангола, Мозамбик, Кабо-Верде, Сан-Томе, Гвинея-Бисау, Тимор-Лешти, Макао), региональные диалекты, достопримечательности и географический квиз.
