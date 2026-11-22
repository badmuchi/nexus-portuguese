import 'package:equatable/equatable.dart';
import 'portuguese_idiom_entity.dart';

/// Интерактивный вопрос квиза на проверку знания идиомы.
class IdiomQuizChallenge extends Equatable {
  final String id;
  final PortugueseIdiom idiom;
  final String questionRu;
  final List<String> optionsRu;
  final int correctIndex;

  const IdiomQuizChallenge({
    required this.id,
    required this.idiom,
    required this.questionRu,
    required this.optionsRu,
    required this.correctIndex,
  });

  bool checkAnswer(int selectedIndex) => selectedIndex == correctIndex;
  String get correctAnswer => optionsRu[correctIndex];

  @override
  List<Object?> get props => [
        id,
        idiom,
        questionRu,
        optionsRu,
        correctIndex,
      ];
}
