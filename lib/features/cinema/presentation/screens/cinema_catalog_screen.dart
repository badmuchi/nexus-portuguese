import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/cinema_repository.dart';
import '../cubit/cinema_catalog_cubit.dart';
import '../cubit/cinema_catalog_state.dart';
import '../widgets/cinema_quote_card.dart';
import '../widgets/movie_scene_card.dart';
import 'scene_player_screen.dart';

class CinemaCatalogScreen extends StatelessWidget {
  const CinemaCatalogScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const CinemaCatalogScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => CinemaCatalogCubit(
        repository: ctx.read<CinemaRepository>(),
      )..loadCatalog(),
      child: const _CinemaCatalogView(),
    );
  }
}

class _CinemaCatalogView extends StatefulWidget {
  const _CinemaCatalogView();

  @override
  State<_CinemaCatalogView> createState() => _CinemaCatalogViewState();
}

class _CinemaCatalogViewState extends State<_CinemaCatalogView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<CinemaCatalogCubit>().setTab(_tabController.index);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Синематека & Диалоги Кино 🎬',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.movie_filter_rounded), text: 'Сцены & Фильмы'),
            Tab(icon: Icon(Icons.format_quote_rounded), text: 'Крылатые Цитаты'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(context),
          Expanded(
            child: BlocBuilder<CinemaCatalogCubit, CinemaCatalogState>(
              builder: (context, state) {
                if (state.status == CinemaCatalogStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == CinemaCatalogStatus.error) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(
                            state.errorMessage ?? 'Произошла ошибка',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => context.read<CinemaCatalogCubit>().loadCatalog(),
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
                    _buildScenesTab(context, state),
                    _buildQuotesTab(context, state),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    final cubit = context.read<CinemaCatalogCubit>();
    final theme = Theme.of(context);

    return BlocBuilder<CinemaCatalogCubit, CinemaCatalogState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск по фильму, цитате, герою...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            cubit.search('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => cubit.search(val),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      selected: state.selectedDialect == 'all',
                      label: const Text('Все регионы'),
                      onSelected: (_) => cubit.filterByDialect('all'),
                    ),
                    const SizedBox(width: 6),
                    FilterChip(
                      selected: state.selectedDialect == 'BR',
                      label: const Text('🇧🇷 Brasil'),
                      onSelected: (_) => cubit.filterByDialect('BR'),
                    ),
                    const SizedBox(width: 6),
                    FilterChip(
                      selected: state.selectedDialect == 'PT',
                      label: const Text('🇵🇹 Portugal'),
                      onSelected: (_) => cubit.filterByDialect('PT'),
                    ),
                    if (state.activeTabIndex == 0) ...[
                      const SizedBox(width: 12),
                      _buildGenreChip(cubit, state, null, 'Все жанры'),
                      _buildGenreChip(cubit, state, 'Crime', '🔫 Crime'),
                      _buildGenreChip(cubit, state, 'Drama', '🎭 Drama'),
                      _buildGenreChip(cubit, state, 'Comédia', '😂 Comédia'),
                      _buildGenreChip(cubit, state, 'Histórico', '📜 Histórico'),
                      _buildGenreChip(cubit, state, 'Suspense', '🕵️ Suspense'),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenreChip(
    CinemaCatalogCubit cubit,
    CinemaCatalogState state,
    String? genre,
    String label,
  ) {
    final isSelected = state.selectedGenre == genre;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) => cubit.filterByGenre(genre),
      ),
    );
  }

  Widget _buildScenesTab(BuildContext context, CinemaCatalogState state) {
    final scenes = state.filteredScenes;

    if (scenes.isEmpty) {
      return _buildEmptyState('Сцены по выбранным фильтрам не найдены');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<CinemaCatalogCubit>().loadCatalog(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: scenes.length,
        itemBuilder: (context, index) {
          final s = scenes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MovieSceneCard(
              scene: s,
              onTap: () {
                Navigator.of(context).push(
                  ScenePlayerScreen.route(scene: s),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuotesTab(BuildContext context, CinemaCatalogState state) {
    final quotes = state.filteredQuotes;

    if (quotes.isEmpty) {
      return _buildEmptyState('Киноцитаты не найдены');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<CinemaCatalogCubit>().loadCatalog(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final q = quotes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CinemaQuoteCard(quote: q),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_off_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
