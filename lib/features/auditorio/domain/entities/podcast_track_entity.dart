import 'package:equatable/equatable.dart';
import 'transcript_snippet_entity.dart';

/// Сущность микро-подкаста в «Auditório».
class PodcastTrack extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final String descriptionPt;
  final String descriptionRu;
  final String dialect; // 'pt_BR' или 'pt_PT'
  final String cefrLevel; // 'A1', 'A2', 'B1', 'B2'
  final String category; // 'Cultura', 'Música', 'História', 'Culinária', 'Viagem', 'Tradição'
  final int durationSeconds;
  final String coverEmoji;
  final int primaryColorHex;
  final int accentColorHex;
  final String? audioAssetPath;
  final List<TranscriptSnippet> transcript;
  final bool isCompleted;

  const PodcastTrack({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.descriptionPt,
    required this.descriptionRu,
    required this.dialect,
    required this.cefrLevel,
    required this.category,
    required this.durationSeconds,
    required this.coverEmoji,
    required this.primaryColorHex,
    required this.accentColorHex,
    this.audioAssetPath,
    required this.transcript,
    this.isCompleted = false,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';
  bool get isPtBr => dialect.toLowerCase().contains('br');

  String get dialectLabel => isPtPt ? 'Portugal (PT-PT)' : 'Brasil (PT-BR)';
  String get dialectFlag => isPtPt ? '🇵🇹' : '🇧🇷';

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  PodcastTrack copyWith({
    String? id,
    String? titlePt,
    String? titleRu,
    String? descriptionPt,
    String? descriptionRu,
    String? dialect,
    String? cefrLevel,
    String? category,
    int? durationSeconds,
    String? coverEmoji,
    int? primaryColorHex,
    int? accentColorHex,
    String? audioAssetPath,
    List<TranscriptSnippet>? transcript,
    bool? isCompleted,
  }) {
    return PodcastTrack(
      id: id ?? this.id,
      titlePt: titlePt ?? this.titlePt,
      titleRu: titleRu ?? this.titleRu,
      descriptionPt: descriptionPt ?? this.descriptionPt,
      descriptionRu: descriptionRu ?? this.descriptionRu,
      dialect: dialect ?? this.dialect,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      category: category ?? this.category,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      coverEmoji: coverEmoji ?? this.coverEmoji,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      audioAssetPath: audioAssetPath ?? this.audioAssetPath,
      transcript: transcript ?? this.transcript,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titlePt,
        titleRu,
        descriptionPt,
        descriptionRu,
        dialect,
        cefrLevel,
        category,
        durationSeconds,
        coverEmoji,
        primaryColorHex,
        accentColorHex,
        audioAssetPath,
        transcript,
        isCompleted,
      ];
}
