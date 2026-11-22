import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/survival_phrase_entity.dart';
import '../../domain/repositories/survival_guide_repository.dart';
import 'survival_catalog_state.dart';

class SurvivalCatalogCubit extends Cubit<SurvivalCatalogState> {
  final SurvivalGuideRepository _repository;

  SurvivalCatalogCubit({required SurvivalGuideRepository repository})
      : _repository = repository,
        super(const SurvivalCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: SurvivalCatalogStatus.loading));

    final questsRes = await _repository.getQuests();
    final phrasesRes = await _repository.getPhrases();
    final tipsRes = await _repository.getTips();

    if (questsRes.isOk && phrasesRes.isOk && tipsRes.isOk) {
      emit(state.copyWith(
        status: SurvivalCatalogStatus.loaded,
        allQuests: questsRes.value,
        allPhrases: phrasesRes.value,
        allTips: tipsRes.value,
      ));
    } else {
      final error = questsRes.failure?.message ??
          phrasesRes.failure?.message ??
          tipsRes.failure?.message ??
          'Ошибка загрузки гида выживания';
      emit(state.copyWith(
        status: SurvivalCatalogStatus.error,
        errorMessage: error,
      ));
    }
  }

  void filterByCategory(SurvivalCategory? category) {
    if (category == null) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategory: category));
    }
  }

  void filterByDialect(String dialect) {
    emit(state.copyWith(selectedDialect: dialect));
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setTab(int index) {
    emit(state.copyWith(activeTabIndex: index));
  }
}
