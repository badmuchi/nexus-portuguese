import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/literary_work_entity.dart';
import '../../domain/repositories/literature_repository.dart';
import 'reader_state.dart';

class ReaderCubit extends Cubit<ReaderState> {
  final LiteratureRepository _repository;
  final HybridAudioPlaybackService _audioService;
  final SrsRepository? _srsRepository;

  ReaderCubit({
    required LiteraryWorkEntity work,
    required LiteratureRepository repository,
    required HybridAudioPlaybackService audioService,
    SrsRepository? srsRepository,
  })  : _repository = repository,
        _audioService = audioService,
        _srsRepository = srsRepository,
        super(ReaderState(work: work));

  void nextPassage() {
    if (state.isLastPassage) {
      if (!state.isCompleted) {
        emit(state.copyWith(isCompleted: true));
        _repository.recordWorkRead(
          workId: state.work.id,
          passagesRead: state.work.passages.length,
        );
      }
    } else {
      stopAudio();
      emit(state.copyWith(
        currentPassageIndex: state.currentPassageIndex + 1,
      ));
    }
  }

  void previousPassage() {
    if (!state.isFirstPassage) {
      stopAudio();
      emit(state.copyWith(
        currentPassageIndex: state.currentPassageIndex - 1,
      ));
    }
  }

  void goToPassage(int index) {
    if (index >= 0 && index < state.work.passages.length) {
      stopAudio();
      emit(state.copyWith(currentPassageIndex: index));
    }
  }

  void toggleGrammarNotes() {
    emit(state.copyWith(showGrammarNotes: !state.showGrammarNotes));
  }

  void togglePoeticDevice() {
    emit(state.copyWith(showPoeticDevice: !state.showPoeticDevice));
  }

  Future<void> reciteCurrentPassage() async {
    final passage = state.currentPassage;
    emit(state.copyWith(isPlayingAudio: true));

    final targetDialect = state.work.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    await _audioService.playAudioOrSpeak(
      fallbackText: passage.audioSnippetText,
      dialect: targetDialect,
      rate: 0.9, // Expressive, measured poetic recitation pace
    );

    if (!isClosed) {
      emit(state.copyWith(isPlayingAudio: false));
    }
  }

  Future<void> stopAudio() async {
    await _audioService.stop();
    if (!isClosed) {
      emit(state.copyWith(isPlayingAudio: false));
    }
  }

  Future<bool> addWordToFsrs(LiteraryVocabularyEntity vocab) async {
    if (_srsRepository == null) return false;

    final targetDialect = state.work.dialect;
    final card = SrsCardEntity(
      id: 'lit_${vocab.id}_${DateTime.now().millisecondsSinceEpoch}',
      portuguese: vocab.wordPt,
      russianTranslation: vocab.translationRu,
      partOfSpeech: vocab.partOfSpeech,
      category: 'literatura',
      dialect: targetDialect,
      examplePortuguese: vocab.contextSentencePt,
      exampleRussian: vocab.contextSentenceRu,
      notes: '${state.work.titlePt} (${state.work.authorName}) • ${vocab.etymologyRu}',
      fsrsState: 'newCard',
      stability: 0.0,
      difficulty: 0.0,
      reps: 0,
      lapses: 0,
      dueAt: DateTime.now(),
    );

    await _srsRepository.addCard(card);

    final updated = Set<String>.from(state.addedVocabularyIds)..add(vocab.id);
    emit(state.copyWith(addedVocabularyIds: updated));
    return true;
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
