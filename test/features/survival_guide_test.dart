import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/survival_guide/data/datasources/survival_guide_seed_data.dart';
import 'package:nexus_portuguese_app/features/survival_guide/data/repositories/survival_guide_repository_impl.dart';
import 'package:nexus_portuguese_app/features/survival_guide/domain/entities/cultural_tip_entity.dart';
import 'package:nexus_portuguese_app/features/survival_guide/domain/entities/survival_phrase_entity.dart';
import 'package:nexus_portuguese_app/features/survival_guide/domain/entities/survival_quest_entity.dart';

void main() {
  group('Survival Guide Entities & Seed Data Tests', () {
    test('SurvivalQuestEntity dialect helpers detect PT-BR and PT-PT correctly', () {
      const ptQuest = SurvivalQuestEntity(
        id: 'q_pt',
        titlePt: 'NIF nas Finanças',
        titleRu: 'Оформление NIF',
        category: SurvivalCategory.bureaucracy,
        dialect: 'pt_PT',
        cefrLevel: 'A2',
        estimatedMinutes: 5,
        iconEmoji: '📋',
        overviewRu: 'Описание',
        steps: [],
      );

      expect(ptQuest.isPtPt, isTrue);
      expect(ptQuest.isPtBr, isFalse);
      expect(ptQuest.dialectFlag, '🇵🇹');
      expect(ptQuest.dialectLabel, 'Portugal');

      const brQuest = SurvivalQuestEntity(
        id: 'q_br',
        titlePt: 'CPF no Rio',
        titleRu: 'Оформление CPF',
        category: SurvivalCategory.bureaucracy,
        dialect: 'pt_BR',
        cefrLevel: 'A2',
        estimatedMinutes: 5,
        iconEmoji: '🇧🇷',
        overviewRu: 'Описание',
        steps: [],
      );

      expect(brQuest.isPtBr, isTrue);
      expect(brQuest.isPtPt, isFalse);
      expect(brQuest.dialectFlag, '🇧🇷');
      expect(brQuest.dialectLabel, 'Brasil');
    });

    test('SurvivalPhraseEntity and CulturalTipEntity properties and equality', () {
      const phrase = SurvivalPhraseEntity(
        id: 'p1',
        textPt: 'Vim pedir o NIF',
        translationRu: 'Пришел оформить NIF',
        contextNoteRu: 'На кассе',
        category: SurvivalCategory.bureaucracy,
        dialect: 'pt_PT',
        isEmergency: false,
      );

      expect(phrase.isPtPt, isTrue);
      expect(phrase.dialectFlag, '🇵🇹');

      const tip = CulturalTipEntity(
        id: 't1',
        titlePt: 'Gorjetas',
        titleRu: 'Чаевые',
        contentRu: 'В Португалии чаевые не обязательны',
        category: SurvivalCategory.banking,
        dialect: 'all',
        iconEmoji: '🪙',
        bulletPointsRu: ['Правило 1', 'Правило 2'],
      );

      expect(tip.dialectFlag, '🌐');
      expect(tip.bulletPointsRu.length, 2);
    });

    test('SurvivalGuideSeedData contains rich and valid quests, phrases, and tips', () {
      const quests = SurvivalGuideSeedData.quests;
      const phrases = SurvivalGuideSeedData.phrases;
      const tips = SurvivalGuideSeedData.tips;

      expect(quests.length, greaterThanOrEqualTo(4));
      expect(phrases.length, greaterThanOrEqualTo(15));
      expect(tips.length, greaterThanOrEqualTo(5));

      for (final quest in quests) {
        expect(quest.id, isNotEmpty);
        expect(quest.titlePt, isNotEmpty);
        expect(quest.steps, isNotEmpty);
        for (final step in quest.steps) {
          expect(step.promptPt, isNotEmpty);
          expect(step.options, isNotEmpty);
          expect(step.options.any((o) => o.isOptimal), isTrue,
              reason: 'Step ${step.id} in quest ${quest.id} must have at least one optimal option');
        }
      }
    });

    test('SurvivalGuideRepositoryImpl returns filtered quests, phrases, and tips', () async {
      final repo = SurvivalGuideRepositoryImpl();

      final questsRes = await repo.getQuests(category: SurvivalCategory.bureaucracy);
      expect(questsRes.isOk, isTrue);
      for (final q in questsRes.value) {
        expect(q.category, SurvivalCategory.bureaucracy);
      }

      final ptQuestsRes = await repo.getQuests(dialect: 'pt_PT');
      expect(ptQuestsRes.isOk, isTrue);
      for (final q in ptQuestsRes.value) {
        expect(q.dialect, 'pt_PT');
      }

      final singleQuestRes = await repo.getQuestById('quest_nif_lisboa');
      expect(singleQuestRes.isOk, isTrue);
      expect(singleQuestRes.value.titlePt, contains('NIF'));

      final emergRes = await repo.getPhrases(emergencyOnly: true);
      expect(emergRes.isOk, isTrue);
      for (final p in emergRes.value) {
        expect(p.isEmergency, isTrue);
      }

      final tipsRes = await repo.getTips(category: SurvivalCategory.bureaucracy);
      expect(tipsRes.isOk, isTrue);
      for (final t in tipsRes.value) {
        expect(t.category, SurvivalCategory.bureaucracy);
      }
    });
  });
}
