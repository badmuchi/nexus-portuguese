import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';
import '../widgets/activity_heatmap_widget.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Прогресс и статистика'),
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
                  Text(state.message),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<ProgressCubit>().loadStats(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is ProgressLoaded) {
            final stats = state.stats;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.tertiary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.local_fire_department_rounded, color: Colors.amber, size: 28),
                            SizedBox(width: 8),
                            Text(
                              'Стрик обучения: 1 день',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Отличное начало! Регулярность — главный секрет освоения португальского языка.',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 12-week GitHub-style heatmap
                  ActivityHeatmapWidget(activityByDay: stats.activityByDay),

                  const SizedBox(height: 20),
                  Text(
                    'Статистика активности:',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    theme,
                    icon: Icons.style_rounded,
                    title: 'FSRS Карточки',
                    value: '${stats.reviewsCount} повторений',
                    subtitle: 'Всего активных карточек в базе: ${stats.cardsCount}',
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    theme,
                    icon: Icons.forum_rounded,
                    title: 'Пройдено диалогов',
                    value: '${stats.dialoguesCount} реплик',
                    subtitle: 'Сценарии в Рио и Лиссабоне',
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    theme,
                    icon: Icons.headphones_rounded,
                    title: 'Аудирование и диктанты',
                    value: '${stats.listeningLogsCount} попыток',
                    subtitle: 'Тренировка восприятия на слух',
                    color: Colors.purple,
                  ),
                  _buildStatCard(
                    theme,
                    icon: Icons.table_chart_rounded,
                    title: 'Грамматические тренировки',
                    value: '${stats.grammarLogsCount} ответов',
                    subtitle: 'Спряжения, предлоги и времена',
                    color: Colors.orange,
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          radius: 24,
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
          ],
        ),
      ),
    );
  }
}
