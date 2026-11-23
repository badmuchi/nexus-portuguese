import 'package:flutter/material.dart';
import '../../domain/entities/science_entities.dart';

class LabExperimentCard extends StatelessWidget {
  final LabExperimentEntity experiment;
  final VoidCallback? onListen;

  const LabExperimentCard({
    super.key,
    required this.experiment,
    this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      experiment.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          experiment.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          experiment.objectiveRu,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onListen != null)
                    IconButton.filledTonal(
                      icon: const Icon(Icons.volume_up_rounded, size: 20),
                      onPressed: onListen,
                      tooltip: 'Слушать эксперимент',
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Hypothesis container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline_rounded,
                            size: 16, color: colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Hipótese Científica (Se + Futuro do Subjuntivo):',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '«${experiment.hypothesisPt}»',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: colorScheme.onSurface,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Procedure steps
              Text(
                'Procedimento Experimental (Voz Passiva):',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...experiment.procedureSteps.asMap().entries.map((entry) {
                final idx = entry.key + 1;
                final step = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: colorScheme.secondaryContainer,
                        child: Text(
                          '$idx',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step,
                          style: theme.textTheme.bodySmall?.copyWith(
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 12),

              // Grammar Note Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade700.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 20,
                      color: Colors.blue.shade800,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gramática Científica (Voz Passiva):',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            experiment.passiveVoiceGrammarNote,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
