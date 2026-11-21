import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/error/failures.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/stories/domain/entities/story_entity.dart';
import 'package:nexus_portuguese_app/features/stories/domain/repositories/stories_repository.dart';
import 'package:nexus_portuguese_app/features/stories/presentation/cubit/stories_cubit.dart';
import 'package:nexus_portuguese_app/features/stories/presentation/cubit/stories_state.dart';

class MockStoriesRepository extends Mock implements StoriesRepository {}

void main() {
  late MockStoriesRepository mockRepository;

  const sampleStory = StoryEntity(
    id: 'story_1',
    titlePortuguese: 'Um Dia em Lisboa',
    titleRussian: 'Один день в Лиссабоне',
    dialect: 'pt_pt',
    level: 'A1',
    coverIcon: 'storefront_rounded',
    description: 'Прогулка по улочкам Алфамы.',
    contentJson: '[]',
    paragraphs: [
      StoryParagraph(
        portuguese: 'O sol brilha sobre o Tejo.',
        russian: 'Солнце светит над Тежу.',
        words: ['O', 'sol', 'brilha'],
      ),
    ],
  );

  setUp(() {
    mockRepository = MockStoriesRepository();
  });

  group('StoriesCubit Tests', () {
    test('initial state is StoriesInitial', () {
      final cubit = StoriesCubit(repository: mockRepository);
      expect(cubit.state, equals(StoriesInitial()));
    });

    blocTest<StoriesCubit, StoriesState>(
      'loadStories emits [StoriesLoading, StoriesLoaded] on success',
      build: () {
        when(() => mockRepository.getAllStories())
            .thenAnswer((_) async => const Result.ok([sampleStory]));
        return StoriesCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadStories(),
      expect: () => [
        StoriesLoading(),
        const StoriesLoaded([sampleStory]),
      ],
    );

    blocTest<StoriesCubit, StoriesState>(
      'loadStories emits [StoriesLoading, StoriesError] on repository failure',
      build: () {
        when(() => mockRepository.getAllStories()).thenAnswer(
          (_) async => Result.err(const DatabaseFailure('Failed to load stories')),
        );
        return StoriesCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadStories(),
      expect: () => [
        StoriesLoading(),
        const StoriesError('Failed to load stories'),
      ],
    );
  });
}
