import 'package:equatable/equatable.dart';

class SrsCardEntity extends Equatable {
  final String id;
  final String portuguese;
  final String russianTranslation;
  final String partOfSpeech;
  final String category;
  final String dialect;
  final String? examplePortuguese;
  final String? exampleRussian;
  final String? audioUrl;
  final String? notes;
  final String fsrsState;
  final double stability;
  final double difficulty;
  final int reps;
  final int lapses;
  final DateTime dueAt;
  final DateTime? lastReviewedAt;

  const SrsCardEntity({
    required this.id,
    required this.portuguese,
    required this.russianTranslation,
    required this.partOfSpeech,
    required this.category,
    required this.dialect,
    this.examplePortuguese,
    this.exampleRussian,
    this.audioUrl,
    this.notes,
    required this.fsrsState,
    required this.stability,
    required this.difficulty,
    required this.reps,
    required this.lapses,
    required this.dueAt,
    this.lastReviewedAt,
  });

  @override
  List<Object?> get props => [
        id,
        portuguese,
        russianTranslation,
        partOfSpeech,
        category,
        dialect,
        examplePortuguese,
        exampleRussian,
        audioUrl,
        notes,
        fsrsState,
        stability,
        difficulty,
        reps,
        lapses,
        dueAt,
        lastReviewedAt,
      ];
}
