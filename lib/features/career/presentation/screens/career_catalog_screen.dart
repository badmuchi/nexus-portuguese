import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/business_phrase_entity.dart';
import '../../domain/entities/interview_question_entity.dart';
import '../../domain/repositories/career_repository.dart';
import '../cubit/career_catalog_cubit.dart';
import '../cubit/career_catalog_state.dart';
import '../widgets/business_phrase_tile.dart';
import '../widgets/cv_guide_card.dart';
import '../widgets/interview_scenario_card.dart';
import 'interview_simulator_screen.dart';

class CareerCatalogScreen extends StatelessWidget {
  const CareerCatalogScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const CareerCatalogScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => CareerCatalogCubit(
        repository: ctx.read<CareerRepository>(),
      )..loadCatalog(),
      child: const _CareerCatalogView(),
    );
  }
}

class _CareerCatalogView extends StatefulWidget {
  const _CareerCatalogView();

  @override
  State<_CareerCatalogView> createState() => _CareerCatalogViewState();
}

class _CareerCatalogViewState extends State<_CareerCatalogView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<CareerCatalogCubit>().setTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Карьера & Рынок Труда 💼',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.record_voice_over_rounded), text: 'Интервью'),
            Tab(icon: Icon(Icons.mark_email_read_rounded), text: 'Фразы & Письма'),
            Tab(icon: Icon(Icons.description_rounded), text: 'Резюме & Законы'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(context),
          Expanded(
            child: BlocBuilder<CareerCatalogCubit, CareerCatalogState>(
              builder: (context, state) {
                if (state.status == CareerCatalogStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == CareerCatalogStatus.error) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(
                            state.errorMessage ?? 'Произошла ошибка',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => context.read<CareerCatalogCubit>().loadCatalog(),
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildScenariosTab(context, state),
                    _buildPhrasesTab(context, state),
                    _buildCvGuidesTab(context, state),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    final cubit = context.read<CareerCatalogCubit>();
    final theme = Theme.of(context);

    return BlocBuilder<CareerCatalogCubit, CareerCatalogState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск по роли, навыку, фразе...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            cubit.search('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => cubit.search(val),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      selected: state.selectedDialect == 'ALL',
                      label: const Text('Все регионы'),
                      onSelected: (_) => cubit.filterByDialect('ALL'),
                    ),
                    const SizedBox(width: 6),
                    FilterChip(
                      selected: state.selectedDialect == 'BR',
                      label: const Text('🇧🇷 Brasil'),
                      onSelected: (_) => cubit.filterByDialect('BR'),
                    ),
                    const SizedBox(width: 6),
                    FilterChip(
                      selected: state.selectedDialect == 'PT',
                      label: const Text('🇵🇹 Portugal'),
                      onSelected: (_) => cubit.filterByDialect('PT'),
                    ),
                    if (state.activeTabIndex == 0) ...[
                      const SizedBox(width: 12),
                      _buildCategoryChip(cubit, state, null, 'Все сферы'),
                      _buildCategoryChip(cubit, state, CareerCategory.tech, '💻 IT & Tech'),
                      _buildCategoryChip(cubit, state, CareerCategory.sales, '📈 Vendas'),
                      _buildCategoryChip(cubit, state, CareerCategory.hospitality, '🏨 Hotelaria'),
                      _buildCategoryChip(cubit, state, CareerCategory.marketing, '📢 Marketing'),
                      _buildCategoryChip(cubit, state, CareerCategory.general, '🤝 Geral & RH'),
                    ],
                    if (state.activeTabIndex == 1) ...[
                      const SizedBox(width: 12),
                      _buildPhraseTypeChip(cubit, state, null, 'Все типы'),
                      _buildPhraseTypeChip(cubit, state, BusinessPhraseType.emailTemplate, '✉️ Emails'),
                      _buildPhraseTypeChip(cubit, state, BusinessPhraseType.interviewPitch, '🤝 Pitch & Entrevista'),
                      _buildPhraseTypeChip(cubit, state, BusinessPhraseType.salaryNegotiation, '💵 Salário'),
                      _buildPhraseTypeChip(cubit, state, BusinessPhraseType.cvActionVerb, '⚡ Verbos de Ação'),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
    CareerCatalogCubit cubit,
    CareerCatalogState state,
    CareerCategory? category,
    String label,
  ) {
    final isSelected = state.selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) => cubit.filterByCategory(category),
      ),
    );
  }

  Widget _buildPhraseTypeChip(
    CareerCatalogCubit cubit,
    CareerCatalogState state,
    BusinessPhraseType? type,
    String label,
  ) {
    final isSelected = state.selectedPhraseType == type;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) => cubit.filterByPhraseType(type),
      ),
    );
  }

  Widget _buildScenariosTab(BuildContext context, CareerCatalogState state) {
    final scenarios = state.filteredScenarios;

    if (scenarios.isEmpty) {
      return _buildEmptyState('Собеседования по заданным фильтрам не найдены');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<CareerCatalogCubit>().loadCatalog(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: scenarios.length,
        itemBuilder: (context, index) {
          final sc = scenarios[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InterviewScenarioCard(
              scenario: sc,
              onTap: () {
                Navigator.of(context).push(
                  InterviewSimulatorScreen.route(scenario: sc),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhrasesTab(BuildContext context, CareerCatalogState state) {
    final phrases = state.filteredPhrases;

    if (phrases.isEmpty) {
      return _buildEmptyState('Деловые фразы по заданным фильтрам не найдены');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<CareerCatalogCubit>().loadCatalog(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          final ph = phrases[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BusinessPhraseTile(phrase: ph),
          );
        },
      ),
    );
  }

  Widget _buildCvGuidesTab(BuildContext context, CareerCatalogState state) {
    final guides = state.filteredCvGuides;

    if (guides.isEmpty) {
      return _buildEmptyState('Гайды по резюме не найдены');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<CareerCatalogCubit>().loadCatalog(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: guides.length,
        itemBuilder: (context, index) {
          final g = guides[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CvGuideCard(item: g),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.work_off_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
