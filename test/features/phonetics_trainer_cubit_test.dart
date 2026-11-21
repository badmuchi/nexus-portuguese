import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/core/speech/speech_recognition_service.dart';
import 'package:nexus_portuguese_app/features/phonetics/domain/entities/phonetic_trainer_models.dart';
import 'package:nexus_portuguese_app/features/phonetics/domain/repositories/phonetics_repository.dart';
import 'package:nexus_portuguese_app/features/phonetics/presentation/cubit/phonetics_trainer_cubit.dart';
import 'package:nexus_portuguese_app/features/phonetics/presentation/cubit/phonetics_trainer_state.dart';

class MockPhoneticsRepository extends Mock implements PhoneticsRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}
class MockSpeechRecognitionService extends Mock implements SpeechRecognitionService {}

void main() {
  late MockPhoneticsRepository mockRepository;
  late MockHybridAudioPlaybackService mockAudioService;
  late MockSpeechRecognitionService mockSpeechService;
  late StreamController<String> textStreamController;

  const sampleExercise1 = PhoneticExercise(
    soundId: 'nasal_ao',
    soundCategory: 'nasal_vowels',
    title: 'Носовой -ÃO',
    ipa: '[ɐ̃w̃]',
    tipPt: 'O ar sai pelo nariz.',
    tipRu: 'Воздух через нос.',
    contrastPairs: [
      MinimalPairItem(
        wordA: 'pão',
        ipaA: '[ˈpɐ̃w̃]',
        meaningARu: 'хлеб',
        wordB: 'pau',
        ipaB: '[ˈpaw]',
        meaningBRu: 'палка',
        distinctionNote: 'Носовой резонанс против чистого гласного',
      ),
      MinimalPairItem(
        wordA: 'mão',
        ipaA: '[ˈmɐ̃w̃]',
        meaningARu: 'рука',
        wordB: 'mau',
        ipaB: '[ˈmaw]',
        meaningBRu: 'плохой',
        distinctionNote: 'Вибрация в носовой полости',
      ),
    ],
    dialectComparison: DialectComparison(
      word: 'coração',
      meaningRu: 'сердце',
      noteBr: 'В Бразилии открыто',
      notePt: 'В Португалии редуцировано',
    ),
  );

  const sampleExercise2 = PhoneticExercise(
    soundId: 'open_closed_o',
    soundCategory: 'open_closed_vowels',
    title: 'Открытый Ó vs Закрытый Ô',
    ipa: '[ɔ] vs [o]',
    tipPt: 'Abertura ampla vs fechada.',
    tipRu: 'Широкий открытый против узкого закрытого.',
    contrastPairs: [
      MinimalPairItem(
        wordA: 'avó',
        ipaA: '[aˈvɔ]',
        meaningARu: 'бабушка',
        wordB: 'avô',
        ipaB: '[aˈvo]',
        meaningBRu: 'дедушка',
        distinctionNote: 'Открытый О vs закрытый О',
      ),
    ],
    dialectComparison: DialectComparison(
      word: 'avó',
      meaningRu: 'бабушка',
      noteBr: 'Открыто',
      notePt: 'Редукция',
    ),
  );

  const sampleMastery = PhoneticMastery(
    soundId: 'nasal_ao',
    soundCategory: 'nasal_vowels',
    title: 'Носовой -ÃO',
    masteryScore: 75.0,
    earAttempts: 4,
    earCorrect: 3,
    mouthAttempts: 1,
    mouthScoreSum: 80.0,
  );

  setUp(() {
    mockRepository = MockPhoneticsRepository();
    mockAudioService = MockHybridAudioPlaybackService();
    mockSpeechService = MockSpeechRecognitionService();
    textStreamController = StreamController<String>.broadcast();

    when(() => mockSpeechService.textStream).thenAnswer((_) => textStreamController.stream);
    when(() => mockAudioService.playAudioOrSpeak(
          fallbackText: any(named: 'fallbackText'),
          dialect: any(named: 'dialect'),
        )).thenAnswer((_) async {});
  });

  tearDown(() {
    textStreamController.close();
  });

  group('PhoneticsTrainerCubit Tests', () {
    test('initial state has correct default values', () {
      final cubit = PhoneticsTrainerCubit(
        repository: mockRepository,
        audioService: mockAudioService,
        speechService: mockSpeechService,
      );

      expect(cubit.state.isLoading, false);
      expect(cubit.state.exercises, isEmpty);
      expect(cubit.state.step, TrainerStep.theory);
      expect(cubit.state.currentExerciseIndex, 0);
      expect(cubit.state.currentPairIndex, 0);
      expect(cubit.state.errorMessage, isNull);
      cubit.close();
    });

    blocTest<PhoneticsTrainerCubit, PhoneticsTrainerState>(
      'loadTrainer emits loaded state with exercises and mastery on success',
      build: () {
        when(() => mockRepository.getTrainerExercises())
            .thenAnswer((_) async => const Result.ok([sampleExercise1, sampleExercise2]));
        when(() => mockRepository.getMasteryList())
            .thenAnswer((_) async => const Result.ok([sampleMastery]));
        return PhoneticsTrainerCubit(
          repository: mockRepository,
          audioService: mockAudioService,
          speechService: mockSpeechService,
        );
      },
      act: (cubit) => cubit.loadTrainer(),
      expect: () => [
        predicate<PhoneticsTrainerState>((s) => s.isLoading == true && s.errorMessage == null),
        predicate<PhoneticsTrainerState>((s) {
          return s.isLoading == false &&
              s.exercises.length == 2 &&
              s.masteryMap.containsKey('nasal_ao') &&
              s.currentExerciseIndex == 0 &&
              s.step == TrainerStep.theory;
        }),
      ],
      verify: (_) {
        verify(() => mockRepository.getTrainerExercises()).called(1);
        verify(() => mockRepository.getMasteryList()).called(1);
      },
    );

    blocTest<PhoneticsTrainerCubit, PhoneticsTrainerState>(
      'loadTrainer emits error message when repository fails',
      build: () {
        when(() => mockRepository.getTrainerExercises())
            .thenAnswer((_) async => Result.err(const DatabaseFailure('Disk error')));
        when(() => mockRepository.getMasteryList())
            .thenAnswer((_) async => const Result.ok([]));
        return PhoneticsTrainerCubit(
          repository: mockRepository,
          audioService: mockAudioService,
          speechService: mockSpeechService,
        );
      },
      act: (cubit) => cubit.loadTrainer(),
      expect: () => [
        predicate<PhoneticsTrainerState>((s) => s.isLoading == true),
        predicate<PhoneticsTrainerState>((s) =>
            s.isLoading == false && s.errorMessage == 'Disk error' && s.exercises.isEmpty),
      ],
    );

    blocTest<PhoneticsTrainerCubit, PhoneticsTrainerState>(
      'selectExercise updates index and resets pair/step',
      build: () => PhoneticsTrainerCubit(
        repository: mockRepository,
        audioService: mockAudioService,
        speechService: mockSpeechService,
      ),
      seed: () => const PhoneticsTrainerState(
        exercises: [sampleExercise1, sampleExercise2],
        currentExerciseIndex: 0,
        currentPairIndex: 1,
        step: TrainerStep.ear,
      ),
      act: (cubit) => cubit.selectExercise(1),
      expect: () => [
        predicate<PhoneticsTrainerState>((s) =>
            s.currentExerciseIndex == 1 &&
            s.currentPairIndex == 0 &&
            s.step == TrainerStep.theory &&
            s.earSelectedWord == null &&
            s.mouthScore == null),
      ],
    );

    blocTest<PhoneticsTrainerCubit, PhoneticsTrainerState>(
      'setStep updates trainer step and clears selections',
      build: () => PhoneticsTrainerCubit(
        repository: mockRepository,
        audioService: mockAudioService,
        speechService: mockSpeechService,
      ),
      seed: () => const PhoneticsTrainerState(
        step: TrainerStep.theory,
        earSelectedWord: 'pão',
      ),
      act: (cubit) => cubit.setStep(TrainerStep.ear),
      expect: () => [
        predicate<PhoneticsTrainerState>((s) =>
            s.step == TrainerStep.ear && s.earSelectedWord == null && s.mouthScore == null),
      ],
    );

    blocTest<PhoneticsTrainerCubit, PhoneticsTrainerState>(
      'nextPair cycles to next pair in current exercise',
      build: () => PhoneticsTrainerCubit(
        repository: mockRepository,
        audioService: mockAudioService,
        speechService: mockSpeechService,
      ),
      seed: () => const PhoneticsTrainerState(
        exercises: [sampleExercise1],
        currentExerciseIndex: 0,
        currentPairIndex: 0,
      ),
      act: (cubit) => cubit.nextPair(),
      expect: () => [
        predicate<PhoneticsTrainerState>((s) => s.currentPairIndex == 1),
      ],
    );

    blocTest<PhoneticsTrainerCubit, PhoneticsTrainerState>(
      'answerEarChoice records answer and updates mastery',
      build: () {
        when(() => mockRepository.recordEarAnswer(
              soundId: any(named: 'soundId'),
              isCorrect: any(named: 'isCorrect'),
              soundCategory: any(named: 'soundCategory'),
              title: any(named: 'title'),
            )).thenAnswer((_) async => const Result.ok(null));
        when(() => mockRepository.getMasteryList())
            .thenAnswer((_) async => const Result.ok([sampleMastery]));
        return PhoneticsTrainerCubit(
          repository: mockRepository,
          audioService: mockAudioService,
          speechService: mockSpeechService,
        );
      },
      seed: () => const PhoneticsTrainerState(
        exercises: [sampleExercise1],
        currentExerciseIndex: 0,
        currentPairIndex: 0,
        isTargetWordA: true, // targetWord is 'pão'
        step: TrainerStep.ear,
      ),
      act: (cubit) => cubit.answerEarChoice('pão'),
      expect: () => [
        predicate<PhoneticsTrainerState>((s) =>
            s.earSelectedWord == 'pão' && s.earIsCorrect == true),
        predicate<PhoneticsTrainerState>((s) =>
            s.masteryMap.containsKey('nasal_ao') && s.masteryMap['nasal_ao']?.masteryScore == 75.0),
      ],
      verify: (_) {
        verify(() => mockRepository.recordEarAnswer(
              soundId: 'nasal_ao',
              isCorrect: true,
              soundCategory: 'nasal_vowels',
              title: 'Носовой -ÃO',
            )).called(1);
      },
    );

    blocTest<PhoneticsTrainerCubit, PhoneticsTrainerState>(
      'playWord delegates to hybrid audio service',
      build: () => PhoneticsTrainerCubit(
        repository: mockRepository,
        audioService: mockAudioService,
        speechService: mockSpeechService,
      ),
      act: (cubit) => cubit.playWord('pão', locale: 'pt-BR'),
      expect: () => [
        predicate<PhoneticsTrainerState>((s) => s.isPlayingAudio == true),
        predicate<PhoneticsTrainerState>((s) => s.isPlayingAudio == false),
      ],
      verify: (_) {
        verify(() => mockAudioService.playAudioOrSpeak(
              fallbackText: 'pão',
              dialect: any(named: 'dialect'),
            )).called(1);
      },
    );
  });
}
