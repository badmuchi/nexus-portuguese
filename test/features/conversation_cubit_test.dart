import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/conversation/data/repositories/conversation_repository_impl.dart';
import 'package:nexus_portuguese_app/features/conversation/domain/entities/dialogue_models.dart';
import 'package:nexus_portuguese_app/features/conversation/presentation/cubit/conversation_cubit.dart';
import 'package:nexus_portuguese_app/features/conversation/presentation/cubit/conversation_state.dart';

class MockConversationRepository extends Mock implements ConversationRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}
class MockAppSettingsStorage extends Mock implements AppSettingsStorage {}

void main() {
  late MockConversationRepository mockRepository;
  late MockHybridAudioPlaybackService mockAudioService;
  late MockAppSettingsStorage mockSettings;

  const sampleScenario = DialogueScenarioInfo(
    id: 'cafe_order',
    title: 'Заказ в кафе',
    category: 'food',
    dialect: 'pt_br',
    startNodeId: 'node_cafe_1',
  );

  const sampleStartNode = DialogueNodeEntity(
    id: 'node_cafe_1',
    speakerPortuguese: 'Garçom',
    speakerRussian: 'Официант',
    linePortuguese: 'Bom dia! O que vai desejar?',
    lineRussian: 'Доброе утро! Что будете заказывать?',
    audioPath: 'assets/audio/dialogue/node_cafe_start.mp3',
    scenarioId: 'cafe_order',
    scenarioTitle: 'Заказ в кафе',
    scenarioCategory: 'food',
    dialect: 'pt_br',
    options: [
      DialogueOption(
        id: 'opt_1',
        textPortuguese: 'Um café, por favor.',
        textRussian: 'Один кофе, пожалуйста.',
        nextNodeId: 'node_cafe_2',
      ),
    ],
  );

  const sampleNextNode = DialogueNodeEntity(
    id: 'node_cafe_2',
    speakerPortuguese: 'Garçom',
    speakerRussian: 'Официант',
    linePortuguese: 'Com açúcar ou sem açúcar?',
    lineRussian: 'С сахаром или без сахара?',
    audioPath: 'assets/audio/dialogue/node_cafe_sugar.mp3',
    scenarioId: 'cafe_order',
    scenarioTitle: 'Заказ в кафе',
    scenarioCategory: 'food',
    dialect: 'pt_br',
    options: [],
  );

  setUp(() {
    mockRepository = MockConversationRepository();
    mockAudioService = MockHybridAudioPlaybackService();
    mockSettings = MockAppSettingsStorage();

    when(() => mockAudioService.playAudioOrSpeak(
      audioPathOrUrl: any(named: 'audioPathOrUrl'),
      fallbackText: any(named: 'fallbackText'),
      dialect: any(named: 'dialect'),
      rate: any(named: 'rate'),
    )).thenAnswer((_) async {});
  });

  group('ConversationCubit Tests', () {
    test('initial state is ConversationInitial', () {
      final cubit = ConversationCubit(
        repository: mockRepository,
        audioService: mockAudioService,
        settings: mockSettings,
      );
      expect(cubit.state, equals(ConversationInitial()));
    });

    blocTest<ConversationCubit, ConversationState>(
      'initScenarios loads first scenario and start node',
      build: () {
        when(() => mockRepository.getScenarios()).thenAnswer((_) async => [sampleScenario]);
        when(() => mockRepository.getNode(sampleScenario.startNodeId)).thenAnswer((_) async => sampleStartNode);
        return ConversationCubit(
          repository: mockRepository,
          audioService: mockAudioService,
          settings: mockSettings,
        );
      },
      act: (cubit) => cubit.initScenarios(),
      expect: () => [
        ConversationLoading(),
        const ConversationActive(
          scenarios: [sampleScenario],
          activeScenario: sampleScenario,
          currentNode: sampleStartNode,
          history: [
            DialogueMessageItem(
              speaker: 'Garçom',
              textPortuguese: 'Bom dia! O que vai desejar?',
              textRussian: 'Доброе утро! Что будете заказывать?',
              isUser: false,
              audioPath: 'assets/audio/dialogue/node_cafe_start.mp3',
            ),
          ],
          isFinished: false,
        ),
      ],
      verify: (_) {
        verify(() => mockAudioService.playAudioOrSpeak(
          audioPathOrUrl: sampleStartNode.audioPath,
          fallbackText: sampleStartNode.linePortuguese,
          dialect: any(named: 'dialect'),
        )).called(1);
      },
    );

    blocTest<ConversationCubit, ConversationState>(
      'selectOption records choice and progresses to next node',
      build: () {
        when(() => mockRepository.recordChoice('node_cafe_1', 'opt_1')).thenAnswer((_) async {});
        when(() => mockRepository.getNode('node_cafe_2')).thenAnswer((_) async => sampleNextNode);
        return ConversationCubit(
          repository: mockRepository,
          audioService: mockAudioService,
          settings: mockSettings,
        );
      },
      seed: () => const ConversationActive(
        scenarios: [sampleScenario],
        activeScenario: sampleScenario,
        currentNode: sampleStartNode,
        history: [
          DialogueMessageItem(
            speaker: 'Garçom',
            textPortuguese: 'Bom dia! O que vai desejar?',
            textRussian: 'Доброе утро! Что будете заказывать?',
            isUser: false,
          ),
        ],
        isFinished: false,
      ),
      act: (cubit) => cubit.selectOption(sampleStartNode.options.first),
      expect: () => [
        const ConversationActive(
          scenarios: [sampleScenario],
          activeScenario: sampleScenario,
          currentNode: sampleNextNode,
          history: [
            DialogueMessageItem(
              speaker: 'Garçom',
              textPortuguese: 'Bom dia! O que vai desejar?',
              textRussian: 'Доброе утро! Что будете заказывать?',
              isUser: false,
            ),
            DialogueMessageItem(
              speaker: 'Você (Вы)',
              textPortuguese: 'Um café, por favor.',
              textRussian: 'Один кофе, пожалуйста.',
              isUser: true,
            ),
            DialogueMessageItem(
              speaker: 'Garçom',
              textPortuguese: 'Com açúcar ou sem açúcar?',
              textRussian: 'С сахаром или без сахара?',
              isUser: false,
              audioPath: 'assets/audio/dialogue/node_cafe_sugar.mp3',
            ),
          ],
          isFinished: true,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.recordChoice('node_cafe_1', 'opt_1')).called(1);
        verify(() => mockAudioService.playAudioOrSpeak(
          audioPathOrUrl: sampleNextNode.audioPath,
          fallbackText: sampleNextNode.linePortuguese,
          dialect: any(named: 'dialect'),
        )).called(1);
      },
    );
  });
}
