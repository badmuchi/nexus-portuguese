import 'package:equatable/equatable.dart';

class MinimalPairItem extends Equatable {
  final String wordA;
  final String ipaA;
  final String meaningARu;
  final String wordB;
  final String ipaB;
  final String meaningBRu;
  final String distinctionNote;

  const MinimalPairItem({
    required this.wordA,
    required this.ipaA,
    required this.meaningARu,
    required this.wordB,
    required this.ipaB,
    required this.meaningBRu,
    required this.distinctionNote,
  });

  factory MinimalPairItem.fromJson(Map<String, dynamic> json) {
    return MinimalPairItem(
      wordA: json['word_a'] as String? ?? '',
      ipaA: json['ipa_a'] as String? ?? '',
      meaningARu: json['meaning_a_ru'] as String? ?? '',
      wordB: json['word_b'] as String? ?? '',
      ipaB: json['ipa_b'] as String? ?? '',
      meaningBRu: json['meaning_b_ru'] as String? ?? '',
      distinctionNote: json['distinction_note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word_a': wordA,
      'ipa_a': ipaA,
      'meaning_a_ru': meaningARu,
      'word_b': wordB,
      'ipa_b': ipaB,
      'meaning_b_ru': meaningBRu,
      'distinction_note': distinctionNote,
    };
  }

  @override
  List<Object?> get props => [
        wordA,
        ipaA,
        meaningARu,
        wordB,
        ipaB,
        meaningBRu,
        distinctionNote,
      ];
}

class DialectComparison extends Equatable {
  final String word;
  final String meaningRu;
  final String noteBr;
  final String notePt;

  const DialectComparison({
    required this.word,
    required this.meaningRu,
    required this.noteBr,
    required this.notePt,
  });

  factory DialectComparison.fromJson(Map<String, dynamic> json) {
    return DialectComparison(
      word: json['word'] as String? ?? '',
      meaningRu: json['meaning_ru'] as String? ?? '',
      noteBr: json['note_br'] as String? ?? '',
      notePt: json['note_pt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'meaning_ru': meaningRu,
      'note_br': noteBr,
      'note_pt': notePt,
    };
  }

  @override
  List<Object?> get props => [word, meaningRu, noteBr, notePt];
}

class PhoneticExercise extends Equatable {
  final String soundId;
  final String soundCategory;
  final String title;
  final String ipa;
  final String tipPt;
  final String tipRu;
  final List<MinimalPairItem> contrastPairs;
  final DialectComparison dialectComparison;

  const PhoneticExercise({
    required this.soundId,
    required this.soundCategory,
    required this.title,
    required this.ipa,
    required this.tipPt,
    required this.tipRu,
    required this.contrastPairs,
    required this.dialectComparison,
  });

  factory PhoneticExercise.fromJson(Map<String, dynamic> json) {
    final pairsRaw = (json['contrast_pairs'] as List<dynamic>?) ?? [];
    return PhoneticExercise(
      soundId: json['sound_id'] as String? ?? '',
      soundCategory: json['sound_category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      ipa: json['ipa'] as String? ?? '',
      tipPt: json['tip_pt'] as String? ?? '',
      tipRu: json['tip_ru'] as String? ?? '',
      contrastPairs: pairsRaw
          .map((e) => MinimalPairItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      dialectComparison: DialectComparison.fromJson(
        (json['dialect_comparison'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [
        soundId,
        soundCategory,
        title,
        ipa,
        tipPt,
        tipRu,
        contrastPairs,
        dialectComparison,
      ];
}

class PhoneticMastery extends Equatable {
  final String soundId;
  final String soundCategory;
  final String title;
  final double masteryScore;
  final int earAttempts;
  final int earCorrect;
  final int mouthAttempts;
  final double mouthScoreSum;
  final DateTime? lastPracticedAt;

  const PhoneticMastery({
    required this.soundId,
    required this.soundCategory,
    required this.title,
    required this.masteryScore,
    required this.earAttempts,
    required this.earCorrect,
    required this.mouthAttempts,
    required this.mouthScoreSum,
    this.lastPracticedAt,
  });

  double get earAccuracyPercent =>
      earAttempts > 0 ? (earCorrect / earAttempts) * 100 : 0.0;

  double get mouthAccuracyAverage =>
      mouthAttempts > 0 ? (mouthScoreSum / mouthAttempts) : 0.0;

  @override
  List<Object?> get props => [
        soundId,
        soundCategory,
        title,
        masteryScore,
        earAttempts,
        earCorrect,
        mouthAttempts,
        mouthScoreSum,
        lastPracticedAt,
      ];
}
