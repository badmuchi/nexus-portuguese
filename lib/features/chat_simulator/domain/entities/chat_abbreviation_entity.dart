import 'package:equatable/equatable.dart';

/// Сущность интернет-сокращения или SMS-сленга в португальском языке.
class ChatAbbreviation extends Equatable {
  final String shortForm;       // 'vc', 'tbm', 'blz', 'fds'
  final String fullWordPt;      // 'você', 'também', 'beleza', 'fim de semana'
  final String translationRu;   // 'ты', 'тоже', 'ладно/ок', 'выходные'
  final String explanationRu;   // Подробный контекст использования
  final String dialect;         // 'pt_BR', 'pt_PT', 'all'

  const ChatAbbreviation({
    required this.shortForm,
    required this.fullWordPt,
    required this.translationRu,
    required this.explanationRu,
    this.dialect = 'all',
  });

  @override
  List<Object?> get props => [
        shortForm,
        fullWordPt,
        translationRu,
        explanationRu,
        dialect,
      ];
}
