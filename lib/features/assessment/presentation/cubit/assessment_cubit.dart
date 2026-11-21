import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../srs/data/repositories/srs_repository_impl.dart';
import '../../../srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/level_quiz_result.dart';
import '../../domain/repositories/assessment_repository.dart';
import 'assessment_state.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  final AssessmentRepository repository;
  final HybridAudioPlaybackService? audioService;
  final SrsRepository? srsRepository;

  AssessmentCubit({
    required this.repository,
    this.audioService,
    this.srsRepository,
  }) : super(const AssessmentInitial());

  Future<void> loadAssessment() async {
    emit(const AssessmentLoading());
    try {
      final latestResult = await repository.getLatestResult();
      if (latestResult.isOk && latestResult.value != null) {
        emit(AssessmentCompleted(result: latestResult.value!));
        return;
      }

      await startNewAssessment();
    } catch (e) {
      emit(AssessmentError('Ошибка при загрузке теста: $e'));
    }
  }

  Future<void> startNewAssessment() async {
    emit(const AssessmentLoading());
    try {
      final questionsResult = await repository.getQuestions();
      if (!questionsResult.isOk || questionsResult.value.isEmpty) {
        emit(const AssessmentError('Вопросы для теста не найдены'));
        return;
      }

      emit(
        AssessmentActive(
          questions: questionsResult.value,
          currentIndex: 0,
          userAnswers: const {},
          selectedOptionIndex: null,
          isSubmitted: false,
        ),
      );
    } catch (e) {
      emit(AssessmentError('Не удалось начать тест: $e'));
    }
  }

  void selectOption(int index) {
    final s = state;
    if (s is! AssessmentActive || s.isSubmitted) return;
    emit(s.copyWith(selectedOptionIndex: index));
  }

  void submitAnswer() {
    final s = state;
    if (s is! AssessmentActive || s.selectedOptionIndex == null || s.isSubmitted) return;

    final updatedAnswers = Map<String, int>.from(s.userAnswers);
    updatedAnswers[s.currentQuestion.id] = s.selectedOptionIndex!;

    emit(
      s.copyWith(
        isSubmitted: true,
        userAnswers: updatedAnswers,
      ),
    );
  }

  Future<void> nextQuestion() async {
    final s = state;
    if (s is! AssessmentActive) return;

    if (s.isLastQuestion) {
      emit(const AssessmentLoading());
      final result = LevelQuizResult.evaluate(
        questions: s.questions,
        userAnswers: s.userAnswers,
      );
      await repository.saveResult(result);
      emit(AssessmentCompleted(result: result));
    } else {
      emit(
        s.copyWith(
          currentIndex: s.currentIndex + 1,
          isSubmitted: false,
          clearSelectedOption: true,
        ),
      );
    }
  }

  Future<void> playAudio(String text) async {
    final s = state;
    if (s is AssessmentActive) {
      emit(s.copyWith(isPlayingAudio: true));
      try {
        await audioService?.playAudioOrSpeak(fallbackText: text);
      } finally {
        if (state is AssessmentActive) {
          emit((state as AssessmentActive).copyWith(isPlayingAudio: false));
        }
      }
    } else {
      await audioService?.playAudioOrSpeak(fallbackText: text);
    }
  }

  Future<void> saveMistakesToFsrs() async {
    final s = state;
    if (s is! AssessmentCompleted || s.isSavingToFsrs || srsRepository == null) return;

    emit(s.copyWith(isSavingToFsrs: true));
    try {
      int addedCount = 0;
      final now = DateTime.now();

      for (int i = 0; i < s.result.mistakes.length; i++) {
        final mistake = s.result.mistakes[i];
        final word = mistake.targetWordForFsrs;
        if (word == null || word.trim().isEmpty) continue;

        final card = SrsCardEntity(
          id: 'cefr_${mistake.id}_${now.millisecondsSinceEpoch}_$i',
          portuguese: word,
          russianTranslation: mistake.targetWordTranslationRu ?? mistake.prompt,
          partOfSpeech: 'phrase',
          category: 'cefr_mistakes',
          dialect: mistake.dialect,
          examplePortuguese: mistake.prompt,
          exampleRussian: mistake.explanationRu,
          fsrsState: 'newCard',
          stability: 0.0,
          difficulty: 0.0,
          reps: 0,
          lapses: 0,
          dueAt: now,
        );

        await srsRepository!.addCard(card);
        addedCount++;
      }

      emit(s.copyWith(isSavingToFsrs: false, addedToFsrsCount: addedCount));
    } catch (e) {
      emit(s.copyWith(isSavingToFsrs: false));
    }
  }
}
