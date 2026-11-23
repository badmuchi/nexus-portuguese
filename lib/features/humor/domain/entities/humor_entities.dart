import 'package:equatable/equatable.dart';

enum JokeCategory {
  boteco, // Шутки у барной стойки, бытовой бразильский юмор
  alentejano, // Тонкий/абсурдный португальский юмор (Алентежу, Мануэл)
  trocadilho, // Игра слов, каламбуры
  meme, // Культурные и интернет-мемы
}

extension JokeCategoryExtension on JokeCategory {
  String get labelRu => switch (this) {
        JokeCategory.boteco => 'Piadas de Boteco 🍺',
        JokeCategory.alentejano => 'Humor Português 🇵🇹',
        JokeCategory.trocadilho => 'Trocadilhos & Каламбуры 🧩',
        JokeCategory.meme => 'Memes Lusófonos 📱',
      };

  String get shortName => switch (this) {
        JokeCategory.boteco => 'Барный юмор',
        JokeCategory.alentejano => 'Португальский',
        JokeCategory.trocadilho => 'Игра слов',
        JokeCategory.meme => 'Мемы',
      };
}

/// Словарный термин или сленг из анекдота для 1-tap FSRS.
class JokeVocabEntity extends Equatable {
  final String id;
  final String termPt;
  final String translationRu;
  final String explanationRu;

  const JokeVocabEntity({
    required this.id,
    required this.termPt,
    required this.translationRu,
    required this.explanationRu,
  });

  @override
  List<Object?> get props => [id, termPt, translationRu, explanationRu];
}

/// Анекдот или юмористическая сцена.
class JokeEntity extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final String setupPt; // Завязка
  final String setupRu;
  final String punchlinePt; // Панчлайн
  final String punchlineRu;
  final String explanationRu; // Почему это смешно (лингвокультурология)
  final JokeCategory category;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final int funLevel; // 1-3
  final List<JokeVocabEntity> vocabulary;

  const JokeEntity({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.setupPt,
    required this.setupRu,
    required this.punchlinePt,
    required this.punchlineRu,
    required this.explanationRu,
    required this.category,
    this.dialect = 'all',
    this.funLevel = 2,
    this.vocabulary = const [],
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      (dialect.toLowerCase().contains('pt') && !dialect.toLowerCase().contains('br'));

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : isPtBr ? '🇧🇷' : '🌐';
  String get dialectLabel => isPtPt ? 'Portugal' : isPtBr ? 'Brasil' : 'Luso';

  @override
  List<Object?> get props => [
        id,
        titlePt,
        titleRu,
        setupPt,
        setupRu,
        punchlinePt,
        punchlineRu,
        explanationRu,
        category,
        dialect,
        funLevel,
        vocabulary,
      ];
}

/// Игра слов / Загадка-каламбур.
class TrocadilhoEntity extends Equatable {
  final String id;
  final String questionPt;
  final String questionRu;
  final String answerPt;
  final String answerRu;
  final String wordplayExplanationRu;
  final String dialect;

  const TrocadilhoEntity({
    required this.id,
    required this.questionPt,
    required this.questionRu,
    required this.answerPt,
    required this.answerRu,
    required this.wordplayExplanationRu,
    this.dialect = 'all',
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      (dialect.toLowerCase().contains('pt') && !dialect.toLowerCase().contains('br'));

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : isPtBr ? '🇧🇷' : '🌐';

  @override
  List<Object?> get props => [
        id,
        questionPt,
        questionRu,
        answerPt,
        answerRu,
        wordplayExplanationRu,
        dialect,
      ];
}

/// Вопрос викторины "Закончи шутку" (Complete a piada).
class HumorQuizEntity extends Equatable {
  final String id;
  final String jokeSetupPt;
  final String jokeSetupRu;
  final List<String> optionsPt;
  final int correctOptionIndex;
  final String explanationRu;
  final String dialect;

  const HumorQuizEntity({
    required this.id,
    required this.jokeSetupPt,
    required this.jokeSetupRu,
    required this.optionsPt,
    required this.correctOptionIndex,
    required this.explanationRu,
    this.dialect = 'all',
  });

  String get correctPunchlinePt => optionsPt[correctOptionIndex];

  @override
  List<Object?> get props => [
        id,
        jokeSetupPt,
        jokeSetupRu,
        optionsPt,
        correctOptionIndex,
        explanationRu,
        dialect,
      ];
}
