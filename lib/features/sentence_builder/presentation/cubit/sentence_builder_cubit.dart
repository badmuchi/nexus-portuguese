import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../assessment/domain/entities/level_quiz_question.dart';
import '../../../srs/data/repositories/srs_repository_impl.dart';
import '../../../srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/sentence_builder_result.dart';
import '../../domain/entities/sentence_puzzle.dart';
import '../../domain/repositories/sentence_builder_repository.dart';
import 'sentence_builder_state.dart';

class SentenceBuilderCubit extends Cubit<SentenceBuilderState> {
  final SentenceBuilderRepository repository;
  final HybridAudioPlaybackService? audioService;
  final SrsRepository? srsRepository;

  SentenceBuilderCubit({
    required this.repository,
    this.audioService,
    this.srsRepository,
  }) : super(const SentenceBuilderInitial());

  Future<void> loadPuzzles({CefrLevel? level, String? dialect}) async {
    emit(const SentenceBuilderLoading());
    try {
      final res = await repository.getPuzzles(level: level, dialect: dialect);
      if (!res.isOk || res.value.isEmpty) {
        emit(const SentenceBuilderError('Не удалось загрузить предложения для сборки'));
        return;
      }

      final puzzles = List<SentencePuzzle>.from(res.value)..shuffle();
      final first = puzzles.first;
      final initialTokens = List<String>.from(first.availableTokens)..shuffle();

      emit(
        SentenceBuilderActive(
          puzzles: puzzles,
          currentIndex: 0,
          availableTokens: initialTokens,
          assembledTokens: const [],
          isChecked: false,
          isCorrect: null,
          scorePoints: 0,
          streak: 0,
          solvedCount: 0,
          mistakes: const [],
        ),
      );
    } catch (e) {
      emit(SentenceBuilderError('Ошибка при загрузке: $e'));
    }
  }

  void tapAvailableToken(int index) {
    final s = state;
    if (s is! SentenceBuilderActive || s.isChecked) return;
    if (index < 0 || index >= s.availableTokens.length) return;

    final token = s.availableTokens[index];
    final newAvailable = List<String>.from(s.availableTokens)..removeAt(index);
    final newAssembled = List<String>.from(s.assembledTokens)..add(token);

    emit(
      s.copyWith(
        availableTokens: newAvailable,
        assembledTokens: newAssembled,
      ),
    );
  }

  void tapAssembledToken(int index) {
    final s = state;
    if (s is! SentenceBuilderActive || s.isChecked) return;
    if (index < 0 || index >= s.assembledTokens.length) return;

    final token = s.assembledTokens[index];
    final newAssembled = List<String>.from(s.assembledTokens)..removeAt(index);
    final newAvailable = List<String>.from(s.availableTokens)..add(token);

    emit(
      s.copyWith(
        availableTokens: newAvailable,
        assembledTokens: newAssembled,
      ),
    );
  }

  void resetCurrentAssembly() {
    final s = state;
    if (s is! SentenceBuilderActive || s.isChecked) return;

    final all = List<String>.from(s.currentPuzzle.availableTokens)..shuffle();
    emit(
      s.copyWith(
        availableTokens: all,
        assembledTokens: const [],
      ),
    );
  }

  void checkAnswer() {
    final s = state;
    if (s is! SentenceBuilderActive || s.assembledTokens.isEmpty || s.isChecked) return;

    final isCorrect = s.currentPuzzle.isMatch(s.assembledTokens);
    final newSolved = isCorrect ? s.solvedCount + 1 : s.solvedCount;
    final newStreak = isCorrect ? s.streak + 1 : 0;
    final multiplier = isCorrect ? min(newStreak, 4) : 0;
    final pointsGained = isCorrect ? (15 * multiplier) : 0;
    final newScore = s.scorePoints + pointsGained;

    final newMistakes = List<SentencePuzzle>.from(s.mistakes);
    if (!isCorrect) {
      newMistakes.add(s.currentPuzzle);
    }

    emit(
      s.copyWith(
        isChecked: true,
        isCorrect: isCorrect,
        solvedCount: newSolved,
        streak: newStreak,
        scorePoints: newScore,
        mistakes: newMistakes,
      ),
    );

    repository.recordCompletion(
      puzzleId: s.currentPuzzle.id,
      isCorrect: isCorrect,
    );

    if (isCorrect) {
      playAudio(s.currentPuzzle.targetPortuguese);
    }
  }

  Future<void> playAudio(String text) async {
    final s = state;
    if (s is SentenceBuilderActive) {
      emit(s.copyWith(isPlayingAudio: true));
      try {
        await audioService?.playAudioOrSpeak(fallbackText: text);
      } finally {
        if (state is SentenceBuilderActive) {
          emit((state as SentenceBuilderActive).copyWith(isPlayingAudio: false));
        }
      }
    } else {
      await audioService?.playAudioOrSpeak(fallbackText: text);
    }
  }

  void nextPuzzle() {
    final s = state;
    if (s is! SentenceBuilderActive) return;

    if (s.isLastPuzzle) {
      final result = SentenceBuilderResult.evaluate(
        totalQuestions: s.totalPuzzles,
        solvedCount: s.solvedCount,
        scorePoints: s.scorePoints,
        mistakes: s.mistakes,
      );
      emit(SentenceBuilderCompleted(result: result));
    } else {
      final nextIdx = s.currentIndex + 1;
      final nextPuzzle = s.puzzles[nextIdx];
      final newTokens = List<String>.from(nextPuzzle.availableTokens)..shuffle();

      emit(
        s.copyWith(
          currentIndex: nextIdx,
          availableTokens: newTokens,
          assembledTokens: const [],
          isChecked: false,
          isCorrect: null,
        ),
      );
    }
  }

  Future<void> saveMistakesToFsrs() async {
    final s = state;
    if (s is! SentenceBuilderCompleted || s.isSavingToFsrs || srsRepository == null) return;

    emit(s.copyWith(isSavingToFsrs: true));
    try {
      int addedCount = 0;
      final now = DateTime.now();

      for (int i = 0; i < s.result.mistakes.length; i++) {
        final mistake = s.result.mistakes[i];
        final card = SrsCardEntity(
          id: 'puzzle_${mistake.id}_${now.millisecondsSinceEpoch}_$i',
          portuguese: mistake.targetPortuguese,
          russianTranslation: mistake.russianMeaning,
          partOfSpeech: 'phrase',
          category: 'sentence_builder',
          dialect: mistake.dialect,
          examplePortuguese: mistake.targetPortuguese,
          exampleRussian: mistake.grammarExplanationRu,
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
    } catch (_) {
      emit(s.copyWith(isSavingToFsrs: false));
    }
  }
}
