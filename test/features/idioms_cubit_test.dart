import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/idioms/data/datasources/idioms_seed_data.dart';
import 'package:nexus_portuguese_app/features/idioms/domain/entities/idiom_quiz_challenge_entity.dart';
import 'package:nexus_portuguese_app/features/idioms/domain/entities/portuguese_idiom_entity.dart';
import 'package:nexus_portuguese_app/features/idioms/domain/repositories/idioms_repository.dart';
import 'package:nexus_portuguese_app/features/idioms/presentation/cubit/idioms_cubit.dart';
import 'package:nexus_portuguese_app/features/idioms/presentation/cubit/idioms_state.dart';

class MockIdiomsRepository extends Mock implements IdiomsRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('IdiomsCubit Tests', () {
    late MockIdiomsRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late IdiomsCubit cubit;

    final sampleIdioms = IdiomsSeedData.idioms.take(4).toList();
    final sampleChallenge = IdiomQuizChallenge(
      id: 'ch_1',
      idiom: sampleIdioms.first,
      questionRu: 'Вопрос?',
      optionsRu: ['Вариант 1', 'Вариант 2', 'Вариант 3', 'Вариант 4'],
      correctIndex: 0,
    );

    setUp(() {
      mockRepo = MockIdiomsRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockRepo.getIdioms(
            category: any(named: 'category'),
            dialect: any(named: 'dialect'),
          )).thenAnswer((_) async => Result.ok(sampleIdioms));

      when(() => mockRepo.getQuizChallenges(count: any(named: 'count')))
          .thenAnswer((_) async => Result.ok([sampleChallenge]));

      when(() => mockRepo.recordQuizResult(
            total: any(named: 'total'),
            correct: any(named: 'correct'),
          )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
            fallbackText: any(named: 'fallbackText'),
            dialect: any(named: 'dialect'),
          )).thenAnswer((_) async {});

      cubit = IdiomsCubit(
        repository: mockRepo,
        audioService: mockAudio,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has correct defaults', () {
      expect(cubit.state.status, IdiomsStatus.initial);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedCategory, isNull);
    });

    test('loadCatalog populates idioms list', () async {
      await cubit.loadCatalog();

      expect(cubit.state.status, IdiomsStatus.loaded);
      expect(cubit.state.allIdioms.length, 4);
      expect(cubit.state.filteredIdioms.length, 4);
    });

    test('filterByCategory and search filter idioms correctly', () async {
      await cubit.loadCatalog();

      cubit.filterByCategory(IdiomCategory.animais);
      expect(cubit.state.selectedCategory, IdiomCategory.animais);

      cubit.filterByCategory(null);
      expect(cubit.state.selectedCategory, isNull);

      cubit.search('pato');
      expect(cubit.state.filteredIdioms.length, 1);
      expect(cubit.state.filteredIdioms.first.expressionPt, 'Pagar o pato');
    });

    test('quiz workflow: start, answer, and finish', () async {
      await cubit.startQuiz();

      expect(cubit.state.status, IdiomsStatus.quizActive);
      expect(cubit.state.quizChallenges.length, 1);

      cubit.answerQuiz(0); // правильный ответ
      expect(cubit.state.selectedQuizAnswerIndex, 0);
      expect(cubit.state.quizCorrectAnswers, 1);

      verify(() => mockAudio.playAudioOrSpeak(
            fallbackText: sampleIdioms.first.expressionPt,
            dialect: any(named: 'dialect'),
          )).called(1);

      await cubit.nextQuizQuestion();
      expect(cubit.state.status, IdiomsStatus.quizFinished);

      verify(() => mockRepo.recordQuizResult(total: 1, correct: 1)).called(1);
    });
  });
}
