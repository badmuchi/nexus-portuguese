import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/duels/data/datasources/duel_questions_seed.dart';
import 'package:nexus_portuguese_app/features/duels/domain/entities/duel_question_entity.dart';
import 'package:nexus_portuguese_app/features/duels/domain/entities/duel_session_result_entity.dart';
import 'package:nexus_portuguese_app/features/duels/domain/repositories/duels_repository.dart';
import 'package:nexus_portuguese_app/features/duels/presentation/cubit/duels_cubit.dart';
import 'package:nexus_portuguese_app/features/duels/presentation/cubit/duels_state.dart';

class MockDuelsRepository extends Mock implements DuelsRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('DuelsCubit Tests', () {
    late MockDuelsRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late DuelsCubit cubit;

    final sampleQuestions = DuelQuestionsSeed.questions.take(3).toList();

    setUp(() {
      mockRepo = MockDuelsRepository();
      mockAudio = MockHybridAudioPlaybackService();

      registerFallbackValue(
        DuelSessionResultEntity.evaluate(total: 3, correct: 3, score: 300, maxStreak: 3),
      );

      when(() => mockRepo.getQuestions(
            category: any(named: 'category'),
            count: any(named: 'count'),
          )).thenAnswer((_) async => Result.ok(sampleQuestions));

      when(() => mockRepo.saveDuelResult(any())).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
            fallbackText: any(named: 'fallbackText'),
            dialect: any(named: 'dialect'),
          )).thenAnswer((_) async {});

      cubit = DuelsCubit(
        repository: mockRepo,
        audioService: mockAudio,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has correct defaults', () {
      expect(cubit.state.status, DuelsStatus.lobby);
      expect(cubit.state.questionsCount, 10);
      expect(cubit.state.questions, isEmpty);
      expect(cubit.state.score, 0);
    });

    test('setCategory and setQuestionsCount update lobby configuration', () {
      cubit.setCategory(DuelCategory.vocabulario);
      expect(cubit.state.selectedCategory, DuelCategory.vocabulario);

      cubit.setQuestionsCount(5);
      expect(cubit.state.questionsCount, 5);

      cubit.setCategory(null);
      expect(cubit.state.selectedCategory, isNull);
    });

    test('startDuel initializes session and timer', () async {
      await cubit.startDuel();

      expect(cubit.state.status, DuelsStatus.inProgress);
      expect(cubit.state.questions.length, 3);
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.currentQuestion, isNotNull);
    });

    test('selectAnswer evaluates correct choice and increases score and streak', () async {
      await cubit.startDuel();

      final current = cubit.state.currentQuestion!;
      cubit.selectAnswer(current.correctIndex);

      expect(cubit.state.status, DuelsStatus.answered);
      expect(cubit.state.isCorrect, true);
      expect(cubit.state.currentStreak, 1);
      expect(cubit.state.score, greaterThanOrEqualTo(100));

      verify(() => mockAudio.playAudioOrSpeak(
            fallbackText: current.correctAnswer,
            dialect: any(named: 'dialect'),
          )).called(1);
    });

    test('selectAnswer evaluates wrong choice and resets streak', () async {
      await cubit.startDuel();

      final current = cubit.state.currentQuestion!;
      final wrongIndex = (current.correctIndex + 1) % 4;
      cubit.selectAnswer(wrongIndex);

      expect(cubit.state.status, DuelsStatus.answered);
      expect(cubit.state.isCorrect, false);
      expect(cubit.state.currentStreak, 0);
    });

    test('nextQuestion cycles until end and finishes duel', () async {
      await cubit.startDuel();

      // Q1
      cubit.selectAnswer(cubit.state.currentQuestion!.correctIndex);
      cubit.nextQuestion();
      expect(cubit.state.currentIndex, 1);
      expect(cubit.state.status, DuelsStatus.inProgress);

      // Q2
      cubit.selectAnswer(cubit.state.currentQuestion!.correctIndex);
      cubit.nextQuestion();
      expect(cubit.state.currentIndex, 2);

      // Q3 (last question)
      cubit.selectAnswer(cubit.state.currentQuestion!.correctIndex);
      cubit.nextQuestion();

      expect(cubit.state.status, DuelsStatus.completed);
      expect(cubit.state.sessionResult, isNotNull);
      expect(cubit.state.sessionResult!.correctAnswers, 3);

      verify(() => mockRepo.saveDuelResult(any())).called(1);
    });
  });
}
