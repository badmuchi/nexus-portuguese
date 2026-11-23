import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/radio_novela_repository.dart';
import '../cubit/radio_novela_catalog_cubit.dart';
import '../cubit/radio_novela_catalog_state.dart';
import '../widgets/drama_episode_card.dart';
import 'radio_player_screen.dart';

class RadioNovelaCatalogScreen extends StatelessWidget {
  const RadioNovelaCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RadioNovelaCatalogCubit(
        repository: context.read<RadioNovelaRepository>(),
      )..loadCatalog(),
      child: const _RadioNovelaCatalogView(),
    );
  }
}

class _RadioNovelaCatalogView extends StatefulWidget {
  const _RadioNovelaCatalogView();

  @override
  State<_RadioNovelaCatalogView> createState() =>
      _RadioNovelaCatalogViewState();
}

class _RadioNovelaCatalogViewState extends State<_RadioNovelaCatalogView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rádio Novela & Drama 📻'),
      ),
      body: BlocBuilder<RadioNovelaCatalogCubit, RadioNovelaCatalogState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == RadioNovelaCatalogStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'Ошибка загрузки радиопостановок',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<RadioNovelaCatalogCubit>().loadCatalog(),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Search input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск по спектаклю, жанру или городу...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              context.read<RadioNovelaCatalogCubit>().search('');
                            },
                          )
                        : null,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (text) =>
                      context.read<RadioNovelaCatalogCubit>().search(text),
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
                          .read<RadioNovelaCatalogCubit>()
                          .filterByDialect('all'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Portugal 🇵🇹'),
                      selected: state.selectedDialect == 'PT',
                      onSelected: (_) => context
                          .read<RadioNovelaCatalogCubit>()
                          .filterByDialect('PT'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Brasil 🇧🇷'),
                      selected: state.selectedDialect == 'BR',
                      onSelected: (_) => context
                          .read<RadioNovelaCatalogCubit>()
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
                          .read<RadioNovelaCatalogCubit>()
                          .filterByGenre(null),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Нуар / Детектив 🕵️‍♂️'),
                      selected: state.selectedGenre == 'Mistério',
                      onSelected: (_) => context
                          .read<RadioNovelaCatalogCubit>()
                          .filterByGenre('Mistério'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Драма / Романс 🌵'),
                      selected: state.selectedGenre == 'Romance',
                      onSelected: (_) => context
                          .read<RadioNovelaCatalogCubit>()
                          .filterByGenre('Romance'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Саспенс 🌊'),
                      selected: state.selectedGenre == 'Suspense',
                      onSelected: (_) => context
                          .read<RadioNovelaCatalogCubit>()
                          .filterByGenre('Suspense'),
                    ),
                  ],
                ),
              ),

              // Dramas list
              Expanded(
                child: state.filteredDramas.isEmpty
                    ? Center(
                        child: Text(
                          'Спектакли не найдены по запросу.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 6, bottom: 24),
                        itemCount: state.filteredDramas.length,
                        itemBuilder: (context, index) {
                          final drama = state.filteredDramas[index];
                          return DramaEpisodeCard(
                            drama: drama,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RadioPlayerScreen(drama: drama),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
