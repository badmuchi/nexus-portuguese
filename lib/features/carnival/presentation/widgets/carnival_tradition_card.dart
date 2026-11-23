import 'package:flutter/material.dart';
import '../../domain/entities/carnival_entities.dart';

class CarnivalTraditionCard extends StatelessWidget {
  final CarnivalTraditionEntity tradition;
  final VoidCallback onTap;

  const CarnivalTraditionCard({
    super.key,
    required this.tradition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (catColor, catLabel) = switch (tradition.category) {
      CarnivalTraditionCategory.frevo => (Colors.orange.shade800, 'Frevo & Passo'),
      CarnivalTraditionCategory.maracatu => (Colors.purple.shade800, 'Maracatu Nação'),
      CarnivalTraditionCategory.sambaEnredo => (Colors.amber.shade900, 'Samba-Enredo'),
      CarnivalTraditionCategory.bumbameuboi => (Colors.red.shade800, 'Bumba-Meu-Boi'),
      CarnivalTraditionCategory.entrudoPortugues => (Colors.teal.shade800, 'Entrudo & Caretos'),
      CarnivalTraditionCategory.trioEletrico => (Colors.blue.shade800, 'Trio Elétrico & Axé'),
    };

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tradition.emoji,
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  catLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: catColor,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tradition.country == 'Portugal'
                                      ? '🇵🇹 Portugal'
                                      : '🇧🇷 Brasil',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tradition.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tradition.region,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  tradition.shortSummary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: tradition.keyInstruments
                      .take(2)
                      .map(
                        (inst) => Chip(
                          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                          visualDensity: VisualDensity.compact,
                          backgroundColor:
                              colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                          label: Text(
                            inst,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
