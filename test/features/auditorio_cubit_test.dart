import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/auditorio/data/datasources/auditorio_seed_data.dart';
import 'package:nexus_portuguese_app/features/auditorio/domain/repositories/auditorio_repository.dart';
import 'package:nexus_portuguese_app/features/auditorio/presentation/cubit/auditorio_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/auditorio/presentation/cubit/auditorio_catalog_state.dart';
import 'package:nexus_portuguese_app/features/auditorio/presentation/cubit/podcast_player_cubit.dart';

class MockAuditorioRepository extends Mock implements AuditorioRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('AuditorioCatalogCubit Tests', () {
    late MockAuditorioRepository mockRepo;
    late AuditorioCatalogCubit cubit;

    setUp(() {
      mockRepo = MockAuditorioRepository();
      when(() => mockRepo.getPodcasts(
            dialect: any(named: 'dialect'),
            cefrLevel: any(named: 'cefrLevel'),
            category: any(named: 'category'),
          )).thenAnswer((_) async => const Result.ok(AuditorioSeedData.tracks));

      cubit = AuditorioCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has correct default values', () {
      expect(cubit.state.status, AuditorioCatalogStatus.initial);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedCefr, 'all');
      expect(cubit.state.selectedCategory, 'all');
    });

    test('loadCatalog emits loaded state with tracks', () async {
      await cubit.loadCatalog();

      expect(cubit.state.status, AuditorioCatalogStatus.loaded);
      expect(cubit.state.allTracks.length, 6);
      expect(cubit.state.filteredTracks.length, 6);
    });

    test('filterByDialect filters tracks correctly', () async {
      await cubit.loadCatalog();

      cubit.filterByDialect('pt_PT');
      expect(cubit.state.selectedDialect, 'pt_PT');
      expect(cubit.state.filteredTracks.every((t) => t.isPtPt), true);

      cubit.filterByDialect('pt_BR');
      expect(cubit.state.selectedDialect, 'pt_BR');
      expect(cubit.state.filteredTracks.every((t) => t.isPtBr), true);
    });

    test('filterByCefr and search filter tracks correctly', () async {
      await cubit.loadCatalog();

      cubit.filterByCefr('A1');
      expect(cubit.state.filteredTracks.length, 1);
      expect(cubit.state.filteredTracks.first.id, 'pod_eletrico_28');

      cubit.filterByCefr('all');
      cubit.search('Bossa Nova');
      expect(cubit.state.filteredTracks.length, 1);
      expect(cubit.state.filteredTracks.first.id, 'pod_garota_ipanema');
    });
  });

  group('PodcastPlayerCubit Tests', () {
    late MockAuditorioRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late PodcastPlayerCubit playerCubit;
    final testTrack = AuditorioSeedData.tracks.first; // Pastéis de Belém

    setUp(() {
      mockRepo = MockAuditorioRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockAudio.playAudioOrSpeak(
            audioPathOrUrl: any(named: 'audioPathOrUrl'),
            fallbackText: any(named: 'fallbackText'),
            dialect: any(named: 'dialect'),
            rate: any(named: 'rate'),
          )).thenAnswer((_) async {});

      when(() => mockAudio.stop()).thenAnswer((_) async {});

      when(() => mockRepo.recordPodcastListenProgress(
            podcastId: any(named: 'podcastId'),
            completedSnippets: any(named: 'completedSnippets'),
            totalSnippets: any(named: 'totalSnippets'),
          )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockRepo.recordShadowingResult(
            podcastId: any(named: 'podcastId'),
            snippetId: any(named: 'snippetId'),
            accuracyScore: any(named: 'accuracyScore'),
            isPass: any(named: 'isPass'),
          )).thenAnswer((_) async => const Result.ok(null));

      playerCubit = PodcastPlayerCubit(
        track: testTrack,
        repository: mockRepo,
        audioService: mockAudio,
      );
    });

    tearDown(() {
      playerCubit.close();
    });

    test('initial state has correct track and values', () {
      expect(playerCubit.state.track.id, testTrack.id);
      expect(playerCubit.state.currentSnippetIndex, 0);
      expect(playerCubit.state.isPlaying, false);
      expect(playerCubit.state.playbackSpeed, 1.0);
      expect(playerCubit.state.showTranslation, true);
      expect(playerCubit.state.isLoopSnippet, false);
      expect(playerCubit.state.currentSnippet.id, 'pb_1');
    });

    test('play, pause and togglePlayPause update playing state and audio service', () async {
      await playerCubit.play();
      expect(playerCubit.state.isPlaying, true);
      verify(() => mockAudio.playAudioOrSpeak(
            fallbackText: any(named: 'fallbackText'),
            dialect: any(named: 'dialect'),
            rate: any(named: 'rate'),
          )).called(1);

      await playerCubit.pause();
      expect(playerCubit.state.isPlaying, false);
      verify(() => mockAudio.stop()).called(1);

      await playerCubit.togglePlayPause();
      expect(playerCubit.state.isPlaying, true);
    });

    test('seekToSnippet, nextSnippet and previousSnippet change snippet index', () async {
      await playerCubit.seekToSnippet(2, autoPlay: false);
      expect(playerCubit.state.currentSnippetIndex, 2);
      expect(playerCubit.state.currentSnippet.id, 'pb_3');

      await playerCubit.previousSnippet();
      expect(playerCubit.state.currentSnippetIndex, 1);

      await playerCubit.nextSnippet();
      expect(playerCubit.state.currentSnippetIndex, 2);
    });

    test('speed, loop and translation toggles', () async {
      await playerCubit.setPlaybackSpeed(0.75);
      expect(playerCubit.state.playbackSpeed, 0.75);

      playerCubit.toggleLoopSnippet();
      expect(playerCubit.state.isLoopSnippet, true);

      playerCubit.toggleTranslation();
      expect(playerCubit.state.showTranslation, false);
    });

    test('evaluateShadowing evaluates user speech and records result', () async {
      final targetText = playerCubit.state.currentSnippet.textPt;
      // Пользователь произносит текст в точности как в оригинале
      await playerCubit.evaluateShadowing(targetText);

      expect(playerCubit.state.shadowingResult != null, true);
      expect(playerCubit.state.shadowingResult!.isPass, true);
      expect(playerCubit.state.shadowingResult!.accuracyScore, greaterThanOrEqualTo(0.95));
      expect(playerCubit.state.shadowingResult!.wordEvaluations.isNotEmpty, true);

      verify(() => mockRepo.recordShadowingResult(
            podcastId: testTrack.id,
            snippetId: 'pb_1',
            accuracyScore: any(named: 'accuracyScore'),
            isPass: true,
          )).called(1);
    });
  });
}
