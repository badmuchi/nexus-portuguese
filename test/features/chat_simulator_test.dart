import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/data/datasources/chat_simulator_seed_data.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/data/repositories/chat_simulator_repository_impl.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/domain/entities/chat_abbreviation_entity.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/domain/entities/chat_message_entity.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/domain/entities/chat_scenario_entity.dart';

void main() {
  group('Chat Simulator Entities & Seed Data Tests', () {
    test('ChatScenarioEntity dialect helpers detect PT-BR and PT-PT correctly', () {
      const brScenario = ChatScenarioEntity(
        id: 's_br',
        titlePt: 'iFood Entrega',
        titleRu: 'Доставка',
        channelName: 'iFood',
        contactName: 'Rodrigo',
        avatarEmoji: '🛵',
        dialect: 'pt_BR',
        cefrLevel: 'A2',
        scenarioContextRu: 'Контекст',
        initialStepId: 'step_1',
        steps: {},
      );

      expect(brScenario.isPtBr, isTrue);
      expect(brScenario.isPtPt, isFalse);
      expect(brScenario.dialectFlag, '🇧🇷');
      expect(brScenario.dialectLabel, 'Brasil');

      const ptScenario = ChatScenarioEntity(
        id: 's_pt',
        titlePt: 'Apartamento Lisboa',
        titleRu: 'Апартаменты',
        channelName: 'WhatsApp',
        contactName: 'João',
        avatarEmoji: '🇵🇹',
        dialect: 'pt_PT',
        cefrLevel: 'B1',
        scenarioContextRu: 'Контекст',
        initialStepId: 'step_1',
        steps: {},
      );

      expect(ptScenario.isPtPt, isTrue);
      expect(ptScenario.isPtBr, isFalse);
      expect(ptScenario.dialectFlag, '🇵🇹');
      expect(ptScenario.dialectLabel, 'Portugal');
    });

    test('ChatAbbreviation and ChatMessageEntity equality and properties', () {
      const abbr = ChatAbbreviation(
        shortForm: 'vc',
        fullWordPt: 'você',
        translationRu: 'ты',
        explanationRu: 'Частое сокращение',
      );

      expect(abbr.shortForm, 'vc');
      expect(abbr.fullWordPt, 'você');

      const msg = ChatMessageEntity(
        id: 'm1',
        senderId: 'contact',
        senderName: 'João',
        textPt: 'Olá vc!',
        translationRu: 'Привет ты!',
        isUser: false,
        timestampStr: '12:00',
        abbreviations: [abbr],
      );

      expect(msg.isUser, isFalse);
      expect(msg.abbreviations, contains(abbr));
    });

    test('ChatSimulatorSeedData contains 6 rich scenarios with valid step transitions', () {
      const scenarios = ChatSimulatorSeedData.scenarios;
      expect(scenarios.length, greaterThanOrEqualTo(6));

      for (final scenario in scenarios) {
        expect(scenario.id, isNotEmpty);
        expect(scenario.titlePt, isNotEmpty);
        expect(scenario.contactName, isNotEmpty);
        expect(scenario.steps, isNotEmpty);
        expect(scenario.steps.containsKey(scenario.initialStepId), isTrue,
            reason: 'Scenario ${scenario.id} must have step ${scenario.initialStepId}');

        // Validate that all choices lead to an existing step in the scenario
        for (final entry in scenario.steps.entries) {
          final step = entry.value;
          for (final choice in step.choices) {
            expect(scenario.steps.containsKey(choice.nextStepId), isTrue,
                reason: 'Step ${step.stepId} in scenario ${scenario.id} has choice linking to invalid step ${choice.nextStepId}');
          }
        }
      }
    });

    test('ChatSimulatorRepositoryImpl returns scenarios and filters by dialect', () async {
      final repo = ChatSimulatorRepositoryImpl();

      final allResult = await repo.getScenarios();
      expect(allResult.isOk, isTrue);
      expect(allResult.value.length, greaterThanOrEqualTo(6));

      final ptResult = await repo.getScenarios(dialect: 'pt_PT');
      expect(ptResult.isOk, isTrue);
      for (final s in ptResult.value) {
        expect(s.dialect, 'pt_PT');
      }

      final brResult = await repo.getScenarios(dialect: 'pt_BR');
      expect(brResult.isOk, isTrue);
      for (final s in brResult.value) {
        expect(s.dialect, 'pt_BR');
      }

      final singleResult = await repo.getScenarioById('lisboa_airbnb');
      expect(singleResult.isOk, isTrue);
      expect(singleResult.value.titlePt, 'Apartamento em Lisboa');
    });
  });
}
