import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/wine_entities.dart';
import '../../domain/repositories/wine_repository.dart';
import '../cubit/wine_catalog_cubit.dart';
import '../cubit/wine_catalog_state.dart';
import '../widgets/tasting_guide_card.dart';
import '../widgets/wine_region_card.dart';
import 'wine_quiz_screen.dart';
import 'wine_region_detail_screen.dart';

class WineCatalogScreen extends StatelessWidget {
  const WineCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => WineCatalogCubit(
        ctx.read<WineRepository>(),
      )..loadData(),
      child: const _WineCatalogView(),
    );
  }
}

class _WineCatalogView extends StatefulWidget {
  const _WineCatalogView();

  @override
  State<_WineCatalogView> createState() => _WineCatalogViewState();
}

class _WineCatalogViewState extends State<_WineCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<WineCatalogCubit>().setTab(_tabController.index);
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
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vinhos & Azeites Lusófonos 🍷'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.wine_bar_rounded), text: 'Terroirs'),
              Tab(icon: Icon(Icons.menu_book_rounded), text: 'Degustação'),
              Tab(icon: Icon(Icons.psychology_alt_rounded), text: 'Квиз'),
            ],
          ),
          actions: [
            BlocBuilder<WineCatalogCubit, WineCatalogState>(
              buildWhen: (prev, curr) =>
                  prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр по регионам',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<WineCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Serra Gaúcha, Vale do São Francisco)'),
                    ),
                    PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Douro, Vinho Verde, Alentejo, Madeira)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<WineCatalogCubit, WineCatalogState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.regions.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 48, color: colorScheme.error),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () =>
                            context.read<WineCatalogCubit>().loadData(),
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
                _buildRegionsTab(context, state),
                _buildTastingGuidesTab(context, state),
                _buildQuizTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRegionsTab(BuildContext context, WineCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () => context.read<WineCatalogCubit>().loadData(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SearchBar(
            controller: _searchController,
            hintText: 'Поиск (Douro, Alvarinho, azeite, espumante)...',
            leading: const Icon(Icons.search_rounded),
            trailing: _searchController.text.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        context.read<WineCatalogCubit>().search('');
                      },
                    )
                  ]
                : null,
            onChanged: (val) => context.read<WineCatalogCubit>().search(val),
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Все категории'),
                  selected: state.selectedCategory == null,
                  onSelected: (_) {
                    context.read<WineCatalogCubit>().filterByCategory(null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Портвейн & Крепленые'),
                  selected: state.selectedCategory == WineCategory.vinhoFortificado,
                  onSelected: (selected) {
                    context.read<WineCatalogCubit>().filterByCategory(
                          selected ? WineCategory.vinhoFortificado : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Винью Верде & Белые'),
                  selected: state.selectedCategory == WineCategory.vinhoVerdeBranco,
                  onSelected: (selected) {
                    context.read<WineCatalogCubit>().filterByCategory(
                          selected ? WineCategory.vinhoVerdeBranco : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Оливковое масло'),
                  selected: state.selectedCategory == WineCategory.azeiteVirgemExtra,
                  onSelected: (selected) {
                    context.read<WineCatalogCubit>().filterByCategory(
                          selected ? WineCategory.azeiteVirgemExtra : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Бразильские терруары'),
                  selected: state.selectedCategory == WineCategory.vinhoBrasileiroAltitude,
                  onSelected: (selected) {
                    context.read<WineCatalogCubit>().filterByCategory(
                          selected ? WineCategory.vinhoBrasileiroAltitude : null,
                        );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (state.filteredRegions.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    const Text('🍷', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(
                      'Ничего не найдено',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Попробуйте изменить поисковый запрос или фильтры',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        _searchController.clear();
                        context.read<WineCatalogCubit>().clearFilters();
                      },
                      child: const Text('Сбросить фильтры'),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Text(
              'Терруары и регионы (${state.filteredRegions.length})',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...state.filteredRegions.map(
              (region) => WineRegionCard(
                region: region,
                onTap: () {
                  Navigator.of(context).push(
                    WineRegionDetailScreen.route(region: region),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTastingGuidesTab(BuildContext context, WineCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 0,
          color: Colors.purple.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.purple.shade200,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.auto_stories_rounded,
                    size: 32, color: Colors.purple.shade800),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enogastronomia & Subjuntivo',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Дегустационные протоколы сомелье, лексика бокала и сослагательное наклонение (Presente do Subjuntivo)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple.shade900,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Протоколы дегустации (${state.guides.length})',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...state.guides.map(
          (guide) => TastingGuideCard(
            guide: guide,
            onListen: () {
              final isPt = guide.beverageType.contains('Porto') ||
                  guide.beverageType.contains('Verde') ||
                  guide.beverageType.contains('Azeite');
              final dialectSetting = isPt
                  ? PortugueseDialect.european
                  : PortugueseDialect.brazilian;
              context.read<HybridAudioPlaybackService>().playAudioOrSpeak(
                    fallbackText:
                        '${guide.title}. ${guide.sommelierRecommendationPt}. ${guide.subjunctiveGrammarNote}',
                    dialect: dialectSetting,
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade800.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wine_bar_rounded,
                    size: 48,
                    color: Colors.purple.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Викторина сомелье',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Проверьте свои знания о винах Португалии и Бразилии, оливковом масле Алентежу, букетах и сослагательном наклонении Subjuntivo.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(WineQuizScreen.route());
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Начать викторину'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
