import 'package:equatable/equatable.dart';
import 'diary_analysis_entity.dart';

/// Сущность записи в бортовом дневнике.
class DiaryEntryEntity extends Equatable {
  final String id;
  final String? promptQuestionPt;
  final String? promptQuestionRu;
  final String contentPt;
  final String dialect; // 'pt_BR', 'pt_PT', 'neutral'
  final int wordCount;
  final String estimatedLevel;
  final String feedbackSummaryRu;
  final List<DiaryMistakeItem> mistakes;
  final DateTime createdAt;

  const DiaryEntryEntity({
    required this.id,
    this.promptQuestionPt,
    this.promptQuestionRu,
    required this.contentPt,
    required this.dialect,
    required this.wordCount,
    required this.estimatedLevel,
    required this.feedbackSummaryRu,
    required this.mistakes,
    required this.createdAt,
  });

  bool get isPtPt => dialect.toLowerCase().contains('pt');
  bool get isPtBr => dialect.toLowerCase().contains('br');

  String get dialectFlag => isPtPt ? '🇵🇹' : (isPtBr ? '🇧🇷' : '🌐');
  String get dialectLabel => isPtPt ? 'Portugal' : (isPtBr ? 'Brasil' : 'Geral');

  String get formattedDate {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }

  DiaryEntryEntity copyWith({
    String? id,
    String? promptQuestionPt,
    String? promptQuestionRu,
    String? contentPt,
    String? dialect,
    int? wordCount,
    String? estimatedLevel,
    String? feedbackSummaryRu,
    List<DiaryMistakeItem>? mistakes,
    DateTime? createdAt,
  }) {
    return DiaryEntryEntity(
      id: id ?? this.id,
      promptQuestionPt: promptQuestionPt ?? this.promptQuestionPt,
      promptQuestionRu: promptQuestionRu ?? this.promptQuestionRu,
      contentPt: contentPt ?? this.contentPt,
      dialect: dialect ?? this.dialect,
      wordCount: wordCount ?? this.wordCount,
      estimatedLevel: estimatedLevel ?? this.estimatedLevel,
      feedbackSummaryRu: feedbackSummaryRu ?? this.feedbackSummaryRu,
      mistakes: mistakes ?? this.mistakes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        promptQuestionPt,
        promptQuestionRu,
        contentPt,
        dialect,
        wordCount,
        estimatedLevel,
        feedbackSummaryRu,
        mistakes,
        createdAt,
      ];
}
