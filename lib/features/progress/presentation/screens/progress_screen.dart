import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';
import 'package:nexus_portuguese_app/features/progress/domain/entities/progress_stats_entity.dart';
import '../widgets/activity_heatmap_widget.dart';
import '../widgets/badges_grid_section.dart';
import '../widgets/fluency_score_card.dart';
import '../widgets/streak_flame_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProgressCubit>().loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Центр беглости и наград 🏆'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Обновить статистику',
            onPressed: () => context.read<ProgressCubit>().loadStats(),
          ),
        ],
      ),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          if (state is ProgressLoading || state is ProgressInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProgressError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.read<ProgressCubit>().loadStats(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is ProgressLoaded) {
            return _ProgressContentView(stats: state.stats);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProgressContentView extends StatelessWidget {
  final ProgressStatsEntity stats;

  const _ProgressContentView({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FluencyScoreCard(
            fluencyScore: stats.fluencyScore,
            cefrLevel: stats.cefrLevel,
            cefrScorePercentage: stats.cefrScorePercentage,
            phoneticMasteryAvg: stats.phoneticMasteryAvg,
            scenesCompletedCount: stats.scenesCompletedCount,
            grammarLogsCount: stats.grammarLogsCount,
          ),
          const SizedBox(height: 16),
          StreakFlameCard(
            currentStreak: stats.currentStreak,
            maxStreak: stats.maxStreak,
            activityByDay: stats.activityByDay,
          ),
          const SizedBox(height: 24),
          BadgesGridSection(badges: stats.badges),
          const SizedBox(height: 24),
          Text(
            'Активность обучения (12 недель):',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ActivityHeatmapWidget(activityByDay: stats.activityByDay),
          const SizedBox(height: 24),
          Text(
            'Статистика по модулям:',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _ModuleStatTile(
            icon: Icons.style_rounded,
            title: 'FSRS Карточки',
            value: '${stats.reviewsCount} повторений',
            subtitle: 'Активных карточек в базе: ${stats.cardsCount}',
            color: Colors.blue,
          ),
          _ModuleStatTile(
            icon: Icons.theater_comedy_rounded,
            title: 'Живые сцены Португалии',
            value: '${stats.scenesCompletedCount} из 6 завершено',
            subtitle: 'Копакабана, Белен, метро и кафе',
            color: Colors.teal,
          ),
          _ModuleStatTile(
            icon: Icons.bolt_rounded,
            title: 'VerboSprint и грамматика',
            value: '${stats.grammarLogsCount} спряжений',
            subtitle: 'Спряжения, предлоги и времена',
            color: Colors.amber.shade900,
          ),
          _ModuleStatTile(
            icon: Icons.graphic_eq_rounded,
            title: 'Фонетика и носовые гласные',
            value: '${stats.phoneticMasteryAvg.round()}% мастерства',
            subtitle: 'Звуки ão, õe, закрытые и открытые гласные',
            color: Colors.deepOrange,
          ),
          _ModuleStatTile(
            icon: Icons.headphones_rounded,
            title: 'Аудирование и диктанты',
            value: '${stats.listeningLogsCount} диктантов',
            subtitle: 'Восприятие живой речи на слух',
            color: Colors.purple,
          ),
          _ModuleStatTile(
            icon: Icons.forum_rounded,
            title: 'Интерактивные диалоги',
            value: '${stats.dialoguesCount} реплик',
            subtitle: 'Разговорная практика в ситуациях',
            color: Colors.green,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ModuleStatTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _ModuleStatTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            radius: 22,
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontSize: 11,
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
