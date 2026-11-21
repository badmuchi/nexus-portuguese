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

---

## 2. Завершённая фича: VerboSprint (Скоростной тренажёр спряжения глаголов)

### Этап 1: Domain и Data слои (`lib/features/verb_trainer/`)
- [x] **Domain-сущности (`domain/entities/`):**
  - `verb_exercise.dart`: `VerbTense`, `VerbPerson`, `VerbExercise`.
  - `verb_trainer_config.dart`: `TrainerMode` (sprint60, drill15, irregularsOnly), `TenseFilter`, `VerbTrainerConfig`.
  - `verb_trainer_session_result.dart`: `VerbTrainerSessionResult` с расчетом комбо, точности и сохранением ошибок в FSRS.
- [x] **Контракт репозитория (`domain/repositories/`):**
  - `verb_trainer_repository.dart`: `generateExercises`, `recordAttempt`, `getMasteryStats`.
- [x] **Data-слой (`data/`):**
  - `datasources/verb_exercise_generator.dart`: генерация дистракторов на основе реальных форм глаголов.
  - `repositories/verb_trainer_repository_impl.dart`: работа с Drift `grammarVerbs` и `grammarPracticeLogs`.
- [x] **Unit-тесты:** `test/features/verb_trainer_test.dart` (100% pass).

### Этап 2: State Management (BLoC/Cubit)
- [x] `cubit/verb_trainer_cubit.dart` & `verb_trainer_state.dart`:
  - Таймер на 60 секунд для спринта, начисление комбо-очков, сохранение ошибок в FSRS.
- [x] **Unit-тесты:** `test/features/verb_trainer_cubit_test.dart` (100% pass).

### Этап 3: Presentation UI и декомпозиция виджетов
- [x] `widgets/verb_trainer_config_sheet.dart`: диалог выбора режима (Спринт, Дрилл, Времена).
- [x] `widgets/verb_session_summary_card.dart`: карточка итогов с разбором ошибок и 1-tap FSRS.
- [x] `screens/verb_trainer_screen.dart`: игровой экран спринта с таймером, комбо-множителем, карточкой формы и аудио.

### Этап 4: Интеграция и верификация
- [x] Добавление кнопки запуска в `GrammarScreen` (в AppBar и FloatingActionButton) и карточки на `HomeScreen`.
- [x] DI в `main.dart`.
- [x] Прогон `flutter analyze` и `flutter test` (0 warnings, 96/96 tests passed).
