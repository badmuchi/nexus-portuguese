import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import '../logging/app_logger.dart';
import 'app_database.dart';

class DatabaseSeedService {
  final AppDatabase _db;
  final AppLogger _logger = const AppLogger('DatabaseSeedService');

  DatabaseSeedService(this._db);

  Future<void> seedIfEmpty() async {
    try {
      await Future.wait([
        _seedSrsCards(),
        _seedDialogueNodes(),
        _seedGrammarVerbs(),
        _seedListeningExercises(),
        _seedStories(),
        _seedSlang(),
        _seedDictionary(),
      ]);
      await _backfillSeedAudio();
      _logger.info('Database seeding completed successfully.');
    } catch (e, st) {
      _logger.error('Failed to seed database', e, st);
    }
  }

  Future<void> _seedSrsCards() async {
    final count = await _db.countSrsCards();
    if (count > 0) return;

    try {
      final jsonStr = await rootBundle.loadString('assets/seed/srs_seed.json');
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final companions = list.map((item) {
        final m = item as Map<String, dynamic>;
        return SrsCardsCompanion.insert(
          id: m['id'] as String,
          portuguese: m['portuguese'] as String,
          russianTranslation: m['russian_translation'] as String,
          partOfSpeech: Value(m['part_of_speech'] as String? ?? 'phrase'),
          category: Value(m['category'] as String? ?? 'general'),
          dialect: Value(m['dialect'] as String? ?? 'all'),
          examplePortuguese: Value(m['example_portuguese'] as String?),
          exampleRussian: Value(m['example_russian'] as String?),
          audioUrl: Value(m['audio_url'] as String?),
          notes: Value(m['notes'] as String?),
          fsrsState: const Value('newCard'),
          stability: const Value(0.0),
          difficulty: const Value(0.0),
          reps: const Value(0),
          lapses: const Value(0),
          dueAt: DateTime.now(),
        );
      }).toList();

      await _db.upsertSrsCards(companions);
    } catch (e) {
      _logger.warning('Error seeding SRS cards: $e');
    }
  }

  Future<void> _seedDialogueNodes() async {
    final count = await _db.countDialogueNodes();
    if (count > 0) return;

    try {
      final jsonStr = await rootBundle.loadString('assets/seed/dialogues_seed.json');
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final companions = list.map((item) {
        final m = item as Map<String, dynamic>;
        return DialogueNodesCompanion.insert(
          id: m['id'] as String,
          speakerPortuguese: m['speaker_portuguese'] as String,
          speakerRussian: m['speaker_russian'] as String,
          linePortuguese: m['line_portuguese'] as String,
          lineRussian: m['line_russian'] as String,
          audioPath: Value(m['audio_path'] as String?),
          scenarioId: m['scenario_id'] as String,
          scenarioTitle: m['scenario_title'] as String,
          scenarioCategory: m['scenario_category'] as String,
          dialect: Value(m['dialect'] as String? ?? 'all'),
          optionsJson: jsonEncode(m['options'] ?? []),
          updatedAt: DateTime.now(),
        );
      }).toList();

      await _db.upsertDialogueNodes(companions);
    } catch (e) {
      _logger.warning('Error seeding Dialogue nodes: $e');
    }
  }

  Future<void> _seedGrammarVerbs() async {
    final count = await _db.countGrammarVerbs();
    if (count > 0) return;

    try {
      final jsonStr = await rootBundle.loadString('assets/seed/grammar_verbs_seed.json');
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      final list = (root['verbs'] as List<dynamic>?) ?? [];
      final companions = list.map((item) {
        final m = item as Map<String, dynamic>;
        return GrammarVerbsCompanion.insert(
          id: m['id'] as String,
          infinitive: m['infinitive'] as String,
          regularity: m['regularity'] as String,
          conjugationGroup: m['conjugation_group'] as String,
          russianMeaning: m['russian_meaning'] as String,
          grammarNotesRu: m['grammar_notes_ru'] as String,
          differenceNote: Value(m['difference_note'] as String?),
          conjugationsJson: jsonEncode(m['conjugations'] ?? []),
        );
      }).toList();

      await _db.upsertGrammarVerbs(companions);
    } catch (e) {
      _logger.warning('Error seeding Grammar verbs: $e');
    }
  }

  Future<void> _seedListeningExercises() async {
    final count = await _db.countListeningExercises();
    if (count > 0) return;

    try {
      final jsonStr = await rootBundle.loadString('assets/seed/listening_seed.json');
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final companions = list.map((item) {
        final m = item as Map<String, dynamic>;
        return ListeningExercisesCompanion.insert(
          id: m['id'] as String,
          transcript: m['transcript'] as String,
          russianTranslation: m['russian_translation'] as String,
          audioUrl: Value(m['audio_url'] as String?),
          difficulty: Value(m['difficulty'] as String? ?? 'beginner'),
          focusWordsJson: jsonEncode(m['focus_words'] ?? []),
          dialect: Value(m['dialect'] as String? ?? 'all'),
        );
      }).toList();

      await _db.upsertListeningExercises(companions);
    } catch (e) {
      _logger.warning('Error seeding Listening exercises: $e');
    }
  }

  Future<void> _seedStories() async {
    final rows = await _db.getAllStories();
    if (rows.isNotEmpty) return;

    try {
      final jsonStr = await rootBundle.loadString('assets/seed/stories_seed.json');
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final companions = list.map((item) {
        final m = item as Map<String, dynamic>;
        return StoriesCompanion.insert(
          id: m['id'] as String,
          titlePortuguese: m['title_portuguese'] as String,
          titleRussian: m['title_russian'] as String,
          dialect: m['dialect'] as String,
          level: m['level'] as String,
          coverIcon: m['cover_icon'] as String,
          description: m['description'] as String,
          contentJson: jsonEncode(m['paragraphs'] ?? []),
        );
      }).toList();

      await _db.upsertStories(companions);
    } catch (e) {
      _logger.warning('Error seeding Stories: $e');
    }
  }

  Future<void> _seedSlang() async {
    final rows = await _db.getAllSlang();
    if (rows.isNotEmpty) return;

    try {
      final jsonStr = await rootBundle.loadString('assets/seed/slang_seed.json');
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final companions = list.map((item) {
        final m = item as Map<String, dynamic>;
        return SlangEntriesCompanion.insert(
          id: m['id'] as String,
          expression: m['expression'] as String,
          literalTranslation: m['literal_translation'] as String,
          actualMeaning: m['actual_meaning'] as String,
          dialect: m['dialect'] as String,
          originNotes: m['origin_notes'] as String,
          exampleSentence: m['example_sentence'] as String,
          exampleTranslation: m['example_translation'] as String,
        );
      }).toList();

      await _db.upsertSlang(companions);
    } catch (e) {
      _logger.warning('Error seeding Slang: $e');
    }
  }

  Future<void> _seedDictionary() async {
    final count = await _db.countDictionaryEntries();
    if (count > 0) return;

    try {
      final jsonStr = await rootBundle.loadString('assets/seed/dictionary_seed.json');
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final companions = list.map((item) {
        final m = item as Map<String, dynamic>;
        return DictionaryEntriesCompanion.insert(
          id: m['id'] as String,
          word: m['word'] as String,
          partOfSpeech: m['part_of_speech'] as String,
          translationRu: m['translation_ru'] as String,
          frequencyRank: Value((m['frequency_rank'] as num?)?.toInt() ?? 9999),
          dialect: Value(m['dialect'] as String? ?? 'all'),
          examplePt: Value(m['example_pt'] as String?),
          exampleRu: Value(m['example_ru'] as String?),
          notes: Value(m['notes'] as String?),
          isCustom: const Value(false),
        );
      }).toList();

      await _db.upsertDictionaryEntries(companions);
    } catch (e) {
      _logger.warning('Error seeding Dictionary: $e');
    }
  }

  Future<void> _backfillSeedAudio() async {
    try {
      final diagStr = await rootBundle.loadString('assets/seed/dialogues_seed.json');
      final diagList = jsonDecode(diagStr) as List<dynamic>;
      final diagMap = <String, String>{};
      for (final item in diagList) {
        final m = item as Map<String, dynamic>;
        final p = m['audio_path'] as String?;
        if (p != null && p.isNotEmpty) {
          diagMap[m['id'] as String] = p;
        }
      }

      final listStr = await rootBundle.loadString('assets/seed/listening_seed.json');
      final listList = jsonDecode(listStr) as List<dynamic>;
      final listMap = <String, String>{};
      for (final item in listList) {
        final m = item as Map<String, dynamic>;
        final p = m['audio_url'] as String?;
        if (p != null && p.isNotEmpty) {
          listMap[m['id'] as String] = p;
        }
      }

      final srsStr = await rootBundle.loadString('assets/seed/srs_seed.json');
      final srsList = jsonDecode(srsStr) as List<dynamic>;
      final srsMap = <String, String>{};
      for (final item in srsList) {
        final m = item as Map<String, dynamic>;
        final p = m['audio_url'] as String?;
        if (p != null && p.isNotEmpty) {
          srsMap[m['id'] as String] = p;
        }
      }

      await _db.backfillSeedAudio(
        dialogueAudioById: diagMap,
        listeningAudioById: listMap,
        srsAudioById: srsMap,
      );
    } catch (e) {
      _logger.warning('Error backfilling seed audio: $e');
    }
  }
}
