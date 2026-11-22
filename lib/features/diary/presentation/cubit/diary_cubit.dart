import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/speech/speech_recognition_service.dart';
import '../../domain/entities/diary_entry_entity.dart';
import '../../domain/entities/diary_prompt_entity.dart';
import '../../domain/repositories/diary_repository.dart';
import 'diary_state.dart';

class DiaryCubit extends Cubit<DiaryState> {
  final DiaryRepository _repository;
  final SpeechRecognitionService? _speechService;
  StreamSubscription<String>? _speechSubscription;

  DiaryCubit({
    required DiaryRepository repository,
    SpeechRecognitionService? speechService,
  })  : _repository = repository,
        _speechService = speechService,
        super(const DiaryState());

  Future<void> loadDiary() async {
    emit(state.copyWith(status: DiaryStatus.loading));

    final entriesResult = await _repository.getAllEntries();
    final promptsResult = await _repository.getDailyPrompts();

    if (entriesResult.isOk) {
      emit(state.copyWith(
        status: DiaryStatus.loaded,
        entries: entriesResult.value,
        prompts: promptsResult.isOk ? promptsResult.value : [],
      ));
    } else {
      emit(state.copyWith(
        status: DiaryStatus.error,
        errorMessage: entriesResult.failure?.message ?? 'Ошибка загрузки дневника',
      ));
    }
  }

  void selectPrompt(DiaryPrompt? prompt) {
    if (prompt == null) {
      emit(state.copyWith(clearSelectedPrompt: true));
    } else {
      emit(state.copyWith(selectedPrompt: prompt));
    }
  }

  Future<void> analyzeText(String text) async {
    if (text.trim().isEmpty) {
      emit(state.copyWith(clearCurrentAnalysis: true));
      return;
    }

    emit(state.copyWith(status: DiaryStatus.analyzing));
    final result = await _repository.analyzeText(text);

    if (result.isOk) {
      emit(state.copyWith(
        status: DiaryStatus.loaded,
        currentAnalysis: result.value,
      ));
    } else {
      emit(state.copyWith(
        status: DiaryStatus.loaded,
        errorMessage: result.failure?.message,
      ));
    }
  }

  Future<bool> saveEntry({
    required String text,
    DiaryPrompt? prompt,
  }) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return false;

    emit(state.copyWith(status: DiaryStatus.loading));

    final analysisResult = await _repository.analyzeText(cleanText);
    final analysis = analysisResult.isOk ? analysisResult.value : null;

    final newEntry = DiaryEntryEntity(
      id: 'entry_${DateTime.now().millisecondsSinceEpoch}',
      promptQuestionPt: prompt?.questionPt,
      promptQuestionRu: prompt?.questionRu,
      contentPt: cleanText,
      dialect: analysis?.detectedDialect ?? 'pt_BR',
      wordCount: analysis?.wordCount ?? cleanText.split(' ').length,
      estimatedLevel: analysis?.estimatedLevel ?? 'A1',
      feedbackSummaryRu: analysis?.feedbackSummaryRu ?? 'Запись сохранена!',
      mistakes: analysis?.mistakes ?? [],
      createdAt: DateTime.now(),
    );

    final saveResult = await _repository.saveEntry(newEntry);

    if (saveResult.isOk) {
      final updatedList = [newEntry, ...state.entries];
      emit(state.copyWith(
        status: DiaryStatus.loaded,
        entries: updatedList,
        currentAnalysis: analysis,
        clearSelectedPrompt: true,
      ));
      return true;
    } else {
      emit(state.copyWith(
        status: DiaryStatus.error,
        errorMessage: saveResult.failure?.message ?? 'Не удалось сохранить запись',
      ));
      return false;
    }
  }

  Future<void> deleteEntry(String id) async {
    final result = await _repository.deleteEntry(id);
    if (result.isOk) {
      final updated = state.entries.where((e) => e.id != id).toList();
      emit(state.copyWith(entries: updated));
    }
  }

  Future<void> startVoiceInput({void Function(String text)? onRecognized}) async {
    final speech = _speechService;
    if (speech != null) {
      emit(state.copyWith(isRecording: true));
      _speechSubscription?.cancel();
      _speechSubscription = speech.textStream.listen((text) {
        if (text.trim().isNotEmpty && onRecognized != null) {
          onRecognized(text);
        }
      });
      await speech.startListening(localeId: 'pt-BR');
    }
  }

  Future<void> stopVoiceInput() async {
    final speech = _speechService;
    if (speech != null) {
      await speech.stopListening();
      _speechSubscription?.cancel();
    }
    emit(state.copyWith(isRecording: false));
  }

  @override
  Future<void> close() {
    _speechSubscription?.cancel();
    return super.close();
  }
}
