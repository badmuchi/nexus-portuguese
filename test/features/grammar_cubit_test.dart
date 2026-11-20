import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/features/grammar/data/repositories/grammar_repository_impl.dart';
import 'package:nexus_portuguese_app/features/grammar/domain/entities/grammar_verb_entity.dart';
import 'package:nexus_portuguese_app/features/grammar/presentation/cubit/grammar_cubit.dart';
import 'package:nexus_portuguese_app/features/grammar/presentation/cubit/grammar_state.dart';

class MockGrammarRepository extends Mock implements GrammarRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  late MockGrammarRepository mockRepository;
  late MockHybridAudioPlaybackService mockAudioService;

  const sampleVerb1 = GrammarVerbEntity(
    id: 'verb_falar',
    infinitive: 'falar',
    regularity: 'regular',
    conjugationGroup: '-ar',
    russianMeaning: 'говорить',
    grammarNotesRu: 'Правильный глагол 1 спряжения',
    conjugations: [
      VerbConjugationForm(tense: 'Presente', person: 'eu', form: 'falo'),
      VerbConjugationForm(tense: 'Presente', person: 'você/ele/ela', form: 'fala'),
    ],
  );

  const sampleVerb2 = GrammarVerbEntity(
    id: 'verb_comer',
    infinitive: 'comer',
    regularity: 'regular',
    conjugationGroup: '-er',
    russianMeaning: 'есть',
    grammarNotesRu: 'Правильный глагол 2 спряжения',
    conjugations: [
      VerbConjugationForm(tense: 'Presente', person: 'eu', form: 'como'),
    ],
  );

  const sampleContraction = PrepositionContractionEntity(
    preposition: 'em',
    article: 'o',
    contracted: 'no',
    example: 'Estou no Brasil',
    translation: 'Я в Бразилии',
    meaning: 'в (мужской род)',
  );

  setUp(() {
    mockRepository = MockGrammarRepository();
    mockAudioService = MockHybridAudioPlaybackService();

    when(() => mockAudioService.playAudioOrSpeak(
      audioPathOrUrl: any(named: 'audioPathOrUrl'),
      fallbackText: any(named: 'fallbackText'),
      dialect: any(named: 'dialect'),
      rate: any(named: 'rate'),
    )).thenAnswer((_) async {});
  });

  group('GrammarCubit Tests', () {
    test('initial state is GrammarInitial', () {
      final cubit = GrammarCubit(
        repository: mockRepository,
        audioService: mockAudioService,
      );
      expect(cubit.state, equals(GrammarInitial()));
    });

    blocTest<GrammarCubit, GrammarState>(
      'loadGrammarData emits [GrammarLoading, GrammarLoaded] on success',
      build: () {
        when(() => mockRepository.getAllVerbs()).thenAnswer((_) async => [sampleVerb1, sampleVerb2]);
        when(() => mockRepository.getPrepositionContractions()).thenAnswer((_) async => [sampleContraction]);
        return GrammarCubit(
          repository: mockRepository,
          audioService: mockAudioService,
        );
      },
      act: (cubit) => cubit.loadGrammarData(),
      expect: () => [
        GrammarLoading(),
        const GrammarLoaded(
          verbs: [sampleVerb1, sampleVerb2],
          contractions: [sampleContraction],
          selectedVerb: sampleVerb1,
        ),
      ],
    );

    blocTest<GrammarCubit, GrammarState>(
      'loadGrammarData emits [GrammarLoading, GrammarError] when database returns no verbs',
      build: () {
        when(() => mockRepository.getAllVerbs()).thenAnswer((_) async => []);
        when(() => mockRepository.getPrepositionContractions()).thenAnswer((_) async => []);
        return GrammarCubit(
          repository: mockRepository,
          audioService: mockAudioService,
        );
      },
      act: (cubit) => cubit.loadGrammarData(),
      expect: () => [
        GrammarLoading(),
        const GrammarError('Глаголы не найдены в базе.'),
      ],
    );

    blocTest<GrammarCubit, GrammarState>(
      'loadGrammarData emits [GrammarLoading, GrammarError] on repository exception',
      build: () {
        when(() => mockRepository.getAllVerbs()).thenThrow(Exception('DB error'));
        return GrammarCubit(
          repository: mockRepository,
          audioService: mockAudioService,
        );
      },
      act: (cubit) => cubit.loadGrammarData(),
      expect: () => [
        GrammarLoading(),
        isA<GrammarError>(),
      ],
    );

    blocTest<GrammarCubit, GrammarState>(
      'selectVerb updates selectedVerb in GrammarLoaded state',
      build: () => GrammarCubit(
        repository: mockRepository,
        audioService: mockAudioService,
      ),
      seed: () => const GrammarLoaded(
        verbs: [sampleVerb1, sampleVerb2],
        contractions: [sampleContraction],
        selectedVerb: sampleVerb1,
      ),
      act: (cubit) => cubit.selectVerb(sampleVerb2),
      expect: () => [
        const GrammarLoaded(
          verbs: [sampleVerb1, sampleVerb2],
          contractions: [sampleContraction],
          selectedVerb: sampleVerb2,
        ),
      ],
    );

    blocTest<GrammarCubit, GrammarState>(
      'filterGroup updates selectedGroup filter',
      build: () => GrammarCubit(
        repository: mockRepository,
        audioService: mockAudioService,
      ),
      seed: () => const GrammarLoaded(
        verbs: [sampleVerb1, sampleVerb2],
        contractions: [sampleContraction],
        selectedVerb: sampleVerb1,
        selectedGroup: 'all',
      ),
      act: (cubit) => cubit.filterGroup('-ar'),
      expect: () => [
        const GrammarLoaded(
          verbs: [sampleVerb1, sampleVerb2],
          contractions: [sampleContraction],
          selectedVerb: sampleVerb1,
          selectedGroup: '-ar',
        ),
      ],
    );

    blocTest<GrammarCubit, GrammarState>(
      'selectTense updates selectedTense filter',
      build: () => GrammarCubit(
        repository: mockRepository,
        audioService: mockAudioService,
      ),
      seed: () => const GrammarLoaded(
        verbs: [sampleVerb1],
        contractions: [sampleContraction],
        selectedVerb: sampleVerb1,
        selectedTense: 'Presente',
      ),
      act: (cubit) => cubit.selectTense('Pretérito Perfeito'),
      expect: () => [
        const GrammarLoaded(
          verbs: [sampleVerb1],
          contractions: [sampleContraction],
          selectedVerb: sampleVerb1,
          selectedTense: 'Pretérito Perfeito',
        ),
      ],
    );

    test('playFormAudio invokes audioService with text', () {
      final cubit = GrammarCubit(
        repository: mockRepository,
        audioService: mockAudioService,
      );
      cubit.playFormAudio('falo');
      verify(() => mockAudioService.playAudioOrSpeak(fallbackText: 'falo')).called(1);
    });
  });
}
