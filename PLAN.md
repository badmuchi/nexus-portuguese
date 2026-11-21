# План разработки: Интерактивный тренажёр фонетики и носовых гласных (Portuguese App)

## Описание фичи
Интерактивный тренажёр фонетики, носовых дифтонгов (`-ão`, `-ãe`, `-am`) и закрытых/открытых гласных (`é/ê`, `ó/ô`) с распознаванием минимальных пар на слух, акустической оценкой произношения в микрофон и сопоставлением диалектов PT-BR vs PT-PT. Разработка ведётся строго по стандарту [`flutter-clean-arch-playbook`](file:///Users/badmuchi/.gemini/config/skills/flutter-clean-arch-playbook/SKILL.md) и правилам архитектуры [`AGENTS.md`](file:///Users/badmuchi/Downloads/Portuguese/AGENTS.md).

---

## Этапы реализации

### Этап 1: Domain и Data слои (Архитектурный фундамент)
- [x] **Domain-сущности (`lib/features/phonetics/domain/entities/`):**
  - `MinimalPairItem` (иммутабельный, `Equatable`, `const` конструкторы, `wordA`, `ipaA`, `meaningARu`, `wordB`, `ipaB`, `meaningBRu`, `distinctionNote`).
  - `DialectComparison` (иммутабельный, `word`, `meaningRu`, `noteBr`, `notePt`).
  - `PhoneticExercise` (звук, IPA, анатомические подсказки PT/RU, список минимальных пар, диалектный контраст).
  - `PhoneticMastery` (метрика освоения звука, расчёт процента точности слуха и речи).
- [x] **Контракт репозитория (`lib/features/phonetics/domain/repositories/`):**
  - `PhoneticsRepository` с типизированным возвратом `Future<Result<T>>` без утечки исключений.
- [x] **Схема локальной БД Drift (`lib/core/database/`):**
  - Таблица `PhoneticMasteryEntries` (`soundId`, `soundCategory`, `title`, `masteryScore`, `earAttempts`, `earCorrect`, `mouthAttempts`, `mouthScoreSum`, `lastPracticedAt`).
  - Миграция БД (схема v2).
  - DAO-методы обновления прогресса с взвешенным расчётом мастерства (50% слух, 50% микрофон).
- [x] **Сид-данные (`assets/seed/phonetics_trainer_seed.json`):**
  - 6 фундаментальных категорий (`nasal_ao`, `nasal_ae`, `open_closed_o`, `open_closed_e`, `consonant_r_rr`, `dialect_contrast_s`).
  - Регистрация в `pubspec.yaml`.
- [x] **Data-репозиторий (`lib/features/phonetics/data/repositories/`):**
  - `PhoneticsRepositoryImpl` с кэшированием в памяти и сохранением попыток в Drift.
- [x] **Unit-тесты Data & Domain (`test/features/phonetics_test.dart`):**
  - Тестирование десериализации, сериализации и математики точности мастерства.

---

### Этап 2: State Management & BLoC/Cubit
- [x] **Cubit & State (`lib/features/phonetics/presentation/cubit/`):**
  - `PhoneticsTrainerState` с `Equatable` и полями `step` (`theory`, `ear`, `mouth`, `dialect`), `masteryMap`, `earSelectedWord`, `mouthScore`.
  - `PhoneticsTrainerCubit` с подпиской на поток распознавания речи, гибридным воспроизведением и обновлением БД.
- [x] **BLoC Unit тесты (`test/features/phonetics_trainer_cubit_test.dart`):**
  - Написание тестов на базе `bloc_test` и `mocktail` для проверки состояний выбора пар, слухового ответа и начисления мастерства (8 тестов, 100% pass).

---

### Этап 3: Presentation UI и декомпозиция виджетов
- [x] **Экран тренажера (`lib/features/phonetics/presentation/screens/phonetics_trainer_screen.dart`):**
  - Чип-карусель выбора фонем с индикатором процента освоения.
  - Карточка прогресса с градиентным прогресс-баром.
  - Сегментированный переключатель 4 режимов.
- [x] **Рефакторинг на выделенные виджеты:**
  - Декомпозиция helper-методов `_build*Step` в отдельные приватные `StatelessWidget` классы по плейбуку:
    - `_TheorySection`
    - `_EarSection`
    - `_MouthSection`
    - `_DialectSection`
    - `_ChoiceCard`
    - `_SoundChipsSelector`
    - `_MasteryHeaderCard`
    - `_StepSegmentedBar`

---

### Этап 4: Интеграция, навигация и верификация
- [x] Интеграция с `PhoneticsScreen` (баннер и кнопка запуска тренажёра).
- [x] DI в `main.dart` через `RepositoryProvider` и `BlocProvider`.
- [x] Запуск `flutter analyze` и подтверждение чистоты (0 issues found!).
- [x] Запуск `flutter test` и подтверждение 100% прохождения тестов (55/55 тестов passed).
- [x] Проверка готовности Web-бандла с WASM SQLite и веб-воркером.
