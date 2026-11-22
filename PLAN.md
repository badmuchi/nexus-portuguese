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
- [x] Data-слой: 6 культурных микро-подкастов (`AuditorioSeedData`: Pastéis de Belém, Garota de Ipanema, Elétrico 28, Festa Junina, O Mercado da Ribeira, Histórias do Sertão), `AuditorioRepositoryImpl` с логированием в Drift.
- [x] Cubit & State: `AuditorioCatalogCubit` с фильтрами по диалектам (PT-BR / PT-PT), уровням CEFR и поиском; `PodcastPlayerCubit` с управлением воспроизведением, скоростью (0.75x, 1.0x, 1.25x), зацикливанием фразы и акустической оценкой через `PronunciationAccuracyEvaluator`.
- [x] UI: `AuditorioCatalogScreen`, `PodcastPlayerScreen`, `PodcastCard`, `TranscriptSnippetTile`, `WordLookupDialog` с 1-tap FSRS сохранением, `SentenceXRaySheet` интеграция, `ShadowingRecorderSheet`.
- [x] Тесты: `test/features/auditorio_test.dart`, `test/features/auditorio_cubit_test.dart` (131/131 тестов pass, `flutter analyze` 0 warnings).

---

## 2. Предлагаемые следующие шаги
- [ ] **Опция А: «Arena de Duelos Culturais» (Викторина-баттл диалектов: PT-BR vs PT-PT)** — интерактивный квиз на выявление региональных различий (*ônibus* vs *autocarro*, *estou fazendo* vs *estou a fazer*, сленг carioca vs tripeiro).
- [ ] **Опция Б: «Diário de Bordo» (Голосовой и текстовый интерактивный дневник с AI-фидбеком и исправлением грамматики)** — практика свободного письма/речи с автоматическим анализом ошибок и сохранением в FSRS.
