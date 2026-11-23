import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/folklore/data/datasources/folklore_seed_data.dart';
import 'package:nexus_portuguese_app/features/folklore/data/repositories/folklore_repository_impl.dart';
import 'package:nexus_portuguese_app/features/folklore/domain/entities/folklore_entities.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback_folk',
        portuguese: 'saci',
        russianTranslation: 'саси',
        partOfSpeech: 'substantivo',
        category: 'folclore',
        dialect: 'pt_BR',
        examplePortuguese: 'O Saci pula em uma perna só.',
        exampleRussian: 'Саси прыгает на одной ноге.',
        notes: 'Фольклорный персонаж',
        fsrsState: 'newCard',
        stability: 0,
        difficulty: 0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      ),
    );
  });

  group('Folklore Entities Tests', () {
    test('MythicalEntity dialect helpers work properly', () {
      const brMyth = MythicalEntity(
        id: 'saci',
        name: 'Saci-Pererê',
        aliasRu: 'Саси-Перере',
        origin: FolkloreOrigin.afroBrasileiro,
        region: 'Brasil (Sudeste / Centro-Oeste)',
        dialect: 'pt_BR',
        shortSummary: 'Menino travesso',
        fullLegend: 'Lenda longa do Saci...',
        magicalPowers: ['Redemoinhos'],
        moralOrMeaning: 'Cultura caipira',
        vocabulary: [],
        audioNarration: 'Narrativa de áudio',
      );

      expect(brMyth.isPtBr, isTrue);
      expect(brMyth.isPtPt, isFalse);

      const ptMyth = MythicalEntity(
        id: 'barcelos',
        name: 'O Galo de Barcelos',
        aliasRu: 'Петушок из Барселуша',
        origin: FolkloreOrigin.iberico,
        region: 'Minho, Portugal',
        dialect: 'pt_PT',
        shortSummary: 'Símbolo de justiça',
        fullLegend: 'Lenda do peregrino...',
        magicalPowers: ['Cantar após assado'],
        moralOrMeaning: 'Justiça e fé',
        vocabulary: [],
        audioNarration: 'Narrativa portuguesa',
      );

      expect(ptMyth.isPtPt, isTrue);
      expect(ptMyth.isPtBr, isFalse);
    });

    test('FolkloreVocabEntity and FolkloreTaleSnippet equality and fields', () {
      const vocab1 = FolkloreVocabEntity(
        id: 'fv1',
        termPt: 'o redemoinho',
        translationRu: 'вихрь, смерч',
        definition: 'Movimento em espiral',
        exampleSentence: 'O Saci surge num redemoinho.',
        dialect: 'all',
      );

      const vocab2 = FolkloreVocabEntity(
        id: 'fv1',
        termPt: 'o redemoinho',
        translationRu: 'вихрь, смерч',
        definition: 'Movimento em espiral',
        exampleSentence: 'O Saci surge num redemoinho.',
        dialect: 'all',
      );

      expect(vocab1, equals(vocab2));
      expect(vocab1.isPtBr, isFalse);
      expect(vocab1.isPtPt, isFalse);

      const tale = FolkloreTaleSnippet(
        id: 't1',
        title: 'O Encontro na Mata',
        characterName: 'Curupira',
        narrativePt: 'Ele protegia a mata quando um lenhador entrou.',
        translationRu: 'Он защищал лес, когда вошел дровосек.',
        grammarInsight: 'Protegia (Imperfeito) vs entrou (Perfeito).',
        icon: '🏹',
      );

      expect(tale.title, 'O Encontro na Mata');
      expect(tale.characterName, 'Curupira');
    });

    test('FolkloreQuizQuestion equality and properties', () {
      const quiz = FolkloreQuizQuestion(
        id: 'q1',
        question: 'Quem tem pés virados para trás?',
        options: ['Saci', 'Curupira', 'Boitatá'],
        correctIndex: 1,
        explanation: 'O Curupira confunde caçadores.',
        dialect: 'pt_BR',
        contextMyth: 'Curupira',
        accentEmoji: '🔥',
      );

      expect(quiz.correctIndex, 1);
      expect(quiz.options.length, 3);
      expect(quiz.contextMyth, 'Curupira');
      expect(quiz.accentEmoji, '🔥');
    });
  });

  group('FolkloreSeedData Integrity Tests', () {
    test('getMyths returns 6 full myth entities with vocabulary and powers', () {
      final myths = FolkloreSeedData.getMyths();
      expect(myths.length, 6);

      for (final myth in myths) {
        expect(myth.id, isNotEmpty);
        expect(myth.name, isNotEmpty);
        expect(myth.aliasRu, isNotEmpty);
        expect(myth.shortSummary, isNotEmpty);
        expect(myth.fullLegend, isNotEmpty);
        expect(myth.magicalPowers, isNotEmpty);
        expect(myth.moralOrMeaning, isNotEmpty);
        expect(myth.vocabulary, isNotEmpty);
        expect(myth.audioNarration, isNotEmpty);
      }

      final ids = myths.map((m) => m.id).toSet();
      expect(ids.contains('saci-perere'), isTrue);
      expect(ids.contains('curupira'), isTrue);
      expect(ids.contains('iara-mae-dagua'), isTrue);
      expect(ids.contains('boitata'), isTrue);
      expect(ids.contains('mula-sem-cabeca'), isTrue);
      expect(ids.contains('galo-de-barcelos'), isTrue);
    });

    test('getTaleSnippets returns 4 snippets with grammar insights', () {
      final snippets = FolkloreSeedData.getTaleSnippets();
      expect(snippets.length, 4);

      for (final s in snippets) {
        expect(s.id, isNotEmpty);
        expect(s.title, isNotEmpty);
        expect(s.characterName, isNotEmpty);
        expect(s.narrativePt, isNotEmpty);
        expect(s.translationRu, isNotEmpty);
        expect(s.grammarInsight, contains('Perfeito'));
      }
    });

    test('getQuizzes returns 6 questions with valid options and correct indices', () {
      final quizzes = FolkloreSeedData.getQuizzes();
      expect(quizzes.length, 6);

      for (final q in quizzes) {
        expect(q.id, isNotEmpty);
        expect(q.question, isNotEmpty);
        expect(q.options.length, greaterThanOrEqualTo(3));
        expect(q.correctIndex, greaterThanOrEqualTo(0));
        expect(q.correctIndex, lessThan(q.options.length));
        expect(q.explanation, isNotEmpty);
      }
    });
  });

  group('FolkloreRepositoryImpl Tests', () {
    late MockSrsRepository mockSrs;
    late MockAppDatabase mockDb;
    late FolkloreRepositoryImpl repository;

    setUp(() {
      mockSrs = MockSrsRepository();
      mockDb = MockAppDatabase();
      repository = FolkloreRepositoryImpl(
        database: mockDb,
        srsRepository: mockSrs,
      );

      when(() => mockDb.insertListeningAttemptLog(
            exerciseId: any(named: 'exerciseId'),
            wordAccuracy: any(named: 'wordAccuracy'),
            isExactMatch: any(named: 'isExactMatch'),
            attemptedAt: any(named: 'attemptedAt'),
          )).thenAnswer((_) async => 1);

      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});
    });

    test('getMyths returns ok Result with all myths', () async {
      final result = await repository.getMyths();
      expect(result.isOk, isTrue);
      expect(result.value.length, 6);
    });

    test('getMyths filters by dialect and origin', () async {
      final ptRes = await repository.getMyths(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      expect(ptRes.value.every((m) => m.isPtPt || m.dialect == 'all'), isTrue);

      final indRes = await repository.getMyths(origin: FolkloreOrigin.indigena);
      expect(indRes.isOk, isTrue);
      expect(indRes.value.every((m) => m.origin == FolkloreOrigin.indigena), isTrue);
    });

    test('getMythById returns myth or error', () async {
      final res = await repository.getMythById('saci-perere');
      expect(res.isOk, isTrue);
      expect(res.value.name, 'Saci-Pererê');

      final err = await repository.getMythById('inexistent');
      expect(err.isFailure, isTrue);
    });

    test('getTaleSnippets returns ok Result with snippets', () async {
      final result = await repository.getTaleSnippets();
      expect(result.isOk, isTrue);
      expect(result.value.length, 4);
    });

    test('getFolkloreQuizzes returns ok Result with quizzes', () async {
      final result = await repository.getFolkloreQuizzes();
      expect(result.isOk, isTrue);
      expect(result.value.length, 6);
    });

    test('recordMythViewed calls db.insertListeningAttemptLog', () async {
      final result = await repository.recordMythViewed('saci-perere');
      expect(result.isOk, isTrue);
      verify(() => mockDb.insertListeningAttemptLog(
            exerciseId: 'folklore-myth-saci-perere',
            wordAccuracy: 1.0,
            isExactMatch: true,
            attemptedAt: any(named: 'attemptedAt'),
          )).called(1);
    });

    test('addFolkloreVocabToSrs saves card to SRS repository', () async {
      const vocab = FolkloreVocabEntity(
        id: 'saci_carapuca',
        termPt: 'a carapuça',
        translationRu: 'красный колпак',
        definition: 'Gorro mágico vermelho',
        exampleSentence: 'O segredo da magia está na carapuça.',
        dialect: 'pt_BR',
      );

      final result = await repository.addFolkloreVocabToSrs(vocab, dialect: 'pt_BR');
      expect(result.isOk, isTrue);
      verify(() => mockSrs.addCard(any(
            that: isA<SrsCardEntity>().having(
              (c) => c.portuguese,
              'portuguese',
              'a carapuça',
            ),
          ))).called(1);
    });
  });
}
