import 'package:equatable/equatable.dart';

/// Сущность отдельной строки песни в синхронизированном караоке.
class SongLyricLine extends Equatable {
  final String id;
  final int index;
  final int startTimeMs;
  final int endTimeMs;
  final String textPt;
  final String translationRu;
  final String? poeticNoteRu;
  final String? targetMissingWord;
  final List<String> quizOptions;

  const SongLyricLine({
    required this.id,
    required this.index,
    required this.startTimeMs,
    required this.endTimeMs,
    required this.textPt,
    required this.translationRu,
    this.poeticNoteRu,
    this.targetMissingWord,
    this.quizOptions = const [],
  });

  int get durationMs => (endTimeMs - startTimeMs).clamp(0, 1000000);

  String get maskedTextPt {
    if (targetMissingWord == null || targetMissingWord!.isEmpty) {
      return textPt;
    }
    return textPt.replaceAll(
      RegExp(RegExp.escape(targetMissingWord!), caseSensitive: false),
      '_______',
    );
  }

  String get formattedTime {
    final totalSec = startTimeMs ~/ 1000;
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
        id,
        index,
        startTimeMs,
        endTimeMs,
        textPt,
        translationRu,
        poeticNoteRu,
        targetMissingWord,
        quizOptions,
      ];
}
