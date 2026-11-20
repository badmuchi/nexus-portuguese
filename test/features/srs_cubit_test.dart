import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/utils/portuguese_normalizer.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import 'package:nexus_portuguese_app/features/srs/domain/services/fsrs_engine.dart';
import 'package:nexus_portuguese_app/features/srs/presentation/cubit/srs_cubit.dart';
import 'package:nexus_portuguese_app/features/srs/presentation/cubit/srs_state.dart';

class MockSrsRepository extends Mock implements SrsRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  late MockSrsRepository mockRepository;
  late MockHybridAudioPlaybackService mockAudioService;

  final sampleCard1 = SrsCardEntity(
    id: 'srs_1',
    portuguese: 'Olá',
    russianTranslation: 'Привет',
    partOfSpeech: 'greeting',
    category: 'basics',
    dialect: 'all',
    audioUrl: 'assets/audio/srs/srs_ola.mp3',
    fsrsState: 'newCard',
    stability: 0.0,
    difficulty: 0.0,
    reps: 0,
    lapses: 0,
    dueAt: DateTime.now(),
  );

  final sampleCard2 = SrsCardEntity(
    id: 'srs_2',
    portuguese: 'Obrigado',
    russianTranslation: 'Спасибо',
    partOfSpeech: 'phrase',
    category: 'basics',
    dialect: 'all',
    audioUrl: 'assets/audio/srs/srs_obrigado.mp3',
    fsrsState: 'newCard',
    stability: 0.0,
    difficulty: 0.0,
    reps: 0,
    lapses: 0,
    dueAt: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(sampleCard1);
    registerFallbackValue(SrsRating.good);
  });

  setUp(() {
    mockRepository = MockSrsRepository();
    mockAudioService = MockHybridAudioPlaybackService();

    when(() => mockAudioService.playAudioOrSpeak(
      audioPathOrUrl: any(named: 'audioPathOrUrl'),
      fallbackText: any(named: 'fallbackText'),
      dialect: any(named: 'dialect'),
      rate: any(named: 'rate'),
    )).thenAnswer((_) async {});
  });

  group('SrsCubit Tests', () {
    test('initial state is SrsInitial', () {
      final cubit = SrsCubit(
        repository: mockRepository,
        audioService: mockAudioService,
      );
      expect(cubit.state, equals(SrsInitial()));
    });

    blocTest<SrsCubit, SrsState>(
      'loadDueCards emits [SrsLoading, SrsReviewing] when queue has cards',
      build: () {
        when(() => mockRepository.getDueCards()).thenAnswer((_) async => [sampleCard1, sampleCard2]);
        return SrsCubit(
          repository: mockRepository,
          audioService: mockAudioService,
        );
      },
      act: (cubit) => cubit.loadDueCards(),
      expect: () => [
        SrsLoading(),
        SrsReviewing(
          queue: [sampleCard1, sampleCard2],
          currentIndex: 0,
          isFrontRevealed: false,
        ),
      ],
    );

    blocTest<SrsCubit, SrsState>(
      'loadDueCards emits [SrsLoading, SrsEmpty] when no cards are due',
      build: () {
        when(() => mockRepository.getDueCards()).thenAnswer((_) async => []);
        when(() => mockRepository.getAllCards()).thenAnswer((_) async => [sampleCard1]);
        return SrsCubit(
          repository: mockRepository,
          audioService: mockAudioService,
        );
      },
      act: (cubit) => cubit.loadDueCards(),
      expect: () => [
        SrsLoading(),
        const SrsEmpty(totalCards: 1),
      ],
    );

    blocTest<SrsCubit, SrsState>(
      'loadDueCards emits [SrsLoading, SrsError] on repository failure',
      build: () {
        when(() => mockRepository.getDueCards()).thenThrow(Exception('Database error'));
        return SrsCubit(
          repository: mockRepository,
          audioService: mockAudioService,
        );
      },
      act: (cubit) => cubit.loadDueCards(),
      expect: () => [
        SrsLoading(),
        isA<SrsError>(),
      ],
    );

    blocTest<SrsCubit, SrsState>(
      'toggleFlip reveals card and triggers audio playback',
      build: () => SrsCubit(
        repository: mockRepository,
        audioService: mockAudioService,
      ),
      seed: () => SrsReviewing(
        queue: [sampleCard1],
        currentIndex: 0,
        isFrontRevealed: false,
      ),
      act: (cubit) => cubit.toggleFlip(),
      expect: () => [
        SrsReviewing(
          queue: [sampleCard1],
          currentIndex: 0,
          isFrontRevealed: true,
        ),
      ],
      verify: (_) {
        verify(() => mockAudioService.playAudioOrSpeak(
          audioPathOrUrl: sampleCard1.audioUrl,
          fallbackText: sampleCard1.portuguese,
        )).called(1);
      },
    );

    blocTest<SrsCubit, SrsState>(
      'switchReviewMode updates mode to typing and clears inputs',
      build: () => SrsCubit(
        repository: mockRepository,
        audioService: mockAudioService,
      ),
      seed: () => SrsReviewing(
        queue: [sampleCard1],
        currentIndex: 0,
        isFrontRevealed: true,
        reviewMode: SrsReviewMode.flashcard,
      ),
      act: (cubit) => cubit.switchReviewMode(SrsReviewMode.typing),
      expect: () => [
        SrsReviewing(
          queue: [sampleCard1],
          currentIndex: 0,
          isFrontRevealed: false,
          reviewMode: SrsReviewMode.typing,
          typedText: null,
          typingResult: null,
        ),
      ],
    );

    blocTest<SrsCubit, SrsState>(
      'submitTypedAnswer evaluates accent missing and plays audio',
      build: () => SrsCubit(
        repository: mockRepository,
        audioService: mockAudioService,
      ),
      seed: () => SrsReviewing(
        queue: [sampleCard1],
        currentIndex: 0,
        isFrontRevealed: false,
        reviewMode: SrsReviewMode.typing,
      ),
      act: (cubit) => cubit.submitTypedAnswer('Ola'),
      expect: () => [
        SrsReviewing(
          queue: [sampleCard1],
          currentIndex: 0,
          isFrontRevealed: true,
          reviewMode: SrsReviewMode.typing,
          typedText: 'Ola',
          typingResult: PortugueseMatchResult.accentMissing,
        ),
      ],
    );

    blocTest<SrsCubit, SrsState>(
      'rateCurrentCard advances to next card and persists review',
      build: () {
        when(() => mockRepository.reviewCard(
          card: any(named: 'card'),
          rating: any(named: 'rating'),
          wasTypedCheck: any(named: 'wasTypedCheck'),
          wasTypedExact: any(named: 'wasTypedExact'),
        )).thenAnswer((_) async {});

        return SrsCubit(
          repository: mockRepository,
          audioService: mockAudioService,
        );
      },
      seed: () => SrsReviewing(
        queue: [sampleCard1, sampleCard2],
        currentIndex: 0,
        isFrontRevealed: true,
      ),
      act: (cubit) => cubit.rateCurrentCard(SrsRating.good),
      expect: () => [
        SrsReviewing(
          queue: [sampleCard1, sampleCard2],
          currentIndex: 1,
          isFrontRevealed: false,
          typedText: null,
          typingResult: null,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.reviewCard(
          card: sampleCard1,
          rating: SrsRating.good,
          wasTypedCheck: false,
          wasTypedExact: false,
        )).called(1);
      },
    );

    blocTest<SrsCubit, SrsState>(
      'rateCurrentCard completes queue and emits SrsEmpty on last card',
      build: () {
        when(() => mockRepository.reviewCard(
          card: any(named: 'card'),
          rating: any(named: 'rating'),
          wasTypedCheck: any(named: 'wasTypedCheck'),
          wasTypedExact: any(named: 'wasTypedExact'),
        )).thenAnswer((_) async {});
        when(() => mockRepository.getAllCards()).thenAnswer((_) async => [sampleCard1]);

        return SrsCubit(
          repository: mockRepository,
          audioService: mockAudioService,
        );
      },
      seed: () => SrsReviewing(
        queue: [sampleCard1],
        currentIndex: 0,
        isFrontRevealed: true,
      ),
      act: (cubit) => cubit.rateCurrentCard(SrsRating.easy),
      expect: () => [
        const SrsEmpty(totalCards: 1),
      ],
    );
  });
}
