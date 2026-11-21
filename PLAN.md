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

---

### Фича 5: Construtor de Frases (Конструктор предложений и синтаксиса) (`lib/features/sentence_builder/`)
- [x] Domain-модели: `SentencePuzzle`, `SentenceBuilderResult`.
- [x] Data-слой: 20 калиброванных предложений A1-B1, `SentenceBuilderRepositoryImpl`.
- [x] Cubit & State: `SentenceBuilderCubit` с анимацией сборки чипов, проверкой и FSRS.
- [x] UI: `SentenceBuilderScreen` с Sentence X-Ray рентгеном и аудио.
- [x] Тесты: `test/features/sentence_builder_test.dart`, `test/features/sentence_builder_cubit_test.dart` (100% pass).

---

## 2. Текущая фича: Centro de Conquistas & Fluência (Центр беглости, стриков и достижений)

### Этап 1: Domain и Data слои (`lib/features/progress/`)
- [ ] **Domain-сущности (`domain/entities/`):**
  - `portuguese_badge.dart`: `PortugueseBadge` (12 культурных наград: Elétrico 28, Garota de Ipanema, Mestre do Til, Relâmpago dos Verbos, Cirurgião da Crase, Poliglota B1, Fogo Sagrado и др.).
  - `progress_stats_entity.dart`: расширение модели (`fluencyScore`, `currentStreak`, `maxStreak`, `scenesCompletedCount`, `phoneticMasteryAvg`, `cefrLevel`, `cefrScorePercentage`, `unlockedBadges`).
- [ ] **Data-слой (`data/`):**
  - `progress_repository_impl.dart`: агрегация данных из всех таблиц Drift (`dialogueNodes`, `srsReviewLogs`, `grammarPracticeLogs`, `listeningAttemptLogs`, `assessmentResultEntries`, `phoneticMasteryEntries`, `sceneProgressEntries`).
  - Расчёт реального динамического стрика по календарным дням.
  - Расчёт формулы индекса беглости (0-100%).
- [ ] **Unit-тесты:** `test/features/progress_test.dart` и обновление `test/features/progress_cubit_test.dart`.

### Этап 2: State Management & Presentation UI
- [ ] `widgets/fluency_score_card.dart`: круговой индикатор владения языком (0-100%) и бэйдж CEFR.
- [ ] `widgets/streak_flame_card.dart`: стрик с недельной шкалой дней (Пн-Вс).
- [ ] `widgets/badges_grid_section.dart`: сетка 12 культурных достижений (разблокированные vs закрытые с условиями).
- [ ] `screens/progress_screen.dart`: полная интеграция с декомпозицией по `flutter-clean-arch-playbook`.

### Этап 3: Интеграция и верификация
- [ ] Прогон `flutter analyze` и `flutter test` (0 warnings, 100% pass).
