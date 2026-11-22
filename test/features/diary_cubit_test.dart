import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/diary/data/datasources/diary_prompts_seed.dart';
import 'package:nexus_portuguese_app/features/diary/domain/entities/diary_analysis_entity.dart';
import 'package:nexus_portuguese_app/features/diary/domain/entities/diary_entry_entity.dart';
import 'package:nexus_portuguese_app/features/diary/domain/repositories/diary_repository.dart';
import 'package:nexus_portuguese_app/features/diary/presentation/cubit/diary_cubit.dart';
import 'package:nexus_portuguese_app/features/diary/presentation/cubit/diary_state.dart';

class MockDiaryRepository extends Mock implements DiaryRepository {}

void main() {
  group('DiaryCubit Tests', () {
    late MockDiaryRepository mockRepo;
    late DiaryCubit cubit;

    final sampleEntry = DiaryEntryEntity(
      id: 'entry_1',
      contentPt: 'Hoje eu fui à praia e tomei uma água de coco.',
      dialect: 'pt_BR',
      wordCount: 11,
      estimatedLevel: 'A1',
      feedbackSummaryRu: 'Muito bem!',
      mistakes: const [],
      createdAt: DateTime.now(),
    );

    setUp(() {
      mockRepo = MockDiaryRepository();
      registerFallbackValue(sampleEntry);

      when(() => mockRepo.getAllEntries()).thenAnswer((_) async => Result.ok([sampleEntry]));
      when(() => mockRepo.getDailyPrompts()).thenAnswer((_) async => const Result.ok(DiaryPromptsSeed.prompts));
      when(() => mockRepo.saveEntry(any())).thenAnswer((invocation) async {
        final entry = invocation.positionalArguments.first as DiaryEntryEntity;
        return Result.ok(entry);
      });
      when(() => mockRepo.deleteEntry(any())).thenAnswer((_) async => const Result.ok(null));
      when(() => mockRepo.analyzeText(any())).thenAnswer((_) async => const Result.ok(
            DiaryAnalysisResult(
              wordCount: 10,
              uniqueWordCount: 8,
              detectedDialect: 'pt_BR',
              dialectNotesRu: 'Бразильский португальский',
              estimatedLevel: 'A1',
              feedbackSummaryRu: 'Отлично!',
              mistakes: [],
              suggestedSrsWords: ['praia'],
            ),
          ));

      cubit = DiaryCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has correct default values', () {
      expect(cubit.state.status, DiaryStatus.initial);
      expect(cubit.state.entries, isEmpty);
      expect(cubit.state.prompts, isEmpty);
      expect(cubit.state.isRecording, false);
    });

    test('loadDiary populates entries and daily prompts', () async {
      await cubit.loadDiary();

      expect(cubit.state.status, DiaryStatus.loaded);
      expect(cubit.state.entries.length, 1);
      expect(cubit.state.prompts.isNotEmpty, true);
    });

    test('selectPrompt sets and clears selected prompt', () {
      final prompt = DiaryPromptsSeed.prompts.first;
      cubit.selectPrompt(prompt);
      expect(cubit.state.selectedPrompt, prompt);

      cubit.selectPrompt(null);
      expect(cubit.state.selectedPrompt, isNull);
    });

    test('analyzeText updates currentAnalysis state', () async {
      await cubit.analyzeText('Hoje eu fui passear.');
      expect(cubit.state.currentAnalysis, isNotNull);
      expect(cubit.state.currentAnalysis!.detectedDialect, 'pt_BR');
    });

    test('saveEntry creates new entry and prepends to list', () async {
      await cubit.loadDiary();

      final success = await cubit.saveEntry(text: 'Estou muito feliz hoje.');
      expect(success, true);
      expect(cubit.state.entries.length, 2);
      expect(cubit.state.entries.first.contentPt, 'Estou muito feliz hoje.');

      verify(() => mockRepo.saveEntry(any())).called(1);
    });

    test('deleteEntry removes entry from state', () async {
      await cubit.loadDiary();
      expect(cubit.state.entries.length, 1);

      await cubit.deleteEntry('entry_1');
      expect(cubit.state.entries, isEmpty);
      verify(() => mockRepo.deleteEntry('entry_1')).called(1);
    });
  });
}
