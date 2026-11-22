import 'package:equatable/equatable.dart';

/// Сущность отдельного предложения/фрагмента в синхронизированной транскрипции подкаста.
class TranscriptSnippet extends Equatable {
  final String id;
  final int index;
  final int startTimeMs;
  final int endTimeMs;
  final String textPt;
  final String translationRu;
  final String? speaker;
  final String? culturalNote;

  const TranscriptSnippet({
    required this.id,
    required this.index,
    required this.startTimeMs,
    required this.endTimeMs,
    required this.textPt,
    required this.translationRu,
    this.speaker,
    this.culturalNote,
  });

  int get durationMs => (endTimeMs - startTimeMs).clamp(0, 1000000);

  String get formattedStartTime {
    final totalSeconds = startTimeMs ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  TranscriptSnippet copyWith({
    String? id,
    int? index,
    int? startTimeMs,
    int? endTimeMs,
    String? textPt,
    String? translationRu,
    String? speaker,
    String? culturalNote,
  }) {
    return TranscriptSnippet(
      id: id ?? this.id,
      index: index ?? this.index,
      startTimeMs: startTimeMs ?? this.startTimeMs,
      endTimeMs: endTimeMs ?? this.endTimeMs,
      textPt: textPt ?? this.textPt,
      translationRu: translationRu ?? this.translationRu,
      speaker: speaker ?? this.speaker,
      culturalNote: culturalNote ?? this.culturalNote,
    );
  }

  @override
  List<Object?> get props => [
        id,
        index,
        startTimeMs,
        endTimeMs,
        textPt,
        translationRu,
        speaker,
        culturalNote,
      ];
}
