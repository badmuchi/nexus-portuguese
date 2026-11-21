import 'package:flutter/material.dart';
import '../../domain/entities/verb_trainer_config.dart';

class VerbTrainerConfigSheet extends StatefulWidget {
  final VerbTrainerConfig initialConfig;
  final ValueChanged<VerbTrainerConfig> onStart;

  const VerbTrainerConfigSheet({
    super.key,
    required this.initialConfig,
    required this.onStart,
  });

  static Future<void> show(
    BuildContext context, {
    VerbTrainerConfig initialConfig = const VerbTrainerConfig(),
    required ValueChanged<VerbTrainerConfig> onStart,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => VerbTrainerConfigSheet(
        initialConfig: initialConfig,
        onStart: onStart,
      ),
    );
  }

  @override
  State<VerbTrainerConfigSheet> createState() => _VerbTrainerConfigSheetState();
}

class _VerbTrainerConfigSheetState extends State<VerbTrainerConfigSheet> {
  late TrainerMode _mode;
  late TenseFilter _tenseFilter;
  late bool _irregularsOnly;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialConfig.mode;
    _tenseFilter = widget.initialConfig.tenseFilter;
    _irregularsOnly = widget.initialConfig.irregularsOnly;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.bolt_rounded, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  'Настройки VerboSprint',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mode Selector
            Text(
              'Режим тренировки:',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _ModeTile(
              mode: TrainerMode.sprint60,
              icon: Icons.timer_outlined,
              title: 'Блиц-Спринт (60 секунд)',
              subtitle: 'Максимум форм за 1 минуту со стрик-множителем',
              isSelected: _mode == TrainerMode.sprint60,
              onTap: () => setState(() => _mode = TrainerMode.sprint60),
            ),
            const SizedBox(height: 6),
            _ModeTile(
              mode: TrainerMode.drill15,
              icon: Icons.checklist_rounded,
              title: 'Дрилл (15 глаголов)',
              subtitle: 'Спокойная практика с подробным разбором',
              isSelected: _mode == TrainerMode.drill15,
              onTap: () => setState(() => _mode = TrainerMode.drill15),
            ),
            const SizedBox(height: 6),
            _ModeTile(
              mode: TrainerMode.marathon30,
              icon: Icons.directions_run_rounded,
              title: 'Марафон (30 глаголов)',
              subtitle: 'Интенсивная прокачка всех спряжений',
              isSelected: _mode == TrainerMode.marathon30,
              onTap: () => setState(() => _mode = TrainerMode.marathon30),
            ),

            const SizedBox(height: 16),

            // Tense Selector
            Text(
              'Время глаголов:',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<TenseFilter>(
              value: _tenseFilter,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              items: TenseFilter.values.map((f) {
                return DropdownMenuItem(
                  value: f,
                  child: Text(f.labelRu),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _tenseFilter = val);
              },
            ),

            const SizedBox(height: 12),

            // Irregular Only Switch
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Только неправильные глаголы'),
              subtitle: const Text('ser, estar, ir, ter, fazer, dizer, poder...'),
              value: _irregularsOnly,
              onChanged: (val) => setState(() => _irregularsOnly = val),
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                widget.onStart(
                  VerbTrainerConfig(
                    mode: _mode,
                    tenseFilter: _tenseFilter,
                    irregularsOnly: _irregularsOnly,
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Начать тренировку', style: TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  final TrainerMode mode;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeTile({
    required this.mode,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
