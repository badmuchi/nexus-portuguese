import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/scenes/domain/entities/portuguese_life_scene.dart';
import 'package:nexus_portuguese_app/features/scenes/domain/repositories/scenes_repository.dart';
import 'package:nexus_portuguese_app/features/scenes/presentation/cubit/scenes_cubit.dart';
import 'package:nexus_portuguese_app/features/scenes/presentation/cubit/scenes_state.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';

class MockScenesRepository extends Mock implements ScenesRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}
class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  late MockScenesRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;
  late MockSrsRepository mockSrs;

  const sampleScene = PortugueseLifeScene(
    id: 'test_cafe',
    category: SceneCategory.cafe,
    titlePt: 'Café Teste',
    titleRu: 'Тестовое кафе',
    locationTag: 'Lisboa 🇵🇹',
    description: 'Описание сцены',
    culturalTip: CulturalTip(
      title: 'Совет',
      bodyRu: 'Описание совета',
      countryFlag: '🇵🇹',
    ),
    words: [
      SceneWord(
        id: 'w1',
        portuguese: 'bica',
        ipa: '[ˈbikɐ]',
        russianMeaning: 'эспрессо',
      ),
    ],
    phrases: [
      ScenePhrase(
        id: 'p1',
        role: PhraseRole.theySay,
        portuguese: 'O que vai ser?',
        russianTranslation: 'Что будете брать?',
      ),
    ],
    challenges: [
      SceneChallenge(
        id: 'c1',
        question: 'Что такое bica?',
        options: ['Кофе', 'Чай'],
        correctIndex: 0,
        explanationRu: 'Это кофе',
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(
      SrsCardEntity(
        id: 'fallback',
        portuguese: '',
        russianTranslation: '',
        partOfSpeech: '',
        category: '',
        dialect: '',
        fsrsState: '',
        stability: 0,
        difficulty: 0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockRepo = MockScenesRepository();
    mockAudio = MockHybridAudioPlaybackService();
    mockSrs = MockSrsRepository();

    when(() => mockAudio.playAudioOrSpeak(
          fallbackText: any(named: 'fallbackText'),
          dialect: any(named: 'dialect'),
        )).thenAnswer((_) async {});
  });

  group('ScenesCubit Tests', () {
    test('initial state is ScenesLoading', () {
      final cubit = ScenesCubit(
        repository: mockRepo,
        audioService: mockAudio,
        srsRepository: mockSrs,
      );
      expect(cubit.state, const ScenesLoading());
      cubit.close();
    });

    blocTest<ScenesCubit, ScenesState>(
      'loadScenes emits ScenesLoaded on success',
      build: () {
        when(() => mockRepo.getScenes()).thenAnswer((_) async => const Result.ok([sampleScene]));
        when(() => mockRepo.getAllProgress()).thenAnswer((_) async => const Result.ok({}));
        return ScenesCubit(
          repository: mockRepo,
          audioService: mockAudio,
          srsRepository: mockSrs,
        );
      },
      act: (cubit) => cubit.loadScenes(),
      expect: () => [
        const ScenesLoading(),
        predicate<ScenesState>((s) => s is ScenesLoaded && s.scenes.length == 1),
      ],
    );

    blocTest<ScenesCubit, ScenesState>(
      'loadScenes emits ScenesError on repository error',
      build: () {
        when(() => mockRepo.getScenes()).thenAnswer((_) async => Result.err(const DatabaseFailure('Failed')));
        when(() => mockRepo.getAllProgress()).thenAnswer((_) async => const Result.ok({}));
        return ScenesCubit(
          repository: mockRepo,
          audioService: mockAudio,
          srsRepository: mockSrs,
        );
      },
      act: (cubit) => cubit.loadScenes(),
      expect: () => [
        const ScenesLoading(),
        const ScenesError('Failed'),
      ],
    );

    blocTest<ScenesCubit, ScenesState>(
      'filterCategory updates selectedCategory filter in loaded state',
      build: () => ScenesCubit(
        repository: mockRepo,
        audioService: mockAudio,
        srsRepository: mockSrs,
      ),
      seed: () => const ScenesLoaded(scenes: [sampleScene]),
      act: (cubit) => cubit.filterCategory(SceneCategory.cafe),
      expect: () => [
        predicate<ScenesState>((s) =>
            s is ScenesLoaded && s.selectedCategory == SceneCategory.cafe),
      ],
    );

    blocTest<ScenesCubit, ScenesState>(
      'playAudio sets activePlayingText and delegates to audioService',
      build: () => ScenesCubit(
        repository: mockRepo,
        audioService: mockAudio,
        srsRepository: mockSrs,
      ),
      seed: () => const ScenesLoaded(scenes: [sampleScene]),
      act: (cubit) => cubit.playAudio('bica', dialectTag: 'pt-PT'),
      expect: () => [
        predicate<ScenesState>((s) =>
            s is ScenesLoaded && s.activePlayingText == 'bica'),
        predicate<ScenesState>((s) =>
            s is ScenesLoaded && s.activePlayingText == null),
      ],
      verify: (_) {
        verify(() => mockAudio.playAudioOrSpeak(
              fallbackText: 'bica',
              dialect: any(named: 'dialect'),
            )).called(1);
      },
    );

    test('addWordToSrs calls srsRepository.addCard and returns true', () async {
      when(() => mockSrs.addCard(any())).thenAnswer((_) async {});

      final cubit = ScenesCubit(
        repository: mockRepo,
        audioService: mockAudio,
        srsRepository: mockSrs,
      );

      final success = await cubit.addWordToSrs(sampleScene.words.first);
      expect(success, true);
      verify(() => mockSrs.addCard(any())).called(1);
      cubit.close();
    });
  });
}
