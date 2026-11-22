import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/culinary_vocabulary_entity.dart';
import '../../domain/repositories/gastronomy_repository.dart';
import '../cubit/gastronomy_catalog_cubit.dart';
import '../cubit/gastronomy_catalog_state.dart';
import '../widgets/culinary_term_tile.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class GastronomyCatalogScreen extends StatelessWidget {
  const GastronomyCatalogScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const GastronomyCatalogScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => GastronomyCatalogCubit(
        repository: ctx.read<GastronomyRepository>(),
      )..loadCatalog(),
      child: const _GastronomyCatalogView(),
    );
  }
}

class _GastronomyCatalogView extends StatefulWidget {
  const _GastronomyCatalogView();

  @override
  State<_GastronomyCatalogView> createState() => _GastronomyCatalogViewState();
}

class _GastronomyCatalogViewState extends State<_GastronomyCatalogView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<GastronomyCatalogCubit>().setTab(_tabController.index);
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
          'Кулинарная Лаборатория 🍳',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.menu_book_rounded), text: 'Рецепты'),
            Tab(icon: Icon(Icons.kitchen_rounded), text: 'Словарь & Утварь'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(context),
          Expanded(
            child: BlocBuilder<GastronomyCatalogCubit, GastronomyCatalogState>(
              builder: (context, state) {
                if (state.status == GastronomyCatalogStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == GastronomyCatalogStatus.error) {
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
                            onPressed: () => context.read<GastronomyCatalogCubit>().loadCatalog(),
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
                    _buildRecipesTab(context, state),
                    _buildTermsTab(context, state),
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
    final cubit = context.read<GastronomyCatalogCubit>();
    final theme = Theme.of(context);

    return BlocBuilder<GastronomyCatalogCubit, GastronomyCatalogState>(
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
                  hintText: 'Поиск по блюду, продукту, глаголу...',
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
                      label: const Text('Все регионы'),
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
                      _buildDifficultyChip(cubit, state, null, 'Все уровни'),
                      _buildDifficultyChip(cubit, state, 'Fácil', '🟢 Fácil'),
                      _buildDifficultyChip(cubit, state, 'Médio', '🟡 Médio'),
                      _buildDifficultyChip(cubit, state, 'Avançado', '🔴 Avançado'),
                    ],
                    if (state.activeTabIndex == 1) ...[
                      const SizedBox(width: 12),
                      _buildTermTypeChip(cubit, state, null, 'Все типы'),
                      _buildTermTypeChip(cubit, state, CulinaryTermType.cookingVerb, '🔪 Глаголы'),
                      _buildTermTypeChip(cubit, state, CulinaryTermType.utensil, '🍳 Утварь'),
                      _buildTermTypeChip(cubit, state, CulinaryTermType.measurement, '⚖️ Меры'),
                      _buildTermTypeChip(cubit, state, CulinaryTermType.dialectFood, '🔄 PT vs BR'),
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

  Widget _buildDifficultyChip(
    GastronomyCatalogCubit cubit,
    GastronomyCatalogState state,
    String? diff,
    String label,
  ) {
    final isSelected = state.selectedDifficulty == diff;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) => cubit.filterByDifficulty(diff),
      ),
    );
  }

  Widget _buildTermTypeChip(
    GastronomyCatalogCubit cubit,
    GastronomyCatalogState state,
    CulinaryTermType? type,
    String label,
  ) {
    final isSelected = state.selectedTermType == type;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) => cubit.filterByTermType(type),
      ),
    );
  }

  Widget _buildRecipesTab(BuildContext context, GastronomyCatalogState state) {
    final recipes = state.filteredRecipes;

    if (recipes.isEmpty) {
      return _buildEmptyState('Рецепты по выбранным фильтрам не найдены');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<GastronomyCatalogCubit>().loadCatalog(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final r = recipes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RecipeCard(
              recipe: r,
              onTap: () {
                Navigator.of(context).push(
                  RecipeDetailScreen.route(recipe: r),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTermsTab(BuildContext context, GastronomyCatalogState state) {
    final terms = state.filteredTerms;

    if (terms.isEmpty) {
      return _buildEmptyState('Кулинарные термины не найдены');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<GastronomyCatalogCubit>().loadCatalog(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: terms.length,
        itemBuilder: (context, index) {
          final t = terms[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CulinaryTermTile(term: t),
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
            const Icon(Icons.soup_kitchen_outlined, size: 56, color: Colors.grey),
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
