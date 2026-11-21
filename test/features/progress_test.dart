import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/progress/data/repositories/progress_repository_impl.dart';
import 'package:nexus_portuguese_app/features/progress/domain/entities/portuguese_badge.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  group('PortugueseBadge Tests', () {
    test('evaluateAll unlocks badges when criteria are met', () {
      final badges = PortugueseBadge.evaluateAll(
        scenesCompletedCount: 2,
        phoneticMasteryAvg: 80.0,
        cefrLevel: 'B1',
        cefrScorePercentage: 75.0,
        grammarLogsCount: 25,
        reviewsCount: 35,
        listeningLogsCount: 12,
        dialoguesCount: 15,
        currentStreak: 7,
        maxStreak: 7,
        fluencyScore: 65.0,
      );

      expect(badges.length, 12);

      final eletrico = badges.firstWhere((b) => b.id == 'badge_eletrico');
      expect(eletrico.isUnlocked, true);

      final nasal = badges.firstWhere((b) => b.id == 'badge_nasal');
      expect(nasal.isUnlocked, true);

      final sprint = badges.firstWhere((b) => b.id == 'badge_sprint');
      expect(sprint.isUnlocked, true);

      final fogo = badges.firstWhere((b) => b.id == 'badge_streak_7');
      expect(fogo.isUnlocked, true);

      final cefr = badges.firstWhere((b) => b.id == 'badge_cefr');
      expect(cefr.isUnlocked, true);
    });

    test('evaluateAll keeps badges locked when progress is insufficient', () {
      final badges = PortugueseBadge.evaluateAll(
        scenesCompletedCount: 0,
        phoneticMasteryAvg: 0.0,
        cefrLevel: null,
        cefrScorePercentage: 0.0,
        grammarLogsCount: 0,
        reviewsCount: 0,
        listeningLogsCount: 0,
        dialoguesCount: 0,
        currentStreak: 1,
        maxStreak: 1,
        fluencyScore: 0.0,
      );

      final eletrico = badges.firstWhere((b) => b.id == 'badge_eletrico');
      expect(eletrico.isUnlocked, false);

      final cefr = badges.firstWhere((b) => b.id == 'badge_cefr');
      expect(cefr.isUnlocked, false);
    });
  });

  group('ProgressRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late ProgressRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      repository = ProgressRepositoryImpl(mockDb);
    });

    test('getProgressStats aggregates data and computes fluency score and badges', () async {
      when(() => mockDb.countSrsCards()).thenAnswer((_) async => 50);
      when(() => mockDb.getAllSrsReviewLogs()).thenAnswer((_) async => []);
      when(() => mockDb.getAllDialogueHistory()).thenAnswer((_) async => []);
      when(() => mockDb.getAllGrammarPracticeLogs()).thenAnswer((_) async => []);
      when(() => mockDb.getAllListeningAttemptLogs()).thenAnswer((_) async => []);
      when(() => mockDb.getLatestAssessmentResult()).thenAnswer((_) async => null);
      when(() => mockDb.getAllPhoneticMastery()).thenAnswer((_) async => []);
      when(() => mockDb.getAllSceneProgress()).thenAnswer((_) async => []);

      final res = await repository.getProgressStats();
      expect(res.isOk, true);
      final stats = res.value;
      expect(stats.cardsCount, 50);
      expect(stats.currentStreak >= 1, true);
      expect(stats.badges.length, 12);
    });
  });
}
