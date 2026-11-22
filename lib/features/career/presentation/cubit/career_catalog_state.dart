import 'package:equatable/equatable.dart';
import '../../domain/entities/business_phrase_entity.dart';
import '../../domain/entities/cv_guide_item_entity.dart';
import '../../domain/entities/interview_question_entity.dart';
import '../../domain/entities/interview_scenario_entity.dart';

enum CareerCatalogStatus { initial, loading, loaded, error }

class CareerCatalogState extends Equatable {
  final CareerCatalogStatus status;
  final List<InterviewScenarioEntity> allScenarios;
  final List<BusinessPhraseEntity> allPhrases;
  final List<CvGuideItemEntity> allCvGuides;
  final CareerCategory? selectedCategory;
  final BusinessPhraseType? selectedPhraseType;
  final String selectedDialect; // 'all', 'pt_BR', 'pt_PT'
  final String searchQuery;
  final int activeTabIndex; // 0 = Собеседования, 1 = Фразы & Письма, 2 = Резюме
  final String? errorMessage;

  const CareerCatalogState({
    this.status = CareerCatalogStatus.initial,
    this.allScenarios = const [],
    this.allPhrases = const [],
    this.allCvGuides = const [],
    this.selectedCategory,
    this.selectedPhraseType,
    this.selectedDialect = 'all',
    this.searchQuery = '',
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  bool get isLoading => status == CareerCatalogStatus.loading;

  List<InterviewScenarioEntity> get filteredScenarios {
    var res = List<InterviewScenarioEntity>.from(allScenarios);
    if (selectedCategory != null) {
      res = res.where((s) => s.category == selectedCategory).toList();
    }
    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt') && !selectedDialect.toLowerCase().contains('br');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((s) => s.isPtPt).toList();
      } else if (isBr) {
        res = res.where((s) => s.isPtBr).toList();
      }
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((s) =>
          s.jobTitlePt.toLowerCase().contains(q) ||
          s.jobTitleRu.toLowerCase().contains(q) ||
          s.companyName.toLowerCase().contains(q)).toList();
    }
    return res;
  }

  List<BusinessPhraseEntity> get filteredPhrases {
    var res = List<BusinessPhraseEntity>.from(allPhrases);
    if (selectedPhraseType != null) {
      res = res.where((p) => p.phraseType == selectedPhraseType).toList();
    }
    if (selectedCategory != null) {
      res = res.where((p) => p.category == selectedCategory).toList();
    }
    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt') && !selectedDialect.toLowerCase().contains('br');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((p) => p.isPtPt || (!p.isPtPt && !p.isPtBr)).toList();
      } else if (isBr) {
        res = res.where((p) => p.isPtBr || (!p.isPtPt && !p.isPtBr)).toList();
      }
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((p) =>
          p.textPt.toLowerCase().contains(q) ||
          p.translationRu.toLowerCase().contains(q) ||
          p.contextNoteRu.toLowerCase().contains(q)).toList();
    }
    return res;
  }

  List<CvGuideItemEntity> get filteredCvGuides {
    var res = List<CvGuideItemEntity>.from(allCvGuides);
    if (selectedDialect != 'all') {
      final isPt = selectedDialect.toLowerCase().contains('pt') && !selectedDialect.toLowerCase().contains('br');
      final isBr = selectedDialect.toLowerCase().contains('br');
      if (isPt) {
        res = res.where((g) => g.isPtPt || (!g.isPtPt && !g.isPtBr)).toList();
      } else if (isBr) {
        res = res.where((g) => g.isPtBr || (!g.isPtPt && !g.isPtBr)).toList();
      }
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      res = res.where((g) =>
          g.sectionTitlePt.toLowerCase().contains(q) ||
          g.sectionTitleRu.toLowerCase().contains(q) ||
          g.explanationRu.toLowerCase().contains(q)).toList();
    }
    return res;
  }

  CareerCatalogState copyWith({
    CareerCatalogStatus? status,
    List<InterviewScenarioEntity>? allScenarios,
    List<BusinessPhraseEntity>? allPhrases,
    List<CvGuideItemEntity>? allCvGuides,
    CareerCategory? selectedCategory,
    bool clearCategory = false,
    BusinessPhraseType? selectedPhraseType,
    bool clearPhraseType = false,
    String? selectedDialect,
    String? searchQuery,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return CareerCatalogState(
      status: status ?? this.status,
      allScenarios: allScenarios ?? this.allScenarios,
      allPhrases: allPhrases ?? this.allPhrases,
      allCvGuides: allCvGuides ?? this.allCvGuides,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedPhraseType: clearPhraseType ? null : (selectedPhraseType ?? this.selectedPhraseType),
      selectedDialect: selectedDialect ?? this.selectedDialect,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allScenarios,
        allPhrases,
        allCvGuides,
        selectedCategory,
        selectedPhraseType,
        selectedDialect,
        searchQuery,
        activeTabIndex,
        errorMessage,
      ];
}
