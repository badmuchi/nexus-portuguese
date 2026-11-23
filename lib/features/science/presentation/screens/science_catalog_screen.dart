import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/science_entities.dart';
import '../../domain/repositories/science_repository.dart';
import '../cubit/science_catalog_cubit.dart';
import '../cubit/science_catalog_state.dart';
import '../widgets/lab_experiment_card.dart';
import '../widgets/science_topic_card.dart';
import 'science_quiz_screen.dart';
import 'science_topic_detail_screen.dart';

class ScienceCatalogScreen extends StatelessWidget {
  const ScienceCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ScienceCatalogCubit(
        ctx.read<ScienceRepository>(),
      )..loadData(),
      child: const _ScienceCatalogView(),
    );
  }
}

class _ScienceCatalogView extends StatefulWidget {
  const _ScienceCatalogView();

  @override
  State<_ScienceCatalogView> createState() => _ScienceCatalogViewState();
}

class _ScienceCatalogViewState extends State<_ScienceCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<ScienceCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Ciência & Oceanografia 🔬'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.biotech_rounded), text: 'Темы'),
              Tab(icon: Icon(Icons.science_outlined), text: 'Лаборатория'),
              Tab(icon: Icon(Icons.psychology_alt_rounded), text: 'Квиз'),
            ],
          ),
          actions: [
            BlocBuilder<ScienceCatalogCubit, ScienceCatalogState>(
              buildWhen: (prev, curr) =>
                  prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр по регионам',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<ScienceCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Butantan, Fiocruz, Alcântara)'),
                    ),
                    PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Açores, WindFloat, Champalimaud)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ScienceCatalogCubit, ScienceCatalogState>(
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
                            context.read<ScienceCatalogCubit>().loadData(),
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
                // Tab 0: Science Topics
                _buildTopicsTab(context, state),
                // Tab 1: Lab Experiments
                _buildExperimentsTab(context, state),
                // Tab 2: Science Quiz
                const ScienceQuizScreen(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopicsTab(BuildContext context, ScienceCatalogState state) {
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
              hintText: 'Поиск (Butantan, Açores, WindFloat...)',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        context.read<ScienceCatalogCubit>().search('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onChanged: (query) {
              context.read<ScienceCatalogCubit>().search(query);
            },
          ),
        ),

        // Science Field filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Все сферы'),
                selected: state.selectedField == null,
                onSelected: (_) {
                  context.read<ScienceCatalogCubit>().filterByField(null);
                },
              ),
              const SizedBox(width: 8),
              ...ScienceField.values.map((field) {
                final isSelected = state.selectedField == field;
                final label = switch (field) {
                  ScienceField.oceanografia => '🌊 Океанография',
                  ScienceField.biomedicina => '🧬 Биомедицина',
                  ScienceField.energiaVerde => '⚡ Зелёная энергия',
                  ScienceField.aeroespacial => '🚀 Аэрокосмос',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) {
                      context.read<ScienceCatalogCubit>().filterByField(
                            isSelected ? null : field,
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
                    return ScienceTopicCard(
                      topic: topic,
                      onTap: () {
                        Navigator.of(context).push(
                          ScienceTopicDetailScreen.route(topic: topic),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildExperimentsTab(BuildContext context, ScienceCatalogState state) {
    final experiments = state.experiments;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: experiments.length,
      itemBuilder: (context, index) {
        final exp = experiments[index];
        return LabExperimentCard(
          experiment: exp,
          onListen: () {
            context.read<HybridAudioPlaybackService>().playAudioOrSpeak(
                  fallbackText: '${exp.title}. ${exp.hypothesisPt}',
                  dialect: PortugueseDialect.brazilian,
                  rate: 0.9,
                );
          },
        );
      },
    );
  }
}
