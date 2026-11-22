import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_scenario_entity.dart';
import '../../domain/repositories/chat_simulator_repository.dart';
import 'chat_catalog_state.dart';

class ChatCatalogCubit extends Cubit<ChatCatalogState> {
  final ChatSimulatorRepository _repository;

  ChatCatalogCubit({required ChatSimulatorRepository repository})
      : _repository = repository,
        super(const ChatCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: ChatCatalogStatus.loading));

    final result = await _repository.getScenarios();
    if (result.isOk) {
      final all = result.value;
      final filtered = _applyFilters(all, state.selectedDialect, state.searchQuery);
      emit(state.copyWith(
        status: ChatCatalogStatus.loaded,
        allScenarios: all,
        filteredScenarios: filtered,
      ));
    } else {
      emit(state.copyWith(
        status: ChatCatalogStatus.error,
        errorMessage: result.failure?.message ?? 'Ошибка загрузки сценариев',
      ));
    }
  }

  Future<void> loadScenarios() => loadCatalog();

  void filterByDialect(String dialect) {
    final filtered = _applyFilters(state.allScenarios, dialect, state.searchQuery);
    emit(state.copyWith(selectedDialect: dialect, filteredScenarios: filtered));
  }

  void search(String query) {
    final filtered = _applyFilters(state.allScenarios, state.selectedDialect, query);
    emit(state.copyWith(searchQuery: query, filteredScenarios: filtered));
  }

  void searchScenarios(String query) => search(query);

  List<ChatScenarioEntity> _applyFilters(
    List<ChatScenarioEntity> list,
    String dialect,
    String query,
  ) {
    var res = List<ChatScenarioEntity>.from(list);

    if (dialect != 'all') {
      res = res.where((s) => s.dialect.toLowerCase() == dialect.toLowerCase()).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      res = res.where((s) {
        return s.titlePt.toLowerCase().contains(q) ||
            s.titleRu.toLowerCase().contains(q) ||
            s.contactName.toLowerCase().contains(q) ||
            s.scenarioContextRu.toLowerCase().contains(q);
      }).toList();
    }

    return res;
  }
}
