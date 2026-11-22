import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/travel_phrase_entity.dart';
import '../../domain/repositories/travel_guide_repository.dart';
import '../cubit/travel_catalog_cubit.dart';
import '../cubit/travel_catalog_state.dart';
import '../widgets/country_card.dart';
import '../widgets/travel_phrase_tile.dart';
import 'country_detail_screen.dart';
import 'geography_quiz_screen.dart';

class TravelCatalogScreen extends StatelessWidget {
  const TravelCatalogScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const TravelCatalogScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => TravelCatalogCubit(
        repository: ctx.read<TravelGuideRepository>(),
      )..loadCatalog(),
      child: const _TravelCatalogView(),
    );
  }
}

class _TravelCatalogView extends StatefulWidget {
  const _TravelCatalogView();

  @override
  State<_TravelCatalogView> createState() => _TravelCatalogViewState();
}

class _TravelCatalogViewState extends State<_TravelCatalogView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<TravelCatalogCubit>().setTab(_tabController.index);
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Атлас & Путеводитель 🧭',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_ind_outlined),
            tooltip: 'Викторина: Паспорт Лузофонии',
            onPressed: () {
              Navigator.of(context).push(GeographyQuizScreen.route());
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.public_rounded), text: 'Страны CPLP'),
            Tab(icon: Icon(Icons.luggage_rounded), text: 'Фразы в Дорогу'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(context),
          Expanded(
            child: BlocBuilder<TravelCatalogCubit, TravelCatalogState>(
              builder: (context, state) {
                if (state.status == TravelCatalogStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == TravelCatalogStatus.error) {
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
                            onPressed: () => context.read<TravelCatalogCubit>().loadCatalog(),
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
                    _buildCountriesTab(context, state, theme),
                    _buildPhrasesTab(context, state),
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
    final cubit = context.read<TravelCatalogCubit>();
    final theme = Theme.of(context);

    return BlocBuilder<TravelCatalogCubit, TravelCatalogState>(
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
                  hintText: 'Поиск по стране, столице, фразе...',
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
                      selected: state.selectedDialect == 'all',
                      label: const Text('Все диалекты'),
                      onSelected: (_) => cubit.filterByDialect('all'),
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
                      _buildContinentChip(cubit, state, null, 'Все регионы'),
                      _buildContinentChip(cubit, state, 'Европа', '🏰 Европа'),
                      _buildContinentChip(cubit, state, 'Америка', '🌴 Америка'),
                      _buildContinentChip(cubit, state, 'Африка', '🦁 Африка'),
                      _buildContinentChip(cubit, state, 'Азия', '🏯 Азия'),
                    ],
                    if (state.activeTabIndex == 1) ...[
                      const SizedBox(width: 12),
                      _buildCategoryChip(cubit, state, null, 'Все темы'),
                      _buildCategoryChip(cubit, state, TravelPhraseCategory.airportCustoms, '✈️ Аэропорт'),
                      _buildCategoryChip(cubit, state, TravelPhraseCategory.transport, '🚕 Транспорт'),
                      _buildCategoryChip(cubit, state, TravelPhraseCategory.hotelLodging, '🏨 Отель'),
                      _buildCategoryChip(cubit, state, TravelPhraseCategory.restaurantDining, '🍽️ Ресторан'),
                      _buildCategoryChip(cubit, state, TravelPhraseCategory.emergencies, '🆘 Помощь'),
                      _buildCategoryChip(cubit, state, TravelPhraseCategory.localCourtesies, '🤝 Этикет'),
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

  Widget _buildContinentChip(
    TravelCatalogCubit cubit,
    TravelCatalogState state,
    String? cont,
    String label,
  ) {
    final isSelected = state.selectedContinent == cont;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) => cubit.filterByContinent(cont),
      ),
    );
  }

  Widget _buildCategoryChip(
    TravelCatalogCubit cubit,
    TravelCatalogState state,
    TravelPhraseCategory? cat,
    String label,
  ) {
    final isSelected = state.selectedPhraseCategory == cat;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) => cubit.filterByPhraseCategory(cat),
      ),
    );
  }

  Widget _buildCountriesTab(
    BuildContext context,
    TravelCatalogState state,
    ThemeData theme,
  ) {
    final countries = state.filteredCountries;

    return RefreshIndicator(
      onRefresh: () => context.read<TravelCatalogCubit>().loadCatalog(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: countries.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.surfaceContainerHighest,
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Text('🛂', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Викторина: Паспорт Лузофонии',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          'Отвечайте на вопросы и собирайте визовые штампы стран CPLP!',
                          style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(GeographyQuizScreen.route());
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Старт', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }

          final c = countries[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CountryCard(
              country: c,
              onTap: () {
                Navigator.of(context).push(
                  CountryDetailScreen.route(country: c),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhrasesTab(BuildContext context, TravelCatalogState state) {
    final phrases = state.filteredPhrases;

    if (phrases.isEmpty) {
      return _buildEmptyState('Фразы по выбранным фильтрам не найдены');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<TravelCatalogCubit>().loadCatalog(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          final p = phrases[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TravelPhraseTile(phrase: p),
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
            const Icon(Icons.explore_off_outlined, size: 56, color: Colors.grey),
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
