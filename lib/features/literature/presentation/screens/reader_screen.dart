import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import '../../domain/entities/literary_work_entity.dart';
import '../../domain/repositories/literature_repository.dart';
import '../cubit/reader_cubit.dart';
import '../cubit/reader_state.dart';
import '../widgets/literary_vocab_sheet.dart';

class ReaderScreen extends StatelessWidget {
  final LiteraryWorkEntity work;

  const ReaderScreen({
    super.key,
    required this.work,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReaderCubit(
        work: work,
        repository: context.read<LiteratureRepository>(),
        audioService: context.read<HybridAudioPlaybackService>(),
        srsRepository: context.read<SrsRepository>(),
      ),
      child: const _ReaderView(),
    );
  }
}

class _ReaderView extends StatelessWidget {
  const _ReaderView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ReaderCubit, ReaderState>(
      builder: (context, state) {
        final work = state.work;
        final passage = state.currentPassage;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  work.titlePt,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  work.authorName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu_book_rounded),
                tooltip: 'Словарь произведения',
                onPressed: () {
                  LiteraryVocabSheet.show(
                    context,
                    work,
                    context.read<ReaderCubit>(),
                  );
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (value) {
                  final cubit = context.read<ReaderCubit>();
                  if (value == 'grammar') cubit.toggleGrammarNotes();
                  if (value == 'poetics') cubit.togglePoeticDevice();
                },
                itemBuilder: (ctx) => [
                  CheckedPopupMenuItem(
                    value: 'grammar',
                    checked: state.showGrammarNotes,
                    child: const Text('Грамматический анализ'),
                  ),
                  CheckedPopupMenuItem(
                    value: 'poetics',
                    checked: state.showPoeticDevice,
                    child: const Text('Поэтические приёмы'),
                  ),
                ],
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(6),
              child: LinearProgressIndicator(
                value: state.readingProgress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header card with epoch & context
                _buildContextCard(context, work),
                const SizedBox(height: 16),

                // Passage pagination indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Строфа ${state.currentPassageIndex + 1} из ${work.passages.length}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${work.dialectFlag} ${work.dialectLabel}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Main Reading Paper / Book Card
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                    ),
                  ),
                  color: theme.colorScheme.surfaceContainerLowest,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Audio recitation trigger
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                work.genre,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                if (state.isPlayingAudio) {
                                  context.read<ReaderCubit>().stopAudio();
                                } else {
                                  context.read<ReaderCubit>().reciteCurrentPassage();
                                }
                              },
                              icon: Icon(
                                state.isPlayingAudio
                                    ? Icons.stop_rounded
                                    : Icons.record_voice_over_rounded,
                                size: 18,
                              ),
                              label: Text(
                                state.isPlayingAudio ? 'Остановить' : 'Декламация',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Portuguese Text in Elegant Serif
                        SelectableText(
                          passage.originalPt,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontFamily: 'serif',
                            height: 1.6,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),

                        // Russian Translation
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          const Text(
                            '🇷🇺',
                            style: TextStyle(fontSize: 16),
                          ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SelectableText(
                                passage.translationRu,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Grammar dissection section
                if (state.showGrammarNotes && passage.grammaticalNotesRu.isNotEmpty) ...[
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: Colors.blue.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.blue.withValues(alpha: 0.3)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_stories_rounded, size: 18, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'Грамматический рентген',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            passage.grammaticalNotesRu,
                            style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Poetic device section
                if (state.showPoeticDevice && passage.poeticDeviceRu.isNotEmpty) ...[
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: Colors.purple.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.purple.withValues(alpha: 0.3)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.flare_rounded, size: 18, color: Colors.purple),
                              const SizedBox(width: 8),
                              Text(
                                'Поэтический приём и смысл',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            passage.poeticDeviceRu,
                            style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Completion banner
                if (state.isCompleted) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Text('📜✨', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Шедевр прочитан!',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              Text(
                                'Отметка о погружении в португальскую классику сохранена в вашем прогрессе.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 60), // Space for floating bottom bar
              ],
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: state.isFirstPassage
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          context.read<ReaderCubit>().previousPassage();
                        },
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Назад'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.read<ReaderCubit>().nextPassage();
                    },
                    icon: Icon(
                      state.isLastPassage
                          ? Icons.check_circle_rounded
                          : Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                    label: Text(
                      state.isLastPassage ? 'Завершить чтение' : 'Следующая строфа',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContextCard(BuildContext context, LiteraryWorkEntity work) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  work.coverEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${work.authorName} • ${work.epochOrMovementRu}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              work.analysisContextRu,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
