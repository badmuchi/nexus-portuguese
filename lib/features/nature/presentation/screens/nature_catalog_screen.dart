import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/nature_entities.dart';
import '../../domain/repositories/nature_repository.dart';
import '../cubit/nature_catalog_cubit.dart';
import '../cubit/nature_catalog_state.dart';
import '../widgets/reserve_card.dart';
import '../widgets/species_card.dart';
import 'eco_quiz_screen.dart';
import 'nature_detail_screen.dart';

class NatureCatalogScreen extends StatelessWidget {
  const NatureCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => NatureCatalogCubit(
        repository: ctx.read<NatureRepository>(),
      )..loadCatalog(),
      child: const _NatureCatalogView(),
    );
  }
}

class _NatureCatalogView extends StatefulWidget {
  const _NatureCatalogView();

  @override
  State<_NatureCatalogView> createState() => _NatureCatalogViewState();
}

class _NatureCatalogViewState extends State<_NatureCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _addedSpeciesIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<NatureCatalogCubit>().setTab(_tabController.index);
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

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Natureza & Ecoturismo 🌿'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.terrain_rounded), text: 'Заповедники'),
              Tab(icon: Icon(Icons.pets_rounded), text: 'Флора & Фауна'),
              Tab(icon: Icon(Icons.eco_rounded), text: 'Эко-тест'),
            ],
          ),
          actions: [
            BlocBuilder<NatureCatalogCubit, NatureCatalogState>(
              buildWhen: (prev, curr) => prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр региона',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<NatureCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    const PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Amazônia, Pantanal, Chapada)'),
                    ),
                    const PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Gerês, Açores, Estrela)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<NatureCatalogCubit, NatureCatalogState>(
          builder: (context, state) {
            if (state.status == NatureCatalogStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == NatureCatalogStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage ?? 'Ошибка загрузки данных',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () =>
                            context.read<NatureCatalogCubit>().loadCatalog(),
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
                _buildReservesTab(context, state),
                _buildSpeciesTab(context, state),
                _buildQuizTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildReservesTab(BuildContext context, NatureCatalogState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final reserves = state.filteredReserves;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Поиск парка, региона или биома...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<NatureCatalogCubit>().search('');
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (text) => context.read<NatureCatalogCubit>().search(text),
        ),
        const SizedBox(height: 16),
        if (reserves.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Заповедников не найдено',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ...reserves.map(
            (r) => ReserveCard(
              reserve: r,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => NatureDetailScreen(reserve: r),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSpeciesTab(BuildContext context, NatureCatalogState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final speciesList = state.filteredSpecies;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Все виды'),
                selected: state.selectedSpeciesCategory == null,
                onSelected: (selected) {
                  if (selected) {
                    context.read<NatureCatalogCubit>().filterBySpeciesCategory(null);
                  }
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('🐾 Фауна'),
                selected: state.selectedSpeciesCategory == SpeciesCategory.fauna,
                onSelected: (selected) {
                  context.read<NatureCatalogCubit>().filterBySpeciesCategory(
                        selected ? SpeciesCategory.fauna : null,
                      );
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('🌿 Флора'),
                selected: state.selectedSpeciesCategory == SpeciesCategory.flora,
                onSelected: (selected) {
                  context.read<NatureCatalogCubit>().filterBySpeciesCategory(
                        selected ? SpeciesCategory.flora : null,
                      );
                },
              ),
            ],
          ),
        ),
        const Divider(height: 16),
        Expanded(
          child: speciesList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Видов не найдено',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: speciesList.length,
                  itemBuilder: (context, index) {
                    final sp = speciesList[index];
                    final isAdded = _addedSpeciesIds.contains(sp.id);
                    return SpeciesCard(
                      species: sp,
                      isAddedToSrs: isAdded,
                      onAddToSrs: () {
                        setState(() => _addedSpeciesIds.add(sp.id));
                        context.read<NatureRepository>().addSpeciesToSrs(sp);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '«${sp.commonNamePt}» добавлено в FSRS словарь!',
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildQuizTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('🌿', style: TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 20),
            Text(
              'Quiz da Natureza & Ecoturismo',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Проверьте свои знания уникальной флоры, фауны, географии и терминов экотуризма Португалии и Бразилии!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EcoQuizScreen()),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Начать эко-викторину'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade800,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
