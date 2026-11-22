import 'package:equatable/equatable.dart';
import 'interview_question_entity.dart';

enum BusinessPhraseType {
  emailTemplate('Modelos de E-mail', 'Шаблоны деловых писем', '✉️'),
  cvActionVerb('Verbos de Ação para CV', 'Глаголы действий для резюме', '⚡'),
  interviewPitch('Elevator Pitch & Respostas', 'Самопрезентация и ответы', '🎤'),
  salaryNegotiation('Negociação Salarial', 'Переговоры о зарплате', '💰');

  final String labelPt;
  final String labelRu;
  final String emoji;

  const BusinessPhraseType(this.labelPt, this.labelRu, this.emoji);
}

/// Сущность деловой фразы, формулы письма или глагола для резюме.
class BusinessPhraseEntity extends Equatable {
  final String id;
  final String textPt;
  final String translationRu;
  final String contextNoteRu;
  final CareerCategory category;
  final BusinessPhraseType phraseType;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'

  const BusinessPhraseEntity({
    required this.id,
    required this.textPt,
    required this.translationRu,
    required this.contextNoteRu,
    required this.category,
    required this.phraseType,
    this.dialect = 'all',
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : isPtBr ? '🇧🇷' : '🌐';

  @override
  List<Object?> get props => [
        id,
        textPt,
        translationRu,
        contextNoteRu,
        category,
        phraseType,
        dialect,
      ];
}
