import 'package:nexus_portuguese_app/features/speech_lab/domain/entities/speech_exercise.dart';

class SpeechLabSeedData {
  static const List<SpeechExercise> exercises = [
    // Nasal Vowels
    SpeechExercise(
      id: 'sp_nasal_1',
      category: SpeechCategory.nasalVowels,
      targetPortuguese: 'Quero pão com manteiga.',
      russianTranslation: 'Я хочу хлеб со сливочным маслом.',
      phoneticTip: '«Pão» звучит как носовой «паун» — воздух выходит одновременно через нос и рот.',
      difficulty: 'iniciante',
    ),
    SpeechExercise(
      id: 'sp_nasal_2',
      category: SpeechCategory.nasalVowels,
      targetPortuguese: 'Não, não é isso que eu quero.',
      russianTranslation: 'Нет, это не то, чего я хочу.',
      phoneticTip: 'Ударный носовой звук в «Não»: следите, чтобы «ão» не превращался в чистое русское «он» или «ау».',
      difficulty: 'iniciante',
    ),
    SpeechExercise(
      id: 'sp_nasal_3',
      category: SpeechCategory.nasalVowels,
      targetPortuguese: 'Minha mãe comprou pães frescos.',
      russianTranslation: 'Моя мама купила свежие булочки.',
      phoneticTip: 'В слове «Mãe» носовой дифтонг звучит как «майн», а в «pães» — «пайнс».',
      difficulty: 'intermediario',
    ),
    SpeechExercise(
      id: 'sp_nasal_4',
      category: SpeechCategory.nasalVowels,
      targetPortuguese: 'Nossos corações estão cheios de esperança.',
      russianTranslation: 'Наши сердца полны надежды.',
      phoneticTip: '«Corações» — множественное число на «-ões» (ойнс), классический португальский носовой дифтонг.',
      difficulty: 'avancado',
    ),

    // Open vs Closed Vowels
    SpeechExercise(
      id: 'sp_vowels_1',
      category: SpeechCategory.openClosed,
      targetPortuguese: 'A avó e o avô viajaram juntos.',
      russianTranslation: 'Бабушка и дедушка поехали вместе.',
      phoneticTip: 'КРИТИЧЕСКИ ВАЖНО: «avó» (бабушка) — широкое открытое «О» (как в слове «борт»), «avô» (дедушка) — круглый глубокий закрытый «О» (как во фр. «eau»).',
      difficulty: 'iniciante',
    ),
    SpeechExercise(
      id: 'sp_vowels_2',
      category: SpeechCategory.openClosed,
      targetPortuguese: 'Você machucou o pé na praia?',
      russianTranslation: 'Ты ушиб ногу на пляже?',
      phoneticTip: '«Você» — закрытое узкое «Ê» (циркумфлекс), «pé» — максимально открытое широкое «É» (острый акцент).',
      difficulty: 'intermediario',
    ),

    // Difficult Consonants
    SpeechExercise(
      id: 'sp_cons_1',
      category: SpeechCategory.consonants,
      targetPortuguese: 'Este carro vermelho é muito caro.',
      russianTranslation: 'Эта красная машина очень дорогая.',
      phoneticTip: '«Carro» — двойная rr (глубокий звук «х» или картавый), «caro» — одиночная r (быстрый щелчок языком об нёбо).',
      difficulty: 'intermediario',
    ),
    SpeechExercise(
      id: 'sp_cons_2',
      category: SpeechCategory.consonants,
      targetPortuguese: 'Tomo uma xícara de chá com açúcar.',
      russianTranslation: 'Я пью чашку чая с сахаром.',
      phoneticTip: 'В слове «xícara» буква X читается как мягкое «ш», а буква «ç» (седриль) в «açúcar» — как чистое «с».',
      difficulty: 'iniciante',
    ),
    SpeechExercise(
      id: 'sp_cons_3',
      category: SpeechCategory.consonants,
      targetPortuguese: 'O táxi chegou para fazer o exame.',
      russianTranslation: 'Такси приехало, чтобы поехать на экзамен.',
      phoneticTip: 'Два лица буквы X: в «táxi» звучит как «кс», а в «exame» между гласными звучит как мягкое звонкое «з»!',
      difficulty: 'avancado',
    ),

    // Tongue Twisters (Trava-línguas)
    SpeechExercise(
      id: 'sp_twist_1',
      category: SpeechCategory.tongueTwisters,
      targetPortuguese: 'O rato roeu a roupa do rei de Roma.',
      russianTranslation: 'Крыса сгрызла одежду короля Рима.',
      phoneticTip: 'Знаменитая скороговорка на звук [R] в начале слов. Старайтесь держать единый ритм.',
      difficulty: 'intermediario',
    ),
    SpeechExercise(
      id: 'sp_twist_2',
      category: SpeechCategory.tongueTwisters,
      targetPortuguese: 'Três pratos de trigo para três tigres tristes.',
      russianTranslation: 'Три тарелки пшеницы для трех грустных тигров.',
      phoneticTip: 'Отработка сочетания согласных [TR] и звуков [T] и [R].',
      difficulty: 'avancado',
    ),

    // Live Dialogues
    SpeechExercise(
      id: 'sp_dialogue_1',
      category: SpeechCategory.dialogueLines,
      targetPortuguese: 'Uma bica e dois pastéis de nata, se faz favor!',
      russianTranslation: 'Один эспрессо и два пирожных паштел-де-ната, пожалуйста!',
      phoneticTip: 'Классический заказ в Лиссабоне. Произносите бодро и слитно.',
      dialect: 'pt_pt',
      difficulty: 'iniciante',
    ),
    SpeechExercise(
      id: 'sp_dialogue_2',
      category: SpeechCategory.dialogueLines,
      targetPortuguese: 'Fala, meu camarada! Vai uma água de coco aí?',
      russianTranslation: 'Здорово, друг! Ледяной кокосовой воды не желаешь?',
      phoneticTip: 'Бразильская пляжная интонация с восходящей мелодикой.',
      dialect: 'pt_br',
      difficulty: 'iniciante',
    ),

    // Dialect Contrasts
    SpeechExercise(
      id: 'sp_dialect_1',
      category: SpeechCategory.dialectContrasts,
      targetPortuguese: 'Tenha um bom dia e uma boa noite na cidade.',
      russianTranslation: 'Хорошего дня и доброй ночи в городе.',
      phoneticTip: 'BR: «джиа», «нойчи», «сидаджи». PT: твердые европейские «диа», «нойт», «сидад».',
      difficulty: 'intermediario',
    ),
    SpeechExercise(
      id: 'sp_dialect_2',
      category: SpeechCategory.dialectContrasts,
      targetPortuguese: 'Eu gosto muito do Brasil e do futebol.',
      russianTranslation: 'Мне очень нравится Бразилия и футбол.',
      phoneticTip: 'BR: буква «L» на конце звучит как гласный «У» («Бразиу», «футебоу»). PT: звучит твердый «Л» («Бразил», «футбол»).',
      difficulty: 'iniciante',
    ),
  ];
}
