import 'package:equatable/equatable.dart';

enum CareerCategory {
  tech('Tecnologia & TI', 'IT и разработка', '💻', 0xFF1976D2),
  sales('Vendas & Comercial', 'Продажи и развитие бизнеса', '📈', 0xFFE64A19),
  hospitality('Hotelaria & Turismo', 'Гостиничный бизнес и сервис', '🏨', 0xFF00796B),
  marketing('Marketing & Mídias', 'Маркетинг и коммуникации', '📢', 0xFF7B1FA2),
  general('Geral & RH', 'Общие вопросы и HR-этикет', '🤝', 0xFF388E3C);

  final String labelPt;
  final String labelRu;
  final String emoji;
  final int colorHex;

  const CareerCategory(this.labelPt, this.labelRu, this.emoji, this.colorHex);
}

/// Вариант ответа соискателя на вопрос интервьюера.
class InterviewAnswerOption extends Equatable {
  final String textPt;
  final String translationRu;
  final bool isStrong; // Является ли ответ сильным, структурированным (STAR)
  final String hrFeedbackRu; // Разбор ответа глазами рекрутера/нанимающего менеджера
  final int points;

  const InterviewAnswerOption({
    required this.textPt,
    required this.translationRu,
    required this.isStrong,
    required this.hrFeedbackRu,
    this.points = 10,
  });

  @override
  List<Object?> get props => [
        textPt,
        translationRu,
        isStrong,
        hrFeedbackRu,
        points,
      ];
}

/// Вопрос интервьюера в процессе собеседования.
class InterviewQuestionEntity extends Equatable {
  final String id;
  final String interviewerRole; // 'Recrutadora de RH', 'Tech Lead', 'Diretor Comercial'
  final String questionPt;
  final String questionRu;
  final String hrInsightRu; // Что рекрутер на самом деле оценивает этим вопросом
  final List<InterviewAnswerOption> options;

  const InterviewQuestionEntity({
    required this.id,
    required this.interviewerRole,
    required this.questionPt,
    required this.questionRu,
    required this.hrInsightRu,
    required this.options,
  });

  @override
  List<Object?> get props => [
        id,
        interviewerRole,
        questionPt,
        questionRu,
        hrInsightRu,
        options,
      ];
}
