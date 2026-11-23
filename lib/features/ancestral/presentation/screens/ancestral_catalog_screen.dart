import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/ancestral_entities.dart';
import '../../domain/repositories/ancestral_repository.dart';
import '../cubit/ancestral_catalog_cubit.dart';
import '../cubit/ancestral_catalog_state.dart';
import '../widgets/community_card.dart';
import '../widgets/herbal_remedy_card.dart';
import 'ancestral_quiz_screen.dart';
import 'community_detail_screen.dart';

class AncestralCatalogScreen extends StatelessWidget {
  const AncestralCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AncestralCatalogCubit(
        ctx.read<AncestralRepository>(),
      )..loadData(),
      child: const _AncestralCatalogView(),
    );
  }
}

class _AncestralCatalogView extends StatefulWidget {
  const _AncestralCatalogView();

  @override
  State<_AncestralCatalogView> createState() => _AncestralCatalogViewState();
}

class _AncestralCatalogViewState extends State<_AncestralCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<AncestralCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Povos Tradicionais & Saberes 🌿'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.people_alt_rounded), text: 'Povos'),
              Tab(icon: Icon(Icons.local_florist_rounded), text: 'Ervanária'),
              Tab(icon: Icon(Icons.psychology_alt_rounded), text: 'Квиз'),
            ],
          ),
          actions: [
            BlocBuilder<AncestralCatalogCubit, AncestralCatalogState>(
              buildWhen: (prev, curr) =>
                  prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр по регионам',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<AncestralCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Ribeirinhos, Caiçaras, Sertanejos, Quilombos)'),
                    ),
                    PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Pastores da Estrela, Mariscadoras de Aveiro)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<AncestralCatalogCubit, AncestralCatalogState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.communities.isEmpty) {
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
                            context.read<AncestralCatalogCubit>().loadData(),
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
                _buildCommunitiesTab(context, state),
                _buildRemediesTab(context, state),
                _buildQuizTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommunitiesTab(
      BuildContext context, AncestralCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () => context.read<AncestralCatalogCubit>().loadData(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SearchBar(
            controller: _searchController,
            hintText: 'Поиск (Ribeirinhos, caiçara, gibão, burel)...',
            leading: const Icon(Icons.search_rounded),
            trailing: _searchController.text.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        context.read<AncestralCatalogCubit>().search('');
                      },
                    )
                  ]
                : null,
            onChanged: (val) =>
                context.read<AncestralCatalogCubit>().search(val),
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
                  label: const Text('Все народы'),
                  selected: state.selectedCategory == null,
                  onSelected: (_) {
                    context.read<AncestralCatalogCubit>().filterByCategory(null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Ribeirinhos'),
                  selected:
                      state.selectedCategory == CommunityCategory.ribeirinhos,
                  onSelected: (selected) {
                    context.read<AncestralCatalogCubit>().filterByCategory(
                          selected ? CommunityCategory.ribeirinhos : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Caiçaras'),
                  selected: state.selectedCategory == CommunityCategory.caicaras,
                  onSelected: (selected) {
                    context.read<AncestralCatalogCubit>().filterByCategory(
                          selected ? CommunityCategory.caicaras : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Sertanejos & Vaqueiros'),
                  selected:
                      state.selectedCategory == CommunityCategory.sertanejos,
                  onSelected: (selected) {
                    context.read<AncestralCatalogCubit>().filterByCategory(
                          selected ? CommunityCategory.sertanejos : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Quilombolas'),
                  selected:
                      state.selectedCategory == CommunityCategory.quilombolas,
                  onSelected: (selected) {
                    context.read<AncestralCatalogCubit>().filterByCategory(
                          selected ? CommunityCategory.quilombolas : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Pastores da Estrela'),
                  selected: state.selectedCategory == CommunityCategory.pastores,
                  onSelected: (selected) {
                    context.read<AncestralCatalogCubit>().filterByCategory(
                          selected ? CommunityCategory.pastores : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Mariscadoras'),
                  selected:
                      state.selectedCategory == CommunityCategory.mariscadores,
                  onSelected: (selected) {
                    context.read<AncestralCatalogCubit>().filterByCategory(
                          selected ? CommunityCategory.mariscadores : null,
                        );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (state.filteredCommunities.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    const Text('🌿', style: TextStyle(fontSize: 48)),
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
                        context.read<AncestralCatalogCubit>().clearFilters();
                      },
                      child: const Text('Сбросить фильтры'),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Text(
              'Сообщества и народы (${state.filteredCommunities.length})',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...state.filteredCommunities.map(
              (community) => CommunityCard(
                community: community,
                onTap: () {
                  Navigator.of(context).push(
                    CommunityDetailScreen.route(community: community),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRemediesTab(
      BuildContext context, AncestralCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 0,
          color: Colors.green.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.green.shade200,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.spa_rounded,
                    size: 32, color: Colors.green.shade800),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ervanária & Modo Imperativo',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Рецепты народной медицины, траволечение и правила повелительного наклонения (tome, ferva, não ferva, aplique)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade900,
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
          'Рецепты и снадобья (${state.remedies.length})',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...state.remedies.map(
          (remedy) => HerbalRemedyCard(
            remedy: remedy,
            onListen: () {
              final isPt = remedy.id.contains('poejo') ||
                  remedy.id.contains('laranjeira');
              final dialectSetting = isPt
                  ? PortugueseDialect.european
                  : PortugueseDialect.brazilian;
              context.read<HybridAudioPlaybackService>().playAudioOrSpeak(
                    fallbackText:
                        '${remedy.plantNamePt}. ${remedy.preparationInstructionsPt}',
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
                    color: Colors.green.shade800.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.eco_rounded,
                    size: 48,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Викторина мудрости предков',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Проверьте свои знания о культуре рибейриньюс, кайсарас, вакейрус, пастухов Эштрелы и грамматике повелительного наклонения Imperativo.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(AncestralQuizScreen.route());
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Начать викторину'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    foregroundColor: Colors.white,
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
