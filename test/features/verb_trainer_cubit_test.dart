import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/domain/entities/verb_exercise.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/domain/entities/verb_trainer_config.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/domain/entities/verb_trainer_session_result.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/domain/repositories/verb_trainer_repository.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/presentation/cubit/verb_trainer_cubit.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/presentation/cubit/verb_trainer_state.dart';

class MockVerbTrainerRepository extends Mock implements VerbTrainerRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}
class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  group('VerbTrainerCubit Tests', () {
    late MockVerbTrainerRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late MockSrsRepository mockSrs;

    const sampleExercise1 = VerbExercise(
      id: 'ex_1',
      verbId: 'verb_fazer',
      infinitive: 'fazer',
      russianMeaning: 'делать',
      isIrregular: true,
      tense: VerbTense.preteritoPerfeito,
      person: VerbPerson.eu,
      correctForm: 'fiz',
      options: ['fiz', 'faço', 'fazia', 'fizer'],
      explanationRu: 'Eu fiz',
      audioPhrase: 'Eu fiz',
    );

    const sampleExercise2 = VerbExercise(
      id: 'ex_2',
      verbId: 'verb_ir',
      infinitive: 'ir',
      russianMeaning: 'идти',
      isIrregular: true,
      tense: VerbTense.presenteIndicativo,
      person: VerbPerson.eu,
      correctForm: 'vou',
      options: ['vou', 'vais', 'vai', 'fui'],
      explanationRu: 'Eu vou',
      audioPhrase: 'Eu vou',
    );

    setUp(() {
      mockRepo = MockVerbTrainerRepository();
      mockAudio = MockHybridAudioPlaybackService();
      mockSrs = MockSrsRepository();
      registerFallbackValue(const VerbTrainerConfig());
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

    test('initial state is VerbTrainerInitial', () {
      final cubit = VerbTrainerCubit(
        repository: mockRepo,
        audioService: mockAudio,
        srsRepository: mockSrs,
      );
      expect(cubit.state, const VerbTrainerInitial());
      cubit.close();
    });

    blocTest<VerbTrainerCubit, VerbTrainerState>(
      'startSession emits [VerbTrainerLoading, VerbTrainerActive] on success',
      build: () {
        when(() => mockRepo.generateExercises(
              config: any(named: 'config'),
              count: any(named: 'count'),
            )).thenAnswer((_) async => const Result.ok([sampleExercise1, sampleExercise2]));
        return VerbTrainerCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.startSession(const VerbTrainerConfig(mode: TrainerMode.drill15)),
      expect: () => [
        const VerbTrainerLoading(),
        isA<VerbTrainerActive>()
            .having((s) => s.exercises.length, 'exercises.length', 2)
            .having((s) => s.currentIndex, 'currentIndex', 0),
      ],
    );

    blocTest<VerbTrainerCubit, VerbTrainerState>(
      'selectOption with correct answer updates score and streak',
      build: () {
        when(() => mockRepo.recordAttempt(
              verbId: any(named: 'verbId'),
              tense: any(named: 'tense'),
              person: any(named: 'person'),
              isCorrect: any(named: 'isCorrect'),
            )).thenAnswer((_) async => const Result.ok(null));
        when(() => mockAudio.playAudioOrSpeak(fallbackText: any(named: 'fallbackText')))
            .thenAnswer((_) async {});
        return VerbTrainerCubit(
          repository: mockRepo,
          audioService: mockAudio,
        );
      },
      seed: () => const VerbTrainerActive(
        exercises: [sampleExercise1],
        currentIndex: 0,
        config: VerbTrainerConfig(mode: TrainerMode.drill15),
      ),
      act: (cubit) => cubit.selectOption('fiz'),
      expect: () => [
        isA<VerbTrainerActive>()
            .having((s) => s.isChecked, 'isChecked', true)
            .having((s) => s.selectedOption, 'selectedOption', 'fiz')
            .having((s) => s.correctCount, 'correctCount', 1)
            .having((s) => s.currentStreak, 'currentStreak', 1)
            .having((s) => s.scorePoints, 'scorePoints', 10),
      ],
      verify: (_) {
        verify(() => mockRepo.recordAttempt(
              verbId: 'verb_fazer',
              tense: 'preterito_perfeito',
              person: 'eu',
              isCorrect: true,
            )).called(1);
      },
    );

    blocTest<VerbTrainerCubit, VerbTrainerState>(
      'nextExercise moves to next question and clears selectedOption',
      build: () {
        return VerbTrainerCubit(repository: mockRepo);
      },
      seed: () => const VerbTrainerActive(
        exercises: [sampleExercise1, sampleExercise2],
        currentIndex: 0,
        selectedOption: 'fiz',
        isChecked: true,
        config: VerbTrainerConfig(mode: TrainerMode.drill15),
      ),
      act: (cubit) => cubit.nextExercise(),
      expect: () => [
        isA<VerbTrainerActive>()
            .having((s) => s.currentIndex, 'currentIndex', 1)
            .having((s) => s.selectedOption, 'selectedOption', isNull)
            .having((s) => s.isChecked, 'isChecked', false),
      ],
    );

    blocTest<VerbTrainerCubit, VerbTrainerState>(
      'finishSession emits VerbTrainerCompleted with evaluated result',
      build: () {
        return VerbTrainerCubit(repository: mockRepo);
      },
      seed: () => const VerbTrainerActive(
        exercises: [sampleExercise1],
        currentIndex: 0,
        scorePoints: 20,
        maxStreak: 2,
        correctCount: 2,
        totalAttempts: 2,
        config: VerbTrainerConfig(mode: TrainerMode.drill15),
      ),
      act: (cubit) => cubit.finishSession(),
      expect: () => [
        isA<VerbTrainerCompleted>()
            .having((s) => s.result.scorePoints, 'scorePoints', 20)
            .having((s) => s.result.accuracyPercentage, 'accuracyPercentage', 100.0),
      ],
    );

    blocTest<VerbTrainerCubit, VerbTrainerState>(
      'saveMistakesToFsrs adds cards to SrsRepository',
      build: () {
        when(() => mockSrs.addCard(any())).thenAnswer((_) async {});
        return VerbTrainerCubit(repository: mockRepo, srsRepository: mockSrs);
      },
      seed: () => VerbTrainerCompleted(
        result: VerbTrainerSessionResult.evaluate(
          totalAttempts: 2,
          correctCount: 1,
          maxStreak: 1,
          scorePoints: 10,
          mistakes: [sampleExercise1],
          mode: TrainerMode.drill15,
        ),
      ),
      act: (cubit) => cubit.saveMistakesToFsrs(),
      expect: () => [
        isA<VerbTrainerCompleted>().having((s) => s.isSavingToFsrs, 'isSavingToFsrs', true),
        isA<VerbTrainerCompleted>()
            .having((s) => s.isSavingToFsrs, 'isSavingToFsrs', false)
            .having((s) => s.addedToFsrsCount, 'addedToFsrsCount', 1),
      ],
      verify: (_) {
        verify(() => mockSrs.addCard(any())).called(1);
      },
    );
  });
}
