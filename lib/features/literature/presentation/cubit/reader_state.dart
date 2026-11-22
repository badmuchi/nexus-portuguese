import 'package:equatable/equatable.dart';
import '../../domain/entities/literary_work_entity.dart';

class ReaderState extends Equatable {
  final LiteraryWorkEntity work;
  final int currentPassageIndex;
  final bool isPlayingAudio;
  final bool showGrammarNotes;
  final bool showPoeticDevice;
  final Set<String> addedVocabularyIds;
  final bool isCompleted;

  const ReaderState({
    required this.work,
    this.currentPassageIndex = 0,
    this.isPlayingAudio = false,
    this.showGrammarNotes = true,
    this.showPoeticDevice = true,
    this.addedVocabularyIds = const {},
    this.isCompleted = false,
  });

  LiteraryPassageEntity get currentPassage =>
      work.passages[currentPassageIndex];

  bool get isFirstPassage => currentPassageIndex == 0;
  bool get isLastPassage => currentPassageIndex == work.passages.length - 1;

  double get readingProgress =>
      work.passages.isNotEmpty
          ? (currentPassageIndex + 1) / work.passages.length
          : 0.0;

  ReaderState copyWith({
    LiteraryWorkEntity? work,
    int? currentPassageIndex,
    bool? isPlayingAudio,
    bool? showGrammarNotes,
    bool? showPoeticDevice,
    Set<String>? addedVocabularyIds,
    bool? isCompleted,
  }) {
    return ReaderState(
      work: work ?? this.work,
      currentPassageIndex: currentPassageIndex ?? this.currentPassageIndex,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      showGrammarNotes: showGrammarNotes ?? this.showGrammarNotes,
      showPoeticDevice: showPoeticDevice ?? this.showPoeticDevice,
      addedVocabularyIds: addedVocabularyIds ?? this.addedVocabularyIds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        work,
        currentPassageIndex,
        isPlayingAudio,
        showGrammarNotes,
        showPoeticDevice,
        addedVocabularyIds,
        isCompleted,
      ];
}
