import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/carnival_entities.dart';
import '../../domain/repositories/carnival_repository.dart';
import '../cubit/carnival_catalog_cubit.dart';
import '../cubit/carnival_catalog_state.dart';
import '../widgets/carnival_tradition_card.dart';
import '../widgets/rhythm_workshop_card.dart';
import 'carnival_detail_screen.dart';
import 'carnival_quiz_screen.dart';

class CarnivalCatalogScreen extends StatelessWidget {
  const CarnivalCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => CarnivalCatalogCubit(
        ctx.read<CarnivalRepository>(),
      )..loadData(),
      child: const _CarnivalCatalogView(),
    );
  }
}

class _CarnivalCatalogView extends StatefulWidget {
  const _CarnivalCatalogView();

  @override
  State<_CarnivalCatalogView> createState() => _CarnivalCatalogViewState();
}

class _CarnivalCatalogViewState extends State<_CarnivalCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<CarnivalCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Carnavais & Ritmos Lusófonos 🎭'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.celebration_rounded), text: 'Folia'),
              Tab(icon: Icon(Icons.music_note_rounded), text: 'Oficinas'),
              Tab(icon: Icon(Icons.psychology_alt_rounded), text: 'Квиз'),
            ],
          ),
          actions: [
            BlocBuilder<CarnivalCatalogCubit, CarnivalCatalogState>(
              buildWhen: (prev, curr) =>
                  prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр по регионам',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<CarnivalCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все регионы'),
                    ),
                    PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Frevo, Maracatu, Samba, Axé, Boi)'),
                    ),
                    PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Entrudo de Torres Vedras, Caretos de Podence)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<CarnivalCatalogCubit, CarnivalCatalogState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.traditions.isEmpty) {
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
                            context.read<CarnivalCatalogCubit>().loadData(),
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
                _buildTraditionsTab(context, state),
                _buildWorkshopsTab(context, state),
                _buildQuizTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTraditionsTab(
      BuildContext context, CarnivalCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () => context.read<CarnivalCatalogCubit>().loadData(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SearchBar(
            controller: _searchController,
            hintText: 'Поиск (Frevo, Maracatu, Samba, Caretos, Boi)...',
            leading: const Icon(Icons.search_rounded),
            trailing: _searchController.text.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        context.read<CarnivalCatalogCubit>().search('');
                      },
                    )
                  ]
                : null,
            onChanged: (val) =>
                context.read<CarnivalCatalogCubit>().search(val),
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
                  label: const Text('Все традиции'),
                  selected: state.selectedCategory == null,
                  onSelected: (_) {
                    context.read<CarnivalCatalogCubit>().filterByCategory(null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Frevo'),
                  selected:
                      state.selectedCategory == CarnivalTraditionCategory.frevo,
                  onSelected: (selected) {
                    context.read<CarnivalCatalogCubit>().filterByCategory(
                          selected ? CarnivalTraditionCategory.frevo : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Maracatu'),
                  selected: state.selectedCategory ==
                      CarnivalTraditionCategory.maracatu,
                  onSelected: (selected) {
                    context.read<CarnivalCatalogCubit>().filterByCategory(
                          selected ? CarnivalTraditionCategory.maracatu : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Samba-Enredo'),
                  selected: state.selectedCategory ==
                      CarnivalTraditionCategory.sambaEnredo,
                  onSelected: (selected) {
                    context.read<CarnivalCatalogCubit>().filterByCategory(
                          selected
                              ? CarnivalTraditionCategory.sambaEnredo
                              : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Bumba-Meu-Boi'),
                  selected: state.selectedCategory ==
                      CarnivalTraditionCategory.bumbameuboi,
                  onSelected: (selected) {
                    context.read<CarnivalCatalogCubit>().filterByCategory(
                          selected
                              ? CarnivalTraditionCategory.bumbameuboi
                              : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Entrudo Português'),
                  selected: state.selectedCategory ==
                      CarnivalTraditionCategory.entrudoPortugues,
                  onSelected: (selected) {
                    context.read<CarnivalCatalogCubit>().filterByCategory(
                          selected
                              ? CarnivalTraditionCategory.entrudoPortugues
                              : null,
                        );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Trio Elétrico & Axé'),
                  selected: state.selectedCategory ==
                      CarnivalTraditionCategory.trioEletrico,
                  onSelected: (selected) {
                    context.read<CarnivalCatalogCubit>().filterByCategory(
                          selected
                              ? CarnivalTraditionCategory.trioEletrico
                              : null,
                        );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (state.filteredTraditions.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    const Text('🎭', style: TextStyle(fontSize: 48)),
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
                        context.read<CarnivalCatalogCubit>().clearFilters();
                      },
                      child: const Text('Сбросить фильтры'),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Text(
              'Карнавалы & Традиции (${state.filteredTraditions.length})',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...state.filteredTraditions.map(
              (tradition) => CarnivalTraditionCard(
                tradition: tradition,
                onTap: () {
                  Navigator.of(context).push(
                    CarnivalDetailScreen.route(tradition: tradition),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkshopsTab(
      BuildContext context, CarnivalCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 0,
          color: Colors.amber.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.amber.shade200,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.queue_music_rounded,
                    size: 32, color: Colors.amber.shade900),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Oficinas de Ritmo & Ações Contínuas',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Padrões rítmicos, letras históricas e o contraste entre o Gerúndio (PT-BR) e Estar a + Infinitivo (PT-PT)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber.shade900,
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
          'Oficinas de Ritmo & Letra (${state.workshops.length})',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...state.workshops.map(
          (workshop) => RhythmWorkshopCard(
            workshop: workshop,
            onListen: () {
              final isPt = workshop.isPtPt;
              final dialectSetting = isPt
                  ? PortugueseDialect.european
                  : PortugueseDialect.brazilian;
              context.read<HybridAudioPlaybackService>().playAudioOrSpeak(
                    fallbackText:
                        '${workshop.title}. ${workshop.lyricsSamplePt}',
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
                    color: Colors.amber.shade900.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.celebration_rounded,
                    size: 48,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Викторина карнаваловеда',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Проверьте свои знания о фрево, маракату, самбе на Сапукаи, матрафонах Торреш-Ведраш, каретуш и сопоставлении герундия в португальском языке.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(CarnivalQuizScreen.route());
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Начать викторину'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber.shade900,
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
