import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('DialogueNodeRow')
class DialogueNodes extends Table {
  TextColumn get id => text()();
  TextColumn get speakerPortuguese => text()();
  TextColumn get speakerRussian => text()();
  TextColumn get linePortuguese => text()();
  TextColumn get lineRussian => text()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get scenarioId => text()();
  TextColumn get scenarioTitle => text()();
  TextColumn get scenarioCategory => text()();
  TextColumn get dialect => text().withDefault(const Constant('all'))();
  TextColumn get optionsJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DialogueHistoryRow')
class DialogueHistoryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nodeId => text()();
  TextColumn get selectedOptionId => text()();
  DateTimeColumn get answeredAt => dateTime()();
}

@DataClassName('SrsCardRow')
class SrsCards extends Table {
  TextColumn get id => text()();
  TextColumn get portuguese => text()();
  TextColumn get russianTranslation => text()();
  TextColumn get partOfSpeech => text().withDefault(const Constant('phrase'))();
  TextColumn get category => text().withDefault(const Constant('general'))();
  TextColumn get dialect => text().withDefault(const Constant('all'))();
  TextColumn get examplePortuguese => text().nullable()();
  TextColumn get exampleRussian => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get fsrsState => text().withDefault(const Constant('newCard'))();
  RealColumn get stability => real().withDefault(const Constant(0.0))();
  RealColumn get difficulty => real().withDefault(const Constant(0.0))();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  DateTimeColumn get dueAt => dateTime()();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SrsReviewLogRow')
class SrsReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cardId => text()();
  IntColumn get rating => integer()();
  RealColumn get stabilityBefore => real()();
  RealColumn get stabilityAfter => real()();
  RealColumn get difficultyAfter => real()();
  IntColumn get scheduledDays => integer()();
  BoolColumn get wasTypedCheck => boolean().withDefault(const Constant(false))();
  BoolColumn get wasTypedExact => boolean().withDefault(const Constant(false))();
  DateTimeColumn get reviewedAt => dateTime()();
}

@DataClassName('GrammarVerbRow')
class GrammarVerbs extends Table {
  TextColumn get id => text()();
  TextColumn get infinitive => text()();
  TextColumn get regularity => text()();
  TextColumn get conjugationGroup => text()();
  TextColumn get russianMeaning => text()();
  TextColumn get grammarNotesRu => text()();
  TextColumn get differenceNote => text().nullable()();
  TextColumn get conjugationsJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GrammarPracticeLogRow')
class GrammarPracticeLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get verbId => text()();
  TextColumn get tense => text()();
  TextColumn get person => text()();
  BoolColumn get isCorrect => boolean()();
  DateTimeColumn get practicedAt => dateTime()();
}

@DataClassName('ListeningExerciseRow')
class ListeningExercises extends Table {
  TextColumn get id => text()();
  TextColumn get transcript => text()();
  TextColumn get russianTranslation => text()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get difficulty => text().withDefault(const Constant('beginner'))();
  TextColumn get focusWordsJson => text()();
  TextColumn get dialect => text().withDefault(const Constant('all'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ListeningAttemptLogRow')
class ListeningAttemptLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exerciseId => text()();
  RealColumn get wordAccuracy => real()();
  BoolColumn get isExactMatch => boolean()();
  DateTimeColumn get attemptedAt => dateTime()();
}

@DataClassName('DictionaryEntryRow')
class DictionaryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get word => text()();
  TextColumn get partOfSpeech => text()();
  TextColumn get translationRu => text()();
  IntColumn get frequencyRank => integer().withDefault(const Constant(9999))();
  TextColumn get dialect => text().withDefault(const Constant('all'))();
  TextColumn get examplePt => text().nullable()();
  TextColumn get exampleRu => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StoryRow')
class Stories extends Table {
  TextColumn get id => text()();
  TextColumn get titlePortuguese => text()();
  TextColumn get titleRussian => text()();
  TextColumn get dialect => text()();
  TextColumn get level => text()();
  TextColumn get coverIcon => text()();
  TextColumn get description => text()();
  TextColumn get contentJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SlangRow')
class SlangEntries extends Table {
  TextColumn get id => text()();
  TextColumn get expression => text()();
  TextColumn get literalTranslation => text()();
  TextColumn get actualMeaning => text()();
  TextColumn get dialect => text()();
  TextColumn get originNotes => text()();
  TextColumn get exampleSentence => text()();
  TextColumn get exampleTranslation => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  DialogueNodes,
  DialogueHistoryEntries,
  SrsCards,
  SrsReviewLogs,
  GrammarVerbs,
  GrammarPracticeLogs,
  ListeningExercises,
  ListeningAttemptLogs,
  DictionaryEntries,
  Stories,
  SlangEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
      : super(
          e ??
              driftDatabase(
                name: 'nexus_portuguese_app',
                native: const DriftNativeOptions(
                  shareAcrossIsolates: true,
                ),
              ),
        );

  @override
  int get schemaVersion => 1;

  // --- Dialogue queries ---
  Future<int> countDialogueNodes() async {
    final rows = await select(dialogueNodes).get();
    return rows.length;
  }

  Future<List<DialogueNodeRow>> getAllDialogueNodes() {
    return select(dialogueNodes).get();
  }

  Future<DialogueNodeRow?> getDialogueNodeById(String id) {
    return (select(dialogueNodes)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<DialogueNodeRow>> getDialogueNodesByScenario(String scenarioId) {
    return (select(dialogueNodes)..where((t) => t.scenarioId.equals(scenarioId))).get();
  }

  Future<void> upsertDialogueNodes(List<DialogueNodesCompanion> rows) {
    return batch((batch) {
      batch.insertAll(dialogueNodes, rows, mode: InsertMode.insertOrReplace);
    });
  }

  Future<int> insertDialogueHistory({
    required String nodeId,
    required String selectedOptionId,
    required DateTime answeredAt,
  }) {
    return into(dialogueHistoryEntries).insert(
      DialogueHistoryEntriesCompanion.insert(
        nodeId: nodeId,
        selectedOptionId: selectedOptionId,
        answeredAt: answeredAt,
      ),
    );
  }

  Future<List<DialogueHistoryRow>> getAllDialogueHistory() {
    return select(dialogueHistoryEntries).get();
  }

  // --- SRS queries ---
  Future<int> countSrsCards() async {
    final rows = await select(srsCards).get();
    return rows.length;
  }

  Future<List<SrsCardRow>> getAllSrsCards() {
    return select(srsCards).get();
  }

  Future<List<SrsCardRow>> getDueSrsCards(DateTime cutoff) {
    return (select(srsCards)
          ..where((t) => t.dueAt.isSmallerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm.asc(t.dueAt)]))
        .get();
  }

  Future<void> upsertSrsCards(List<SrsCardsCompanion> rows) {
    return batch((batch) {
      batch.insertAll(srsCards, rows, mode: InsertMode.insertOrIgnore);
    });
  }

  Future<void> updateSrsCardProgress(SrsCardsCompanion card) {
    return update(srsCards).replace(card);
  }

  Future<int> insertSrsReviewLog({
    required String cardId,
    required int rating,
    required double stabilityBefore,
    required double stabilityAfter,
    required double difficultyAfter,
    required int scheduledDays,
    required bool wasTypedCheck,
    required bool wasTypedExact,
    required DateTime reviewedAt,
  }) {
    return into(srsReviewLogs).insert(
      SrsReviewLogsCompanion.insert(
        cardId: cardId,
        rating: rating,
        stabilityBefore: stabilityBefore,
        stabilityAfter: stabilityAfter,
        difficultyAfter: difficultyAfter,
        scheduledDays: scheduledDays,
        wasTypedCheck: Value(wasTypedCheck),
        wasTypedExact: Value(wasTypedExact),
        reviewedAt: reviewedAt,
      ),
    );
  }

  Future<List<SrsReviewLogRow>> getAllSrsReviewLogs() {
    return select(srsReviewLogs).get();
  }

  // --- Grammar queries ---
  Future<int> countGrammarVerbs() async {
    final rows = await select(grammarVerbs).get();
    return rows.length;
  }

  Future<List<GrammarVerbRow>> getAllGrammarVerbs() {
    return select(grammarVerbs).get();
  }

  Future<GrammarVerbRow?> getGrammarVerbById(String id) {
    return (select(grammarVerbs)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsertGrammarVerbs(List<GrammarVerbsCompanion> rows) {
    return batch((batch) {
      batch.insertAll(grammarVerbs, rows, mode: InsertMode.insertOrReplace);
    });
  }

  Future<int> insertGrammarPracticeLog({
    required String verbId,
    required String tense,
    required String person,
    required bool isCorrect,
    required DateTime practicedAt,
  }) {
    return into(grammarPracticeLogs).insert(
      GrammarPracticeLogsCompanion.insert(
        verbId: verbId,
        tense: tense,
        person: person,
        isCorrect: isCorrect,
        practicedAt: practicedAt,
      ),
    );
  }

  Future<List<GrammarPracticeLogRow>> getAllGrammarPracticeLogs() {
    return select(grammarPracticeLogs).get();
  }

  // --- Listening queries ---
  Future<int> countListeningExercises() async {
    final rows = await select(listeningExercises).get();
    return rows.length;
  }

  Future<List<ListeningExerciseRow>> getAllListeningExercises() {
    return select(listeningExercises).get();
  }

  Future<void> upsertListeningExercises(List<ListeningExercisesCompanion> rows) {
    return batch((batch) {
      batch.insertAll(listeningExercises, rows, mode: InsertMode.insertOrIgnore);
    });
  }

  Future<int> insertListeningAttemptLog({
    required String exerciseId,
    required double wordAccuracy,
    required bool isExactMatch,
    required DateTime attemptedAt,
  }) {
    return into(listeningAttemptLogs).insert(
      ListeningAttemptLogsCompanion.insert(
        exerciseId: exerciseId,
        wordAccuracy: wordAccuracy,
        isExactMatch: isExactMatch,
        attemptedAt: attemptedAt,
      ),
    );
  }

  Future<List<ListeningAttemptLogRow>> getAllListeningAttemptLogs() {
    return select(listeningAttemptLogs).get();
  }

  // --- Dictionary queries ---
  Future<int> countDictionaryEntries() async {
    final rows = await select(dictionaryEntries).get();
    return rows.length;
  }

  Future<List<DictionaryEntryRow>> getAllDictionaryEntries() {
    return (select(dictionaryEntries)
          ..orderBy([
            (t) => OrderingTerm.asc(t.frequencyRank),
            (t) => OrderingTerm.asc(t.word),
          ]))
        .get();
  }

  Future<List<DictionaryEntryRow>> searchDictionary(String query) {
    final pattern = '%$query%';
    return (select(dictionaryEntries)
          ..where((t) => t.word.like(pattern) | t.translationRu.like(pattern))
          ..orderBy([(t) => OrderingTerm.asc(t.frequencyRank)]))
        .get();
  }

  Future<void> upsertDictionaryEntries(List<DictionaryEntriesCompanion> rows) {
    return batch((batch) {
      batch.insertAll(dictionaryEntries, rows, mode: InsertMode.insertOrIgnore);
    });
  }

  Future<int> insertCustomDictionaryEntry(DictionaryEntriesCompanion row) {
    return into(dictionaryEntries).insertOnConflictUpdate(row);
  }

  // --- Stories queries ---
  Future<List<StoryRow>> getAllStories() {
    return select(stories).get();
  }

  Future<void> upsertStories(List<StoriesCompanion> rows) {
    return batch((batch) {
      batch.insertAll(stories, rows, mode: InsertMode.insertOrReplace);
    });
  }

  // --- Slang queries ---
  Future<List<SlangRow>> getAllSlang() {
    return select(slangEntries).get();
  }

  Future<void> upsertSlang(List<SlangEntriesCompanion> rows) {
    return batch((batch) {
      batch.insertAll(slangEntries, rows, mode: InsertMode.insertOrReplace);
    });
  }

  /// Populates missing local audio paths on already-seeded rows without
  /// overwriting existing user progress or custom cards.
  Future<void> backfillSeedAudio({
    required Map<String, String> dialogueAudioById,
    required Map<String, String> listeningAudioById,
    required Map<String, String> srsAudioById,
  }) {
    return transaction(() async {
      for (final entry in dialogueAudioById.entries) {
        await (update(dialogueNodes)
              ..where(
                (t) =>
                    t.id.equals(entry.key) &
                    (t.audioPath.isNull() | t.audioPath.equals('')),
              ))
            .write(DialogueNodesCompanion(audioPath: Value(entry.value)));
      }
      for (final entry in listeningAudioById.entries) {
        await (update(listeningExercises)
              ..where(
                (t) =>
                    t.id.equals(entry.key) &
                    (t.audioUrl.isNull() | t.audioUrl.equals('')),
              ))
            .write(ListeningExercisesCompanion(audioUrl: Value(entry.value)));
      }
      for (final entry in srsAudioById.entries) {
        await (update(srsCards)
              ..where(
                (t) =>
                    t.id.equals(entry.key) &
                    (t.audioUrl.isNull() | t.audioUrl.equals('')),
              ))
            .write(SrsCardsCompanion(audioUrl: Value(entry.value)));
      }
    });
  }
}
