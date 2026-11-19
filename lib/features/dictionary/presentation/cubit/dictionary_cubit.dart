import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../data/repositories/dictionary_repository_impl.dart';
import '../../domain/entities/dictionary_entry_entity.dart';
import 'dictionary_state.dart';

class DictionaryCubit extends Cubit<DictionaryState> {
  final DictionaryRepository _repository;
  final HybridAudioPlaybackService _audioService;

  DictionaryCubit({
    required DictionaryRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(DictionaryInitial());

  Future<void> loadDictionary() async {
    emit(DictionaryLoading());
    try {
      final entries = await _repository.getAllEntries();
      emit(DictionaryLoaded(entries: entries));
    } catch (e) {
      emit(DictionaryError('Ошибка загрузки словаря: $e'));
    }
  }

  Future<void> search(String query) async {
    final s = state;
    if (s is DictionaryLoaded) {
      try {
        final results = await _repository.search(query);
        emit(s.copyWith(entries: results, searchQuery: query));
      } catch (e) {
        emit(DictionaryError('Ошибка поиска: $e'));
      }
    }
  }

  void filterPart(String part) {
    final s = state;
    if (s is DictionaryLoaded) {
      emit(s.copyWith(selectedFilter: part));
    }
  }

  Future<void> addWord(DictionaryEntryEntity entry) async {
    try {
      await _repository.addCustomEntry(entry);
      await loadDictionary();
    } catch (e) {
      emit(DictionaryError('Ошибка добавления слова: $e'));
    }
  }

  void playWord(String word) {
    _audioService.playAudioOrSpeak(fallbackText: word);
  }
}
