import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/fashion_entities.dart';
import '../../domain/repositories/fashion_repository.dart';
import '../cubit/fashion_catalog_cubit.dart';
import '../cubit/fashion_catalog_state.dart';
import '../widgets/fashion_topic_card.dart';
import '../widgets/textile_craft_card.dart';
import 'fashion_quiz_screen.dart';
import 'fashion_topic_detail_screen.dart';

class FashionCatalogScreen extends StatelessWidget {
  const FashionCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => FashionCatalogCubit(
        ctx.read<FashionRepository>(),
      )..loadData(),
      child: const _FashionCatalogView(),
    );
  }
}

class _FashionCatalogView extends StatefulWidget {
  const _FashionCatalogView();

  @override
  State<_FashionCatalogView> createState() => _FashionCatalogViewState();
}

class _FashionCatalogViewState extends State<_FashionCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<FashionCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Moda & Têxtil Lusófono 👗'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.style_rounded), text: 'Tópicos'),
              Tab(icon: Icon(Icons.palette_outlined), text: 'Oficinas'),
              Tab(icon: Icon(Icons.psychology_alt_rounded), text: 'Квиз'),
            ],
          ),
          actions: [
            BlocBuilder<FashionCatalogCubit, FashionCatalogState>(
              buildWhen: (prev, curr) =>
                  prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр по регионам',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<FashionCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (SPFW, Chita, Ceará)'),
                    ),
                    PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Calçado, Bilros, Filigrana)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<FashionCatalogCubit, FashionCatalogState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.topics.isEmpty) {
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
                            context.read<FashionCatalogCubit>().loadData(),
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
                // Tab 0: Fashion Topics
                _buildTopicsTab(context, state),
                // Tab 1: Textile Crafts & Workshops
                _buildCraftsTab(context, state),
                // Tab 2: Fashion Quiz
                const FashionQuizScreen(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopicsTab(BuildContext context, FashionCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск (SPFW, Calçado, Filigrana, Chita...)',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        context.read<FashionCatalogCubit>().search('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onChanged: (query) {
              context.read<FashionCatalogCubit>().search(query);
            },
          ),
        ),

        // Fashion Category filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Все направления'),
                selected: state.selectedCategory == null,
                onSelected: (_) {
                  context.read<FashionCatalogCubit>().filterByCategory(null);
                },
              ),
              const SizedBox(width: 8),
              ...FashionCategory.values.map((category) {
                final isSelected = state.selectedCategory == category;
                final label = switch (category) {
                  FashionCategory.altaCostura => '👠 Высокая мода',
                  FashionCategory.calcadoCouro => '👞 Обувь & Кожа',
                  FashionCategory.rendasTecidos => '🧵 Кружева & Ткани',
                  FashionCategory.ourivesariaDesign => '✨ Филигрань & Украшения',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) {
                      context.read<FashionCatalogCubit>().filterByCategory(
                            isSelected ? null : category,
                          );
                    },
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Topics list
        Expanded(
          child: state.filteredTopics.isEmpty
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
                  itemCount: state.filteredTopics.length,
                  itemBuilder: (context, index) {
                    final topic = state.filteredTopics[index];
                    return FashionTopicCard(
                      topic: topic,
                      onTap: () {
                        Navigator.of(context).push(
                          FashionTopicDetailScreen.route(topic: topic),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCraftsTab(BuildContext context, FashionCatalogState state) {
    final crafts = state.crafts;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: crafts.length,
      itemBuilder: (context, index) {
        final craft = crafts[index];
        return TextileCraftCard(
          craft: craft,
          onListen: () {
            context.read<HybridAudioPlaybackService>().playAudioOrSpeak(
                  fallbackText: '${craft.title}. ${craft.techniqueDescriptionPt}',
                  dialect: PortugueseDialect.brazilian,
                  rate: 0.9,
                );
          },
        );
      },
    );
  }
}
