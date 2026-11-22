import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../cubit/chat_conversation_cubit.dart';
import '../cubit/chat_conversation_state.dart';
import '../widgets/abbreviation_detail_sheet.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_choice_panel.dart';
import '../widgets/chat_typing_indicator.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();

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
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatConversationCubit, ChatConversationState>(
      listener: (context, state) {
        _scrollToBottom();

        if (state.selectedAbbreviation != null) {
          final cubit = context.read<ChatConversationCubit>();
          final abbr = state.selectedAbbreviation!;
          cubit.clearAbbreviation();
          AbbreviationDetailSheet.show(context, abbr);
        }
      },
      builder: (context, state) {
        final cubit = context.read<ChatConversationCubit>();
        final scenario = state.scenario;
        final audioService = context.read<HybridAudioPlaybackService>();

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    scenario.avatarEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scenario.contactName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        state.isTyping ? 'digitando...' : '${scenario.dialectFlag} ${scenario.channelName}',
                        style: TextStyle(
                          fontSize: 11,
                          color: state.isTyping
                              ? Colors.green.shade700
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: state.isTyping ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  state.showTranslation ? Icons.translate_rounded : Icons.g_translate_outlined,
                  color: state.showTranslation ? Theme.of(context).colorScheme.primary : null,
                ),
                tooltip: 'Показать перевод',
                onPressed: cubit.toggleTranslation,
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Начать сначала',
                onPressed: cubit.restartScenario,
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  itemCount: state.messages.length + (state.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.messages.length && state.isTyping) {
                      return ChatTypingIndicator(contactName: scenario.contactName);
                    }

                    final message = state.messages[index];
                    final isPlayingThisVoice =
                        state.isPlayingVoiceNote && state.playingVoiceMessageId == message.id;

                    return ChatBubble(
                      message: message,
                      showTranslation: state.showTranslation,
                      isPlayingVoiceNote: isPlayingThisVoice,
                      onPlayVoiceNote: () => cubit.playVoiceNote(message),
                      onStopVoiceNote: cubit.stopVoiceNote,
                      onPlayTts: () {
                        final dialect = scenario.isPtPt
                            ? PortugueseDialect.european
                            : PortugueseDialect.brazilian;
                        audioService.playAudioOrSpeak(
                          fallbackText: message.textPt,
                          dialect: dialect,
                        );
                      },
                      onTapAbbreviation: cubit.showAbbreviation,
                    );
                  },
                ),
              ),
              ChatChoicePanel(
                choices: state.currentChoices,
                lastFeedbackNote: state.lastFeedbackNote,
                isCompleted: state.isCompleted,
                concludingNote: state.concludingNote,
                score: state.score,
                totalChoicesMade: state.totalChoicesMade,
                onSelectChoice: cubit.selectChoice,
                onDismissFeedback: cubit.dismissFeedback,
                onRestart: cubit.restartScenario,
                onFinish: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
