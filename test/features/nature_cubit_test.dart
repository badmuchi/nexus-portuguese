import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/nature/data/datasources/nature_seed_data.dart';
import 'package:nexus_portuguese_app/features/nature/domain/entities/nature_entities.dart';
import 'package:nexus_portuguese_app/features/nature/domain/repositories/nature_repository.dart';
import 'package:nexus_portuguese_app/features/nature/presentation/cubit/eco_quiz_cubit.dart';
import 'package:nexus_portuguese_app/features/nature/presentation/cubit/eco_quiz_state.dart';
import 'package:nexus_portuguese_app/features/nature/presentation/cubit/nature_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/nature/presentation/cubit/nature_catalog_state.dart';
import 'package:nexus_portuguese_app/features/nature/presentation/cubit/nature_reserve_cubit.dart';

class MockNatureRepository extends Mock implements NatureRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const SpeciesEntity(
        id: 'fallback_sp',
        commonNamePt: 'nome',
        scientificName: 'sc_nome',
        nameRu: 'рус',
        emoji: '🌿',
        category: SpeciesCategory.flora,
        statusRu: 'статус',
        curiosityRu: 'факт',
      ),
    );
  });

  late MockNatureRepository mockRepo;
  late MockHybridAudioPlaybackService mockAudio;

  setUp(() {
    mockRepo = MockNatureRepository();
    mockAudio = MockHybridAudioPlaybackService();

    when(() => mockAudio.stop()).thenAnswer((_) async {});
    when(
      () => mockAudio.playAudioOrSpeak(
        fallbackText: any(named: 'fallbackText'),
        audioPathOrUrl: any(named: 'audioPathOrUrl'),
        dialect: any(named: 'dialect'),
        rate: any(named: 'rate'),
      ),
    ).thenAnswer((_) async {});
  });

  group('NatureCatalogCubit Tests', () {
    test('initial state has correct defaults', () {
      final cubit = NatureCatalogCubit(repository: mockRepo);
      expect(cubit.state.status, NatureCatalogStatus.initial);
      expect(cubit.state.selectedDialect, 'all');
      expect(cubit.state.selectedSpeciesCategory, isNull);
      cubit.close();
    });

    test('loadCatalog success populates reserves and species', () async {
      when(() => mockRepo.getReserves())
          .thenAnswer((_) async => Result.ok(NatureSeedData.getReserves()));
      when(() => mockRepo.getAllSpecies())
          .thenAnswer((_) async => Result.ok(NatureSeedData.getAllSpecies()));

      final cubit = NatureCatalogCubit(repository: mockRepo);
      await cubit.loadCatalog();

      expect(cubit.state.status, NatureCatalogStatus.loaded);
      expect(cubit.state.allReserves.length, 6);
      expect(cubit.state.allSpecies.length, greaterThanOrEqualTo(12));
      cubit.close();
    });

    test('loadCatalog error emits error status', () async {
      when(() => mockRepo.getReserves())
          .thenAnswer((_) async => Result.err(const DatabaseFailure('Failed to load')));
      when(() => mockRepo.getAllSpecies())
          .thenAnswer((_) async => Result.ok(NatureSeedData.getAllSpecies()));

      final cubit = NatureCatalogCubit(repository: mockRepo);
      await cubit.loadCatalog();

      expect(cubit.state.status, NatureCatalogStatus.error);
      expect(cubit.state.errorMessage, isNotNull);
      cubit.close();
    });

    test('filters reserves and species by dialect, category and search', () async {
      when(() => mockRepo.getReserves())
          .thenAnswer((_) async => Result.ok(NatureSeedData.getReserves()));
      when(() => mockRepo.getAllSpecies())
          .thenAnswer((_) async => Result.ok(NatureSeedData.getAllSpecies()));

      final cubit = NatureCatalogCubit(repository: mockRepo);
      await cubit.loadCatalog();

      cubit.filterByDialect('pt_BR');
      expect(cubit.state.filteredReserves.every((r) => r.isPtBr), isTrue);

      cubit.filterByDialect('all');
      cubit.filterBySpeciesCategory(SpeciesCategory.fauna);
      expect(cubit.state.filteredSpecies.every((s) => s.category == SpeciesCategory.fauna), isTrue);

      cubit.filterBySpeciesCategory(null);
      expect(cubit.state.selectedSpeciesCategory, isNull);

      cubit.search('gerês');
      expect(cubit.state.filteredReserves.length, 1);

      cubit.setTab(1);
      expect(cubit.state.activeTabIndex, 1);

      cubit.close();
    });
  });

  group('NatureReserveCubit Tests', () {
    late NatureReserveEntity testReserve;

    setUp(() {
      testReserve = NatureSeedData.getReserves().first;

      when(
        () => mockRepo.recordTrailCompleted(
          trailId: any(named: 'trailId'),
          distanceKm: any(named: 'distanceKm'),
        ),
      ).thenAnswer((_) async => const Result.ok(null));

      when(
        () => mockRepo.addSpeciesToSrs(any()),
      ).thenAnswer((_) async => const Result.ok(null));
    });

    test('initial state matches reserve', () {
      final cubit = NatureReserveCubit(
        reserve: testReserve,
        repository: mockRepo,
        audioService: mockAudio,
      );

      expect(cubit.state.reserve.id, testReserve.id);
      expect(cubit.state.completedTrailIds, isEmpty);
      expect(cubit.state.addedSpeciesIds, isEmpty);
      cubit.close();
    });

    test('completeTrail adds id to set and calls repository', () async {
      final cubit = NatureReserveCubit(
        reserve: testReserve,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final trail = testReserve.trails.first;
      await cubit.completeTrail(trail);

      expect(cubit.state.completedTrailIds, contains(trail.id));
      verify(
        () => mockRepo.recordTrailCompleted(
          trailId: trail.id,
          distanceKm: trail.distanceKm,
        ),
      ).called(1);

      cubit.close();
    });

    test('addSpeciesToSrs adds id to set and calls repository', () async {
      final cubit = NatureReserveCubit(
        reserve: testReserve,
        repository: mockRepo,
        audioService: mockAudio,
      );

      final species = testReserve.faunaFlora.first;
      await cubit.addSpeciesToSrs(species);

      expect(cubit.state.addedSpeciesIds, contains(species.id));
      verify(() => mockRepo.addSpeciesToSrs(species)).called(1);

      cubit.close();
    });

    test('playDescription and stopAudio control audio playback', () async {
      final cubit = NatureReserveCubit(
        reserve: testReserve,
        repository: mockRepo,
        audioService: mockAudio,
      );

      await cubit.playDescription();
      verify(() => mockAudio.playAudioOrSpeak(
            fallbackText: any(named: 'fallbackText'),
            dialect: any(named: 'dialect'),
            rate: any(named: 'rate'),
          )).called(1);

      await cubit.stopAudio();
      verify(() => mockAudio.stop()).called(1);

      cubit.close();
    });
  });

  group('EcoQuizCubit Tests', () {
    setUp(() {
      when(() => mockRepo.getEcoQuizzes())
          .thenAnswer((_) async => Result.ok(NatureSeedData.getEcoQuizzes()));
    });

    test('loadQuizzes populates quiz questions', () async {
      final cubit = EcoQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      expect(cubit.state.status, EcoQuizStatus.inProgress);
      expect(cubit.state.quizzes.length, 6);
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);

      cubit.close();
    });

    test('selectOption, checkAnswer and nextQuestion progress quiz', () async {
      final cubit = EcoQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      final correctIndex = cubit.state.currentQuiz!.correctOptionIndex;
      cubit.selectOption(correctIndex);
      expect(cubit.state.selectedOption, correctIndex);

      cubit.checkAnswer();
      expect(cubit.state.isAnswerChecked, isTrue);
      expect(cubit.state.score, 1);
      expect(cubit.state.isCorrect, isTrue);

      cubit.nextQuestion();
      expect(cubit.state.currentIndex, 1);
      expect(cubit.state.selectedOption, isNull);
      expect(cubit.state.isAnswerChecked, isFalse);

      cubit.close();
    });

    test('restart resets state to beginning', () async {
      final cubit = EcoQuizCubit(repository: mockRepo);
      await cubit.loadQuizzes();

      cubit.selectOption(0);
      cubit.checkAnswer();
      cubit.nextQuestion();
      expect(cubit.state.currentIndex, 1);

      cubit.restart();
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.score, 0);
      expect(cubit.state.selectedOption, isNull);

      cubit.close();
    });
  });
}
