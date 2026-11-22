import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/business_phrase_entity.dart';
import '../../domain/entities/interview_question_entity.dart';
import '../../domain/repositories/career_repository.dart';
import 'career_catalog_state.dart';

class CareerCatalogCubit extends Cubit<CareerCatalogState> {
  final CareerRepository _repository;

  CareerCatalogCubit({required CareerRepository repository})
      : _repository = repository,
        super(const CareerCatalogState());

  Future<void> loadCatalog() async {
    emit(state.copyWith(status: CareerCatalogStatus.loading));

    final scRes = await _repository.getScenarios();
    final phRes = await _repository.getPhrases();
    final cvRes = await _repository.getCvGuides();

    if (scRes.isOk && phRes.isOk && cvRes.isOk) {
      emit(state.copyWith(
        status: CareerCatalogStatus.loaded,
        allScenarios: scRes.value,
        allPhrases: phRes.value,
        allCvGuides: cvRes.value,
      ));
    } else {
      final error = scRes.failure?.message ??
          phRes.failure?.message ??
          cvRes.failure?.message ??
          'Ошибка загрузки карьерного каталога';
      emit(state.copyWith(
        status: CareerCatalogStatus.error,
        errorMessage: error,
      ));
    }
  }

  void filterByCategory(CareerCategory? category) {
    if (category == null) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategory: category));
    }
  }

  void filterByPhraseType(BusinessPhraseType? phraseType) {
    if (phraseType == null) {
      emit(state.copyWith(clearPhraseType: true));
    } else {
      emit(state.copyWith(selectedPhraseType: phraseType));
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
