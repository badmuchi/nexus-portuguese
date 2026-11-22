import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/auditorio/data/datasources/auditorio_seed_data.dart';
import 'package:nexus_portuguese_app/features/auditorio/data/repositories/auditorio_repository_impl.dart';
import 'package:nexus_portuguese_app/features/auditorio/domain/entities/podcast_track_entity.dart';
import 'package:nexus_portuguese_app/features/auditorio/domain/entities/transcript_snippet_entity.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  group('Auditorio Domain & Seed Tests', () {
    test('AuditorioSeedData contains 6 rich cultural podcasts', () {
      const tracks = AuditorioSeedData.tracks;
      expect(tracks.length, 6);

      for (final track in tracks) {
        expect(track.id.isNotEmpty, true);
        expect(track.titlePt.isNotEmpty, true);
        expect(track.titleRu.isNotEmpty, true);
        expect(track.transcript.isNotEmpty, true);
        expect(track.coverEmoji.isNotEmpty, true);

        for (final snippet in track.transcript) {
          expect(snippet.id.isNotEmpty, true);
          expect(snippet.textPt.isNotEmpty, true);
          expect(snippet.translationRu.isNotEmpty, true);
          expect(snippet.endTimeMs, greaterThan(snippet.startTimeMs));
        }
      }
    });

    test('PodcastTrack dialect helper properties work correctly', () {
      const ptTrack = PodcastTrack(
        id: 'pt_sample',
        titlePt: 'Lisboa',
        titleRu: 'Лиссабон',
        descriptionPt: 'Desc',
        descriptionRu: 'Опис',
        dialect: 'pt_PT',
        cefrLevel: 'A2',
        category: 'Cultura',
        durationSeconds: 120,
        coverEmoji: '🚋',
        primaryColorHex: 0xFF123456,
        accentColorHex: 0xFF654321,
        transcript: [],
      );

      expect(ptTrack.isPtPt, true);
      expect(ptTrack.isPtBr, false);
      expect(ptTrack.dialectFlag, '🇵🇹');
      expect(ptTrack.dialectLabel, 'Portugal (PT-PT)');

      const brTrack = PodcastTrack(
        id: 'br_sample',
        titlePt: 'Rio',
        titleRu: 'Рио',
        descriptionPt: 'Desc',
        descriptionRu: 'Опис',
        dialect: 'pt_BR',
        cefrLevel: 'B1',
        category: 'Música',
        durationSeconds: 125,
        coverEmoji: '🎸',
        primaryColorHex: 0xFF123456,
        accentColorHex: 0xFF654321,
        transcript: [],
      );

      expect(brTrack.isPtPt, false);
      expect(brTrack.isPtBr, true);
      expect(brTrack.dialectFlag, '🇧🇷');
      expect(brTrack.dialectLabel, 'Brasil (PT-BR)');
      expect(brTrack.formattedDuration, '2m 05s');
    });

    test('TranscriptSnippet formatted time calculation', () {
      const snippet = TranscriptSnippet(
        id: 'sn_1',
        index: 0,
        startTimeMs: 75000, // 1m 15s
        endTimeMs: 82000,
        textPt: 'Texto',
        translationRu: 'Текст',
      );

      expect(snippet.formattedStartTime, '01:15');
      expect(snippet.durationMs, 7000);
    });
  });

  group('AuditorioRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late AuditorioRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      repository = AuditorioRepositoryImpl(database: mockDb);

      when(() => mockDb.getAllListeningAttemptLogs()).thenAnswer((_) async => []);
      when(() => mockDb.insertListeningAttemptLog(
            exerciseId: any(named: 'exerciseId'),
            wordAccuracy: any(named: 'wordAccuracy'),
            isExactMatch: any(named: 'isExactMatch'),
            attemptedAt: any(named: 'attemptedAt'),
          )).thenAnswer((_) async => 1);
    });

    test('getPodcasts returns all tracks when no filters applied', () async {
      final result = await repository.getPodcasts();
      expect(result.isOk, true);
      expect(result.value.length, 6);
    });

    test('getPodcasts filters by dialect', () async {
      final ptPtResult = await repository.getPodcasts(dialect: 'pt_PT');
      expect(ptPtResult.isOk, true);
      expect(ptPtResult.value.every((t) => t.isPtPt), true);

      final ptBrResult = await repository.getPodcasts(dialect: 'pt_BR');
      expect(ptBrResult.isOk, true);
      expect(ptBrResult.value.every((t) => t.isPtBr), true);
    });

    test('getPodcasts filters by cefrLevel and category', () async {
      final a2Result = await repository.getPodcasts(cefrLevel: 'A2');
      expect(a2Result.isOk, true);
      expect(a2Result.value.every((t) => t.cefrLevel == 'A2'), true);

      final musicResult = await repository.getPodcasts(category: 'Música');
      expect(musicResult.isOk, true);
      expect(musicResult.value.length, 1);
      expect(musicResult.value.first.id, 'pod_garota_ipanema');
    });

    test('getPodcastById returns correct track', () async {
      final result = await repository.getPodcastById('pod_eletrico_28');
      expect(result.isOk, true);
      expect(result.value.titlePt, 'Elétrico 28: Pelas Colinas de Alfama');
    });

    test('recordPodcastListenProgress inserts log to DB', () async {
      final result = await repository.recordPodcastListenProgress(
        podcastId: 'pod_pasteis_belem',
        completedSnippets: 5,
        totalSnippets: 5,
      );

      expect(result.isOk, true);
      verify(() => mockDb.insertListeningAttemptLog(
            exerciseId: 'auditorio_track_pod_pasteis_belem',
            wordAccuracy: 1.0,
            isExactMatch: true,
            attemptedAt: any(named: 'attemptedAt'),
          )).called(1);
    });

    test('recordShadowingResult inserts evaluation to DB', () async {
      final result = await repository.recordShadowingResult(
        podcastId: 'pod_pasteis_belem',
        snippetId: 'pb_1',
        accuracyScore: 0.88,
        isPass: true,
      );

      expect(result.isOk, true);
      verify(() => mockDb.insertListeningAttemptLog(
            exerciseId: 'auditorio_pod_pasteis_belem_pb_1',
            wordAccuracy: 0.88,
            isExactMatch: true,
            attemptedAt: any(named: 'attemptedAt'),
          )).called(1);
    });
  });
}
