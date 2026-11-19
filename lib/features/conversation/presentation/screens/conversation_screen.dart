import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/dialogue_models.dart';
import '../cubit/conversation_cubit.dart';
import '../cubit/conversation_state.dart';
import '../widgets/pronunciation_practice_sheet.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ConversationCubit>().initScenarios();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Диалоги'),
        actions: [
          BlocBuilder<ConversationCubit, ConversationState>(
            builder: (context, state) {
              if (state is ConversationActive) {
                return PopupMenuButton<DialogueScenarioInfo>(
                  icon: const Icon(Icons.swap_horiz_rounded),
                  tooltip: 'Выбрать сценарий',
                  onSelected: (sc) {
                    context.read<ConversationCubit>().loadScenario(sc);
                  },
                  itemBuilder: (context) {
                    return state.scenarios.map((sc) {
                      return PopupMenuItem(
                        value: sc,
                        child: Row(
                          children: [
                            Text(sc.dialect == 'pt_br' ? '🇧🇷' : '🇵🇹'),
                            const SizedBox(width: 8),
                            Expanded(child: Text(sc.title)),
                          ],
                        ),
                      );
                    }).toList();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            tooltip: 'Перезапустить диалог',
            icon: const Icon(Icons.restart_alt_rounded),
            onPressed: () {
              final s = context.read<ConversationCubit>().state;
              if (s is ConversationActive) {
                context.read<ConversationCubit>().loadScenario(s.activeScenario);
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<ConversationCubit, ConversationState>(
        listener: (context, state) {
          if (state is ConversationActive) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          if (state is ConversationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ConversationError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: theme.colorScheme.error)),
            );
          }

          if (state is ConversationActive) {
            final activeScenario = state.activeScenario;

            return Column(
              children: [
                // Scenario Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          activeScenario.dialect == 'pt_br' ? 'PT-BR 🇧🇷' : 'PT-PT 🇵🇹',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          activeScenario.title,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // Chat Messages List
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: state.history.length,
                    itemBuilder: (context, index) {
                      final item = state.history[index];
                      return _buildMessageBubble(item, theme);
                    },
                  ),
                ),

                // Options / Scenario Completion
                if (state.isFinished)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: theme.colorScheme.surfaceContainer,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'Сценарий успешно завершен!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () {
                            context.read<ConversationCubit>().loadScenario(activeScenario);
                          },
                          icon: const Icon(Icons.replay_rounded),
                          label: const Text('Пройти заново'),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ваш ответ:',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...state.currentNode.options.map((opt) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                alignment: Alignment.centerLeft,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => context.read<ConversationCubit>().selectOption(opt),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    opt.textPortuguese,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    opt.textRussian,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  if (opt.notes != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      '💡 ${opt.notes}',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.amber.shade800,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
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

  Widget _buildMessageBubble(DialogueMessageItem item, ThemeData theme) {
    return Align(
      alignment: item.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isUser ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(item.isUser ? 16 : 4),
            bottomRight: Radius.circular(item.isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.isUser ? Icons.person_rounded : Icons.record_voice_over_rounded,
                  size: 14,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  item.speaker,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.textPortuguese,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              item.textRussian,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => context.read<ConversationCubit>().playMessageAudio(item),
                ),
                IconButton(
                  icon: const Icon(Icons.mic_none_rounded, size: 20),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Тренировать произношение',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => PronunciationPracticeSheet(
                        targetText: item.textPortuguese,
                        russianTranslation: item.textRussian,
                        audioService: context.read<HybridAudioPlaybackService>(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
