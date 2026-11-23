import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/bazar_repository.dart';
import '../cubit/bazar_catalog_cubit.dart';
import '../cubit/bazar_catalog_state.dart';
import '../widgets/bargain_scenario_card.dart';
import '../widgets/market_phrase_tile.dart';
import '../widgets/marketplace_card.dart';
import 'bargain_simulator_screen.dart';
import 'market_detail_screen.dart';

class BazarCatalogScreen extends StatelessWidget {
  const BazarCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => BazarCatalogCubit(
        repository: ctx.read<BazarRepository>(),
      )..loadCatalog(),
      child: const _BazarCatalogView(),
    );
  }
}

class _BazarCatalogView extends StatefulWidget {
  const _BazarCatalogView();

  @override
  State<_BazarCatalogView> createState() => _BazarCatalogViewState();
}

class _BazarCatalogViewState extends State<_BazarCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<BazarCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Bazar & Feira Livre 🛒'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.storefront_rounded), text: 'Рынки'),
              Tab(icon: Icon(Icons.handshake_outlined), text: 'Торг'),
              Tab(icon: Icon(Icons.chat_bubble_outline_rounded), text: 'Фразы'),
            ],
          ),
          actions: [
            BlocBuilder<BazarCatalogCubit, BazarCatalogState>(
              buildWhen: (prev, curr) => prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр диалекта',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<BazarCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все диалекты'),
                    ),
                    const PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Feira Livre)'),
                    ),
                    const PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Mercado/Feira)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<BazarCatalogCubit, BazarCatalogState>(
          builder: (context, state) {
            if (state.status == BazarCatalogStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == BazarCatalogStatus.error) {
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
                            context.read<BazarCatalogCubit>().loadCatalog(),
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
                _buildMarketsTab(context, state),
                _buildScenariosTab(context, state),
                _buildPhrasesTab(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMarketsTab(BuildContext context, BazarCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final markets = state.filteredMarkets;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Intro hint
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              const Text('🍍', style: TextStyle(fontSize: 26)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Знакомьтесь с легендарными рынками Лиссабона, Порту, Сан-Паулу и Рио. Слушайте зазывы торговцев и пополняйте словарный запас!',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (markets.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Рынков не найдено для выбранного фильтра',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...markets.map(
            (m) => MarketplaceCard(
              market: m,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MarketDetailScreen(marketplace: m),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildScenariosTab(BuildContext context, BazarCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scenarios = state.filteredScenarios;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Intro hint
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.secondary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              const Text('🏷️', style: TextStyle(fontSize: 26)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Торговаться — это искусство (Pechinchar в Бразилии, Regatear в Португалии). Пройдите диалоговый симулятор и сбейте стартовую цену!',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (scenarios.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Сценариев торга пока нет для выбранного фильтра',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...scenarios.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BargainScenarioCard(
                scenario: s,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BargainSimulatorScreen(scenario: s),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPhrasesTab(BuildContext context, BazarCatalogState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final phrases = state.filteredPhrases;

    final categories = <String, String>{
      'all': 'Все темы',
      'greeting': 'Приветствие',
      'weightAndQty': 'Вес и объём',
      'tasting': 'Дегустация',
      'bargaining': 'Торг и оплата',
    };

    return Column(
      children: [
        // Search & Filter
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск фраз по-португальски или по-русски...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<BazarCatalogCubit>().search('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (text) => context.read<BazarCatalogCubit>().search(text),
          ),
        ),
        // Category Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: categories.entries.map((entry) {
              final isSelected = entry.key == 'all'
                  ? state.selectedPhraseCategory == null
                  : state.selectedPhraseCategory == entry.key;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (selected) {
                    context.read<BazarCatalogCubit>().filterByCategory(
                          entry.key == 'all' || !selected ? null : entry.key,
                        );
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 16),
        // List of phrases
        Expanded(
          child: phrases.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Фраз не найдено',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: phrases.length,
                itemBuilder: (context, index) {
                  final phrase = phrases[index];
                  return MarketPhraseTile(phrase: phrase);
                },
              ),
        ),
      ],
    );
  }
}
