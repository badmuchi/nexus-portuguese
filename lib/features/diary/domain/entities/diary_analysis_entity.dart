import 'package:equatable/equatable.dart';

class DiaryMistakeItem extends Equatable {
  final String originalText;
  final String suggestedText;
  final String ruleExplanationRu;
  final String type; // 'accent', 'contraction', 'gender', 'spelling', 'grammar'

  const DiaryMistakeItem({
    required this.originalText,
    required this.suggestedText,
    required this.ruleExplanationRu,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'originalText': originalText,
        'suggestedText': suggestedText,
        'ruleExplanationRu': ruleExplanationRu,
        'type': type,
      };

  factory DiaryMistakeItem.fromJson(Map<String, dynamic> json) => DiaryMistakeItem(
        originalText: json['originalText'] as String? ?? '',
        suggestedText: json['suggestedText'] as String? ?? '',
        ruleExplanationRu: json['ruleExplanationRu'] as String? ?? '',
        type: json['type'] as String? ?? 'grammar',
      );

  @override
  List<Object?> get props => [
        originalText,
        suggestedText,
        ruleExplanationRu,
        type,
      ];
}

class DiaryAnalysisResult extends Equatable {
  final int wordCount;
  final int uniqueWordCount;
  final String detectedDialect; // 'pt_BR', 'pt_PT', 'neutral'
  final String dialectNotesRu;
  final String estimatedLevel; // 'A1', 'A2', 'B1', 'B2'
  final String feedbackSummaryRu;
  final List<DiaryMistakeItem> mistakes;
  final List<String> suggestedSrsWords;

  const DiaryAnalysisResult({
    required this.wordCount,
    required this.uniqueWordCount,
    required this.detectedDialect,
    required this.dialectNotesRu,
    required this.estimatedLevel,
    required this.feedbackSummaryRu,
    required this.mistakes,
    required this.suggestedSrsWords,
  });

  bool get hasMistakes => mistakes.isNotEmpty;

  @override
  List<Object?> get props => [
        wordCount,
        uniqueWordCount,
        detectedDialect,
        dialectNotesRu,
        estimatedLevel,
        feedbackSummaryRu,
        mistakes,
        suggestedSrsWords,
      ];
}
