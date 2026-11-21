import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/assessment/domain/entities/level_quiz_question.dart';
import 'package:nexus_portuguese_app/features/sentence_builder/domain/entities/sentence_builder_result.dart';
import 'package:nexus_portuguese_app/features/sentence_builder/domain/entities/sentence_puzzle.dart';
import 'package:nexus_portuguese_app/features/sentence_builder/domain/repositories/sentence_builder_repository.dart';
import 'package:nexus_portuguese_app/features/sentence_builder/presentation/cubit/sentence_builder_cubit.dart';
import 'package:nexus_portuguese_app/features/sentence_builder/presentation/cubit/sentence_builder_state.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockSentenceBuilderRepository extends Mock implements SentenceBuilderRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}
class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  group('SentenceBuilderCubit Tests', () {
    late MockSentenceBuilderRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late MockSrsRepository mockSrs;

    const samplePuzzle1 = SentencePuzzle(
      id: 'p_1',
      targetPortuguese: 'Eu quero café.',
      russianMeaning: 'Я хочу кофе.',
      level: CefrLevel.a1,
      availableTokens: ['Eu', 'quero', 'café'],
      correctSequence: ['Eu', 'quero', 'café'],
      grammarExplanationRu: 'Querer',
    );

    const samplePuzzle2 = SentencePuzzle(
      id: 'p_2',
      targetPortuguese: 'Ela fala português.',
      russianMeaning: 'Она говорит по-португальски.',
      level: CefrLevel.a1,
      availableTokens: ['Ela', 'fala', 'português'],
      correctSequence: ['Ela', 'fala', 'português'],
      grammarExplanationRu: 'Falar',
    );

    setUp(() {
      mockRepo = MockSentenceBuilderRepository();
      mockAudio = MockHybridAudioPlaybackService();
      mockSrs = MockSrsRepository();
      registerFallbackValue(
        SrsCardEntity(
          id: 'dummy',
          portuguese: 'teste',
          russianTranslation: 'тест',
          partOfSpeech: 'phrase',
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

    test('initial state is SentenceBuilderInitial', () {
      final cubit = SentenceBuilderCubit(
        repository: mockRepo,
        audioService: mockAudio,
        srsRepository: mockSrs,
      );
      expect(cubit.state, const SentenceBuilderInitial());
    });

    blocTest<SentenceBuilderCubit, SentenceBuilderState>(
      'loadPuzzles emits [SentenceBuilderLoading, SentenceBuilderActive] on success',
      build: () {
        when(() => mockRepo.getPuzzles(
              level: any(named: 'level'),
              dialect: any(named: 'dialect'),
            )).thenAnswer((_) async => const Result.ok([samplePuzzle1, samplePuzzle2]));
        return SentenceBuilderCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.loadPuzzles(),
      expect: () => [
        const SentenceBuilderLoading(),
        isA<SentenceBuilderActive>()
            .having((s) => s.puzzles.length, 'puzzles.length', 2)
            .having((s) => s.currentIndex, 'currentIndex', 0),
      ],
    );

    blocTest<SentenceBuilderCubit, SentenceBuilderState>(
      'tapAvailableToken moves token to assembledTokens',
      build: () {
        return SentenceBuilderCubit(repository: mockRepo);
      },
      seed: () => const SentenceBuilderActive(
        puzzles: [samplePuzzle1],
        currentIndex: 0,
        availableTokens: ['Eu', 'café', 'quero'],
        assembledTokens: [],
      ),
      act: (cubit) => cubit.tapAvailableToken(0), // picks 'Eu'
      expect: () => [
        isA<SentenceBuilderActive>()
            .having((s) => s.availableTokens, 'availableTokens', ['café', 'quero'])
            .having((s) => s.assembledTokens, 'assembledTokens', ['Eu']),
      ],
    );

    blocTest<SentenceBuilderCubit, SentenceBuilderState>(
      'tapAssembledToken moves token back to availableTokens',
      build: () {
        return SentenceBuilderCubit(repository: mockRepo);
      },
      seed: () => const SentenceBuilderActive(
        puzzles: [samplePuzzle1],
        currentIndex: 0,
        availableTokens: ['café'],
        assembledTokens: ['Eu', 'quero'],
      ),
      act: (cubit) => cubit.tapAssembledToken(1), // returns 'quero'
      expect: () => [
        isA<SentenceBuilderActive>()
            .having((s) => s.assembledTokens, 'assembledTokens', ['Eu'])
            .having((s) => s.availableTokens, 'availableTokens', ['café', 'quero']),
      ],
    );

    blocTest<SentenceBuilderCubit, SentenceBuilderState>(
      'checkAnswer marks isChecked and isCorrect when user matches target',
      build: () {
        when(() => mockRepo.recordCompletion(
              puzzleId: any(named: 'puzzleId'),
              isCorrect: any(named: 'isCorrect'),
            )).thenAnswer((_) async => const Result.ok(null));
        when(() => mockAudio.playAudioOrSpeak(fallbackText: any(named: 'fallbackText')))
            .thenAnswer((_) async {});
        return SentenceBuilderCubit(
          repository: mockRepo,
          audioService: mockAudio,
        );
      },
      seed: () => const SentenceBuilderActive(
        puzzles: [samplePuzzle1],
        currentIndex: 0,
        availableTokens: [],
        assembledTokens: ['Eu', 'quero', 'café'],
      ),
      act: (cubit) => cubit.checkAnswer(),
      expect: () => [
        isA<SentenceBuilderActive>()
            .having((s) => s.isChecked, 'isChecked', true)
            .having((s) => s.isCorrect, 'isCorrect', true)
            .having((s) => s.scorePoints, 'scorePoints', 15)
            .having((s) => s.streak, 'streak', 1),
        isA<SentenceBuilderActive>()
            .having((s) => s.isPlayingAudio, 'isPlayingAudio', true),
        isA<SentenceBuilderActive>()
            .having((s) => s.isPlayingAudio, 'isPlayingAudio', false),
      ],
    );

    blocTest<SentenceBuilderCubit, SentenceBuilderState>(
      'nextPuzzle on last question emits SentenceBuilderCompleted',
      build: () {
        return SentenceBuilderCubit(repository: mockRepo);
      },
      seed: () => const SentenceBuilderActive(
        puzzles: [samplePuzzle1],
        currentIndex: 0,
        availableTokens: [],
        assembledTokens: ['Eu', 'quero', 'café'],
        isChecked: true,
        isCorrect: true,
        scorePoints: 15,
        solvedCount: 1,
      ),
      act: (cubit) => cubit.nextPuzzle(),
      expect: () => [
        isA<SentenceBuilderCompleted>()
            .having((s) => s.result.solvedCount, 'solvedCount', 1)
            .having((s) => s.result.accuracyPercentage, 'accuracyPercentage', 100.0),
      ],
    );

    blocTest<SentenceBuilderCubit, SentenceBuilderState>(
      'saveMistakesToFsrs adds mistakes to SrsRepository',
      build: () {
        when(() => mockSrs.addCard(any())).thenAnswer((_) async {});
        return SentenceBuilderCubit(
          repository: mockRepo,
          srsRepository: mockSrs,
        );
      },
      seed: () => SentenceBuilderCompleted(
        result: SentenceBuilderResult.evaluate(
          totalQuestions: 2,
          solvedCount: 1,
          scorePoints: 15,
          mistakes: const [samplePuzzle1],
        ),
      ),
      act: (cubit) => cubit.saveMistakesToFsrs(),
      expect: () => [
        isA<SentenceBuilderCompleted>().having((s) => s.isSavingToFsrs, 'isSavingToFsrs', true),
        isA<SentenceBuilderCompleted>()
            .having((s) => s.isSavingToFsrs, 'isSavingToFsrs', false)
            .having((s) => s.addedToFsrsCount, 'addedToFsrsCount', 1),
      ],
      verify: (_) {
        verify(() => mockSrs.addCard(any())).called(1);
      },
    );
  });
}
