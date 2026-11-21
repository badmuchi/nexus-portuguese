import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/slang/domain/entities/slang_entity.dart';
import 'package:nexus_portuguese_app/features/slang/domain/repositories/slang_repository.dart';
import 'package:nexus_portuguese_app/features/slang/presentation/cubit/slang_cubit.dart';
import 'package:nexus_portuguese_app/features/slang/presentation/cubit/slang_state.dart';

class MockSlangRepository extends Mock implements SlangRepository {}

void main() {
  late MockSlangRepository mockRepository;

  const sampleSlang = SlangEntity(
    id: 'slang_1',
    expression: 'Legal / Fixe',
    literalTranslation: 'Легальный / Зафиксированный',
    actualMeaning: 'Круто, здорово',
    dialect: 'both',
    originNotes: 'Legal в Бразилии, Fixe в Португалии',
    exampleSentence: 'Que legal!',
    exampleTranslation: 'Как здорово!',
  );

  setUp(() {
    mockRepository = MockSlangRepository();
  });

  group('SlangCubit Tests', () {
    test('initial state is SlangInitial', () {
      final cubit = SlangCubit(repository: mockRepository);
      expect(cubit.state, equals(SlangInitial()));
    });

    blocTest<SlangCubit, SlangState>(
      'loadSlang emits [SlangLoading, SlangLoaded] on success',
      build: () {
        when(() => mockRepository.getAllSlang())
            .thenAnswer((_) async => const Result.ok([sampleSlang]));
        return SlangCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadSlang(),
      expect: () => [
        SlangLoading(),
        const SlangLoaded([sampleSlang]),
      ],
    );

    blocTest<SlangCubit, SlangState>(
      'loadSlang emits [SlangLoading, SlangError] on repository failure',
      build: () {
        when(() => mockRepository.getAllSlang()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Database read error')),
        );
        return SlangCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadSlang(),
      expect: () => [
        SlangLoading(),
        const SlangError('Database read error'),
      ],
    );
  });
}
