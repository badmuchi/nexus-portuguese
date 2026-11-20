import 'package:equatable/equatable.dart';

class StoryParagraph extends Equatable {
  final String portuguese;
  final String russian;
  final List<String> words;

  const StoryParagraph({
    required this.portuguese,
    required this.russian,
    required this.words,
  });

  @override
  List<Object?> get props => [portuguese, russian, words];
}

class StoryEntity extends Equatable {
  final String id;
  final String titlePortuguese;
  final String titleRussian;
  final String dialect;
  final String level;
  final String coverIcon;
  final String description;
  final String contentJson;
  final List<StoryParagraph> paragraphs;

  const StoryEntity({
    required this.id,
    required this.titlePortuguese,
    required this.titleRussian,
    required this.dialect,
    required this.level,
    required this.coverIcon,
    required this.description,
    required this.contentJson,
    required this.paragraphs,
  });

  @override
  List<Object?> get props => [
        id,
        titlePortuguese,
        titleRussian,
        dialect,
        level,
        coverIcon,
        description,
        contentJson,
        paragraphs,
      ];
}
