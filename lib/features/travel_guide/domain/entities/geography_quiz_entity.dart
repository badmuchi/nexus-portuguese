import 'package:equatable/equatable.dart';

/// Вопрос географического квиза «Passaporte Lusófono».
class GeographyQuizQuestion extends Equatable {
  final String id;
  final String questionPt;
  final String questionRu;
  final List<String> optionsPt;
  final List<String> optionsRu;
  final int correctOptionIndex;
  final String explanationRu;
  final String countryId;
  final String flagEmoji;

  const GeographyQuizQuestion({
    required this.id,
    required this.questionPt,
    required this.questionRu,
    required this.optionsPt,
    required this.optionsRu,
    required this.correctOptionIndex,
    required this.explanationRu,
    required this.countryId,
    required this.flagEmoji,
  });

  @override
  List<Object?> get props => [
        id,
        questionPt,
        questionRu,
        optionsPt,
        optionsRu,
        correctOptionIndex,
        explanationRu,
        countryId,
        flagEmoji,
      ];
}
