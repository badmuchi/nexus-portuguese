import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/survival_phrase_entity.dart';
import '../../domain/entities/survival_quest_entity.dart';
import '../../domain/repositories/survival_guide_repository.dart';
import '../cubit/survival_catalog_cubit.dart';
import '../cubit/survival_catalog_state.dart';
import '../cubit/survival_quest_cubit.dart';
import '../widgets/cultural_tip_card.dart';
import '../widgets/survival_phrase_tile.dart';
import '../widgets/survival_quest_card.dart';
import 'survival_quest_screen.dart';

class SurvivalGuideCatalogScreen extends StatelessWidget {
  const SurvivalGuideCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurvivalCatalogCubit(
        repository: context.read<SurvivalGuideRepository>(),
      )..loadCatalog(),
      child: const _SurvivalGuideCatalogView(),
    );
  }
}

class _SurvivalGuideCatalogView extends StatelessWidget {
  const _SurvivalGuideCatalogView();

  void _openQuest(BuildContext context, SurvivalQuestEntity quest) {
    final repo = context.read<SurvivalGuideRepository>();
    final audio = context.read<HybridAudioPlaybackService>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => SurvivalQuestCubit(
            quest: quest,
            repository: repo,
            audioService: audio,
          ),
          child: const SurvivalQuestScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SurvivalCatalogCubit, SurvivalCatalogState>(
      builder: (context, state) {
        final cubit = context.read<SurvivalCatalogCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Text('Guia de Sobrevivência'),
                SizedBox(width: 8),
                Text('🧭', style: TextStyle(fontSize: 20)),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _TabBarHeader(
                activeTabIndex: state.activeTabIndex,
                onTabSelected: cubit.setTab,
                theme: theme,
              ),
            ),
          ),
          body: Column(
            children: [
              _SearchAndFilterSection(state: state, cubit: cubit),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildTabContent(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent(BuildContext context, SurvivalCatalogState state) {
    if (state.activeTabIndex == 0) {
      final quests = state.filteredQuests;
      if (quests.isEmpty) {
        return const _EmptyResultsView(message: 'Квесты не найдены');
      }
      return ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: quests.length,
        itemBuilder: (context, index) {
          final quest = quests[index];
          return SurvivalQuestCard(
            quest: quest,
            onTap: () => _openQuest(context, quest),
          );
        },
      );
    } else if (state.activeTabIndex == 1) {
      final phrases = state.filteredPhrases;
      if (phrases.isEmpty) {
        return const _EmptyResultsView(message: 'Шпаргалки не найдены');
      }
      return ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          return SurvivalPhraseTile(phrase: phrases[index]);
        },
      );
    } else {
      final tips = state.filteredTips;
      if (tips.isEmpty) {
        return const _EmptyResultsView(message: 'Советы не найдены');
      }
      return ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return CulturalTipCard(tip: tips[index]);
        },
      );
    }
  }
}

class _TabBarHeader extends StatelessWidget {
  final int activeTabIndex;
  final ValueChanged<int> onTabSelected;
  final ThemeData theme;

  const _TabBarHeader({
    required this.activeTabIndex,
    required this.onTabSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildTabButton('🧭 Квесты', 0),
          _buildTabButton('📋 Шпаргалки', 1),
          _buildTabButton('💡 Этикет', 2),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = activeTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchAndFilterSection extends StatelessWidget {
  final SurvivalCatalogState state;
  final SurvivalCatalogCubit cubit;

  const _SearchAndFilterSection({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            onChanged: cubit.search,
            decoration: InputDecoration(
              hintText: 'Поиск по теме, процедуре или фразе...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: state.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () => cubit.search(''),
                    )
                  : null,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Все категории'),
                selected: state.selectedCategory == null,
                onSelected: (_) => cubit.filterByCategory(null),
              ),
              const SizedBox(width: 8),
              ...SurvivalCategory.values.map((cat) {
                final isSelected = state.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text('${cat.emoji} ${cat.labelRu}'),
                    selected: isSelected,
                    onSelected: (selected) => cubit.filterByCategory(selected ? cat : null),
                  ),
                );
              }),
              const SizedBox(width: 4),
              FilterChip(
                label: const Text('🇧🇷 Brasil'),
                selected: state.selectedDialect == 'pt_BR',
                onSelected: (selected) => cubit.filterByDialect(selected ? 'pt_BR' : 'all'),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('🇵🇹 Portugal'),
                selected: state.selectedDialect == 'pt_PT',
                onSelected: (selected) => cubit.filterByDialect(selected ? 'pt_PT' : 'all'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyResultsView extends StatelessWidget {
  final String message;

  const _EmptyResultsView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.travel_explore_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Попробуй изменить фильтры или поисковый запрос',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
