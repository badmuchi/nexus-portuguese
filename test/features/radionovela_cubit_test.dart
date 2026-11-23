import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/radionovela/data/datasources/radio_novela_seed_data.dart';
import 'package:nexus_portuguese_app/features/radionovela/domain/repositories/radio_novela_repository.dart';
import 'package:nexus_portuguese_app/features/radionovela/presentation/cubit/radio_novela_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/radionovela/presentation/cubit/radio_novela_catalog_state.dart';
import 'package:nexus_portuguese_app/features/radionovela/presentation/cubit/radio_player_cubit.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockRadioNovelaRepository extends Mock implements RadioNovelaRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}
class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback',
        portuguese: 'teste',
        russianTranslation: 'тест',
        partOfSpeech: 'frase',
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

  group('RadioNovelaCatalogCubit Tests', () {
    late MockRadioNovelaRepository mockRepo;
    late RadioNovelaCatalogCubit cubit;
    const testDramas = RadioNovelaSeedData.dramas;

    setUp(() {
      mockRepo = MockRadioNovelaRepository();
      when(() => mockRepo.getDramas()).thenAnswer((_) async => const Result.ok(testDramas));

      cubit = RadioNovelaCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty data and is not loading', () {
      expect(cubit.state.status, RadioNovelaCatalogStatus.initial);
      expect(cubit.state.allDramas, isEmpty);
    });

    test('loadCatalog populates dramas', () async {
      await cubit.loadCatalog();

      expect(cubit.state.status, RadioNovelaCatalogStatus.loaded);
      expect(cubit.state.allDramas.length, testDramas.length);
      expect(cubit.state.filteredDramas.length, testDramas.length);
    });

    test('loadCatalog handles repository error', () async {
      when(() => mockRepo.getDramas()).thenAnswer(
        (_) async => Result.err(const DatabaseFailure('Ошибка загрузки радионовелл')),
      );

      await cubit.loadCatalog();

      expect(cubit.state.status, RadioNovelaCatalogStatus.error);
      expect(cubit.state.errorMessage, 'Ошибка загрузки радионовелл');
    });

    test('filterByDialect filters dramas by BR/PT', () async {
      await cubit.loadCatalog();

      cubit.filterByDialect('BR');
      expect(cubit.state.selectedDialect, 'BR');
      expect(cubit.state.filteredDramas.every((d) => d.isPtBr), isTrue);

      cubit.filterByDialect('PT');
      expect(cubit.state.selectedDialect, 'PT');
      expect(cubit.state.filteredDramas.every((d) => d.isPtPt), isTrue);

      cubit.filterByDialect('all');
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.filteredDramas.length, testDramas.length);
    });

    test('filterByGenre filters dramas by genre', () async {
      await cubit.loadCatalog();

      cubit.filterByGenre('Mistério');
      expect(cubit.state.selectedGenre, 'Mistério');
      expect(cubit.state.filteredDramas.every((d) => d.genre.contains('Mistério')), isTrue);

      cubit.filterByGenre(null);
      expect(cubit.state.selectedGenre, isNull);
      expect(cubit.state.filteredDramas.length, testDramas.length);
    });

    test('search filters dramas by title or setting', () async {
      await cubit.loadCatalog();

      cubit.search('Alfama');
      expect(cubit.state.filteredDramas.length, 1);
      expect(cubit.state.filteredDramas.first.id, 'misterio_alfama');

      cubit.search('');
      expect(cubit.state.filteredDramas.length, testDramas.length);
    });
  });

  group('RadioPlayerCubit Tests', () {
    late MockRadioNovelaRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late MockSrsRepository mockSrs;
    late RadioPlayerCubit cubit;
    final testDrama = RadioNovelaSeedData.dramas.first; // Alfama (1 scene, 4 lines)

    setUp(() {
      mockRepo = MockRadioNovelaRepository();
      mockAudio = MockHybridAudioPlaybackService();
      mockSrs = MockSrsRepository();

      when(() => mockRepo.recordDramaCompleted(
        dramaId: any(named: 'dramaId'),
        scenesFinished: any(named: 'scenesFinished'),
      )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
        audioPathOrUrl: any(named: 'audioPathOrUrl'),
        fallbackText: any(named: 'fallbackText'),
        dialect: any(named: 'dialect'),
        rate: any(named: 'rate'),
      )).thenAnswer((_) async {});

      when(() => mockAudio.stop()).thenAnswer((_) async {});

      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});

      cubit = RadioPlayerCubit(
        drama: testDrama,
        repository: mockRepo,
        audioService: mockAudio,
        srsRepository: mockSrs,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state starts at first line and scene 0', () {
      expect(cubit.state.drama.id, testDrama.id);
      expect(cubit.state.currentSceneIndex, 0);
      expect(cubit.state.currentLineIndex, 0);
      expect(cubit.state.isFirstLine, isTrue);
      expect(cubit.state.isPlayingAudio, isFalse);
    });

    test('nextLine and previousLine navigate through lines', () {
      cubit.nextLine();
      expect(cubit.state.currentLineIndex, 1);
      expect(cubit.state.isFirstLine, isFalse);

      cubit.previousLine();
      expect(cubit.state.currentLineIndex, 0);
      expect(cubit.state.isFirstLine, isTrue);
    });

    test('playCurrentLine triggers audio recitation', () async {
      await cubit.playCurrentLine();

      verify(() => mockAudio.playAudioOrSpeak(
        fallbackText: testDrama.scenes.first.lines.first.audioSnippetText,
        dialect: any(named: 'dialect'),
        rate: any(named: 'rate'),
      )).called(1);
    });

    test('toggles and setters update player state', () {
      cubit.toggleAutoPlay();
      expect(cubit.state.isAutoPlay, isFalse);

      cubit.setSpeechRate(0.85);
      expect(cubit.state.speechRate, 0.85);

      cubit.toggleTranslation();
      expect(cubit.state.showTranslation, isFalse);

      cubit.toggleStageDirection();
      expect(cubit.state.showStageDirection, isFalse);

      cubit.selectChoice('choice_1');
      expect(cubit.state.chosenOptionId, 'choice_1');
    });

    test('nextLine on last line completes drama and records log', () {
      for (int i = 0; i < testDrama.scenes.first.lines.length - 1; i++) {
        cubit.nextLine();
      }
      expect(cubit.state.isLastLineInScene, isTrue);

      cubit.nextLine();

      expect(cubit.state.isCompleted, isTrue);
      verify(() => mockRepo.recordDramaCompleted(
        dramaId: testDrama.id,
        scenesFinished: testDrama.scenes.length,
      )).called(1);
    });

    test('addToFsrs delegates to SrsRepository', () async {
      final line = testDrama.scenes.first.lines.first;
      final res = await cubit.addToFsrs(line);

      expect(res, isTrue);
      verify(() => mockSrs.addCard(any())).called(1);
    });
  });
}
