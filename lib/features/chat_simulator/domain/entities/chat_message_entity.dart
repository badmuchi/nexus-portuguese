import 'package:equatable/equatable.dart';
import 'chat_abbreviation_entity.dart';

/// Сущность сообщения в симуляторе переписки (WhatsApp / iMessage).
class ChatMessageEntity extends Equatable {
  final String id;
  final String senderId; // 'contact', 'user', 'system'
  final String senderName;
  final String textPt;
  final String translationRu;
  final bool isUser;
  final String timestampStr;
  final bool isVoiceNote;
  final int voiceDurationSeconds;
  final List<ChatAbbreviation> abbreviations;

  const ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.textPt,
    required this.translationRu,
    required this.isUser,
    required this.timestampStr,
    this.isVoiceNote = false,
    this.voiceDurationSeconds = 0,
    this.abbreviations = const [],
  });

  ChatMessageEntity copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? textPt,
    String? translationRu,
    bool? isUser,
    String? timestampStr,
    bool? isVoiceNote,
    int? voiceDurationSeconds,
    List<ChatAbbreviation>? abbreviations,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      textPt: textPt ?? this.textPt,
      translationRu: translationRu ?? this.translationRu,
      isUser: isUser ?? this.isUser,
      timestampStr: timestampStr ?? this.timestampStr,
      isVoiceNote: isVoiceNote ?? this.isVoiceNote,
      voiceDurationSeconds: voiceDurationSeconds ?? this.voiceDurationSeconds,
      abbreviations: abbreviations ?? this.abbreviations,
    );
  }

  @override
  List<Object?> get props => [
        id,
        senderId,
        senderName,
        textPt,
        translationRu,
        isUser,
        timestampStr,
        isVoiceNote,
        voiceDurationSeconds,
        abbreviations,
      ];
}
