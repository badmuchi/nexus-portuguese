import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/result/result.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/data/datasources/chat_simulator_seed_data.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/domain/entities/chat_abbreviation_entity.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/domain/repositories/chat_simulator_repository.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/presentation/cubit/chat_catalog_cubit.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/presentation/cubit/chat_conversation_cubit.dart';

class MockChatSimulatorRepository extends Mock implements ChatSimulatorRepository {}
class MockHybridAudioPlaybackService extends Mock implements HybridAudioPlaybackService {}

void main() {
  group('ChatCatalogCubit Tests', () {
    late MockChatSimulatorRepository mockRepo;
    late ChatCatalogCubit cubit;
    const testScenarios = ChatSimulatorSeedData.scenarios;

    setUp(() {
      mockRepo = MockChatSimulatorRepository();
      when(() => mockRepo.getScenarios(
            dialect: any(named: 'dialect'),
          )).thenAnswer((_) async => const Result.ok(testScenarios));

      cubit = ChatCatalogCubit(repository: mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty scenarios and not loading', () {
      expect(cubit.state.scenarios, isEmpty);
      expect(cubit.state.isLoading, isFalse);
    });

    test('loadCatalog loads scenarios into state', () async {
      await cubit.loadCatalog();
      expect(cubit.state.scenarios.length, testScenarios.length);
      expect(cubit.state.isLoading, isFalse);
    });

    test('filterByDialect updates selected dialect and filtered results', () async {
      await cubit.loadCatalog();
      cubit.filterByDialect('pt_PT');

      expect(cubit.state.selectedDialect, 'pt_PT');
      for (final s in cubit.state.filteredScenarios) {
        expect(s.dialect, 'pt_PT');
      }
    });

    test('searchScenarios filters by title, contact or context', () async {
      await cubit.loadCatalog();
      cubit.searchScenarios('iFood');

      expect(cubit.state.filteredScenarios.length, 1);
      expect(cubit.state.filteredScenarios.first.channelName, contains('iFood'));
    });
  });

  group('ChatConversationCubit Tests', () {
    late MockChatSimulatorRepository mockRepo;
    late MockHybridAudioPlaybackService mockAudio;
    late ChatConversationCubit cubit;
    final testScenario = ChatSimulatorSeedData.scenarios.first;

    setUp(() {
      mockRepo = MockChatSimulatorRepository();
      mockAudio = MockHybridAudioPlaybackService();

      when(() => mockRepo.recordScenarioCompleted(
            scenarioId: any(named: 'scenarioId'),
            score: any(named: 'score'),
            totalChoices: any(named: 'totalChoices'),
          )).thenAnswer((_) async => const Result.ok(null));

      when(() => mockAudio.playAudioOrSpeak(
            fallbackText: any(named: 'fallbackText'),
            dialect: any(named: 'dialect'),
          )).thenAnswer((_) async {});

      when(() => mockAudio.stop()).thenAnswer((_) async {});

      cubit = ChatConversationCubit(
        scenario: testScenario,
        repository: mockRepo,
        audioService: mockAudio,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state loads first step messages', () {
      expect(cubit.state.messages, isNotEmpty);
      expect(cubit.state.currentStepId, testScenario.initialStepId);
      expect(cubit.state.isTyping, isFalse);
      expect(cubit.state.isCompleted, isFalse);
      expect(cubit.state.score, 0);
    });

    test('selectChoice adds user message and advances to next step after timer', () async {
      final initialStep = testScenario.getStep(testScenario.initialStepId)!;
      final naturalChoice = initialStep.choices.firstWhere((c) => c.isNaturalChoice);

      cubit.selectChoice(naturalChoice);

      expect(cubit.state.isTyping, isTrue);
      expect(cubit.state.score, 1);
      expect(cubit.state.totalChoicesMade, 1);
      expect(cubit.state.lastFeedbackNote, naturalChoice.feedbackNoteRu);

      // Wait for the typing timer
      await Future<void>.delayed(const Duration(milliseconds: 800));

      expect(cubit.state.isTyping, isFalse);
      expect(cubit.state.currentStepId, naturalChoice.nextStepId);
    });

    test('voice notes play and stop correctly', () {
      final msg = testScenario.getStep('step_3')?.incomingMessages.firstWhere((m) => m.isVoiceNote);
      if (msg != null) {
        cubit.playVoiceNote(msg);

        expect(cubit.state.isPlayingVoiceNote, isTrue);
        expect(cubit.state.playingVoiceMessageId, msg.id);

        cubit.stopVoiceNote();
        expect(cubit.state.isPlayingVoiceNote, isFalse);
        expect(cubit.state.playingVoiceMessageId, isNull);
      }
    });

    test('showAbbreviation and clearAbbreviation manage state', () {
      const abbr = ChatAbbreviation(
        shortForm: 'vc',
        fullWordPt: 'você',
        translationRu: 'ты',
        explanationRu: 'Пояснение',
      );

      cubit.showAbbreviation(abbr);
      expect(cubit.state.selectedAbbreviation, abbr);

      cubit.clearAbbreviation();
      expect(cubit.state.selectedAbbreviation, isNull);
    });

    test('toggleTranslation switches showTranslation flag', () {
      expect(cubit.state.showTranslation, isTrue);
      cubit.toggleTranslation();
      expect(cubit.state.showTranslation, isFalse);
    });

    test('restartScenario resets conversation to initial step', () async {
      final initialStep = testScenario.getStep(testScenario.initialStepId)!;
      cubit.selectChoice(initialStep.choices.first);

      cubit.restartScenario();
      expect(cubit.state.currentStepId, testScenario.initialStepId);
      expect(cubit.state.score, 0);
      expect(cubit.state.isCompleted, isFalse);
    });
  });
}
