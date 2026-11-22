import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/idioms/data/datasources/idioms_seed_data.dart';
import 'package:nexus_portuguese_app/features/idioms/data/repositories/idioms_repository_impl.dart';
import 'package:nexus_portuguese_app/features/idioms/domain/entities/portuguese_idiom_entity.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  group('IdiomsSeedData & Entity Tests', () {
    test('contains 16 authentic idioms with origins and examples', () {
      const idioms = IdiomsSeedData.idioms;
      expect(idioms.length, 16);

      for (final idiom in idioms) {
        expect(idiom.id.isNotEmpty, true);
        expect(idiom.expressionPt.isNotEmpty, true);
        expect(idiom.literalTranslationRu.isNotEmpty, true);
        expect(idiom.meaningRu.isNotEmpty, true);
        expect(idiom.meaningPt.isNotEmpty, true);
        expect(idiom.originStoryRu.isNotEmpty, true);
        expect(idiom.examplePt.isNotEmpty, true);
        expect(idiom.exampleRu.isNotEmpty, true);
        expect(idiom.illustrationEmoji.isNotEmpty, true);
      }
    });

    test('PortugueseIdiom dialect helper flags work correctly', () {
      final brIdiom = IdiomsSeedData.idioms.firstWhere((i) => i.dialect == 'pt_BR');
      expect(brIdiom.isPtBr, true);
      expect(brIdiom.isPtPt, false);
      expect(brIdiom.dialectFlag, '🇧🇷');

      final ptIdiom = IdiomsSeedData.idioms.firstWhere((i) => i.dialect == 'pt_PT');
      expect(ptIdiom.isPtPt, true);
      expect(ptIdiom.isPtBr, false);
      expect(ptIdiom.dialectFlag, '🇵🇹');

      final allIdiom = IdiomsSeedData.idioms.firstWhere((i) => i.dialect == 'all');
      expect(allIdiom.dialectFlag, '🌐');
    });
  });

  group('IdiomsRepositoryImpl Tests', () {
    late MockAppDatabase mockDb;
    late IdiomsRepositoryImpl repository;

    setUp(() {
      mockDb = MockAppDatabase();
      repository = IdiomsRepositoryImpl(database: mockDb);

      when(() => mockDb.insertListeningAttemptLog(
            exerciseId: any(named: 'exerciseId'),
            wordAccuracy: any(named: 'wordAccuracy'),
            isExactMatch: any(named: 'isExactMatch'),
            attemptedAt: any(named: 'attemptedAt'),
          )).thenAnswer((_) async => 1);
    });

    test('getIdioms filters by category and dialect', () async {
      final foodResult = await repository.getIdioms(category: IdiomCategory.comida);
      expect(foodResult.isOk, true);
      expect(foodResult.value.every((i) => i.category == IdiomCategory.comida), true);

      final ptResult = await repository.getIdioms(dialect: 'pt_PT');
      expect(ptResult.isOk, true);
      expect(ptResult.value.every((i) => i.dialect == 'all' || i.dialect == 'pt_PT'), true);
    });

    test('getIdiomById returns correct entity', () async {
      final result = await repository.getIdiomById('idiom_pagar_o_pato');
      expect(result.isOk, true);
      expect(result.value.expressionPt, 'Pagar o pato');
    });

    test('getQuizChallenges generates balanced multiple-choice questions', () async {
      final result = await repository.getQuizChallenges(count: 4);
      expect(result.isOk, true);
      expect(result.value.length, 4);

      for (final challenge in result.value) {
        expect(challenge.optionsRu.length, 4);
        expect(challenge.correctIndex, inInclusiveRange(0, 3));
        expect(challenge.correctAnswer, challenge.optionsRu[challenge.correctIndex]);
      }
    });

    test('recordQuizResult inserts log into database', () async {
      final result = await repository.recordQuizResult(total: 5, correct: 5);
      expect(result.isOk, true);

      verify(() => mockDb.insertListeningAttemptLog(
            exerciseId: any(named: 'exerciseId'),
            wordAccuracy: 1.0,
            isExactMatch: true,
            attemptedAt: any(named: 'attemptedAt'),
          )).called(1);
    });
  });
}
