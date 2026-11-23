import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/festas_entities.dart';
import '../../domain/repositories/festas_repository.dart';
import '../cubit/festas_catalog_cubit.dart';
import '../cubit/festas_catalog_state.dart';
import '../widgets/festa_card.dart';
import '../widgets/tradition_card.dart';
import 'festa_detail_screen.dart';
import 'festa_quiz_screen.dart';

class FestasCatalogScreen extends StatelessWidget {
  const FestasCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => FestasCatalogCubit(
        ctx.read<FestasRepository>(),
      )..loadData(),
      child: const _FestasCatalogView(),
    );
  }
}

class _FestasCatalogView extends StatefulWidget {
  const _FestasCatalogView();

  @override
  State<_FestasCatalogView> createState() => _FestasCatalogViewState();
}

class _FestasCatalogViewState extends State<_FestasCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<FestasCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Festas & Folclore 🎉'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.celebration_rounded), text: 'Праздники'),
              Tab(icon: Icon(Icons.auto_stories_rounded), text: 'Традиции'),
              Tab(icon: Icon(Icons.psychology_alt_rounded), text: 'Квиз'),
            ],
          ),
          actions: [
            BlocBuilder<FestasCatalogCubit, FestasCatalogState>(
              buildWhen: (prev, curr) =>
                  prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр региона',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<FestasCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Rio, Salvador, São João)'),
                    ),
                    PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Lisboa, Porto)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<FestasCatalogCubit, FestasCatalogState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.festas.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage ?? 'Ошибка загрузки праздников',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () =>
                            context.read<FestasCatalogCubit>().loadData(),
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
                _buildFestasTab(context, state),
                _buildTraditionsTab(context, state),
                _buildQuizTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFestasTab(BuildContext context, FestasCatalogState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final festas = state.filteredFestas;

    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск праздника, города или традиции...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<FestasCatalogCubit>().search('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (text) =>
                context.read<FestasCatalogCubit>().search(text),
          ),
        ),
        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: const Text('Все события'),
                  selected: state.selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<FestasCatalogCubit>().filterByCategory(null);
                    }
                  },
                ),
              ),
              ...FestaCategory.values.map((cat) {
                final isSelected = state.selectedCategory == cat;
                final label = switch (cat) {
                  FestaCategory.carnaval => 'Карнавал',
                  FestaCategory.santosPopulares => 'Santos Populares',
                  FestaCategory.junina => 'Festa Junina',
                  FestaCategory.folclore => 'Фольклорный эпос',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      context
                          .read<FestasCatalogCubit>()
                          .filterByCategory(selected ? cat : null);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: festas.isEmpty
              ? Center(
                  child: Text(
                    'Ничего не найдено',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  itemCount: festas.length,
                  itemBuilder: (context, index) {
                    final festa = festas[index];
                    return FestaCard(
                      festa: festa,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FestaDetailScreen(
                              festa: festa,
                            ),
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

  Widget _buildTraditionsTab(BuildContext context, FestasCatalogState state) {
    final traditions = state.traditions;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: traditions.length,
      itemBuilder: (context, index) {
        final tradition = traditions[index];
        return TraditionCard(tradition: tradition);
      },
    );
  }

  Widget _buildQuizTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.celebration_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Викторина Народных Праздников',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Проверьте свои знания обрядов, карнавальных терминов (pipoca, comissão de frente), традиций Сан-Жуана и Санту-Антониу!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FestaQuizScreen(),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Начать викторину'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
