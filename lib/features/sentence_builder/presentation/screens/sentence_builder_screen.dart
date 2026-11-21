import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/features/morphology/presentation/widgets/sentence_xray_sheet.dart';
import '../../domain/entities/sentence_builder_result.dart';
import '../../domain/entities/sentence_puzzle.dart';
import '../cubit/sentence_builder_cubit.dart';
import '../cubit/sentence_builder_state.dart';

class SentenceBuilderScreen extends StatefulWidget {
  const SentenceBuilderScreen({super.key});

  @override
  State<SentenceBuilderScreen> createState() => _SentenceBuilderScreenState();
}

class _SentenceBuilderScreenState extends State<SentenceBuilderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SentenceBuilderCubit>().loadPuzzles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Конструктор фраз 🧩'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Начать заново',
            onPressed: () => context.read<SentenceBuilderCubit>().loadPuzzles(),
          ),
        ],
      ),
      body: BlocBuilder<SentenceBuilderCubit, SentenceBuilderState>(
        builder: (context, state) {
          if (state is SentenceBuilderLoading || state is SentenceBuilderInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SentenceBuilderError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.read<SentenceBuilderCubit>().loadPuzzles(),
                      child: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is SentenceBuilderCompleted) {
            return _BuilderSummaryView(result: state.result);
          }

          if (state is SentenceBuilderActive) {
            return _ActivePuzzleView(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ActivePuzzleView extends StatelessWidget {
  final SentenceBuilderActive state;

  const _ActivePuzzleView({required this.state});

  @override
  Widget build(BuildContext context) {
    final puzzle = state.currentPuzzle;

    return Column(
      children: [
        _TopProgressHeader(
          currentIndex: state.currentIndex,
          totalPuzzles: state.totalPuzzles,
          progressPercent: state.progressPercent,
          levelLabel: puzzle.level.label,
          scorePoints: state.scorePoints,
          streak: state.streak,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TranslationCard(
                  russianMeaning: puzzle.russianMeaning,
                  dialect: puzzle.dialect,
                ),
                const SizedBox(height: 20),
                _AssemblySlotArea(
                  assembledTokens: state.assembledTokens,
                  isChecked: state.isChecked,
                  isCorrect: state.isCorrect,
                  onRemoveToken: (index) {
                    if (!state.isChecked) {
                      context.read<SentenceBuilderCubit>().tapAssembledToken(index);
                    }
                  },
                ),
                const SizedBox(height: 24),
                _AvailableTokensBank(
                  availableTokens: state.availableTokens,
                  isChecked: state.isChecked,
                  onSelectToken: (index) {
                    if (!state.isChecked) {
                      context.read<SentenceBuilderCubit>().tapAvailableToken(index);
                    }
                  },
                ),
                if (state.isChecked) ...[
                  const SizedBox(height: 20),
                  _ExplanationAndXRayBox(
                    puzzle: puzzle,
                    isCorrect: state.isCorrect ?? false,
                    isPlayingAudio: state.isPlayingAudio,
                    onPlayAudio: () {
                      context
                          .read<SentenceBuilderCubit>()
                          .playAudio(puzzle.targetPortuguese);
                    },
                    onOpenXRay: () {
                      SentenceXRaySheet.show(
                        context,
                        sentencePortuguese: puzzle.targetPortuguese,
                        translationRussian: puzzle.russianMeaning,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        _BottomActionControls(
          isChecked: state.isChecked,
          canCheck: state.assembledTokens.isNotEmpty,
          isLast: state.isLastPuzzle,
          onReset: () => context.read<SentenceBuilderCubit>().resetCurrentAssembly(),
          onCheck: () => context.read<SentenceBuilderCubit>().checkAnswer(),
          onNext: () => context.read<SentenceBuilderCubit>().nextPuzzle(),
        ),
      ],
    );
  }
}

class _TopProgressHeader extends StatelessWidget {
  final int currentIndex;
  final int totalPuzzles;
  final double progressPercent;
  final String levelLabel;
  final int scorePoints;
  final int streak;

  const _TopProgressHeader({
    required this.currentIndex,
    required this.totalPuzzles,
    required this.progressPercent,
    required this.levelLabel,
    required this.scorePoints,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        LinearProgressIndicator(
          value: progressPercent,
          minHeight: 6,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      levelLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Фраза ${currentIndex + 1} из $totalPuzzles',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: [
                  if (streak >= 2) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: Colors.deepOrange, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'x$streak',
                            style: const TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$scorePoints pts',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _TranslationCard extends StatelessWidget {
  final String russianMeaning;
  final String dialect;

  const _TranslationCard({
    required this.russianMeaning,
    required this.dialect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Соберите предложение:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.outline,
                ),
              ),
              const Spacer(),
              if (dialect != 'all')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    dialect == 'pt-PT' ? '🇵🇹 PT-PT' : '🇧🇷 PT-BR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            russianMeaning,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssemblySlotArea extends StatelessWidget {
  final List<String> assembledTokens;
  final bool isChecked;
  final bool? isCorrect;
  final ValueChanged<int> onRemoveToken;

  const _AssemblySlotArea({
    required this.assembledTokens,
    required this.isChecked,
    required this.isCorrect,
    required this.onRemoveToken,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.6);
    Color bgColor = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);

    if (isChecked) {
      if (isCorrect == true) {
        borderColor = Colors.green;
        bgColor = Colors.green.withValues(alpha: 0.1);
      } else {
        borderColor = Colors.redAccent;
        bgColor = Colors.redAccent.withValues(alpha: 0.1);
      }
    }

    return Container(
      constraints: const Duration().inMilliseconds > 0 ? null : const BoxConstraints(minHeight: 110),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: isChecked ? 2 : 1.5),
      ),
      child: assembledTokens.isEmpty
          ? Center(
              child: Text(
                'Нажимайте на слова внизу, чтобы составить фразу',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.outline,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(assembledTokens.length, (index) {
                final token = assembledTokens[index];
                return _TokenChip(
                  text: token,
                  isAssembled: true,
                  onTap: () => onRemoveToken(index),
                );
              }),
            ),
    );
  }
}

class _AvailableTokensBank extends StatelessWidget {
  final List<String> availableTokens;
  final bool isChecked;
  final ValueChanged<int> onSelectToken;

  const _AvailableTokensBank({
    required this.availableTokens,
    required this.isChecked,
    required this.onSelectToken,
  });

  @override
  Widget build(BuildContext context) {
    if (availableTokens.isEmpty) {
      return const SizedBox(height: 48);
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: List.generate(availableTokens.length, (index) {
        final token = availableTokens[index];
        return _TokenChip(
          text: token,
          isAssembled: false,
          onTap: () => onSelectToken(index),
        );
      }),
    );
  }
}

class _TokenChip extends StatelessWidget {
  final String text;
  final bool isAssembled;
  final VoidCallback onTap;

  const _TokenChip({
    required this.text,
    required this.isAssembled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isAssembled
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAssembled
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
            width: isAssembled ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isAssembled
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ExplanationAndXRayBox extends StatelessWidget {
  final SentencePuzzle puzzle;
  final bool isCorrect;
  final bool isPlayingAudio;
  final VoidCallback onPlayAudio;
  final VoidCallback onOpenXRay;

  const _ExplanationAndXRayBox({
    required this.puzzle,
    required this.isCorrect,
    required this.isPlayingAudio,
    required this.onPlayAudio,
    required this.onOpenXRay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isCorrect ? Colors.green : Colors.deepOrange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                color: color,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isCorrect ? 'Идеально собрано!' : 'Правильный вариант:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlayingAudio ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                  color: color,
                ),
                onPressed: isPlayingAudio ? null : onPlayAudio,
                tooltip: 'Прослушать фразу',
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            puzzle.targetPortuguese,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            puzzle.grammarExplanationRu,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onOpenXRay,
            icon: const Icon(Icons.document_scanner_rounded, size: 18),
            label: const Text('Рентген фразы (Sentence X-Ray)'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionControls extends StatelessWidget {
  final bool isChecked;
  final bool canCheck;
  final bool isLast;
  final VoidCallback onReset;
  final VoidCallback onCheck;
  final VoidCallback onNext;

  const _BottomActionControls({
    required this.isChecked,
    required this.canCheck,
    required this.isLast,
    required this.onReset,
    required this.onCheck,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: isChecked
            ? SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: onNext,
                  icon: Icon(isLast ? Icons.done_all_rounded : Icons.arrow_forward_rounded),
                  label: Text(
                    isLast ? 'Завершить конструктор' : 'Следующая фраза',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              )
            : Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Сброс'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: FilledButton(
                        onPressed: canCheck ? onCheck : null,
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'Проверить синтаксис',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _BuilderSummaryView extends StatelessWidget {
  final SentenceBuilderResult result;

  const _BuilderSummaryView({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SentenceBuilderCubit, SentenceBuilderState>(
      builder: (context, state) {
        final isSavingToFsrs = state is SentenceBuilderCompleted && state.isSavingToFsrs;
        final addedCount = state is SentenceBuilderCompleted ? state.addedToFsrsCount : 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.withValues(alpha: 0.15),
                      theme.colorScheme.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.teal.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.extension_rounded, color: Colors.white, size: 36),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Конструктор завершён!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Собрано: ${result.solvedCount} из ${result.totalQuestions} (${result.accuracyPercentage.round()}%)',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Заработано очков: ${result.scorePoints} pts',
                      style: TextStyle(color: theme.colorScheme.outline),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (result.mistakes.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.style_rounded, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Сложные предложения: ${result.mistakes.length}',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Добавьте предложения с ошибками в умные карточки FSRS для закрепления порядка слов.',
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: (isSavingToFsrs || addedCount > 0)
                            ? null
                            : () => context.read<SentenceBuilderCubit>().saveMistakesToFsrs(),
                        icon: isSavingToFsrs
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Icon(addedCount > 0 ? Icons.check_circle_rounded : Icons.add_card_rounded),
                        label: Text(
                          addedCount > 0
                              ? 'Добавлено в FSRS ($addedCount)'
                              : 'Добавить ${result.mistakes.length} предложений в FSRS',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              FilledButton.icon(
                onPressed: () => context.read<SentenceBuilderCubit>().loadPuzzles(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Собрать ещё раз'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
