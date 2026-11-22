import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/literature_repository.dart';
import '../cubit/literature_catalog_cubit.dart';
import '../cubit/literature_catalog_state.dart';
import '../widgets/literary_quote_card.dart';
import '../widgets/literary_work_card.dart';
import 'reader_screen.dart';

class LiteratureCatalogScreen extends StatelessWidget {
  const LiteratureCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LiteratureCatalogCubit(
        repository: context.read<LiteratureRepository>(),
      )..loadCatalog(),
      child: const _LiteratureCatalogView(),
    );
  }
}

class _LiteratureCatalogView extends StatefulWidget {
  const _LiteratureCatalogView();

  @override
  State<_LiteratureCatalogView> createState() => _LiteratureCatalogViewState();
}

class _LiteratureCatalogViewState extends State<_LiteratureCatalogView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<LiteratureCatalogCubit>().setTab(_tabController.index);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expresso Literário 📚'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Шедевры', icon: Icon(Icons.auto_stories_rounded)),
            Tab(text: 'Крылатые цитаты', icon: Icon(Icons.format_quote_rounded)),
          ],
        ),
      ),
      body: BlocBuilder<LiteratureCatalogCubit, LiteratureCatalogState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == LiteratureCatalogStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'Ошибка загрузки литературы',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<LiteratureCatalogCubit>().loadCatalog(),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Search field
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск по автору, тексту или теме...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              context.read<LiteratureCatalogCubit>().search('');
                            },
                          )
                        : null,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (text) =>
                      context.read<LiteratureCatalogCubit>().search(text),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    // Dialect filters
                    ChoiceChip(
                      label: const Text('Все регионы 🌐'),
                      selected: state.selectedDialect == 'all',
                      onSelected: (_) => context
                          .read<LiteratureCatalogCubit>()
                          .filterByDialect('all'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Portugal 🇵🇹'),
                      selected: state.selectedDialect == 'PT',
                      onSelected: (_) => context
                          .read<LiteratureCatalogCubit>()
                          .filterByDialect('PT'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Brasil 🇧🇷'),
                      selected: state.selectedDialect == 'BR',
                      onSelected: (_) => context
                          .read<LiteratureCatalogCubit>()
                          .filterByDialect('BR'),
                    ),
                    const SizedBox(width: 12),
                    const Text('•', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 12),

                    // Genre filters
                    ChoiceChip(
                      label: const Text('Все жанры'),
                      selected: state.selectedGenre == null,
                      onSelected: (_) => context
                          .read<LiteratureCatalogCubit>()
                          .filterByGenre(null),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Поэзия 📜'),
                      selected: state.selectedGenre == 'Poesia',
                      onSelected: (_) => context
                          .read<LiteratureCatalogCubit>()
                          .filterByGenre('Poesia'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Сонеты 🌹'),
                      selected: state.selectedGenre == 'Soneto',
                      onSelected: (_) => context
                          .read<LiteratureCatalogCubit>()
                          .filterByGenre('Soneto'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Проза 📖'),
                      selected: state.selectedGenre == 'Romance',
                      onSelected: (_) => context
                          .read<LiteratureCatalogCubit>()
                          .filterByGenre('Romance'),
                    ),
                  ],
                ),
              ),

              // TabBarView Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // 1. Works Tab
                    state.filteredWorks.isEmpty
                        ? Center(
                            child: Text(
                              'Шедевры не найдены по запросу.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 6, bottom: 24),
                            itemCount: state.filteredWorks.length,
                            itemBuilder: (context, index) {
                              final work = state.filteredWorks[index];
                              return LiteraryWorkCard(
                                work: work,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReaderScreen(work: work),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                    // 2. Quotes Tab
                    state.filteredQuotes.isEmpty
                        ? Center(
                            child: Text(
                              'Цитаты не найдены по запросу.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 6, bottom: 24),
                            itemCount: state.filteredQuotes.length,
                            itemBuilder: (context, index) {
                              final quote = state.filteredQuotes[index];
                              return LiteraryQuoteCard(quote: quote);
                            },
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
