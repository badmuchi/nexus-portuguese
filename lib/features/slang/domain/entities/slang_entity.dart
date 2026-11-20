import 'package:equatable/equatable.dart';

class SlangEntity extends Equatable {
  final String id;
  final String expression;
  final String literalTranslation;
  final String actualMeaning;
  final String dialect;
  final String originNotes;
  final String exampleSentence;
  final String exampleTranslation;

  const SlangEntity({
    required this.id,
    required this.expression,
    required this.literalTranslation,
    required this.actualMeaning,
    required this.dialect,
    required this.originNotes,
    required this.exampleSentence,
    required this.exampleTranslation,
  });

  @override
  List<Object?> get props => [
        id,
        expression,
        literalTranslation,
        actualMeaning,
        dialect,
        originNotes,
        exampleSentence,
        exampleTranslation,
      ];
}
