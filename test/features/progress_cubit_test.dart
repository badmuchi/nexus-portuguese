import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/progress/domain/entities/progress_stats_entity.dart';
import 'package:nexus_portuguese_app/features/progress/domain/repositories/progress_repository.dart';
import 'package:nexus_portuguese_app/features/progress/presentation/cubit/progress_cubit.dart';
import 'package:nexus_portuguese_app/features/progress/presentation/cubit/progress_state.dart';

class MockProgressRepository extends Mock implements ProgressRepository {}

void main() {
  late MockProgressRepository mockRepository;

  final sampleStats = ProgressStatsEntity(
    cardsCount: 16,
    reviewsCount: 42,
    dialoguesCount: 5,
    grammarLogsCount: 12,
    listeningLogsCount: 7,
    activityByDay: {
      DateTime(2026, 11, 20): 10,
    },
  );

  setUp(() {
    mockRepository = MockProgressRepository();
  });

  group('ProgressCubit Tests', () {
    test('initial state is ProgressInitial', () {
      final cubit = ProgressCubit(repository: mockRepository);
      expect(cubit.state, equals(ProgressInitial()));
    });

    blocTest<ProgressCubit, ProgressState>(
      'loadStats emits [ProgressLoading, ProgressLoaded] on success',
      build: () {
        when(() => mockRepository.getProgressStats())
            .thenAnswer((_) async => Result.ok(sampleStats));
        return ProgressCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadStats(),
      expect: () => [
        ProgressLoading(),
        ProgressLoaded(sampleStats),
      ],
    );

    blocTest<ProgressCubit, ProgressState>(
      'loadStats emits [ProgressLoading, ProgressError] on failure',
      build: () {
        when(() => mockRepository.getProgressStats()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load stats')),
        );
        return ProgressCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadStats(),
      expect: () => [
        ProgressLoading(),
        const ProgressError('Failed to load stats'),
      ],
    );
  });
}
