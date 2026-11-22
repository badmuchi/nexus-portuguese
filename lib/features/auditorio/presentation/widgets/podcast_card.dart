import 'package:flutter/material.dart';
import '../../domain/entities/podcast_track_entity.dart';

class PodcastCard extends StatelessWidget {
  final PodcastTrack track;
  final VoidCallback onTap;

  const PodcastCard({
    super.key,
    required this.track,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Color(track.primaryColorHex);
    final accentColor = Color(track.accentColorHex);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardBanner(
              primaryColor: primaryColor,
              accentColor: accentColor,
              coverEmoji: track.coverEmoji,
              dialectFlag: track.dialectFlag,
              dialectLabel: track.dialectLabel,
              cefrLevel: track.cefrLevel,
              isCompleted: track.isCompleted,
            ),
            _CardContent(
              titlePt: track.titlePt,
              titleRu: track.titleRu,
              descriptionRu: track.descriptionRu,
              formattedDuration: track.formattedDuration,
              snippetsCount: track.transcript.length,
              category: track.category,
              theme: theme,
              accentColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardBanner extends StatelessWidget {
  final Color primaryColor;
  final Color accentColor;
  final String coverEmoji;
  final String dialectFlag;
  final String dialectLabel;
  final String cefrLevel;
  final bool isCompleted;

  const _CardBanner({
    required this.primaryColor,
    required this.accentColor,
    required this.coverEmoji,
    required this.dialectFlag,
    required this.dialectLabel,
    required this.cefrLevel,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, accentColor.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                ),
                alignment: Alignment.center,
                child: Text(
                  coverEmoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(dialectFlag, style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Text(
                          dialectLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'CEFR $cefrLevel',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Изучен',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

class _CardContent extends StatelessWidget {
  final String titlePt;
  final String titleRu;
  final String descriptionRu;
  final String formattedDuration;
  final int snippetsCount;
  final String category;
  final ThemeData theme;
  final Color accentColor;

  const _CardContent({
    required this.titlePt,
    required this.titleRu,
    required this.descriptionRu,
    required this.formattedDuration,
    required this.snippetsCount,
    required this.category,
    required this.theme,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titlePt,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            titleRu,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            descriptionRu,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.timer_outlined,
                    label: formattedDuration,
                    theme: theme,
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.format_quote_rounded,
                    label: '$snippetsCount фраз',
                    theme: theme,
                  ),
                ],
              ),
              FilledButton.tonalIcon(
                onPressed: null, // обрабатывается тапом по карточке InkWell
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                icon: const Icon(Icons.play_arrow_rounded, size: 18),
                label: const Text('Слушать'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.outline),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
