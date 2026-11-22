import 'package:flutter/material.dart';
import '../../domain/entities/chat_abbreviation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final bool showTranslation;
  final bool isPlayingVoiceNote;
  final VoidCallback onPlayVoiceNote;
  final VoidCallback onStopVoiceNote;
  final VoidCallback onPlayTts;
  final ValueChanged<ChatAbbreviation> onTapAbbreviation;

  const ChatBubble({
    super.key,
    required this.message,
    required this.showTranslation,
    required this.isPlayingVoiceNote,
    required this.onPlayVoiceNote,
    required this.onStopVoiceNote,
    required this.onPlayTts,
    required this.onTapAbbreviation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser && message.senderName.isNotEmpty) ...[
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (message.isVoiceNote)
                    _VoiceNoteBubbleContent(
                      message: message,
                      isPlaying: isPlayingVoiceNote,
                      onTogglePlay: isPlayingVoiceNote ? onStopVoiceNote : onPlayVoiceNote,
                      theme: theme,
                    )
                  else ...[
                    Text(
                      message.textPt,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        height: 1.3,
                        color: isUser
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    if (showTranslation && message.translationRu.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        message.translationRu,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: isUser
                              ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                              : theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                  if (message.abbreviations.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: message.abbreviations.map((abbr) {
                        return InkWell(
                          onTap: () => onTapAbbreviation(abbr),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? theme.colorScheme.surface.withValues(alpha: 0.6)
                                  : theme.colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isUser
                                    ? theme.colorScheme.primary.withValues(alpha: 0.3)
                                    : theme.colorScheme.primary.withValues(alpha: 0.4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('💡 ', style: TextStyle(fontSize: 10)),
                                Text(
                                  '${abbr.shortForm} = ${abbr.fullWordPt}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!message.isVoiceNote)
                        GestureDetector(
                          onTap: onPlayTts,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.volume_up_rounded,
                              size: 14,
                              color: isUser
                                  ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6)
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      Text(
                        message.timestampStr,
                        style: TextStyle(
                          fontSize: 10,
                          color: isUser
                              ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6)
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all_rounded,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VoiceNoteBubbleContent extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isPlaying;
  final VoidCallback onTogglePlay;
  final ThemeData theme;

  const _VoiceNoteBubbleContent({
    required this.message,
    required this.isPlaying,
    required this.onTogglePlay,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filled(
              onPressed: onTogglePlay,
              icon: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 22,
              ),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.zero,
                minimumSize: const Size(36, 36),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(14, (index) {
                      final heights = [10, 16, 8, 22, 14, 18, 24, 12, 20, 15, 8, 18, 12, 14];
                      final barHeight = heights[index % heights.length].toDouble();
                      final isPast = isPlaying && index < 7;

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: isPast
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0:${message.voiceDurationSeconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Text(
                        '🎙️ Áudio',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          message.textPt,
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (message.translationRu.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            message.translationRu,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}
