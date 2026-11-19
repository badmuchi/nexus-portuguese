import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/portuguese_normalizer.dart';
import '../../domain/services/fsrs_engine.dart';
import '../cubit/srs_cubit.dart';
import '../cubit/srs_state.dart';

class SrsScreen extends StatefulWidget {
  const SrsScreen({super.key});

  @override
  State<SrsScreen> createState() => _SrsScreenState();
}

class _SrsScreenState extends State<SrsScreen> {
  final _typingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SrsCubit>().loadDueCards();
  }

  @override
  void dispose() {
    _typingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FSRS Карточки'),
        actions: [
          BlocBuilder<SrsCubit, SrsState>(
            builder: (context, state) {
              if (state is SrsReviewing) {
                final isTyping = state.reviewMode == SrsReviewMode.typing;
                return IconButton(
                  tooltip: isTyping ? 'Режим карточек' : 'Режим ввода с клавиатуры',
                  icon: Icon(isTyping ? Icons.style_rounded : Icons.keyboard_rounded),
                  onPressed: () {
                    context.read<SrsCubit>().switchReviewMode(
                          isTyping ? SrsReviewMode.flashcard : SrsReviewMode.typing,
                        );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            tooltip: 'Обновить',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<SrsCubit>().loadDueCards(),
          ),
        ],
      ),
      body: BlocConsumer<SrsCubit, SrsState>(
        listener: (context, state) {
          if (state is SrsReviewing && !state.isFrontRevealed) {
            _typingController.clear();
          }
        },
        builder: (context, state) {
          if (state is SrsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SrsEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 72, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Tudo em dia!',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Все карточки повторены на сегодня! Всего в базе: ${state.totalCards}.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.read<SrsCubit>().loadDueCards(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Проверить снова'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is SrsError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: theme.colorScheme.error)),
            );
          }

          if (state is SrsReviewing) {
            final card = state.currentCard;

            return Column(
              children: [
                LinearProgressIndicator(
                  value: (state.currentIndex + 1) / state.queue.length,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Осталось: ${state.remainingCount}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          card.dialect == 'pt_br'
                              ? 'PT-BR 🇧🇷'
                              : card.dialect == 'pt_pt'
                                  ? 'PT-PT 🇵🇹'
                                  : 'PT 🇧🇷/🇵🇹',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Card surface
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: state.reviewMode == SrsReviewMode.flashcard
                              ? () => context.read<SrsCubit>().toggleFlip()
                              : null,
                          child: Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 260),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  card.russianTranslation,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (card.exampleRussian != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    card.exampleRussian!,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.outline,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 24),
                                if (state.isFrontRevealed) ...[
                                  const Divider(),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          card.portuguese,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.volume_up_rounded),
                                        color: theme.colorScheme.primary,
                                        onPressed: () => context.read<SrsCubit>().playCurrentCardAudio(),
                                      ),
                                    ],
                                  ),
                                  if (card.examplePortuguese != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      card.examplePortuguese!,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                  if (card.notes != null) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        card.notes!,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                ] else if (state.reviewMode == SrsReviewMode.flashcard) ...[
                                  Text(
                                    'Нажмите, чтобы перевернуть',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // Typing Input area if typing mode
                        if (state.reviewMode == SrsReviewMode.typing && !state.isFrontRevealed) ...[
                          const SizedBox(height: 20),
                          TextField(
                            controller: _typingController,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'Введите перевод на португальском',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_forward_rounded),
                                onPressed: () {
                                  context.read<SrsCubit>().submitTypedAnswer(_typingController.text);
                                },
                              ),
                            ),
                            onSubmitted: (text) {
                              context.read<SrsCubit>().submitTypedAnswer(text);
                            },
                          ),
                        ],

                        // Typing Feedback
                        if (state.reviewMode == SrsReviewMode.typing && state.isFrontRevealed) ...[
                          const SizedBox(height: 16),
                          _buildTypingFeedback(state.typingResult, theme),
                        ],
                      ],
                    ),
                  ),
                ),

                // Rating buttons (1=Again, 2=Hard, 3=Good, 4=Easy)
                if (state.isFrontRevealed)
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () => context.read<SrsCubit>().rateCurrentCard(SrsRating.again),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Снова', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('1 дн', style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () => context.read<SrsCubit>().rateCurrentCard(SrsRating.hard),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Трудно', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('2-3 дн', style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () => context.read<SrsCubit>().rateCurrentCard(SrsRating.good),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Хорошо', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('4-7 дн', style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () => context.read<SrsCubit>().rateCurrentCard(SrsRating.easy),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Легко', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('10+ дн', style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTypingFeedback(PortugueseMatchResult? result, ThemeData theme) {
    if (result == null) return const SizedBox.shrink();

    return switch (result) {
      PortugueseMatchResult.exact => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Perfeito! Точное совпадение со всеми ударениями!',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      PortugueseMatchResult.accentMissing => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Почти! Буквы верны, но не забывайте диакритику (ударения / тильду)!',
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      PortugueseMatchResult.mismatch => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.redAccent),
          ),
          child: const Row(
            children: [
              Icon(Icons.close_rounded, color: Colors.redAccent),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ошибка в написании. Посмотрите правильный вариант выше.',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
    };
  }
}
