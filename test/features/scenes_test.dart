import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/scenes/data/repositories/scenes_repository_impl.dart';
import 'package:nexus_portuguese_app/features/scenes/domain/entities/portuguese_life_scene.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  group('Portuguese Life Scene Domain Tests', () {
    test('SceneProgressEntity calculates correct progressPercent', () {
      final progress1 = SceneProgressEntity(
        sceneId: 'scene_cafe',
        completedChallengesCount: 2,
        totalChallengesCount: 4,
        isCompleted: false,
        lastVisitedAt: DateTime(2026, 11, 21),
      );

      expect(progress1.progressPercent, 0.5);

      final progress2 = SceneProgressEntity(
        sceneId: 'scene_cafe',
        completedChallengesCount: 4,
        totalChallengesCount: 4,
        isCompleted: true,
        lastVisitedAt: DateTime(2026, 11, 21),
      );

      expect(progress2.progressPercent, 1.0);
    });

    test('SceneWord and ScenePhrase equality check with Equatable', () {
      const word1 = SceneWord(
        id: 'w_1',
        portuguese: 'a bica',
        ipa: '[ˈbikɐ]',
        russianMeaning: 'эспрессо',
      );
      const word2 = SceneWord(
        id: 'w_1',
        portuguese: 'a bica',
        ipa: '[ˈbikɐ]',
        russianMeaning: 'эспрессо',
      );

      expect(word1, equals(word2));

      const phrase1 = ScenePhrase(
        id: 'p_1',
        role: PhraseRole.youSay,
        portuguese: 'Uma bica, se faz favor',
        russianTranslation: 'Один эспрессо, пожалуйста',
      );
      const phrase2 = ScenePhrase(
        id: 'p_1',
        role: PhraseRole.youSay,
        portuguese: 'Uma bica, se faz favor',
        russianTranslation: 'Один эспрессо, пожалуйста',
      );

      expect(phrase1, equals(phrase2));
    });
  });

  group('ScenesRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late ScenesRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      repository = ScenesRepositoryImpl(database: mockDb);
    });

    test('getScenes returns all scenes and can filter by category', () async {
      final allScenesResult = await repository.getScenes();
      expect(allScenesResult.isOk, true);
      expect(allScenesResult.value.length, 6);

      final cafeScenesResult = await repository.getScenes(category: SceneCategory.cafe);
      expect(cafeScenesResult.isOk, true);
      expect(cafeScenesResult.value.length, 1);
      expect(cafeScenesResult.value.first.id, 'scene_cafe_belem');
    });

    test('getSceneById returns correct scene', () async {
      final result = await repository.getSceneById('scene_beach_copacabana');
      expect(result.isOk, true);
      expect(result.value?.titlePt, 'Quiosque na Praia de Copacabana');
    });

    test('getAllProgress maps rows from database correctly', () async {
      final now = DateTime(2026, 11, 21);
      final row = SceneProgressRow(
        sceneId: 'scene_cafe_belem',
        completedChallengesCount: 2,
        totalChallengesCount: 2,
        isCompleted: true,
        lastVisitedAt: now,
      );

      when(() => mockDb.getAllSceneProgress()).thenAnswer((_) async => [row]);

      final result = await repository.getAllProgress();
      expect(result.isOk, true);
      expect(result.value.containsKey('scene_cafe_belem'), true);
      expect(result.value['scene_cafe_belem']?.isCompleted, true);
    });

    test('saveSceneProgress delegates to database upsert', () async {
      when(() => mockDb.upsertSceneProgress(
            sceneId: any(named: 'sceneId'),
            completedCount: any(named: 'completedCount'),
            totalCount: any(named: 'totalCount'),
            isCompleted: any(named: 'isCompleted'),
          )).thenAnswer((_) async {});

      final result = await repository.saveSceneProgress(
        sceneId: 'scene_cafe_belem',
        completedCount: 2,
        totalCount: 2,
        isCompleted: true,
      );

      expect(result.isOk, true);
      verify(() => mockDb.upsertSceneProgress(
            sceneId: 'scene_cafe_belem',
            completedCount: 2,
            totalCount: 2,
            isCompleted: true,
          )).called(1);
    });
  });
}
