import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/portuguese_life_scene.dart';
import '../cubit/scenes_cubit.dart';
import '../cubit/scenes_state.dart';
import 'scene_detail_screen.dart';

class ScenesCatalogScreen extends StatelessWidget {
  const ScenesCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🎭 Cenas da Vida'),
            SizedBox(width: 8),
            Text('• Ситуации', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
      body: BlocBuilder<ScenesCubit, ScenesState>(
        builder: (context, state) {
          if (state is ScenesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ScenesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<ScenesCubit>().loadScenes(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is ScenesLoaded) {
            final filtered = state.filteredScenes;

            return Column(
              children: [
                _CategoryChips(
                  selectedCategory: state.selectedCategory,
                  onSelect: (cat) => context.read<ScenesCubit>().filterCategory(cat),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final scene = filtered[index];
                      final progress = state.progressMap[scene.id];

                      return _SceneCatalogCard(
                        scene: scene,
                        progress: progress,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SceneDetailScreen(scene: scene),
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

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final SceneCategory? selectedCategory;
  final ValueChanged<SceneCategory?> onSelect;

  const _CategoryChips({
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        children: [
          FilterChip(
            selected: selectedCategory == null,
            label: const Text('Все сцены'),
            onSelected: (_) => onSelect(null),
          ),
          const SizedBox(width: 8),
          ...SceneCategory.values.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                selected: selectedCategory == cat,
                label: Text('${cat.emoji} ${cat.titleRu}'),
                onSelected: (_) => onSelect(cat),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SceneCatalogCard extends StatelessWidget {
  final PortugueseLifeScene scene;
  final SceneProgressEntity? progress;
  final VoidCallback onTap;

  const _SceneCatalogCard({
    required this.scene,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalChallenges = scene.challenges.length;
    final completedChallenges = progress?.completedChallengesCount ?? 0;
    final isDone = progress?.isCompleted ?? false;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDone ? Colors.green.shade400 : theme.colorScheme.outlineVariant,
          width: isDone ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      scene.category.emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scene.titlePt,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          scene.titleRu,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      scene.locationTag,
                      style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                scene.description,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    isDone ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                    size: 16,
                    color: isDone ? Colors.green : theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Челленджи: $completedChallenges / $totalChallenges',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDone ? Colors.green : theme.colorScheme.outline,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${scene.words.length} слов • ${scene.phrases.length} фраз',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
