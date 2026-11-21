import 'package:equatable/equatable.dart';

enum VerbTense {
  presenteIndicativo('presente_indicativo', 'Presente do Indicativo', 'Настоящее время'),
  preteritoPerfeito('preterito_perfeito', 'Pretérito Perfeito', 'Прошедшее совершенное (fui, fiz)'),
  preteritoImperfeito('preterito_imperfeito', 'Pretérito Imperfeito', 'Прошедшее длительное (ia, fazia)'),
  futuroPresente('futuro_presente', 'Futuro do Presente', 'Будущее время (irei, farei)'),
  presenteSubjuntivo('presente_subjuntivo', 'Presente do Subjuntivo', 'Сослагательное наклонение (que eu vá)');

  final String id;
  final String labelPt;
  final String titleRu;

  const VerbTense(this.id, this.labelPt, this.titleRu);

  static VerbTense fromRaw(String raw) {
    for (final t in VerbTense.values) {
      if (t.id == raw) return t;
    }
    return VerbTense.presenteIndicativo;
  }
}

enum VerbPerson {
  eu('eu', 'Я'),
  tu('tu', 'Ты (PT-PT / юг BR)'),
  eleElaVoce('ele/ela/você', 'Он / Она / Вы (ед.ч.)'),
  nos('nós', 'Мы'),
  elesElasVoces('eles/elas/vocês', 'Они / Вы (мн.ч.)');

  final String raw;
  final String labelRu;

  const VerbPerson(this.raw, this.labelRu);

  String get pronounDisplay {
    switch (this) {
      case VerbPerson.eu:
        return 'Eu';
      case VerbPerson.tu:
        return 'Tu';
      case VerbPerson.eleElaVoce:
        return 'Ele / Ela / Você';
      case VerbPerson.nos:
        return 'Nós';
      case VerbPerson.elesElasVoces:
        return 'Eles / Elas / Vocês';
    }
  }

  static VerbPerson fromRaw(String raw) {
    final clean = raw.toLowerCase().trim();
    if (clean.contains('tu')) return VerbPerson.tu;
    if (clean.contains('nós') || clean.contains('nos')) return VerbPerson.nos;
    if (clean.contains('eles') || clean.contains('vocês') || clean.contains('voces')) {
      return VerbPerson.elesElasVoces;
    }
    if (clean.contains('ele') || clean.contains('ela') || clean.contains('você') || clean.contains('voce')) {
      return VerbPerson.eleElaVoce;
    }
    return VerbPerson.eu;
  }
}

class VerbExercise extends Equatable {
  final String id;
  final String verbId;
  final String infinitive;
  final String russianMeaning;
  final bool isIrregular;
  final VerbTense tense;
  final VerbPerson person;
  final String correctForm;
  final List<String> options;
  final String explanationRu;
  final String audioPhrase;

  const VerbExercise({
    required this.id,
    required this.verbId,
    required this.infinitive,
    required this.russianMeaning,
    required this.isIrregular,
    required this.tense,
    required this.person,
    required this.correctForm,
    required this.options,
    required this.explanationRu,
    required this.audioPhrase,
  });

  bool isCorrect(String option) =>
      option.trim().toLowerCase() == correctForm.trim().toLowerCase();

  @override
  List<Object?> get props => [
        id,
        verbId,
        infinitive,
        russianMeaning,
        isIrregular,
        tense,
        person,
        correctForm,
        options,
        explanationRu,
        audioPhrase,
      ];
}
