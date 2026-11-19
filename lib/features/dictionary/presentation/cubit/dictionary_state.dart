import 'package:equatable/equatable.dart';
import '../../domain/entities/dictionary_entry_entity.dart';

abstract class DictionaryState extends Equatable {
  const DictionaryState();

  @override
  List<Object?> get props => [];
}

class DictionaryInitial extends DictionaryState {}

class DictionaryLoading extends DictionaryState {}

class DictionaryLoaded extends DictionaryState {
  final List<DictionaryEntryEntity> entries;
  final String searchQuery;
  final String selectedFilter; // 'all', 'verb', 'noun', 'adjective'

  const DictionaryLoaded({
    required this.entries,
    this.searchQuery = '',
    this.selectedFilter = 'all',
  });

  List<DictionaryEntryEntity> get filteredEntries {
    if (selectedFilter == 'all') return entries;
    return entries.where((e) => e.partOfSpeech.toLowerCase().contains(selectedFilter)).toList();
  }

  DictionaryLoaded copyWith({
    List<DictionaryEntryEntity>? entries,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return DictionaryLoaded(
      entries: entries ?? this.entries,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [entries, searchQuery, selectedFilter];
}

class DictionaryError extends DictionaryState {
  final String message;
  const DictionaryError(this.message);

  @override
  List<Object?> get props => [message];
}
