import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/literature/data/datasources/literature_seed_data.dart';
import 'package:nexus_portuguese_app/features/literature/domain/repositories/literature_repository.dart';
import 'package:nexus_portuguese_app/features/literature/presentation/cubit/literature_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/literature/presentation/cubit/literature_catalog_state.dart';
import 'package:nexus_portuguese_app/features/literature/presentation/cubit/reader_cubit.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockLiteratureRepository extends Mock implements LiteratureRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}
class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback',
        portuguese: 'teste',
        russianTranslation: 'тест',
        partOfSpeech: 'substantivo',
        category: 'geral',
        dialect: 'pt_BR',
        examplePortuguese: 'exemplo',
        exampleRussian: 'пример',
        notes: 'nota',
        fsrsState: 'newCard',
        stability: 0,
        difficulty: 0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      ),
    );
  });

  group('LiteratureCatalogCubit Tests', () {
    late MockLiteratureRepository mockRepo;
    late LiteratureCatalogCubit cubit;
    const testWorks = LiteratureSeedData.works;
    const testQuotes = LiteratureSeedData.famousQuotes;

    setUp(() {
      mockRepo = MockLiteratureRepository();
      when(() => mockRepo.getWorks()).thenAnswer((_) async => const Result.ok(testWorks));
      when(() => mockRepo.getFamousQuotes()).thenAnswer((_) async => const Result.ok(testQuotes));

      cubit = LiteratureCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty data and default index', () {
      expect(cubit.state.status, LiteratureCatalogStatus.initial);
      expect(cubit.state.allWorks, isEmpty);
      expect(cubit.state.allQuotes, isEmpty);
      expect(cubit.state.activeTabIndex, 0);
    });

    test('loadCatalog populates works and quotes', () async {
      await cubit.loadCatalog();

      expect(cubit.state.status, LiteratureCatalogStatus.loaded);
      expect(cubit.state.allWorks.length, testWorks.length);
      expect(cubit.state.allQuotes.length, testQuotes.length);
      expect(cubit.state.filteredWorks.length, testWorks.length);
      expect(cubit.state.filteredQuotes.length, testQuotes.length);
    });

    test('loadCatalog handles repository error', () async {
      when(() => mockRepo.getWorks()).thenAnswer(
        (_) async => Result.err(const DatabaseFailure('Ошибка загрузки литературы')),
      );

      await cubit.loadCatalog();

      expect(cubit.state.status, LiteratureCatalogStatus.error);
      expect(cubit.state.errorMessage, 'Ошибка загрузки литературы');
    });

    test('filterByDialect filters works and quotes', () async {
      await cubit.loadCatalog();

      cubit.filterByDialect('BR');
      expect(cubit.state.selectedDialect, 'BR');
      expect(cubit.state.filteredWorks.every((w) => w.isPtBr), isTrue);
      expect(cubit.state.filteredQuotes.every((q) => q.isPtBr), isTrue);

      cubit.filterByDialect('PT');
      expect(cubit.state.selectedDialect, 'PT');
      expect(cubit.state.filteredWorks.every((w) => w.isPtPt), isTrue);
      expect(cubit.state.filteredQuotes.every((q) => q.isPtPt), isTrue);

      cubit.filterByDialect('all');
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.filteredWorks.length, testWorks.length);
    });

    test('filterByGenre filters works by genre', () async {
      await cubit.loadCatalog();

      cubit.filterByGenre('Poesia');
      expect(cubit.state.selectedGenre, 'Poesia');
      expect(cubit.state.filteredWorks.every((w) => w.genre.toLowerCase().contains('poesia')), isTrue);

      cubit.filterByGenre(null);
      expect(cubit.state.selectedGenre, isNull);
      expect(cubit.state.filteredWorks.length, testWorks.length);
    });

    test('search filters works by title or author', () async {
      await cubit.loadCatalog();

      cubit.search('Pessoa');
      expect(cubit.state.filteredWorks.any((w) => w.authorName.contains('Pessoa')), isTrue);

      cubit.search('');
      expect(cubit.state.filteredWorks.length, testWorks.length);
    });

    test('setTab switches active tab index', () {
      cubit.setTab(1);
      expect(cubit.state.activeTabIndex, 1);
      cubit.setTab(0);
      expect(cubit.state.activeTabIndex, 0);
    });
  });

  group('ReaderCubit Tests', () {
    late MockLiteratureRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late MockSrsRepository mockSrs;
    late ReaderCubit cubit;
    final testWork = LiteratureSeedData.works.first; // Tabacaria (3 passages)

    setUp(() {
      mockRepo = MockLiteratureRepository();
      mockAudio = MockHybridAudioPlaybackService();
      mockSrs = MockSrsRepository();

      when(() => mockRepo.recordWorkRead(
        workId: any(named: 'workId'),
        passagesRead: any(named: 'passagesRead'),
      )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
        audioPathOrUrl: any(named: 'audioPathOrUrl'),
        fallbackText: any(named: 'fallbackText'),
        dialect: any(named: 'dialect'),
        rate: any(named: 'rate'),
      )).thenAnswer((_) async {});

      when(() => mockAudio.stop()).thenAnswer((_) async {});

      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});

      cubit = ReaderCubit(
        work: testWork,
        repository: mockRepo,
        audioService: mockAudio,
        srsRepository: mockSrs,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has first passage and default flags', () {
      expect(cubit.state.work.id, testWork.id);
      expect(cubit.state.currentPassageIndex, 0);
      expect(cubit.state.isFirstPassage, isTrue);
      expect(cubit.state.isPlayingAudio, isFalse);
      expect(cubit.state.showGrammarNotes, isTrue);
      expect(cubit.state.showPoeticDevice, isTrue);
    });

    test('nextPassage and previousPassage navigate through stanzas', () {
      expect(cubit.state.currentPassageIndex, 0);

      cubit.nextPassage();
      expect(cubit.state.currentPassageIndex, 1);
      expect(cubit.state.isFirstPassage, isFalse);

      cubit.previousPassage();
      expect(cubit.state.currentPassageIndex, 0);
      expect(cubit.state.isFirstPassage, isTrue);
    });

    test('goToPassage jumps to valid passage', () {
      cubit.goToPassage(2);
      expect(cubit.state.currentPassageIndex, 2);
    });

    test('toggleGrammarNotes and togglePoeticDevice invert boolean flags', () {
      cubit.toggleGrammarNotes();
      expect(cubit.state.showGrammarNotes, isFalse);

      cubit.togglePoeticDevice();
      expect(cubit.state.showPoeticDevice, isFalse);
    });

    test('reciteCurrentPassage triggers audio playback', () async {
      await cubit.reciteCurrentPassage();

      verify(() => mockAudio.playAudioOrSpeak(
        fallbackText: testWork.passages.first.audioSnippetText,
        dialect: any(named: 'dialect'),
        rate: any(named: 'rate'),
      )).called(1);
    });

    test('nextPassage on last passage marks work completed and logs progress', () {
      // Go to last passage
      cubit.goToPassage(testWork.passages.length - 1);
      expect(cubit.state.isLastPassage, isTrue);

      cubit.nextPassage();

      expect(cubit.state.isCompleted, isTrue);
      verify(() => mockRepo.recordWorkRead(
        workId: testWork.id,
        passagesRead: testWork.passages.length,
      )).called(1);
    });

    test('addWordToFsrs creates card and adds to repository', () async {
      final vocab = testWork.vocabularyCards.first;
      final success = await cubit.addWordToFsrs(vocab);

      expect(success, isTrue);
      expect(cubit.state.addedVocabularyIds.contains(vocab.id), isTrue);
      verify(() => mockSrs.addCard(any())).called(1);
    });
  });
}
