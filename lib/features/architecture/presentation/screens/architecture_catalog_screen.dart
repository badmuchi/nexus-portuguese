import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/architecture_entities.dart';
import '../../domain/repositories/architecture_repository.dart';
import '../cubit/architecture_catalog_cubit.dart';
import '../cubit/architecture_catalog_state.dart';
import '../widgets/architectural_style_card.dart';
import '../widgets/monument_card.dart';
import 'architecture_quiz_screen.dart';
import 'monument_detail_screen.dart';

class ArchitectureCatalogScreen extends StatelessWidget {
  const ArchitectureCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ArchitectureCatalogCubit(
        ctx.read<ArchitectureRepository>(),
      )..loadData(),
      child: const _ArchitectureCatalogView(),
    );
  }
}

class _ArchitectureCatalogView extends StatefulWidget {
  const _ArchitectureCatalogView();

  @override
  State<_ArchitectureCatalogView> createState() =>
      _ArchitectureCatalogViewState();
}

class _ArchitectureCatalogViewState extends State<_ArchitectureCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<ArchitectureCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Arquitetura Lusófona 🏛️'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.apartment_rounded), text: 'Памятники'),
              Tab(icon: Icon(Icons.style_rounded), text: 'Стили'),
              Tab(icon: Icon(Icons.psychology_alt_rounded), text: 'Квиз'),
            ],
          ),
          actions: [
            BlocBuilder<ArchitectureCatalogCubit, ArchitectureCatalogState>(
              buildWhen: (prev, curr) =>
                  prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр региона',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context
                        .read<ArchitectureCatalogCubit>()
                        .filterByDialect(dialect);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Niemeyer, Barroco, Manaus)'),
                    ),
                    PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Manuelino, Porto, Sintra)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ArchitectureCatalogCubit, ArchitectureCatalogState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.monuments.isEmpty) {
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
                        state.errorMessage ?? 'Ошибка загрузки каталога',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () =>
                            context.read<ArchitectureCatalogCubit>().loadData(),
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
                _buildMonumentsTab(context, state),
                _buildStylesTab(context, state),
                _buildQuizTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonumentsTab(
      BuildContext context, ArchitectureCatalogState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final monuments = state.filteredMonuments;

    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск памятника, города или архитектора...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<ArchitectureCatalogCubit>().search('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (text) =>
                context.read<ArchitectureCatalogCubit>().search(text),
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
                  label: const Text('Все направления'),
                  selected: state.selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) {
                      context
                          .read<ArchitectureCatalogCubit>()
                          .filterByCategory(null);
                    }
                  },
                ),
              ),
              ...ArchitectureCategory.values.map((cat) {
                final isSelected = state.selectedCategory == cat;
                final label = switch (cat) {
                  ArchitectureCategory.monument => 'Памятники & Соборы',
                  ArchitectureCategory.modernUrban => 'Модернизм & Город',
                  ArchitectureCategory.contemporary => 'Современная',
                  ArchitectureCategory.colonial => 'Колониальное барокко',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      context
                          .read<ArchitectureCatalogCubit>()
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
          child: monuments.isEmpty
              ? Center(
                  child: Text(
                    'Ничего не найдено',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  itemCount: monuments.length,
                  itemBuilder: (context, index) {
                    final monument = monuments[index];
                    return MonumentCard(
                      monument: monument,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MonumentDetailScreen(
                              monument: monument,
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

  Widget _buildStylesTab(
      BuildContext context, ArchitectureCatalogState state) {
    final styles = state.styles;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: styles.length,
      itemBuilder: (context, index) {
        final style = styles[index];
        return ArchitecturalStyleCard(style: style);
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
              Icons.architecture_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Архитектурная Викторина',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Проверьте свои знания архитектурных стилей, мануэлино, модернизма Оскара Нимейера и ключевой португальской терминологии.',
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
                  builder: (_) => const ArchitectureQuizScreen(),
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
