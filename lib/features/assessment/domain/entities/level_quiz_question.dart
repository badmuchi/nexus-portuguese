import 'package:equatable/equatable.dart';

enum CefrLevel {
  a1,
  a2,
  b1,
  b2;

  String get label {
    switch (this) {
      case CefrLevel.a1:
        return 'A1';
      case CefrLevel.a2:
        return 'A2';
      case CefrLevel.b1:
        return 'B1';
      case CefrLevel.b2:
        return 'B2';
    }
  }

  String get titleRu {
    switch (this) {
      case CefrLevel.a1:
        return 'Iniciante (A1)';
      case CefrLevel.a2:
        return 'Básico (A2)';
      case CefrLevel.b1:
        return 'Intermediário (B1)';
      case CefrLevel.b2:
        return 'Avançado (B2)';
    }
  }

  String get descriptionRu {
    switch (this) {
      case CefrLevel.a1:
        return 'Базовые фразы, приветствия, настоящее время глаголов (-ar, -er, -ir) и базовые предлоги.';
      case CefrLevel.a2:
        return 'Прошедшее время (Pretérito Perfeito), слияния предлогов (do, na, à crase) и повседневные диалоги.';
      case CefrLevel.b1:
        return 'Сложные времена (Imperfeito), сослагательное наклонение (Subjuntivo), косвенная речь и сленг.';
      case CefrLevel.b2:
        return 'Свободная беглая речь, тонкие нюансы между PT-BR и PT-PT, идиомы и сложные грамматические конструкции.';
    }
  }

  static CefrLevel fromString(String val) {
    switch (val.toUpperCase()) {
      case 'A1':
        return CefrLevel.a1;
      case 'A2':
        return CefrLevel.a2;
      case 'B1':
        return CefrLevel.b1;
      case 'B2':
        return CefrLevel.b2;
      default:
        return CefrLevel.a1;
    }
  }
}

enum SkillFocus {
  grammar,
  prepositions,
  vocabulary,
  listening,
  dialects;

  String get titleRu {
    switch (this) {
      case SkillFocus.grammar:
        return 'Грамматика и спряжения';
      case SkillFocus.prepositions:
        return 'Предлоги и слияния (Crase)';
      case SkillFocus.vocabulary:
        return 'Лексика и контекст';
      case SkillFocus.listening:
        return 'Восприятие на слух';
      case SkillFocus.dialects:
        return 'Диалекты (PT-BR vs PT-PT)';
    }
  }

  static SkillFocus fromString(String val) {
    switch (val.toLowerCase()) {
      case 'grammar':
        return SkillFocus.grammar;
      case 'prepositions':
        return SkillFocus.prepositions;
      case 'vocabulary':
        return SkillFocus.vocabulary;
      case 'listening':
        return SkillFocus.listening;
      case 'dialects':
        return SkillFocus.dialects;
      default:
        return SkillFocus.grammar;
    }
  }
}

class LevelQuizQuestion extends Equatable {
  final String id;
  final CefrLevel level;
  final SkillFocus skill;
  final String prompt;
  final String? audioText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanationRu;
  final String? targetWordForFsrs;
  final String? targetWordTranslationRu;
  final String dialect;

  const LevelQuizQuestion({
    required this.id,
    required this.level,
    required this.skill,
    required this.prompt,
    this.audioText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanationRu,
    this.targetWordForFsrs,
    this.targetWordTranslationRu,
    this.dialect = 'all',
  });

  bool isCorrect(int selectedIndex) => selectedIndex == correctOptionIndex;

  @override
  List<Object?> get props => [
        id,
        level,
        skill,
        prompt,
        audioText,
        options,
        correctOptionIndex,
        explanationRu,
        targetWordForFsrs,
        targetWordTranslationRu,
        dialect,
      ];
}
