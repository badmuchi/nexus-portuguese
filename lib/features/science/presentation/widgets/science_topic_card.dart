import 'package:flutter/material.dart';
import '../../domain/entities/science_entities.dart';

class ScienceTopicCard extends StatelessWidget {
  final ScienceTopicEntity topic;
  final VoidCallback onTap;

  const ScienceTopicCard({
    super.key,
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (fieldColor, fieldLabel) = switch (topic.field) {
      ScienceField.oceanografia => (Colors.blue.shade800, 'Океанография'),
      ScienceField.biomedicina => (Colors.teal.shade700, 'Биомедицина'),
      ScienceField.energiaVerde => (Colors.green.shade700, 'Зелёная энергия'),
      ScienceField.aeroespacial => (Colors.deepPurple.shade700, 'Аэрокосмос'),
    };

    final dialectFlag = topic.isPtPt ? '🇵🇹' : (topic.isPtBr ? '🇧🇷' : '🌐');

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: fieldColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: fieldColor.withValues(alpha: 0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        topic.accentEmoji,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  topic.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  dialectFlag,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            topic.institution,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  topic.shortSummary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: fieldColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        fieldLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: fieldColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        topic.region,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: colorScheme.outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
