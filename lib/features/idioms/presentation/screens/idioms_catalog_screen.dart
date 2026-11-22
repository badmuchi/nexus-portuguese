import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/portuguese_idiom_entity.dart';
import '../../domain/repositories/idioms_repository.dart';
import '../cubit/idioms_cubit.dart';
import '../cubit/idioms_state.dart';
import '../widgets/idiom_card.dart';
import '../widgets/idiom_detail_sheet.dart';
import '../widgets/idiom_quiz_view.dart';

class IdiomsCatalogScreen extends StatelessWidget {
  const IdiomsCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<IdiomsRepository>();
    final audio = context.read<HybridAudioPlaybackService>();

    return BlocProvider<IdiomsCubit>(
      create: (_) => IdiomsCubit(
        repository: repository,
        audioService: audio,
      )..loadCatalog(),
      child: const _IdiomsCatalogView(),
    );
  }
}

class _IdiomsCatalogView extends StatelessWidget {
  const _IdiomsCatalogView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<IdiomsCubit, IdiomsState>(
      builder: (context, state) {
        final cubit = context.read<IdiomsCubit>();
        final isQuizMode = state.status == IdiomsStatus.quizActive || state.status == IdiomsStatus.quizFinished;

        return Scaffold(
          appBar: AppBar(
            title: Text(isQuizMode ? '🎯 Квиз по идиомам' : '🎨 Expressões Idiomáticas'),
            actions: [
              if (!isQuizMode)
                FilledButton.tonalIcon(
                  onPressed: () => cubit.startQuiz(),
                  icon: const Icon(Icons.psychology_rounded, size: 18),
                  label: const Text('Квиз'),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: isQuizMode
              ? const IdiomQuizView()
              : Column(
                  children: [
                    _IdiomsHeroBanner(theme: theme),
                    _SearchAndFilterBar(
                      selectedCategory: state.selectedCategory,
                      selectedDialect: state.selectedDialect,
                      onSearch: (q) => cubit.search(q),
                      onCategorySelected: (cat) => cubit.filterByCategory(cat),
                      onDialectSelected: (d) => cubit.filterByDialect(d),
                      theme: theme,
                    ),
                    Expanded(
                      child: state.filteredIdioms.isEmpty
                          ? _EmptyIdiomsPlaceholder(theme: theme)
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: state.filteredIdioms.length,
                              itemBuilder: (context, index) {
                                final idiom = state.filteredIdioms[index];
                                return IdiomCard(
                                  idiom: idiom,
                                  onTap: () => IdiomDetailSheet.show(context, idiom: idiom),
                                  onPlayAudio: () => cubit.playIdiomPronunciation(idiom),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _IdiomsHeroBanner extends StatelessWidget {
  final ThemeData theme;
  const _IdiomsHeroBanner({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade800,
            Colors.amber.shade900,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Text('💡', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Душа португальской речи',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Почему за утку платят, а пиццей всё заканчивается? Узнайте истории выражений!',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilterBar extends StatelessWidget {
  final IdiomCategory? selectedCategory;
  final String selectedDialect;
  final ValueChanged<String> onSearch;
  final ValueChanged<IdiomCategory?> onCategorySelected;
  final ValueChanged<String> onDialectSelected;
  final ThemeData theme;

  const _SearchAndFilterBar({
    required this.selectedCategory,
    required this.selectedDialect,
    required this.onSearch,
    required this.onCategorySelected,
    required this.onDialectSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Поиск по идиоме или значению...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Все категории'),
                selected: selectedCategory == null,
                onSelected: (_) => onCategorySelected(null),
                visualDensity: VisualDensity.compact,
              ),
              ...IdiomCategory.values.map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: ChoiceChip(
                    label: Text('${cat.emoji} ${cat.labelRu}'),
                    selected: selectedCategory == cat,
                    onSelected: (_) => onCategorySelected(cat),
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }),
              const SizedBox(width: 10),
              Container(width: 1, height: 24, color: theme.colorScheme.outlineVariant),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('Все диалекты'),
                selected: selectedDialect == 'all',
                onSelected: (_) => onDialectSelected('all'),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 6),
              ChoiceChip(
                label: const Text('🇧🇷 Brasil'),
                selected: selectedDialect == 'pt_BR',
                onSelected: (_) => onDialectSelected('pt_BR'),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 6),
              ChoiceChip(
                label: const Text('🇵🇹 Portugal'),
                selected: selectedDialect == 'pt_PT',
                onSelected: (_) => onDialectSelected('pt_PT'),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyIdiomsPlaceholder extends StatelessWidget {
  final ThemeData theme;
  const _EmptyIdiomsPlaceholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 48, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            'Идиомы не найдены',
            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.outline),
          ),
          const SizedBox(height: 4),
          Text(
            'Попробуйте сбросить фильтры',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
