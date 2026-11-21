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

---

## 2. Текущая фича: Diagnóstico CEFR (Тест на определение уровня A1–B2)

### Этап 1: Domain и Data слои (Схема v4)
- [x] **Схема локальной БД Drift (`lib/core/database/`):**
  - Таблица `AssessmentResultEntries` (`id`, `determinedLevel`, `levelTitleRu`, `scorePercentage`, `totalQuestions`, `correctAnswers`, `skillScoresJson`, `mistakesJson`, `completedAt`).
  - Миграция схемы до `schemaVersion = 4`.
  - Кодогенерация через `build_runner`.
  - DAO-запросы: `getLatestAssessmentResult()`, `insertAssessmentResult()`.
- [x] **Domain-сущности (`lib/features/assessment/domain/`):**
  - `entities/level_quiz_question.dart`: `CefrLevel`, `SkillFocus`, `LevelQuizQuestion`.
  - `entities/level_quiz_result.dart`: `LevelQuizResult` с вычислением уровня (A1-B2), скилл-радара, списка ошибок и рекомендаций.
  - `repositories/assessment_repository.dart`: Контракт с `Result<T>`.
- [x] **Data-слой (`lib/features/assessment/data/`):**
  - `datasources/portuguese_assessment_seed_data.dart`: 15 калиброванных тестовых вопросов (грамматика, crase, PT-BR vs PT-PT, аудирование, лексика).
  - `repositories/assessment_repository_impl.dart`: Реализация `AssessmentRepository` с сохранением в Drift.
- [x] **Unit-тесты:** `test/features/assessment_test.dart`.

### Этап 2: State Management (BLoC/Cubit)
- [x] `cubit/assessment_cubit.dart` и `assessment_state.dart`:
  - Состояния: загрузка, активный вопрос, показ объяснения, завершённый сертификат, добавление ошибок в FSRS.
  - Unit-тесты: `test/features/assessment_cubit_test.dart` (100% pass).

### Этап 3: Presentation UI
- [x] `widgets/level_certificate_card.dart`:
  - Карточка-сертификат Material 3 с бэйджем уровня, разбивкой навыков и кнопкой «Добавить ошибки в FSRS».
- [x] `screens/level_assessment_screen.dart`:
  - Интерактивный квиз с аудио, выбором вариантов, объяснениями и переходом к результату.

### Этап 4: Интеграция и верификация
- [x] Регистрация в `main.dart` (`MultiRepositoryProvider`, `MultiBlocProvider`).
- [x] Добавление баннера и карточки модуля в `HomeScreen`.
- [x] Запуск `flutter analyze` и `flutter test` (0 warnings, 82/82 tests passed).
