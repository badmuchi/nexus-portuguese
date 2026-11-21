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

## 2. Завершённая фича: Construtor de Frases (Конструктор предложений и синтаксиса)

### Этап 1: Domain и Data слои (`lib/features/sentence_builder/`)
- [x] **Domain-сущности (`domain/entities/`):**
  - `sentence_puzzle.dart`: `SentencePuzzle` (португальская цель, русский перевод, канонический порядок токенов, перемешанные чипы + дистракторы, грамматическая подсказка, уровень CEFR, диалект).
  - `sentence_builder_result.dart`: результат сессии с оценкой точности и списком ошибок.
- [x] **Контракт репозитория (`domain/repositories/`):**
  - `sentence_builder_repository.dart`: получение пазлов по уровню/диалекту и запись попыток.
- [x] **Data-слой (`data/`):**
  - `datasources/portuguese_sentence_seed_data.dart`: 20 калиброванных предложений A1-B1 со слияниями, crase, местоимениями и диалектными вариациями.
  - `repositories/sentence_builder_repository_impl.dart`.
- [x] **Unit-тесты:** `test/features/sentence_builder_test.dart` (100% pass).

### Этап 2: State Management (BLoC/Cubit)
- [x] `cubit/sentence_builder_cubit.dart` & `sentence_builder_state.dart`:
  - Добавление/возврат слов между банком чипов и строкой предложения.
  - Проверка правильности порядка слов и пунктуации.
  - Озвучка фразы и интеграция с FSRS и Sentence X-Ray.
- [x] **Unit-тесты:** `test/features/sentence_builder_cubit_test.dart` (100% pass).

### Этап 3: Presentation UI и декомпозиция виджетов
- [x] `screens/sentence_builder_screen.dart`: интерактивный экран сборки с анимацией чипов, подсказками и рентгеном фразы.
- [x] Декомпозиция по плейбуку на приватные `StatelessWidget`.

### Этап 4: Интеграция и верификация
- [x] Карточка модуля в каталоге на `HomeScreen`.
- [x] DI в `main.dart`.
- [x] Прогон `flutter analyze` и `flutter test` (0 warnings, 110/110 tests passed).
