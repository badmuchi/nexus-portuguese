import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_portuguese_app/features/morphology/domain/entities/morphology_models.dart';
import 'package:nexus_portuguese_app/features/morphology/domain/services/portuguese_morphology_engine.dart';

void main() {
  group('PortugueseMorphologyEngine Tests', () {
    test('analyzes preposition contraction "no" as "em + o"', () {
      final res = PortugueseMorphologyEngine.analyzeSentence(
        sentence: 'Estou no Brasil',
        translationRu: 'Я нахожусь в Бразилии',
      );

      expect(res.words.length, equals(3));
      final noWord = res.words[1];
      expect(noWord.cleanWord, equals('no'));
      expect(noWord.partOfSpeech, equals(PartOfSpeech.contracao));
      expect(noWord.contraction, isNotNull);
      expect(noWord.contraction!.formula, equals('em + o = no'));
      expect(noWord.contraction!.preposition, equals('em'));
      expect(noWord.contraction!.articleOrPronoun, equals('o'));
    });

    test('analyzes enclitic hyphenated pronoun in "avise-me"', () {
      final res = PortugueseMorphologyEngine.analyzeSentence(
        sentence: 'Avise-me por favor',
        translationRu: 'Дайте мне знать пожалуйста',
      );

      final aviseWord = res.words[0];
      expect(aviseWord.cleanWord, equals('avise-me'));
      expect(aviseWord.cliticPronoun, equals('me'));
      expect(aviseWord.lemma, equals('avise'));
    });

    test('analyzes verb forms and basic parts of speech', () {
      final res = PortugueseMorphologyEngine.analyzeSentence(
        sentence: 'Eu falo português',
      );

      final euWord = res.words[0];
      expect(euWord.partOfSpeech, equals(PartOfSpeech.pronome));

      final faloWord = res.words[1];
      expect(faloWord.partOfSpeech, equals(PartOfSpeech.verbo));
      expect(faloWord.lemma, equals('falar'));
    });
  });
}
