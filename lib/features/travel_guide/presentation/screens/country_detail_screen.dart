import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/lusophone_country_entity.dart';

class CountryDetailScreen extends StatelessWidget {
  final LusophoneCountryEntity country;

  const CountryDetailScreen({super.key, required this.country});

  static Route<void> route({required LusophoneCountryEntity country}) {
    return MaterialPageRoute(
      builder: (_) => CountryDetailScreen(country: country),
    );
  }

  void _playAudio(BuildContext context, String text) {
    final audio = context.read<HybridAudioPlaybackService>();
    final dialect = country.id == 'brasil'
        ? PortugueseDialect.brazilian
        : PortugueseDialect.european;

    audio.playAudioOrSpeak(
      fallbackText: text,
      dialect: dialect,
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Скопировано в буфер обмена! 🧭'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addExpressionToSrs(
    BuildContext context,
    CountryLinguisticFeature expr,
  ) async {
    HapticFeedback.mediumImpact();
    try {
      final srsRepo = context.read<SrsRepository>();
      final card = SrsCardEntity(
        id: 'country_expr_${expr.termPt}_${DateTime.now().millisecondsSinceEpoch}',
        portuguese: expr.termPt,
        russianTranslation: expr.translationRu,
        partOfSpeech: 'Gíria Regional',
        category: 'geografia',
        dialect: country.id == 'brasil' ? 'pt_BR' : 'pt_PT',
        examplePortuguese: expr.examplePt,
        exampleRussian: expr.translationRu,
        notes: '${country.nameRu} • ${expr.explanationRu}',
        fsrsState: 'newCard',
        stability: 0.0,
        difficulty: 0.0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      );

      await srsRepo.addCard(card);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('«${expr.termPt}» добавлено в FSRS! 🌍'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          country.namePt,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded),
            tooltip: 'Озвучить название страны',
            onPressed: () => _playAudio(context, '${country.namePt}. Capital: ${country.capitalPt}.'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Hero Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
                    theme.colorScheme.surfaceContainerHighest,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Text(country.flagEmoji, style: const TextStyle(fontSize: 56)),
                  const SizedBox(height: 8),
                  Text(
                    country.namePt,
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    country.nameRu,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildPill(theme, Icons.location_city_rounded, 'Столица: ${country.capitalRu}'),
                      _buildPill(theme, Icons.public_rounded, country.continentRu),
                      _buildPill(theme, Icons.people_outline_rounded, country.population),
                      _buildPill(theme, Icons.payments_outlined, country.currency),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Dialect & Language Notes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.record_voice_over_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Особенности языка и диалекта',
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    country.dialectOverviewRu,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Culture & History
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_stories_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Культура и дух страны',
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    country.culturalOverviewRu,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Национальное блюдо: ',
                        style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          country.nationalDishRu,
                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Top Attractions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.camera_alt_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Главные достопримечательности',
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...country.topAttractionsRu.map(
                    (attr) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('📍 ', style: TextStyle(fontSize: 14)),
                          Expanded(
                            child: Text(
                              attr,
                              style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Local Expressions
            Text(
              'Фирменные выражения (${country.localExpressions.length})',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...country.localExpressions.map(
              (expr) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            expr.termPt,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, size: 20),
                            onPressed: () => _playAudio(context, expr.termPt),
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            onPressed: () => _copy(context, expr.termPt),
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                            onPressed: () => _addExpressionToSrs(context, expr),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      Text(
                        expr.translationRu,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        expr.explanationRu,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '«${expr.examplePt}»',
                          style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(ThemeData theme, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: theme.colorScheme.primary),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
