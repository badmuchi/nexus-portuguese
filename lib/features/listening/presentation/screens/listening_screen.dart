import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/portuguese_normalizer.dart';
import '../../../../core/widgets/portuguese_accent_bar.dart';
import '../cubit/listening_cubit.dart';
import '../cubit/listening_state.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final _dictationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ListeningCubit>().loadExercises();
  }

  @override
  void dispose() {
    _dictationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Аудирование и диктанты'),
        actions: [
          IconButton(
            tooltip: 'Обновить',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<ListeningCubit>().loadExercises(),
          ),
        ],
      ),
      body: BlocConsumer<ListeningCubit, ListeningState>(
        listener: (context, state) {
          if (state is ListeningLoaded && !state.isRevealed) {
            _dictationController.clear();
          }
        },
        builder: (context, state) {
          if (state is ListeningLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ListeningError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: theme.colorScheme.error)),
            );
          }

          if (state is ListeningLoaded) {
            final ex = state.currentExercise;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Difficulty & Dialect Tags
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ex.dialect == 'pt_br'
                              ? 'PT-BR 🇧🇷'
                              : ex.dialect == 'pt_pt'
                                  ? 'PT-PT 🇵🇹'
                                  : 'PT 🇧🇷/🇵🇹',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      Text(
                        'Упражнение ${state.currentIndex + 1} из ${state.exercises.length}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Player Box
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        FilledButton.tonalIcon(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () => context.read<ListeningCubit>().playAudio(),
                          icon: const Icon(Icons.volume_up_rounded, size: 28),
                          label: const Text(
                            'Слушать фразу',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: state.playbackRate == 0.75
                                    ? theme.colorScheme.secondaryContainer
                                    : null,
                              ),
                              onPressed: () => context.read<ListeningCubit>().setPlaybackRate(0.75),
                              child: const Text('0.75x (Медленно)'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: state.playbackRate == 1.0
                                    ? theme.colorScheme.secondaryContainer
                                    : null,
                              ),
                              onPressed: () => context.read<ListeningCubit>().setPlaybackRate(1.0),
                              child: const Text('1.0x (Нормально)'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dictation Input Field
                  if (!state.isRevealed) ...[
                    PortugueseAccentBar(
                      controller: _dictationController,
                      onSubmitted: () {
                        context.read<ListeningCubit>().checkDictation(_dictationController.text);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _dictationController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Запишите услышанное на португальском',
                        hintText: 'Введите текст фразы...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              context.read<ListeningCubit>().checkDictation(_dictationController.text);
                            },
                            child: const Text('Проверить'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => context.read<ListeningCubit>().revealTranscript(),
                          child: const Text('Показать текст'),
                        ),
                      ],
                    ),
                  ],

                  // Revealed Results
                  if (state.isRevealed) ...[
                    if (state.matchResult != null) ...[
                      _buildFeedbackBanner(state.matchResult!, theme),
                      const SizedBox(height: 16),
                    ],
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Оригинал фразы:',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ex.transcript,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Перевод: ${ex.russianTranslation}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          if (ex.focusWords.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              children: ex.focusWords.map((w) {
                                return Chip(
                                  label: Text(w),
                                  visualDensity: VisualDensity.compact,
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => context.read<ListeningCubit>().nextExercise(),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Следующая фраза'),
                    ),
                  ],
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFeedbackBanner(PortugueseMatchResult result, ThemeData theme) {
    return switch (result) {
      PortugueseMatchResult.exact => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Perfeito! 100% точное распознавание на слух!',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      PortugueseMatchResult.accentMissing => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_rounded, color: Colors.orange),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Хорошо! Слова верны, но обратите внимание на диакритику!',
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      PortugueseMatchResult.mismatch => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.redAccent),
          ),
          child: const Row(
            children: [
              Icon(Icons.replay_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Есть несовпадения. Сравните с оригиналом ниже.',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
    };
  }
}
