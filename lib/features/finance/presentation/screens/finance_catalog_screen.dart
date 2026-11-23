import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/finance_entities.dart';
import '../../domain/repositories/finance_repository.dart';
import '../cubit/finance_catalog_cubit.dart';
import '../cubit/finance_catalog_state.dart';
import '../widgets/finance_topic_card.dart';
import '../widgets/fintech_simulator_card.dart';
import 'finance_quiz_screen.dart';
import 'finance_topic_detail_screen.dart';

class FinanceCatalogScreen extends StatelessWidget {
  const FinanceCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => FinanceCatalogCubit(
        ctx.read<FinanceRepository>(),
      )..loadData(),
      child: const _FinanceCatalogView(),
    );
  }
}

class _FinanceCatalogView extends StatefulWidget {
  const _FinanceCatalogView();

  @override
  State<_FinanceCatalogView> createState() => _FinanceCatalogViewState();
}

class _FinanceCatalogViewState extends State<_FinanceCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<FinanceCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Economia & Startups 💳'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.account_balance_rounded), text: 'Темы'),
              Tab(icon: Icon(Icons.phonelink_ring_rounded), text: 'Симуляторы'),
              Tab(icon: Icon(Icons.psychology_alt_rounded), text: 'Квиз'),
            ],
          ),
          actions: [
            BlocBuilder<FinanceCatalogCubit, FinanceCatalogState>(
              buildWhen: (prev, curr) =>
                  prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр региона',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<FinanceCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Pix, Faria Lima, CLT/PJ)'),
                    ),
                    PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (MB WAY, Web Summit, 14º)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<FinanceCatalogCubit, FinanceCatalogState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.topics.isEmpty) {
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
                        state.errorMessage ?? 'Ошибка загрузки финансовых тем',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () =>
                            context.read<FinanceCatalogCubit>().loadData(),
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
                _buildTopicsTab(context, state),
                _buildSimulatorsTab(context, state),
                _buildQuizTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopicsTab(BuildContext context, FinanceCatalogState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final topics = state.filteredTopics;

    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск темы, платежа или стартапа...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<FinanceCatalogCubit>().search('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (text) =>
                context.read<FinanceCatalogCubit>().search(text),
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
                  label: const Text('Все категории'),
                  selected: state.selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<FinanceCatalogCubit>().filterByCategory(null);
                    }
                  },
                ),
              ),
              ...FinanceCategory.values.map((cat) {
                final isSelected = state.selectedCategory == cat;
                final label = switch (cat) {
                  FinanceCategory.fintech => 'Финтех & Платежи',
                  FinanceCategory.startups => 'Стартапы & Венчур',
                  FinanceCategory.personalFinance => 'Личные финансы',
                  FinanceCategory.business => 'Бизнес & Налоги',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      context
                          .read<FinanceCatalogCubit>()
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
          child: topics.isEmpty
              ? Center(
                  child: Text(
                    'Ничего не найдено',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return FinanceTopicCard(
                      topic: topic,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FinanceTopicDetailScreen(
                              topic: topic,
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

  Widget _buildSimulatorsTab(
      BuildContext context, FinanceCatalogState state) {
    final simulators = state.simulators;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: simulators.length,
      itemBuilder: (context, index) {
        final sim = simulators[index];
        return FintechSimulatorCard(simulator: sim);
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
              Icons.savings_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Финансовая Викторина',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Проверьте свои знания о переводах Pix, MB WAY, 14 зарплатах в Португалии, налогах и экосистеме стартапов!',
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
                  builder: (_) => const FinanceQuizScreen(),
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
