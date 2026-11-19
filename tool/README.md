# Open-Source Portuguese Content ETL (`tool/import_open_portuguese.py`)

Утилита на чистом Python (только стандартная библиотека) для наполнения оффлайн-базы португальского приложения из открытых источников.

## Поддерживаемые источники и лицензии

1. **Tatoeba API v1** (`https://api.tatoeba.org/v1/sentences`):
   - Текстовые пары `por ↔ rus`: `CC-BY 2.0 FR`.
   - Аудио-записи носителей: фильтруются по открытым лицензиям (`CC0`, `CC-BY`).
   - Целевые форматы:
     - `srs` -> `assets/seed/srs_seed.json`
     - `listening` -> `assets/seed/listening_seed.json` (с авторасчётом `difficulty` и выделением `focus_words`)
2. **Kaikki.org / Wiktextract Portuguese** (`https://kaikki.org/dictionary/Portuguese/`):
   - Дамп Викисловаря для португальского (`CC BY-SA 4.0`): глаголы со спряжениями, части речи, примеры и русский перевод.

## Примеры запуска

```bash
# Предпросмотр фраз с Tatoeba по запросу "café"
python3 tool/import_open_portuguese.py tatoeba --query café --limit 10 --dry-run

# Добавить фразы по слову "praia" в аудирование
python3 tool/import_open_portuguese.py tatoeba --query praia --format listening --limit 15
```
