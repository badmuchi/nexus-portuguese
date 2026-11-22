import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/cinema/data/datasources/cinema_seed_data.dart';
import 'package:nexus_portuguese_app/features/cinema/domain/repositories/cinema_repository.dart';
import 'package:nexus_portuguese_app/features/cinema/presentation/cubit/cinema_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/cinema/presentation/cubit/cinema_catalog_state.dart';
import 'package:nexus_portuguese_app/features/cinema/presentation/cubit/scene_player_cubit.dart';

class MockCinemaRepository extends Mock implements CinemaRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('CinemaCatalogCubit Tests', () {
    late MockCinemaRepository mockRepo;
    late CinemaCatalogCubit cubit;
    const testScenes = CinemaSeedData.scenes;
    const testQuotes = CinemaSeedData.famousQuotes;

    setUp(() {
      mockRepo = MockCinemaRepository();
      when(() => mockRepo.getScenes()).thenAnswer((_) async => const Result.ok(testScenes));
      when(() => mockRepo.getFamousQuotes()).thenAnswer((_) async => const Result.ok(testQuotes));

      cubit = CinemaCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty data and is not loading', () {
      expect(cubit.state.status, CinemaCatalogStatus.initial);
      expect(cubit.state.allScenes, isEmpty);
      expect(cubit.state.allQuotes, isEmpty);
      expect(cubit.state.activeTabIndex, 0);
    });

    test('loadCatalog populates scenes and quotes', () async {
      await cubit.loadCatalog();

      expect(cubit.state.status, CinemaCatalogStatus.loaded);
      expect(cubit.state.allScenes.length, testScenes.length);
      expect(cubit.state.allQuotes.length, testQuotes.length);
    });

    test('loadCatalog handles error failure', () async {
      when(() => mockRepo.getScenes()).thenAnswer(
        (_) async => Result.err(const DatabaseFailure('Ошибка загрузки синематеки')),
      );

      await cubit.loadCatalog();

      expect(cubit.state.status, CinemaCatalogStatus.error);
      expect(cubit.state.errorMessage, 'Ошибка загрузки синематеки');
    });

    test('filterByDialect updates dialect and filters scenes', () async {
      await cubit.loadCatalog();

      cubit.filterByDialect('BR');
      expect(cubit.state.selectedDialect, 'BR');
      for (final s in cubit.state.filteredScenes) {
        expect(s.isPtBr, isTrue);
      }

      cubit.filterByDialect('PT');
      expect(cubit.state.selectedDialect, 'PT');
      for (final s in cubit.state.filteredScenes) {
        expect(s.isPtPt, isTrue);
      }
    });

    test('filterByGenre filters scenes by genre', () async {
      await cubit.loadCatalog();

      cubit.filterByGenre('Drama');
      expect(cubit.state.selectedGenre, 'Drama');
      for (final s in cubit.state.filteredScenes) {
        expect(s.genre.toLowerCase().contains('drama'), isTrue);
      }

      cubit.filterByGenre(null);
      expect(cubit.state.selectedGenre, isNull);
    });

    test('search filters scenes and quotes by query', () async {
      await cubit.loadCatalog();

      cubit.search('Deus');
      for (final s in cubit.state.filteredScenes) {
        final matches = s.movieTitlePt.toLowerCase().contains('deus') ||
            s.movieTitleRu.toLowerCase().contains('deus');
        expect(matches, isTrue);
      }

      cubit.search('');
      expect(cubit.state.filteredScenes.length, testScenes.length);
    });

    test('setTab updates activeTabIndex', () {
      cubit.setTab(1);
      expect(cubit.state.activeTabIndex, 1);
    });
  });

  group('ScenePlayerCubit Tests', () {
    late MockCinemaRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late ScenePlayerCubit cubit;
    final testScene = CinemaSeedData.scenes.first;

    setUp(() {
      mockRepo = MockCinemaRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockRepo.recordSceneCompleted(
        sceneId: any(named: 'sceneId'),
        linesPracticed: any(named: 'linesPracticed'),
      )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
        fallbackText: any(named: 'fallbackText'),
        dialect: any(named: 'dialect'),
      )).thenAnswer((_) async {});

      cubit = ScenePlayerCubit(
        scene: testScene,
        repository: mockRepo,
        audioService: mockAudio,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state starts at line 0 and is not completed', () {
      expect(cubit.state.currentLineIndex, 0);
      expect(cubit.state.isSceneCompleted, isFalse);
      expect(cubit.state.isPlaying, isFalse);
      expect(cubit.state.isDubbingMode, isFalse);
      expect(cubit.state.isAutoPlay, isFalse);
    });

    test('selectLine updates currentLineIndex', () {
      cubit.selectLine(2);
      expect(cubit.state.currentLineIndex, 2);

      // Out of bounds does nothing
      cubit.selectLine(999);
      expect(cubit.state.currentLineIndex, 2);
    });

    test('nextLine advances line and previousLine returns back', () {
      cubit.nextLine();
      expect(cubit.state.currentLineIndex, 1);
      expect(cubit.state.practicedLineIndices.contains(0), isTrue);

      cubit.previousLine();
      expect(cubit.state.currentLineIndex, 0);
    });

    test('nextLine on last line marks scene completed and records progress', () {
      final totalLines = testScene.dialogueLines.length;

      for (var i = 0; i < totalLines; i++) {
        cubit.nextLine();
      }

      expect(cubit.state.isSceneCompleted, isTrue);
      verify(() => mockRepo.recordSceneCompleted(
        sceneId: testScene.id,
        linesPracticed: any(named: 'linesPracticed'),
      )).called(1);
    });

    test('toggleDubbingMode and toggleAutoPlay change mode flags', () {
      cubit.toggleDubbingMode();
      expect(cubit.state.isDubbingMode, isTrue);

      cubit.toggleDubbingMode();
      expect(cubit.state.isDubbingMode, isFalse);

      cubit.toggleAutoPlay();
      expect(cubit.state.isAutoPlay, isTrue);

      cubit.toggleAutoPlay();
      expect(cubit.state.isAutoPlay, isFalse);
    });

    test('playCurrentLineAudio invokes audioService with line text', () {
      cubit.playCurrentLineAudio();

      final expectedDialect = testScene.isPtPt
          ? PortugueseDialect.european
          : PortugueseDialect.brazilian;

      verify(() => mockAudio.playAudioOrSpeak(
        fallbackText: testScene.dialogueLines.first.textPt,
        dialect: expectedDialect,
      )).called(1);
    });

    test('restart resets state to line 0 and not completed', () {
      cubit.nextLine();
      expect(cubit.state.currentLineIndex, 1);

      cubit.restart();
      expect(cubit.state.currentLineIndex, 0);
      expect(cubit.state.isSceneCompleted, isFalse);
    });
  });
}
