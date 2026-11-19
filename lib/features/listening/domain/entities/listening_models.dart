import 'package:equatable/equatable.dart';

class ListeningExerciseEntity extends Equatable {
  final String id;
  final String transcript;
  final String russianTranslation;
  final String? audioUrl;
  final String difficulty;
  final List<String> focusWords;
  final String dialect;

  const ListeningExerciseEntity({
    required this.id,
    required this.transcript,
    required this.russianTranslation,
    this.audioUrl,
    required this.difficulty,
    required this.focusWords,
    required this.dialect,
  });

  @override
  List<Object?> get props => [
        id,
        transcript,
        russianTranslation,
        audioUrl,
        difficulty,
        focusWords,
        dialect,
      ];
}
