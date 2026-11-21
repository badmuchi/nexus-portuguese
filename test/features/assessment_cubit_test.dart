import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/assessment/data/datasources/portuguese_assessment_seed_data.dart';
import 'package:nexus_portuguese_app/features/assessment/domain/entities/level_quiz_question.dart';
import 'package:nexus_portuguese_app/features/assessment/domain/entities/level_quiz_result.dart';
import 'package:nexus_portuguese_app/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:nexus_portuguese_app/features/assessment/presentation/cubit/assessment_cubit.dart';
import 'package:nexus_portuguese_app/features/assessment/presentation/cubit/assessment_state.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockAssessmentRepository extends Mock implements AssessmentRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}
class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  group('AssessmentCubit Tests', () {
    late MockAssessmentRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late MockSrsRepository mockSrs;

    final sampleQuestions = PortugueseAssessmentSeedData.questions.take(2).toList();
    final sampleResult = LevelQuizResult(
      level: CefrLevel.b1,
      levelTitleRu: 'Intermediário (B1)',
      scorePercentage: 75.0,
      totalQuestions: 15,
      correctAnswers: 11,
      skillScores: const {SkillFocus.grammar: 80.0},
      mistakes: [sampleQuestions.first],
      recommendations: const ['Keep going!'],
      completedAt: DateTime(2026, 11, 21),
    );

    setUp(() {
      mockRepo = MockAssessmentRepository();
      mockAudio = MockHybridAudioPlaybackService();
      mockSrs = MockSrsRepository();
      registerFallbackValue(sampleResult);
      registerFallbackValue(
        SrsCardEntity(
          id: 'dummy',
          portuguese: 'teste',
          russianTranslation: 'тест',
          partOfSpeech: 'noun',
          category: 'test',
          dialect: 'all',
          fsrsState: 'newCard',
          stability: 0.0,
          difficulty: 0.0,
          reps: 0,
          lapses: 0,
          dueAt: DateTime.now(),
        ),
      );
    });

    test('initial state is AssessmentInitial', () {
      final cubit = AssessmentCubit(
        repository: mockRepo,
        audioService: mockAudio,
        srsRepository: mockSrs,
      );
      expect(cubit.state, const AssessmentInitial());
    });

    blocTest<AssessmentCubit, AssessmentState>(
      'loadAssessment emits [AssessmentLoading, AssessmentCompleted] when existing result found',
      build: () {
        when(() => mockRepo.getLatestResult()).thenAnswer((_) async => Result.ok(sampleResult));
        return AssessmentCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.loadAssessment(),
      expect: () => [
        const AssessmentLoading(),
        AssessmentCompleted(result: sampleResult),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'loadAssessment emits [AssessmentLoading, AssessmentActive] when no previous result',
      build: () {
        when(() => mockRepo.getLatestResult()).thenAnswer((_) async => const Result.ok(null));
        when(() => mockRepo.getQuestions()).thenAnswer((_) async => Result.ok(sampleQuestions));
        return AssessmentCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.loadAssessment(),
      expect: () => [
        const AssessmentLoading(),
        isA<AssessmentActive>()
            .having((s) => s.questions.length, 'questions.length', 2)
            .having((s) => s.currentIndex, 'currentIndex', 0),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'selectOption and submitAnswer update selection and submit state',
      build: () {
        return AssessmentCubit(repository: mockRepo);
      },
      seed: () => AssessmentActive(
        questions: sampleQuestions,
        currentIndex: 0,
      ),
      act: (cubit) {
        cubit.selectOption(1);
        cubit.submitAnswer();
      },
      expect: () => [
        isA<AssessmentActive>()
            .having((s) => s.selectedOptionIndex, 'selectedOptionIndex', 1)
            .having((s) => s.isSubmitted, 'isSubmitted', false),
        isA<AssessmentActive>()
            .having((s) => s.isSubmitted, 'isSubmitted', true)
            .having((s) => s.userAnswers[sampleQuestions.first.id], 'userAnswers', 1),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'nextQuestion moves to question 2 when not last',
      build: () {
        return AssessmentCubit(repository: mockRepo);
      },
      seed: () => AssessmentActive(
        questions: sampleQuestions,
        currentIndex: 0,
        selectedOptionIndex: 1,
        isSubmitted: true,
      ),
      act: (cubit) => cubit.nextQuestion(),
      expect: () => [
        isA<AssessmentActive>()
            .having((s) => s.currentIndex, 'currentIndex', 1)
            .having((s) => s.selectedOptionIndex, 'selectedOptionIndex', null)
            .having((s) => s.isSubmitted, 'isSubmitted', false),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'nextQuestion on last question evaluates, saves and emits AssessmentCompleted',
      build: () {
        when(() => mockRepo.saveResult(any())).thenAnswer((_) async => const Result.ok(null));
        return AssessmentCubit(repository: mockRepo);
      },
      seed: () => AssessmentActive(
        questions: sampleQuestions,
        currentIndex: 1,
        userAnswers: {sampleQuestions[0].id: 2, sampleQuestions[1].id: 0},
        selectedOptionIndex: 0,
        isSubmitted: true,
      ),
      act: (cubit) => cubit.nextQuestion(),
      expect: () => [
        const AssessmentLoading(),
        isA<AssessmentCompleted>()
            .having((s) => s.result.totalQuestions, 'totalQuestions', 2),
      ],
      verify: (_) {
        verify(() => mockRepo.saveResult(any())).called(1);
      },
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'saveMistakesToFsrs adds cards to SrsRepository and updates count',
      build: () {
        when(() => mockSrs.addCard(any())).thenAnswer((_) async {});
        return AssessmentCubit(repository: mockRepo, srsRepository: mockSrs);
      },
      seed: () => AssessmentCompleted(result: sampleResult),
      act: (cubit) => cubit.saveMistakesToFsrs(),
      expect: () => [
        AssessmentCompleted(result: sampleResult, isSavingToFsrs: true),
        AssessmentCompleted(result: sampleResult, isSavingToFsrs: false, addedToFsrsCount: 1),
      ],
      verify: (_) {
        verify(() => mockSrs.addCard(any())).called(1);
      },
    );
  });
}
