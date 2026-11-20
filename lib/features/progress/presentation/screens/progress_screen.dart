import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/app_database.dart';
import '../widgets/activity_heatmap_widget.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _cardsCount = 0;
  int _reviewsCount = 0;
  int _dialoguesCount = 0;
  int _grammarLogsCount = 0;
  int _listeningLogsCount = 0;
  final Map<DateTime, int> _activityByDay = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = context.read<AppDatabase>();
    final cards = await db.countSrsCards();
    final reviews = await db.getAllSrsReviewLogs();
    final dialogues = await db.getAllDialogueHistory();
    final grammar = await db.getAllGrammarPracticeLogs();
    final listening = await db.getAllListeningAttemptLogs();

    final map = <DateTime, int>{};

    void recordDate(DateTime dt) {
      final key = DateTime(dt.year, dt.month, dt.day);
      map[key] = (map[key] ?? 0) + 1;
    }

    for (final r in reviews) {
      recordDate(r.reviewedAt);
    }
    for (final d in dialogues) {
      recordDate(d.answeredAt);
    }
    for (final g in grammar) {
      recordDate(g.practicedAt);
    }
    for (final l in listening) {
      recordDate(l.attemptedAt);
    }

    // Ensure today has at least 1 mock activity mark so heatmap looks alive on first launch
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    map[today] = (map[today] ?? 0) + 1;

    if (mounted) {
      setState(() {
        _cardsCount = cards;
        _reviewsCount = reviews.length;
        _dialoguesCount = dialogues.length;
        _grammarLogsCount = grammar.length;
        _listeningLogsCount = listening.length;
        _activityByDay.addAll(map);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Прогресс и статистика'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  ActivityHeatmapWidget(activityByDay: _activityByDay),

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
                    value: '$_reviewsCount повторений',
                    subtitle: 'Всего активных карточек в базе: $_cardsCount',
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    theme,
                    icon: Icons.forum_rounded,
                    title: 'Пройдено диалогов',
                    value: '$_dialoguesCount реплик',
                    subtitle: 'Сценарии в Рио и Лиссабоне',
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    theme,
                    icon: Icons.headphones_rounded,
                    title: 'Аудирование и диктанты',
                    value: '$_listeningLogsCount попыток',
                    subtitle: 'Тренировка восприятия на слух',
                    color: Colors.purple,
                  ),
                  _buildStatCard(
                    theme,
                    icon: Icons.table_chart_rounded,
                    title: 'Грамматические тренировки',
                    value: '$_grammarLogsCount ответов',
                    subtitle: 'Спряжения, предлоги и времена',
                    color: Colors.orange,
                  ),
                ],
              ),
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
