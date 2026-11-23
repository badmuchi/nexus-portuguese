import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/humor_entities.dart';
import '../../domain/repositories/humor_repository.dart';
import '../cubit/humor_catalog_cubit.dart';
import '../cubit/humor_catalog_state.dart';
import '../widgets/joke_card.dart';
import '../widgets/trocadilho_card.dart';
import 'humor_quiz_screen.dart';
import 'joke_detail_screen.dart';

class HumorCatalogScreen extends StatelessWidget {
  const HumorCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => HumorCatalogCubit(
        repository: ctx.read<HumorRepository>(),
      )..loadCatalog(),
      child: const _HumorCatalogView(),
    );
  }
}

class _HumorCatalogView extends StatefulWidget {
  const _HumorCatalogView();

  @override
  State<_HumorCatalogView> createState() => _HumorCatalogViewState();
}

class _HumorCatalogViewState extends State<_HumorCatalogView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<HumorCatalogCubit>().setTab(_tabController.index);
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
          title: const Text('Humor & Piadas de Boteco 😂'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.sentiment_very_satisfied_rounded), text: 'Анекдоты'),
              Tab(icon: Icon(Icons.extension_rounded), text: 'Игра слов'),
              Tab(icon: Icon(Icons.quiz_rounded), text: 'Викторина'),
            ],
          ),
          actions: [
            BlocBuilder<HumorCatalogCubit, HumorCatalogState>(
              buildWhen: (prev, curr) => prev.selectedDialect != curr.selectedDialect,
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Фильтр диалекта',
                  initialValue: state.selectedDialect,
                  onSelected: (dialect) {
                    context.read<HumorCatalogCubit>().filterByDialect(dialect);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'all',
                      child: Text('🌐 Все диалекты'),
                    ),
                    const PopupMenuItem(
                      value: 'pt_BR',
                      child: Text('🇧🇷 Brasil (Boteco & Memes)'),
                    ),
                    const PopupMenuItem(
                      value: 'pt_PT',
                      child: Text('🇵🇹 Portugal (Alentejano)'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HumorCatalogCubit, HumorCatalogState>(
          builder: (context, state) {
            if (state.status == HumorCatalogStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == HumorCatalogStatus.error) {
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
                            context.read<HumorCatalogCubit>().loadCatalog(),
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
                _buildJokesTab(context, state),
                _buildTrocadilhosTab(context, state),
                _buildQuizTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildJokesTab(BuildContext context, HumorCatalogState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final jokes = state.filteredJokes;

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск шутки или ключевого слова...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<HumorCatalogCubit>().search('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (text) => context.read<HumorCatalogCubit>().search(text),
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
                  label: const Text('Все темы'),
                  selected: state.selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<HumorCatalogCubit>().filterByCategory(null);
                    }
                  },
                ),
              ),
              ...JokeCategory.values.map((cat) {
                final isSelected = state.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat.labelRu),
                    selected: isSelected,
                    onSelected: (selected) {
                      context.read<HumorCatalogCubit>().filterByCategory(
                            selected ? cat : null,
                          );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        const Divider(height: 16),
        // Jokes List
        Expanded(
          child: jokes.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Анекдотов не найдено для выбранных параметров',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jokes.length,
                  itemBuilder: (context, index) {
                    final joke = jokes[index];
                    return JokeCard(
                      joke: joke,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => JokeDetailScreen(joke: joke),
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

  Widget _buildTrocadilhosTab(BuildContext context, HumorCatalogState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final trocadilhos = state.filteredTrocadilhos;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Intro Banner
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
              Text('🧩', style: TextStyle(fontSize: 26)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Trocadilhos — игра слов и созвучий. Попробуйте отгадать ответ до того, как откроете карточку!',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (trocadilhos.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Каламбуров не найдено',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ...trocadilhos.map((t) => TrocadilhoCard(trocadilho: t)),
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
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('🎭', style: TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 20),
            Text(
              'Complete a Piada',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Интерактивная викторина: угадайте остроумный панчлайн шутки или разгадайте каламбур из нескольких вариантов!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HumorQuizScreen()),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Начать викторину'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
