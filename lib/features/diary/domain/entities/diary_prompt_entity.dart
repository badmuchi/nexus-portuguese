import 'package:equatable/equatable.dart';

/// Тема/вопрос дня для вдохновения на запись в дневнике.
class DiaryPrompt extends Equatable {
  final String id;
  final String questionPt;
  final String questionRu;
  final List<String> hintWords;
  final String category;
  final String difficultyCefr;

  const DiaryPrompt({
    required this.id,
    required this.questionPt,
    required this.questionRu,
    required this.hintWords,
    required this.category,
    required this.difficultyCefr,
  });

  @override
  List<Object?> get props => [
        id,
        questionPt,
        questionRu,
        hintWords,
        category,
        difficultyCefr,
      ];
}
