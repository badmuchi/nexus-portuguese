import 'dart:math';
import '../../../grammar/domain/entities/grammar_verb_entity.dart';
import '../../domain/entities/verb_exercise.dart';
import '../../domain/entities/verb_trainer_config.dart';

class VerbExerciseGenerator {
  final Random _random;

  VerbExerciseGenerator([Random? random]) : _random = random ?? Random();

  List<VerbExercise> generate({
    required List<GrammarVerbEntity> allVerbs,
    required VerbTrainerConfig config,
    int count = 20,
  }) {
    if (allVerbs.isEmpty) return const [];

    // Filter verbs according to config
    var filteredVerbs = allVerbs;
    if (config.irregularsOnly) {
      filteredVerbs = allVerbs.where((v) => v.regularity == 'irregular').toList();
      if (filteredVerbs.isEmpty) {
        filteredVerbs = allVerbs;
      }
    }

    final exercises = <VerbExercise>[];
    final allAvailableForms = <String>{};
    for (final v in allVerbs) {
      for (final c in v.conjugations) {
        allAvailableForms.add(c.form);
      }
    }

    // Determine target tenses
    final targetTenses = <String>[];
    if (config.tenseFilter == TenseFilter.all) {
      targetTenses.addAll([
        'presente_indicativo',
        'preterito_perfeito',
        'preterito_imperfeito',
        'futuro_presente',
        'presente_subjuntivo',
      ]);
    } else {
      targetTenses.add(config.tenseFilter.rawTense);
    }

    // Collect all valid (verb, conjugation) candidates
    final candidates = <({GrammarVerbEntity verb, VerbConjugationForm conj})>[];
    for (final v in filteredVerbs) {
      for (final c in v.conjugations) {
        if (targetTenses.contains(c.tense)) {
          candidates.add((verb: v, conj: c));
        }
      }
    }

    if (candidates.isEmpty) return const [];

    candidates.shuffle(_random);

    final selectedCandidates = candidates.take(count).toList();

    for (int i = 0; i < selectedCandidates.length; i++) {
      final item = selectedCandidates[i];
      final verb = item.verb;
      final conj = item.conj;

      final tenseEnum = VerbTense.fromRaw(conj.tense);
      final personEnum = VerbPerson.fromRaw(conj.person);
      final correctForm = conj.form;

      // Distractors pool
      final distractors = <String>{};

      // 1. Same verb, other persons or tenses
      final otherFormsSameVerb = verb.conjugations
          .where((c) => c.form.toLowerCase() != correctForm.toLowerCase())
          .map((c) => c.form)
          .toList()
        ..shuffle(_random);

      for (final f in otherFormsSameVerb) {
        if (distractors.length < 3) {
          distractors.add(f);
        }
      }

      // 2. Fallback: forms from other verbs with same tense/person
      if (distractors.length < 3) {
        final sameTenseOtherVerbs = <String>[];
        for (final otherV in allVerbs) {
          if (otherV.id == verb.id) continue;
          for (final otherC in otherV.conjugations) {
            if (otherC.tense == conj.tense &&
                otherC.form.toLowerCase() != correctForm.toLowerCase()) {
              sameTenseOtherVerbs.add(otherC.form);
            }
          }
        }
        sameTenseOtherVerbs.shuffle(_random);
        for (final f in sameTenseOtherVerbs) {
          if (distractors.length < 3) {
            distractors.add(f);
          }
        }
      }

      // 3. Fallback: any available form
      if (distractors.length < 3) {
        final fallbackList = allAvailableForms.toList()..shuffle(_random);
        for (final f in fallbackList) {
          if (f.toLowerCase() != correctForm.toLowerCase() && distractors.length < 3) {
            distractors.add(f);
          }
        }
      }

      final options = [correctForm, ...distractors.take(3)]..shuffle(_random);

      final isIrregular = verb.regularity == 'irregular';
      final irregularHint = isIrregular ? ' (неправильный глагол с чередованием основы)' : '';
      final explanation =
          'Глагол «${verb.infinitive}» (${verb.russianMeaning}) в ${tenseEnum.titleRu} для ${personEnum.pronounDisplay}: «$correctForm»$irregularHint.';

      exercises.add(
        VerbExercise(
          id: 've_${verb.id}_${conj.tense}_${conj.person}_$i',
          verbId: verb.id,
          infinitive: verb.infinitive,
          russianMeaning: verb.russianMeaning,
          isIrregular: isIrregular,
          tense: tenseEnum,
          person: personEnum,
          correctForm: correctForm,
          options: options,
          explanationRu: explanation,
          audioPhrase: '${personEnum.pronounDisplay} $correctForm',
        ),
      );
    }

    return exercises;
  }
}
