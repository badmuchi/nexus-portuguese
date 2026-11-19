import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../data/repositories/grammar_repository_impl.dart';
import '../../domain/entities/grammar_verb_entity.dart';
import 'grammar_state.dart';

class GrammarCubit extends Cubit<GrammarState> {
  final GrammarRepository _repository;
  final HybridAudioPlaybackService _audioService;

  GrammarCubit({
    required GrammarRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(GrammarInitial());

  Future<void> loadGrammarData() async {
    emit(GrammarLoading());
    try {
      final verbs = await _repository.getAllVerbs();
      final contractions = await _repository.getPrepositionContractions();

      if (verbs.isEmpty) {
        emit(const GrammarError('Глаголы не найдены в базе.'));
        return;
      }

      emit(
        GrammarLoaded(
          verbs: verbs,
          contractions: contractions,
          selectedVerb: verbs.first,
        ),
      );
    } catch (e) {
      emit(GrammarError('Ошибка загрузки грамматики: $e'));
    }
  }

  void selectVerb(GrammarVerbEntity verb) {
    final s = state;
    if (s is GrammarLoaded) {
      emit(s.copyWith(selectedVerb: verb));
    }
  }

  void filterGroup(String group) {
    final s = state;
    if (s is GrammarLoaded) {
      emit(s.copyWith(selectedGroup: group));
    }
  }

  void selectTense(String tense) {
    final s = state;
    if (s is GrammarLoaded) {
      emit(s.copyWith(selectedTense: tense));
    }
  }

  void playFormAudio(String text) {
    _audioService.playAudioOrSpeak(fallbackText: text);
  }
}
