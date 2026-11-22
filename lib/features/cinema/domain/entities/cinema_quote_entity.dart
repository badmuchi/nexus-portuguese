import 'package:equatable/equatable.dart';

/// Легендарная цитата из фильма/сериала, ставшая крылатой фразой в народе.
class CinemaQuoteEntity extends Equatable {
  final String id;
  final String quotePt;
  final String translationRu;
  final String character;
  final String movieTitle;
  final int releaseYear;
  final String dialect; // 'pt_BR', 'pt_PT'
  final String popCultureImpactRu;

  const CinemaQuoteEntity({
    required this.id,
    required this.quotePt,
    required this.translationRu,
    required this.character,
    required this.movieTitle,
    required this.releaseYear,
    required this.dialect,
    required this.popCultureImpactRu,
  });

  bool get isPtPt =>
      dialect.toLowerCase().contains('pt_pt') ||
      dialect.toLowerCase().contains('pt-pt') ||
      dialect.toLowerCase() == 'pt';

  bool get isPtBr =>
      dialect.toLowerCase().contains('pt_br') ||
      dialect.toLowerCase().contains('pt-br') ||
      dialect.toLowerCase() == 'br';

  String get dialectFlag => isPtPt ? '🇵🇹' : '🇧🇷';
  String get dialectLabel => isPtPt ? 'Portugal' : 'Brasil';

  @override
  List<Object?> get props => [
        id,
        quotePt,
        translationRu,
        character,
        movieTitle,
        releaseYear,
        dialect,
        popCultureImpactRu,
      ];
}
