import 'package:equatable/equatable.dart';

/// Элемент руководства по составлению резюме и пониманию трудовых режимов.
class CvGuideItemEntity extends Equatable {
  final String id;
  final String sectionTitlePt;
  final String sectionTitleRu;
  final String dialect; // 'pt_BR', 'pt_PT', 'all'
  final String iconEmoji;
  final String explanationRu;
  final String examplePt;
  final List<String> tipsListRu;

  const CvGuideItemEntity({
    required this.id,
    required this.sectionTitlePt,
    required this.sectionTitleRu,
    this.dialect = 'all',
    required this.iconEmoji,
    required this.explanationRu,
    required this.examplePt,
    this.tipsListRu = const [],
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : isPtBr ? '🇧🇷' : '🌐';

  @override
  List<Object?> get props => [
        id,
        sectionTitlePt,
        sectionTitleRu,
        dialect,
        iconEmoji,
        explanationRu,
        examplePt,
        tipsListRu,
      ];
}
