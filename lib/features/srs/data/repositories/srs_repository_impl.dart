import 'package:drift/drift.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import 'package:nexus_portuguese_app/features/srs/domain/services/fsrs_engine.dart';

abstract class SrsRepository {
  Future<List<SrsCardEntity>> getDueCards({DateTime? cutoff});
  Future<List<SrsCardEntity>> getAllCards();
  Future<void> reviewCard({
    required SrsCardEntity card,
    required SrsRating rating,
    bool wasTypedCheck = false,
    bool wasTypedExact = false,
  });
  Future<void> addCard(SrsCardEntity card);
}

class SrsRepositoryImpl implements SrsRepository {
  final AppDatabase _db;

  SrsRepositoryImpl(this._db);

  @override
  Future<List<SrsCardEntity>> getDueCards({DateTime? cutoff}) async {
    final now = cutoff ?? DateTime.now();
    final rows = await _db.getDueSrsCards(now);
    return rows.map(_mapRowToEntity).toList();
  }

  @override
  Future<List<SrsCardEntity>> getAllCards() async {
    final rows = await _db.getAllSrsCards();
    return rows.map(_mapRowToEntity).toList();
  }

  @override
  Future<void> reviewCard({
    required SrsCardEntity card,
    required SrsRating rating,
    bool wasTypedCheck = false,
    bool wasTypedExact = false,
  }) async {
    final now = DateTime.now();
    final currentState = FsrsItemState(
      stability: card.stability,
      difficulty: card.difficulty,
      reps: card.reps,
      lapses: card.lapses,
      state: card.fsrsState,
      dueAt: card.dueAt,
      scheduledDays: 1,
    );

    final nextState = FsrsEngine.review(
      currentState: currentState,
      rating: rating,
      now: now,
    );

    await _db.updateSrsCardProgress(
      SrsCardsCompanion(
        id: Value(card.id),
        portuguese: Value(card.portuguese),
        russianTranslation: Value(card.russianTranslation),
        partOfSpeech: Value(card.partOfSpeech),
        category: Value(card.category),
        dialect: Value(card.dialect),
        examplePortuguese: Value(card.examplePortuguese),
        exampleRussian: Value(card.exampleRussian),
        audioUrl: Value(card.audioUrl),
        notes: Value(card.notes),
        fsrsState: Value(nextState.state),
        stability: Value(nextState.stability),
        difficulty: Value(nextState.difficulty),
        reps: Value(nextState.reps),
        lapses: Value(nextState.lapses),
        dueAt: Value(nextState.dueAt),
        lastReviewedAt: Value(now),
      ),
    );

    await _db.insertSrsReviewLog(
      cardId: card.id,
      rating: rating.value,
      stabilityBefore: card.stability,
      stabilityAfter: nextState.stability,
      difficultyAfter: nextState.difficulty,
      scheduledDays: nextState.scheduledDays,
      wasTypedCheck: wasTypedCheck,
      wasTypedExact: wasTypedExact,
      reviewedAt: now,
    );
  }

  @override
  Future<void> addCard(SrsCardEntity card) async {
    await _db.upsertSrsCards([
      SrsCardsCompanion.insert(
        id: card.id,
        portuguese: card.portuguese,
        russianTranslation: card.russianTranslation,
        partOfSpeech: Value(card.partOfSpeech),
        category: Value(card.category),
        dialect: Value(card.dialect),
        examplePortuguese: Value(card.examplePortuguese),
        exampleRussian: Value(card.exampleRussian),
        audioUrl: Value(card.audioUrl),
        notes: Value(card.notes),
        fsrsState: Value(card.fsrsState),
        stability: Value(card.stability),
        difficulty: Value(card.difficulty),
        reps: Value(card.reps),
        lapses: Value(card.lapses),
        dueAt: card.dueAt,
        lastReviewedAt: Value(card.lastReviewedAt),
      ),
    ]);
  }

  SrsCardEntity _mapRowToEntity(SrsCardRow row) {
    return SrsCardEntity(
      id: row.id,
      portuguese: row.portuguese,
      russianTranslation: row.russianTranslation,
      partOfSpeech: row.partOfSpeech,
      category: row.category,
      dialect: row.dialect,
      examplePortuguese: row.examplePortuguese,
      exampleRussian: row.exampleRussian,
      audioUrl: row.audioUrl,
      notes: row.notes,
      fsrsState: row.fsrsState,
      stability: row.stability,
      difficulty: row.difficulty,
      reps: row.reps,
      lapses: row.lapses,
      dueAt: row.dueAt,
      lastReviewedAt: row.lastReviewedAt,
    );
  }
}
