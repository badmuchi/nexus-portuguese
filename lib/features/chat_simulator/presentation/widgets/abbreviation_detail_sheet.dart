import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/chat_abbreviation_entity.dart';

class AbbreviationDetailSheet extends StatelessWidget {
  final ChatAbbreviation abbreviation;

  const AbbreviationDetailSheet({
    super.key,
    required this.abbreviation,
  });

  static Future<void> show(BuildContext context, ChatAbbreviation abbreviation) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AbbreviationDetailSheet(abbreviation: abbreviation),
    );
  }

  Future<void> _addToSrs(BuildContext context) async {
    HapticFeedback.mediumImpact();
    try {
      final srsRepo = context.read<SrsRepository>();
      final card = SrsCardEntity(
        id: 'chat_abbr_${abbreviation.shortForm}_${DateTime.now().millisecondsSinceEpoch}',
        portuguese: '${abbreviation.shortForm} (${abbreviation.fullWordPt})',
        russianTranslation: abbreviation.translationRu,
        partOfSpeech: 'gíria / abreviação',
        category: 'chat_sms',
        dialect: abbreviation.dialect,
        examplePortuguese: '${abbreviation.shortForm} é abreviação de "${abbreviation.fullWordPt}" na internet.',
        exampleRussian: abbreviation.explanationRu,
        notes: 'Интернет-сокращение: ${abbreviation.shortForm} = ${abbreviation.fullWordPt}',
        fsrsState: 'newCard',
        stability: 0.0,
        difficulty: 0.0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      );

      await srsRepo.addCard(card);

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Сокращение "${abbreviation.shortForm}" добавлено в карточки FSRS! 📱'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  abbreviation.shortForm,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      abbreviation.fullWordPt,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      abbreviation.translationRu,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (abbreviation.dialect != 'all')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    abbreviation.dialect.toLowerCase().contains('br') ? '🇧🇷 Brasil' : '🇵🇹 Portugal',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡 ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Text(
                    abbreviation.explanationRu,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _addToSrs(context),
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Добавить в карточки FSRS'),
          ),
        ],
      ),
    );
  }
}
