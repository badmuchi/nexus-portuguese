import 'package:equatable/equatable.dart';

enum SceneCategory {
  cafe(
    id: 'cafe',
    titleRu: 'Кафе и пастелария',
    emoji: '☕',
  ),
  beach(
    id: 'beach',
    titleRu: 'Пляж и киоск',
    emoji: '🏖️',
  ),
  supermarket(
    id: 'supermarket',
    titleRu: 'Супермаркет и рынок',
    emoji: '🛒',
  ),
  transport(
    id: 'transport',
    titleRu: 'Транспорт и билеты',
    emoji: '🚇',
  ),
  hotel(
    id: 'hotel',
    titleRu: 'Отель и аренда жилья',
    emoji: '🏨',
  ),
  pharmacy(
    id: 'pharmacy',
    titleRu: 'Аптека и здоровье',
    emoji: '💊',
  );

  const SceneCategory({
    required this.id,
    required this.titleRu,
    required this.emoji,
  });

  final String id;
  final String titleRu;
  final String emoji;
}

final class SceneWord extends Equatable {
  final String id;
  final String portuguese;
  final String ipa;
  final String russianMeaning;
  final String? contextNote;
  final String? gender;
  final String dialectTag;
  final String? audioPath;

  const SceneWord({
    required this.id,
    required this.portuguese,
    required this.ipa,
    required this.russianMeaning,
    this.contextNote,
    this.gender,
    this.dialectTag = 'all',
    this.audioPath,
  });

  @override
  List<Object?> get props => [
        id,
        portuguese,
        ipa,
        russianMeaning,
        contextNote,
        gender,
        dialectTag,
        audioPath,
      ];
}

enum PhraseRole {
  theySay(labelRu: 'Вам скажут 👂', isIncoming: true),
  youSay(labelRu: 'Вы ответите 🗣️', isIncoming: false);

  const PhraseRole({required this.labelRu, required this.isIncoming});
  final String labelRu;
  final bool isIncoming;
}

final class ScenePhrase extends Equatable {
  final String id;
  final PhraseRole role;
  final String portuguese;
  final String russianTranslation;
  final String dialectTag;
  final String? pronunciationTip;

  const ScenePhrase({
    required this.id,
    required this.role,
    required this.portuguese,
    required this.russianTranslation,
    this.dialectTag = 'all',
    this.pronunciationTip,
  });

  @override
  List<Object?> get props => [
        id,
        role,
        portuguese,
        russianTranslation,
        dialectTag,
        pronunciationTip,
      ];
}

final class SceneChallenge extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanationRu;

  const SceneChallenge({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanationRu,
  });

  @override
  List<Object?> get props => [
        id,
        question,
        options,
        correctIndex,
        explanationRu,
      ];
}

final class CulturalTip extends Equatable {
  final String title;
  final String bodyRu;
  final String countryFlag;

  const CulturalTip({
    required this.title,
    required this.bodyRu,
    required this.countryFlag,
  });

  @override
  List<Object?> get props => [title, bodyRu, countryFlag];
}

final class PortugueseLifeScene extends Equatable {
  final String id;
  final SceneCategory category;
  final String titlePt;
  final String titleRu;
  final String locationTag;
  final String description;
  final CulturalTip culturalTip;
  final List<SceneWord> words;
  final List<ScenePhrase> phrases;
  final List<SceneChallenge> challenges;

  const PortugueseLifeScene({
    required this.id,
    required this.category,
    required this.titlePt,
    required this.titleRu,
    required this.locationTag,
    required this.description,
    required this.culturalTip,
    required this.words,
    required this.phrases,
    required this.challenges,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        titlePt,
        titleRu,
        locationTag,
        description,
        culturalTip,
        words,
        phrases,
        challenges,
      ];
}

final class SceneProgressEntity extends Equatable {
  final String sceneId;
  final int completedChallengesCount;
  final int totalChallengesCount;
  final bool isCompleted;
  final DateTime lastVisitedAt;

  const SceneProgressEntity({
    required this.sceneId,
    required this.completedChallengesCount,
    required this.totalChallengesCount,
    required this.isCompleted,
    required this.lastVisitedAt,
  });

  double get progressPercent => totalChallengesCount > 0
      ? (completedChallengesCount / totalChallengesCount).clamp(0.0, 1.0)
      : (isCompleted ? 1.0 : 0.0);

  @override
  List<Object?> get props => [
        sceneId,
        completedChallengesCount,
        totalChallengesCount,
        isCompleted,
        lastVisitedAt,
      ];
}
