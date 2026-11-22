import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/career/data/datasources/career_seed_data.dart';
import 'package:nexus_portuguese_app/features/career/data/repositories/career_repository_impl.dart';
import 'package:nexus_portuguese_app/features/career/domain/entities/business_phrase_entity.dart';
import 'package:nexus_portuguese_app/features/career/domain/entities/cv_guide_item_entity.dart';
import 'package:nexus_portuguese_app/features/career/domain/entities/interview_question_entity.dart';
import 'package:nexus_portuguese_app/features/career/domain/entities/interview_scenario_entity.dart';

void main() {
  group('Career Entities & Models Tests', () {
    test('InterviewScenarioEntity dialect helpers detect PT-BR and PT-PT correctly', () {
      const ptScenario = InterviewScenarioEntity(
        id: 'it_lisbon',
        jobTitlePt: 'Engenheiro de Software',
        jobTitleRu: 'Инженер-программист',
        companyName: 'Scale-up em Lisboa',
        category: CareerCategory.tech,
        dialect: 'pt_PT',
        cefrLevel: 'B1',
        workModel: 'Híbrido',
        salaryContextRu: '€35.000 - €48.000 brutos anuais + 14 meses',
        iconEmoji: '💻',
        questions: [],
      );

      expect(ptScenario.isPtPt, isTrue);
      expect(ptScenario.isPtBr, isFalse);
      expect(ptScenario.dialectFlag, '🇵🇹');
      expect(ptScenario.dialectLabel, 'Portugal');
      expect(ptScenario.maxScore, 0);

      const brScenario = InterviewScenarioEntity(
        id: 'sales_sp',
        jobTitlePt: 'Gerente de Contas',
        jobTitleRu: 'Менеджер по работе с клиентами',
        companyName: 'Multinacional em SP',
        category: CareerCategory.sales,
        dialect: 'pt_BR',
        cefrLevel: 'B2',
        workModel: 'Presencial',
        salaryContextRu: 'R\$ 12.000 CLT + comissões',
        iconEmoji: '📈',
        questions: [],
      );

      expect(brScenario.isPtBr, isTrue);
      expect(brScenario.isPtPt, isFalse);
      expect(brScenario.dialectFlag, '🇧🇷');
      expect(brScenario.dialectLabel, 'Brasil');
    });

    test('InterviewScenarioEntity maxScore calculates 10 points per question', () {
      const scenarioWithQuestions = InterviewScenarioEntity(
        id: 'test_sc',
        jobTitlePt: 'Developer',
        jobTitleRu: 'Разработчик',
        companyName: 'Tech',
        category: CareerCategory.tech,
        dialect: 'pt_PT',
        cefrLevel: 'B1',
        workModel: 'Remoto',
        salaryContextRu: 'Salary info',
        iconEmoji: '💻',
        questions: [
          InterviewQuestionEntity(
            id: 'q1',
            interviewerRole: 'Recrutadora de RH',
            questionPt: 'Conte sobre você',
            questionRu: 'Расскажите о себе',
            hrInsightRu: 'Оценка самопрезентации',
            options: [
              InterviewAnswerOption(
                textPt: 'Opção 1',
                translationRu: 'Опция 1',
                hrFeedbackRu: 'Слабо',
                points: 3,
                isStrong: false,
              ),
              InterviewAnswerOption(
                textPt: 'Opção 2',
                translationRu: 'Опция 2',
                hrFeedbackRu: 'Отлично',
                points: 10,
                isStrong: true,
              ),
            ],
          ),
          InterviewQuestionEntity(
            id: 'q2',
            interviewerRole: 'Tech Director',
            questionPt: 'Qual sua maior fraqueza?',
            questionRu: 'Ваша слабость?',
            hrInsightRu: 'Покажите работу над ошибками',
            options: [
              InterviewAnswerOption(
                textPt: 'Opção 1',
                translationRu: 'Опция 1',
                hrFeedbackRu: 'Великолепно',
                points: 10,
                isStrong: true,
              ),
              InterviewAnswerOption(
                textPt: 'Opção 2',
                translationRu: 'Опция 2',
                hrFeedbackRu: 'Приемлемо',
                points: 6,
                isStrong: false,
              ),
            ],
          ),
        ],
      );

      expect(scenarioWithQuestions.maxScore, 20);
    });

    test('BusinessPhraseEntity properties and dialect helpers', () {
      const phrase = BusinessPhraseEntity(
        id: 'ph_1',
        textPt: 'Segue em anexo o meu currículo atualizado.',
        translationRu: 'Во вложении направляю обновленное резюме.',
        contextNoteRu: 'Стандартная фраза для отклика по email.',
        category: CareerCategory.general,
        phraseType: BusinessPhraseType.emailTemplate,
        dialect: 'all',
      );

      expect(phrase.dialectFlag, '🌐');
      expect(phrase.phraseType, BusinessPhraseType.emailTemplate);
    });

    test('CvGuideItemEntity properties and bullet points', () {
      const guide = CvGuideItemEntity(
        id: 'cv_pt',
        sectionTitleRu: 'Резюме для Португалии и ЕС',
        sectionTitlePt: 'Currículo Europass vs Modelo Moderno',
        dialect: 'pt_PT',
        iconEmoji: '🇵🇹',
        explanationRu: 'Особенности рынка Португалии',
        examplePt: 'Experiência Profissional: Responsável pela otimização...',
        tipsListRu: [
          'Не прикрепляйте фото, если не просят специально',
          'Указывайте знание языков по CEFR (A1-C2)',
        ],
      );

      expect(guide.tipsListRu.length, 2);
      expect(guide.isPtPt, isTrue);
      expect(guide.dialectFlag, '🇵🇹');
    });
  });

  group('CareerSeedData Verification Tests', () {
    test('CareerSeedData scenarios contain valid questions with positive points and STAR feedback', () {
      expect(CareerSeedData.scenarios, isNotEmpty);

      for (final sc in CareerSeedData.scenarios) {
        expect(sc.id, isNotEmpty);
        expect(sc.jobTitleRu, isNotEmpty);
        expect(sc.salaryContextRu, isNotEmpty);
        expect(sc.questions, isNotEmpty);

        for (final q in sc.questions) {
          expect(q.id, isNotEmpty);
          expect(q.questionPt, isNotEmpty);
          expect(q.questionRu, isNotEmpty);
          expect(q.options.length, greaterThanOrEqualTo(2));

          // Must have at least one strong answer with high points
          final strongOptions = q.options.where((o) => o.isStrong).toList();
          expect(strongOptions, isNotEmpty);

          for (final opt in q.options) {
            expect(opt.textPt, isNotEmpty);
            expect(opt.translationRu, isNotEmpty);
            expect(opt.hrFeedbackRu, isNotEmpty);
            expect(opt.points, greaterThanOrEqualTo(0));
          }
        }
      }
    });

    test('CareerSeedData phrases contain diverse business types', () {
      expect(CareerSeedData.phrases, isNotEmpty);

      final types = CareerSeedData.phrases.map((p) => p.phraseType).toSet();
      expect(types.contains(BusinessPhraseType.emailTemplate), isTrue);
      expect(types.contains(BusinessPhraseType.cvActionVerb), isTrue);
      expect(types.contains(BusinessPhraseType.interviewPitch), isTrue);
      expect(types.contains(BusinessPhraseType.salaryNegotiation), isTrue);
    });

    test('CareerSeedData cvGuides contain tips and examples for both BR and PT', () {
      expect(CareerSeedData.cvGuides, isNotEmpty);

      final hasPt = CareerSeedData.cvGuides.any((g) => g.dialect == 'pt_PT');
      final hasBr = CareerSeedData.cvGuides.any((g) => g.dialect == 'pt_BR');
      expect(hasPt, isTrue);
      expect(hasBr, isTrue);

      for (final g in CareerSeedData.cvGuides) {
        expect(g.sectionTitleRu, isNotEmpty);
        expect(g.tipsListRu, isNotEmpty);
      }
    });
  });

  group('CareerRepositoryImpl Tests', () {
    final repo = CareerRepositoryImpl();

    test('getScenarios returns all scenarios or filters by category and dialect', () async {
      final allRes = await repo.getScenarios();
      expect(allRes.isOk, isTrue);
      expect(allRes.value.length, CareerSeedData.scenarios.length);

      final techRes = await repo.getScenarios(category: CareerCategory.tech);
      expect(techRes.isOk, isTrue);
      for (final sc in techRes.value) {
        expect(sc.category, CareerCategory.tech);
      }

      final ptRes = await repo.getScenarios(dialect: 'pt_PT');
      expect(ptRes.isOk, isTrue);
      for (final sc in ptRes.value) {
        expect(sc.dialect, 'pt_PT');
      }
    });

    test('getScenarioById returns valid scenario or error', () async {
      final first = CareerSeedData.scenarios.first;
      final res = await repo.getScenarioById(first.id);
      expect(res.isOk, isTrue);
      expect(res.value.id, first.id);

      final notFound = await repo.getScenarioById('non_existent_id');
      expect(notFound.isFailure, isTrue);
    });

    test('getPhrases returns filtered phrases', () async {
      final allPhrases = await repo.getPhrases();
      expect(allPhrases.isOk, isTrue);
      expect(allPhrases.value.length, CareerSeedData.phrases.length);

      final emailPhrases = await repo.getPhrases(phraseType: BusinessPhraseType.emailTemplate);
      expect(emailPhrases.isOk, isTrue);
      for (final p in emailPhrases.value) {
        expect(p.phraseType, BusinessPhraseType.emailTemplate);
      }
    });

    test('getCvGuides returns guides', () async {
      final guides = await repo.getCvGuides();
      expect(guides.isOk, isTrue);
      expect(guides.value.length, CareerSeedData.cvGuides.length);
    });

    test('recordInterviewCompleted handles null database safely', () async {
      final res = await repo.recordInterviewCompleted(
        scenarioId: 'test_sc',
        score: 25,
        maxScore: 30,
      );
      expect(res.isOk, isTrue);
    });
  });
}
