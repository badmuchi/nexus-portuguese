import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/literary_work_entity.dart';
import '../cubit/reader_cubit.dart';
import '../cubit/reader_state.dart';

class LiteraryVocabSheet extends StatelessWidget {
  final LiteraryWorkEntity work;

  const LiteraryVocabSheet({
    super.key,
    required this.work,
  });

  static void show(BuildContext context, LiteraryWorkEntity work, ReaderCubit readerCubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: readerCubit,
        child: LiteraryVocabSheet(work: work),
      ),
    );
  }

  void _playWordAudio(BuildContext context, String word) {
    final audio = context.read<HybridAudioPlaybackService>();
    final targetDialect = work.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;
    audio.playAudioOrSpeak(
      fallbackText: word,
      dialect: targetDialect,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('📚', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Словарь шедевра',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '«${work.titlePt}» • ${work.vocabularyCards.length} слов',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<ReaderCubit, ReaderState>(
              builder: (context, state) {
                if (work.vocabularyCards.isEmpty) {
                  return Center(
                    child: Text(
                      'Для данного произведения словарь формируется.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: work.vocabularyCards.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = work.vocabularyCards[index];
                    final isAdded = state.addedVocabularyIds.contains(item.id);

                    return Card(
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isAdded
                              ? Colors.green.withValues(alpha: 0.5)
                              : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        item.wordPt,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'serif',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item.partOfSpeech,
                                          style: theme.textTheme.labelSmall?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                                  onPressed: () => _playWordAudio(context, item.wordPt),
                                ),
                                ElevatedButton.icon(
                                  onPressed: isAdded
                                      ? null
                                      : () async {
                                          HapticFeedback.mediumImpact();
                                          final success = await context
                                              .read<ReaderCubit>()
                                              .addWordToFsrs(item);
                                          if (success && context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Слово «${item.wordPt}» добавлено в FSRS! 🗂️',
                                                ),
                                                behavior: SnackBarBehavior.floating,
                                                duration: const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    backgroundColor: isAdded
                                        ? Colors.green.shade50
                                        : theme.colorScheme.primaryContainer,
                                    foregroundColor: isAdded
                                        ? Colors.green.shade800
                                        : theme.colorScheme.onPrimaryContainer,
                                    elevation: 0,
                                  ),
                                  icon: Icon(
                                    isAdded
                                        ? Icons.check_circle_rounded
                                        : Icons.add_rounded,
                                    size: 16,
                                  ),
                                  label: Text(
                                    isAdded ? 'В колоде' : '+ FSRS',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.translationRu,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '«${item.contextSentencePt}»',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.contextSentenceRu,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.etymologyRu.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.history_edu_rounded,
                                    size: 14,
                                    color: theme.colorScheme.outline,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Этимология: ${item.etymologyRu}',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.outline,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
