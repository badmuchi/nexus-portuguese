import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/art_entities.dart';
import '../../domain/repositories/art_repository.dart';
import '../cubit/art_catalog_cubit.dart';
import '../cubit/art_catalog_state.dart';
import '../widgets/art_style_card.dart';
import '../widgets/artwork_card.dart';
import 'art_quiz_screen.dart';
import 'artwork_detail_screen.dart';

class ArtCatalogScreen extends StatelessWidget {
  const ArtCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ArtCatalogCubit(
        repository: ctx.read<ArtRepository>(),
      )..loadCatalog(),
      child: const _ArtCatalogView(),
    );
  }
}

class _ArtCatalogView extends StatefulWidget {
  const _ArtCatalogView();

  @override
  State<_ArtCatalogView> createState() => _ArtCatalogViewState();
}

class _ArtCatalogViewState extends State<_ArtCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<ArtCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Artes & Azulejos 🎨'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.palette_rounded), text: 'Шедевры'),
              Tab(icon: Icon(Icons.style_rounded), text: 'Стили'),
              Tab(icon: Icon(Icons.psychology_alt_rounded), text: 'Квиз'),
            ],
          ),
          actions: [
            BlocBuilder<ArtCatalogCubit, ArtCatalogState>(
              buildWhen: (prev, curr) => prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр региона',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<ArtCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    const PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Modernismo & Barroco)'),
                    ),
                    const PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Azulejos & Vanguarda)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ArtCatalogCubit, ArtCatalogState>(
          builder: (context, state) {
            if (state.status == ArtCatalogStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ArtCatalogStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage ?? 'Ошибка загрузки каталога',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () =>
                            context.read<ArtCatalogCubit>().loadCatalog(),
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
                _buildArtworksTab(context, state),
                _buildStylesTab(context, state),
                _buildQuizTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildArtworksTab(BuildContext context, ArtCatalogState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final artworks = state.filteredArtworks;

    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск картины, художника или музея...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<ArtCatalogCubit>().search('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (text) => context.read<ArtCatalogCubit>().search(text),
          ),
        ),
        // Period Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: const Text('Все эпохи'),
                  selected: state.selectedPeriod == null,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<ArtCatalogCubit>().filterByPeriod(null);
                    }
                  },
                ),
              ),
              ...ArtPeriod.values.map((period) {
                final isSelected = state.selectedPeriod == period;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(period.labelRu),
                    selected: isSelected,
                    onSelected: (selected) {
                      context.read<ArtCatalogCubit>().filterByPeriod(
                            selected ? period : null,
                          );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        const Divider(height: 16),
        // List
        Expanded(
          child: artworks.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Произведений не найдено',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: artworks.length,
                  itemBuilder: (context, index) {
                    final art = artworks[index];
                    return ArtworkCard(
                      artwork: art,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ArtworkDetailScreen(artwork: art),
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

  Widget _buildStylesTab(BuildContext context, ArtCatalogState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final styles = state.allStyles;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: const Row(
            children: [
              Text('🏛️', style: TextStyle(fontSize: 26)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'От изразцов Лиссабона и золотого барокко Оуру-Прету до бунтарского модерна и урбанистического стрит-арта Сан-Паулу.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...styles.map((s) => ArtStyleCard(style: s)),
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
                color: Colors.amber.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('🎨', style: TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 20),
            Text(
              'Quiz do Crítico de Arte',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Проверьте свои знания шедевров живописи, скульптуры, азулежу и стрит-арта Португалии и Бразилии!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ArtQuizScreen()),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Начать арт-викторину'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.amber.shade900,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
