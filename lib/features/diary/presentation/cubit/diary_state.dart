import 'package:equatable/equatable.dart';
import '../../domain/entities/diary_analysis_entity.dart';
import '../../domain/entities/diary_entry_entity.dart';
import '../../domain/entities/diary_prompt_entity.dart';

enum DiaryStatus { initial, loading, loaded, analyzing, error }

class DiaryState extends Equatable {
  final DiaryStatus status;
  final List<DiaryEntryEntity> entries;
  final List<DiaryPrompt> prompts;
  final DiaryPrompt? selectedPrompt;
  final DiaryAnalysisResult? currentAnalysis;
  final bool isRecording;
  final String? errorMessage;

  const DiaryState({
    this.status = DiaryStatus.initial,
    this.entries = const [],
    this.prompts = const [],
    this.selectedPrompt,
    this.currentAnalysis,
    this.isRecording = false,
    this.errorMessage,
  });

  int get totalWordCount => entries.fold(0, (sum, e) => sum + e.wordCount);

  DiaryState copyWith({
    DiaryStatus? status,
    List<DiaryEntryEntity>? entries,
    List<DiaryPrompt>? prompts,
    DiaryPrompt? selectedPrompt,
    bool clearSelectedPrompt = false,
    DiaryAnalysisResult? currentAnalysis,
    bool clearCurrentAnalysis = false,
    bool? isRecording,
    String? errorMessage,
  }) {
    return DiaryState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      prompts: prompts ?? this.prompts,
      selectedPrompt: clearSelectedPrompt ? null : (selectedPrompt ?? this.selectedPrompt),
      currentAnalysis: clearCurrentAnalysis ? null : (currentAnalysis ?? this.currentAnalysis),
      isRecording: isRecording ?? this.isRecording,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        entries,
        prompts,
        selectedPrompt,
        currentAnalysis,
        isRecording,
        errorMessage,
      ];
}
