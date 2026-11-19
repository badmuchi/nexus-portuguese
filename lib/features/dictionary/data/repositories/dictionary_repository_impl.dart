import 'package:drift/drift.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/dictionary/domain/entities/dictionary_entry_entity.dart';

abstract class DictionaryRepository {
  Future<List<DictionaryEntryEntity>> getAllEntries();
  Future<List<DictionaryEntryEntity>> search(String query);
  Future<void> addCustomEntry(DictionaryEntryEntity entry);
}

class DictionaryRepositoryImpl implements DictionaryRepository {
  final AppDatabase _db;

  DictionaryRepositoryImpl(this._db);

  @override
  Future<List<DictionaryEntryEntity>> getAllEntries() async {
    final rows = await _db.getAllDictionaryEntries();
    return rows.map(_mapRow).toList();
  }

  @override
  Future<List<DictionaryEntryEntity>> search(String query) async {
    if (query.trim().isEmpty) return getAllEntries();
    final rows = await _db.searchDictionary(query.trim());
    return rows.map(_mapRow).toList();
  }

  @override
  Future<void> addCustomEntry(DictionaryEntryEntity entry) async {
    await _db.insertCustomDictionaryEntry(
      DictionaryEntriesCompanion.insert(
        id: entry.id,
        word: entry.word,
        partOfSpeech: entry.partOfSpeech,
        translationRu: entry.translationRu,
        frequencyRank: Value(entry.frequencyRank),
        dialect: Value(entry.dialect),
        examplePt: Value(entry.examplePt),
        exampleRu: Value(entry.exampleRu),
        notes: Value(entry.notes),
        isCustom: const Value(true),
      ),
    );
  }

  DictionaryEntryEntity _mapRow(DictionaryEntryRow row) {
    return DictionaryEntryEntity(
      id: row.id,
      word: row.word,
      partOfSpeech: row.partOfSpeech,
      translationRu: row.translationRu,
      frequencyRank: row.frequencyRank,
      dialect: row.dialect,
      examplePt: row.examplePt,
      exampleRu: row.exampleRu,
      notes: row.notes,
      isCustom: row.isCustom,
    );
  }
}
