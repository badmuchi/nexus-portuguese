import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/football_entities.dart';
import '../../domain/repositories/football_repository.dart';
import '../cubit/football_catalog_cubit.dart';
import '../cubit/football_catalog_state.dart';
import '../widgets/fan_chant_card.dart';
import '../widgets/football_match_card.dart';
import '../widgets/football_term_card.dart';
import 'football_quiz_screen.dart';
import 'match_simulator_screen.dart';

class FootballCatalogScreen extends StatelessWidget {
  const FootballCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FootballCatalogCubit(
        repository: context.read<FootballRepository>(),
      )..loadCatalog(),
      child: const _FootballCatalogView(),
    );
  }
}

class _FootballCatalogView extends StatefulWidget {
  const _FootballCatalogView();

  @override
  State<_FootballCatalogView> createState() => _FootballCatalogViewState();
}

class _FootballCatalogViewState extends State<_FootballCatalogView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<FootballCatalogCubit>().setTab(_tabController.index);
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
        title: const Text('Gira do Futebol & Torcida ⚽'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sports_rounded),
            tooltip: 'Quiz da Pelada',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FootballQuizScreen()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Матчи', icon: Icon(Icons.stadium_rounded)),
            Tab(text: 'Словарь', icon: Icon(Icons.compare_arrows_rounded)),
            Tab(text: 'Кричалки', icon: Icon(Icons.campaign_rounded)),
          ],
        ),
      ),
      body: BlocBuilder<FootballCatalogCubit, FootballCatalogState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FootballCatalogStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'Ошибка загрузки футбола',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<FootballCatalogCubit>().loadCatalog(),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Search input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск термина, клуба или момента...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              context.read<FootballCatalogCubit>().search('');
                            },
                          )
                        : null,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (text) =>
                      context.read<FootballCatalogCubit>().search(text),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    // Dialect filters
                    ChoiceChip(
                      label: const Text('Все регионы 🌐'),
                      selected: state.selectedDialect == 'all',
                      onSelected: (_) => context
                          .read<FootballCatalogCubit>()
                          .filterByDialect('all'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Portugal 🇵🇹'),
                      selected: state.selectedDialect == 'PT',
                      onSelected: (_) => context
                          .read<FootballCatalogCubit>()
                          .filterByDialect('PT'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Brasil 🇧🇷'),
                      selected: state.selectedDialect == 'BR',
                      onSelected: (_) => context
                          .read<FootballCatalogCubit>()
                          .filterByDialect('BR'),
                    ),

                    if (state.activeTabIndex == 1) ...[
                      const SizedBox(width: 12),
                      const Text('•', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 12),

                      ChoiceChip(
                        label: const Text('Все категории'),
                        selected: state.selectedCategory == null,
                        onSelected: (_) => context
                            .read<FootballCatalogCubit>()
                            .filterByCategory(null),
                      ),
                      const SizedBox(width: 8),
                      ...FootballTermCategory.values.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('${cat.emoji} ${cat.labelRu}'),
                            selected: state.selectedCategory == cat,
                            onSelected: (_) => context
                                .read<FootballCatalogCubit>()
                                .filterByCategory(cat),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),

              // TabBarView Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // 1. Matches Tab
                    state.filteredMatches.isEmpty
                        ? Center(
                            child: Text(
                              'Матчи не найдены по запросу.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 6, bottom: 24),
                            itemCount: state.filteredMatches.length,
                            itemBuilder: (context, index) {
                              final match = state.filteredMatches[index];
                              return FootballMatchCard(
                                match: match,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MatchSimulatorScreen(match: match),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                    // 2. Terms Tab
                    state.filteredTerms.isEmpty
                        ? Center(
                            child: Text(
                              'Термины не найдены по запросу.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 6, bottom: 24),
                            itemCount: state.filteredTerms.length,
                            itemBuilder: (context, index) {
                              final term = state.filteredTerms[index];
                              return FootballTermCard(term: term);
                            },
                          ),

                    // 3. Chants Tab
                    state.filteredChants.isEmpty
                        ? Center(
                            child: Text(
                              'Кричалки не найдены по запросу.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 6, bottom: 24),
                            itemCount: state.filteredChants.length,
                            itemBuilder: (context, index) {
                              final chant = state.filteredChants[index];
                              return FanChantCard(chant: chant);
                            },
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
