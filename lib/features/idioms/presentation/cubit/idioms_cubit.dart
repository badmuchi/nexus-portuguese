import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/portuguese_idiom_entity.dart';
import '../../domain/repositories/idioms_repository.dart';
import 'idioms_state.dart';

class IdiomsCubit extends Cubit<IdiomsState> {
  final IdiomsRepository _repository;
  final HybridAudioPlaybackService _audioService;

  IdiomsCubit({
    required IdiomsRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(const IdiomsState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: IdiomsStatus.loading));

    final result = await _repository.getIdioms();
    if (result.isOk) {
      final all = result.value;
      final filtered = _applyFilters(all, state.selectedCategory, state.selectedDialect, state.searchQuery);

      emit(state.copyWith(
        status: IdiomsStatus.loaded,
        allIdioms: all,
        filteredIdioms: filtered,
      ));
    } else {
      emit(state.copyWith(
        status: IdiomsStatus.error,
        errorMessage: result.failure?.message ?? 'Ошибка загрузки идиом',
      ));
    }
  }

  void filterByCategory(IdiomCategory? category) {
    final filtered = _applyFilters(state.allIdioms, category, state.selectedDialect, state.searchQuery);
    if (category == null) {
      emit(state.copyWith(clearCategory: true, filteredIdioms: filtered));
    } else {
      emit(state.copyWith(selectedCategory: category, filteredIdioms: filtered));
    }
  }

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(state.allIdioms, state.selectedCategory, dialect, state.searchQuery);
    emit(state.copyWith(selectedDialect: dialect, filteredIdioms: filtered));
  }

  void search(String query) {
    final filtered = _applyFilters(state.allIdioms, state.selectedCategory, state.selectedDialect, query);
    emit(state.copyWith(searchQuery: query, filteredIdioms: filtered));
  }

  Future<void> startQuiz({int count = 5}) async {
    emit(state.copyWith(status: IdiomsStatus.loading));

    final challengesRes = await _repository.getQuizChallenges(count: count);
    if (challengesRes.isOk && challengesRes.value.isNotEmpty) {
      emit(state.copyWith(
        status: IdiomsStatus.quizActive,
        quizChallenges: challengesRes.value,
        currentQuizIndex: 0,
        quizCorrectAnswers: 0,
        clearSelection: true,
      ));
    } else {
      emit(state.copyWith(
        status: IdiomsStatus.error,
        errorMessage: challengesRes.failure?.message ?? 'Не удалось запустить квиз',
      ));
    }
  }

  void answerQuiz(int index) {
    if (state.status != IdiomsStatus.quizActive) return;
    final challenge = state.currentChallenge;
    if (challenge == null) return;

    final isCorrect = challenge.checkAnswer(index);
    final newCorrect = state.quizCorrectAnswers + (isCorrect ? 1 : 0);

    emit(state.copyWith(
      selectedQuizAnswerIndex: index,
      quizCorrectAnswers: newCorrect,
    ));

    playIdiomPronunciation(challenge.idiom);
  }

  Future<void> nextQuizQuestion() async {
    if (state.currentQuizIndex < state.quizChallenges.length - 1) {
      emit(state.copyWith(
        currentQuizIndex: state.currentQuizIndex + 1,
        clearSelection: true,
      ));
    } else {
      emit(state.copyWith(status: IdiomsStatus.quizFinished));
      await _repository.recordQuizResult(
        total: state.quizChallenges.length,
        correct: state.quizCorrectAnswers,
      );
    }
  }

  void exitQuiz() {
    emit(state.copyWith(
      status: IdiomsStatus.loaded,
      clearSelection: true,
    ));
  }

  void playIdiomPronunciation(PortugueseIdiom idiom) {
    final dialect = idiom.isPtPt ? PortugueseDialect.european : PortugueseDialect.brazilian;
    _audioService.playAudioOrSpeak(
      fallbackText: idiom.expressionPt,
      dialect: dialect,
    );
  }

  List<PortugueseIdiom> _applyFilters(
    List<PortugueseIdiom> list,
    IdiomCategory? category,
    String dialect,
    String query,
  ) {
    var res = List<PortugueseIdiom>.from(list);

    if (category != null) {
      res = res.where((i) => i.category == category).toList();
    }

    if (dialect != 'all') {
      res = res.where((i) => i.dialect == 'all' || i.dialect.toLowerCase() == dialect.toLowerCase()).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      res = res.where((i) {
        return i.expressionPt.toLowerCase().contains(q) ||
            i.literalTranslationRu.toLowerCase().contains(q) ||
            i.meaningRu.toLowerCase().contains(q);
      }).toList();
    }

    return res;
  }
}
