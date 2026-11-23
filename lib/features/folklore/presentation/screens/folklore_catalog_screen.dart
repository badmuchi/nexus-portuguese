import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/folklore_entities.dart';
import '../../domain/repositories/folklore_repository.dart';
import '../cubit/folklore_catalog_cubit.dart';
import '../cubit/folklore_catalog_state.dart';
import '../widgets/folklore_tale_card.dart';
import '../widgets/myth_card.dart';
import 'folklore_quiz_screen.dart';
import 'myth_detail_screen.dart';

class FolkloreCatalogScreen extends StatelessWidget {
  const FolkloreCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => FolkloreCatalogCubit(
        ctx.read<FolkloreRepository>(),
      )..loadData(),
      child: const _FolkloreCatalogView(),
    );
  }
}

class _FolkloreCatalogView extends StatefulWidget {
  const _FolkloreCatalogView();

  @override
  State<_FolkloreCatalogView> createState() => _FolkloreCatalogViewState();
}

class _FolkloreCatalogViewState extends State<_FolkloreCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<FolkloreCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Mitos & Folclore 🧙‍♂️'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.auto_awesome_rounded), text: 'Мифы'),
              Tab(icon: Icon(Icons.auto_stories_rounded), text: 'Сказки'),
              Tab(icon: Icon(Icons.psychology_alt_rounded), text: 'Квиз'),
            ],
          ),
          actions: [
            BlocBuilder<FolkloreCatalogCubit, FolkloreCatalogState>(
              buildWhen: (prev, curr) =>
                  prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр по регионам',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<FolkloreCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Саси, Курупира, Яра)'),
                    ),
                    PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Барселуш, Лобизомем)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<FolkloreCatalogCubit, FolkloreCatalogState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.myths.isEmpty) {
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
                            context.read<FolkloreCatalogCubit>().loadData(),
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
                // Tab 0: Myths list
                _buildMythsTab(context, state),
                // Tab 1: Tale snippets with grammar insights
                _buildTalesTab(context, state),
                // Tab 2: Quiz
                const FolkloreQuizScreen(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMythsTab(BuildContext context, FolkloreCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Search and Origin filter
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск мифов (Saci, Curupira, Iara...)',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        context.read<FolkloreCatalogCubit>().search('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onChanged: (query) {
              context.read<FolkloreCatalogCubit>().search(query);
            },
          ),
        ),

        // Origin filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Все корни'),
                selected: state.selectedOrigin == null,
                onSelected: (_) {
                  context.read<FolkloreCatalogCubit>().filterByOrigin(null);
                },
              ),
              const SizedBox(width: 8),
              ...FolkloreOrigin.values.map((origin) {
                final isSelected = state.selectedOrigin == origin;
                final label = switch (origin) {
                  FolkloreOrigin.indigena => '🌿 Индейские',
                  FolkloreOrigin.afroBrasileiro => '🥁 Афро-традиции',
                  FolkloreOrigin.iberico => '🏰 Иберийские',
                  FolkloreOrigin.urbanoMisto => '🌕 Городские',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) {
                      context.read<FolkloreCatalogCubit>().filterByOrigin(
                            isSelected ? null : origin,
                          );
                    },
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Myths list
        Expanded(
          child: state.filteredMyths.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 48, color: colorScheme.outline),
                      const SizedBox(height: 12),
                      Text(
                        'Ничего не найдено',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: state.filteredMyths.length,
                  itemBuilder: (context, index) {
                    final myth = state.filteredMyths[index];
                    return MythCard(
                      myth: myth,
                      onTap: () {
                        Navigator.of(context).push(
                          MythDetailScreen.route(myth: myth),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTalesTab(BuildContext context, FolkloreCatalogState state) {
    final snippets = state.snippets;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: snippets.length,
      itemBuilder: (context, index) {
        final snippet = snippets[index];
        return FolkloreTaleCard(
          snippet: snippet,
          onListen: () {
            context.read<HybridAudioPlaybackService>().playAudioOrSpeak(
                  fallbackText: snippet.narrativePt,
                  dialect: PortugueseDialect.brazilian,
                  rate: 0.9,
                );
          },
        );
      },
    );
  }
}
