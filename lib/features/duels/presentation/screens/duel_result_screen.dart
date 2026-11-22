import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/duel_session_result_entity.dart';
import '../cubit/duels_cubit.dart';

class DuelResultScreen extends StatelessWidget {
  final DuelSessionResultEntity result;

  const DuelResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<DuelsCubit>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Итоги дуэли'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TrophyCard(result: result, theme: theme),
            const SizedBox(height: 20),
            _StatsBreakdownCard(result: result, theme: theme),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                cubit.startDuel();
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.replay_rounded),
              label: const Text(
                'Сыграть ещё раунд!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                cubit.resetToLobby();
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('В лобби арены'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrophyCard extends StatelessWidget {
  final DuelSessionResultEntity result;
  final ThemeData theme;

  const _TrophyCard({
    required this.result,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade800,
            Colors.purple.shade900,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(result.trophyEmoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 12),
          Text(
            result.titlePt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            result.titleRu,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBreakdownCard extends StatelessWidget {
  final DuelSessionResultEntity result;
  final ThemeData theme;

  const _StatsBreakdownCard({
    required this.result,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.check_circle_rounded,
                  iconColor: Colors.green,
                  label: 'Правильно',
                  value: '${result.correctAnswers} / ${result.totalQuestions}',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _StatTile(
                  icon: Icons.percent_rounded,
                  iconColor: Colors.blue,
                  label: 'Точность',
                  value: '${result.accuracyPercent.round()}%',
                  theme: theme,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.bolt_rounded,
                  iconColor: Colors.amber,
                  label: 'Очки',
                  value: '${result.score}',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _StatTile(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: Colors.deepOrange,
                  label: 'Макс. стрик',
                  value: '${result.maxStreak} 🔥',
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final ThemeData theme;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 26),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
        ),
      ],
    );
  }
}
