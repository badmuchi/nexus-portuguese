import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_scenario_entity.dart';

enum ChatCatalogStatus { initial, loading, loaded, error }

class ChatCatalogState extends Equatable {
  final ChatCatalogStatus status;
  final List<ChatScenarioEntity> allScenarios;
  final List<ChatScenarioEntity> filteredScenarios;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String searchQuery;
  final String? errorMessage;

  const ChatCatalogState({
    this.status = ChatCatalogStatus.initial,
    this.allScenarios = const [],
    this.filteredScenarios = const [],
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.errorMessage,
  });

  bool get isLoading => status == ChatCatalogStatus.loading;
  List<ChatScenarioEntity> get scenarios => filteredScenarios;

  ChatCatalogState copyWith({
    ChatCatalogStatus? status,
    List<ChatScenarioEntity>? allScenarios,
    List<ChatScenarioEntity>? filteredScenarios,
    String? selectedDialect,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ChatCatalogState(
      status: status ?? this.status,
      allScenarios: allScenarios ?? this.allScenarios,
      filteredScenarios: filteredScenarios ?? this.filteredScenarios,
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allScenarios,
        filteredScenarios,
        selectedDialect,
        searchQuery,
        errorMessage,
      ];
}
