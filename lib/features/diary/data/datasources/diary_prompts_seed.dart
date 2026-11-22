import '../../domain/entities/diary_prompt_entity.dart';

class DiaryPromptsSeed {
  static const List<DiaryPrompt> prompts = [
    DiaryPrompt(
      id: 'prompt_today_activities',
      questionPt: 'O que você fez hoje de especial?',
      questionRu: 'Что особенного вы делали сегодня?',
      hintWords: ['hoje', 'trabalhei', 'estudei', 'encontrei', 'gostei', 'descansei'],
      category: 'Dia a Dia',
      difficultyCefr: 'A1',
    ),
    DiaryPrompt(
      id: 'prompt_lisboa_rio',
      questionPt: 'Um café em Lisboa ou um açaí na praia do Rio de Janeiro?',
      questionRu: 'Кофе в Лиссабоне или асай на пляже в Рио-де-Жанейро?',
      hintWords: ['prefiro', 'bica', 'pastel de nata', 'praia', 'mar', 'sol', 'calor'],
      category: 'Cultura',
      difficultyCefr: 'A2',
    ),
    DiaryPrompt(
      id: 'prompt_favorite_food',
      questionPt: 'Qual é o seu prato favorito e como ele é preparado?',
      questionRu: 'Какое ваше любимое блюдо и как оно готовится?',
      hintWords: ['comida', 'ingredientes', 'saboroso', 'cozinhar', 'almoço', 'jantar'],
      category: 'Comida',
      difficultyCefr: 'A2',
    ),
    DiaryPrompt(
      id: 'prompt_dream_trip',
      questionPt: 'Para onde você gostaria de viajar quando falar português fluente?',
      questionRu: 'Куда бы вы хотели поехать, когда будете свободно говорить по-португальски?',
      hintWords: ['viajar', 'Portugal', 'Brasil', 'conhecer', 'pessoas', 'cidades', 'praias'],
      category: 'Viagem',
      difficultyCefr: 'B1',
    ),
    DiaryPrompt(
      id: 'prompt_music_feelings',
      questionPt: 'Qual música em português te emociona ou dá vontade de dançar?',
      questionRu: 'Какая музыка на португальском трогает вас или зовет танцевать?',
      hintWords: ['música', 'bossa nova', 'fado', 'samba', 'letra', 'ritmo', 'alegria'],
      category: 'Cultura',
      difficultyCefr: 'B1',
    ),
    DiaryPrompt(
      id: 'prompt_childhood_memory',
      questionPt: 'Conte uma lembrança marcante da sua infância.',
      questionRu: 'Расскажите одно яркое воспоминание из вашего детства.',
      hintWords: ['quando era criança', 'brincava', 'família', 'amigos', 'lembro-me'],
      category: 'Memórias',
      difficultyCefr: 'B1',
    ),
    DiaryPrompt(
      id: 'prompt_future_fluency',
      questionPt: 'Como falar português mudará os seus horizontes pessoais e profissionais?',
      questionRu: 'Как владение португальским изменит ваши личные и профессиональные горизонты?',
      hintWords: ['oportunidades', 'comunicação', 'aprender', 'sonho', 'futuro', 'mundo'],
      category: 'Sonhos',
      difficultyCefr: 'B2',
    ),
  ];
}
