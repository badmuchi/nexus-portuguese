import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/duel_question_entity.dart';
import '../../domain/repositories/duels_repository.dart';
import '../cubit/duels_cubit.dart';
import '../cubit/duels_state.dart';
import 'duel_gameplay_screen.dart';

class DuelsLobbyScreen extends StatelessWidget {
  const DuelsLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<DuelsRepository>();
    final audio = context.read<HybridAudioPlaybackService>();

    return BlocProvider<DuelsCubit>(
      create: (_) => DuelsCubit(
        repository: repository,
        audioService: audio,
      ),
      child: const _DuelsLobbyView(),
    );
  }
}

class _DuelsLobbyView extends StatelessWidget {
  const _DuelsLobbyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚔️ Arena de Duelos Culturais'),
      ),
      body: BlocConsumer<DuelsCubit, DuelsState>(
        listener: (context, state) {
          if (state.status == DuelsStatus.inProgress) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<DuelsCubit>(),
                  child: const DuelGameplayScreen(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<DuelsCubit>();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LobbyHeroBanner(theme: theme),
                const SizedBox(height: 20),
                Text(
                  'Выберите категорию дуэли:',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _CategorySelectionGrid(
                  selectedCategory: state.selectedCategory,
                  onCategorySelected: (cat) => cubit.setCategory(cat),
                  theme: theme,
                ),
                const SizedBox(height: 20),
                Text(
                  'Количество раундов:',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _RoundsCountSelector(
                  selectedCount: state.questionsCount,
                  onCountSelected: (count) => cubit.setQuestionsCount(count),
                  theme: theme,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: state.status == DuelsStatus.loading ? null : () => cubit.startDuel(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.flash_on_rounded),
                  label: const Text(
                    'Начать битву диалектов!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LobbyHeroBanner extends StatelessWidget {
  final ThemeData theme;
  const _LobbyHeroBanner({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade800,
            Colors.deepOrange.shade800,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'PT-BR  vs  PT-PT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Text('🇧🇷 ⚔️ 🇵🇹', style: TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Два берега одного языка',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Проверьте себя на знание различий: ônibus или autocarro? estou fazendo или estou a fazer? Раскройте опасных ложных друзей!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySelectionGrid extends StatelessWidget {
  final DuelCategory? selectedCategory;
  final ValueChanged<DuelCategory?> onCategorySelected;
  final ThemeData theme;

  const _CategorySelectionGrid({
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final allCategories = [
      null, // Все категории
      DuelCategory.vocabulario,
      DuelCategory.gramatica,
      DuelCategory.falsosAmigos,
      DuelCategory.girias,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allCategories.map((cat) {
        final isSelected = selectedCategory == cat;
        final label = cat == null ? '🎲 Все темы подряд' : '${cat.emoji} ${cat.labelRu}';

        return ChoiceChip(
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          selected: isSelected,
          onSelected: (_) => onCategorySelected(cat),
        );
      }).toList(),
    );
  }
}

class _RoundsCountSelector extends StatelessWidget {
  final int selectedCount;
  final ValueChanged<int> onCountSelected;
  final ThemeData theme;

  const _RoundsCountSelector({
    required this.selectedCount,
    required this.onCountSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    const counts = [5, 10, 15];

    return Row(
      children: counts.map((count) {
        final isSelected = selectedCount == count;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Center(
                child: Text(
                  '$count вопросов',
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onCountSelected(count),
            ),
          ),
        );
      }).toList(),
    );
  }
}
