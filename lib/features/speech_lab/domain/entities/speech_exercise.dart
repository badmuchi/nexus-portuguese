import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SpeechCategory {
  nasalVowels(
    labelRu: 'Носовые гласные (-ão, -ãe)',
    labelPt: 'Sons Nasais',
    icon: Icons.waves_rounded,
    badgeColor: Color(0xFF006C50),
  ),
  openClosed(
    labelRu: 'Открытые/закрытые (é/ê)',
    labelPt: 'Vogais Abertas/Fechadas',
    icon: Icons.record_voice_over_rounded,
    badgeColor: Color(0xFFD49B0E),
  ),
  consonants(
    labelRu: 'Согласные (r/rr, x, ç)',
    labelPt: 'Consoantes Difíceis',
    icon: Icons.tune_rounded,
    badgeColor: Color(0xFF1976D2),
  ),
  tongueTwisters(
    labelRu: 'Скороговорки',
    labelPt: 'Trava-línguas',
    icon: Icons.flash_on_rounded,
    badgeColor: Color(0xFFD81B60),
  ),
  dialogueLines(
    labelRu: 'Живые реплики',
    labelPt: 'Frases do Dia a Dia',
    icon: Icons.forum_rounded,
    badgeColor: Color(0xFF7B1FA2),
  ),
  dialectContrasts(
    labelRu: 'Контраст BR vs PT',
    labelPt: 'Sotaques BR vs PT',
    icon: Icons.compare_arrows_rounded,
    badgeColor: Color(0xFFE65100),
  );

  final String labelRu;
  final String labelPt;
  final IconData icon;
  final Color badgeColor;

  const SpeechCategory({
    required this.labelRu,
    required this.labelPt,
    required this.icon,
    required this.badgeColor,
  });
}

class SpeechExercise extends Equatable {
  final String id;
  final SpeechCategory category;
  final String targetPortuguese;
  final String russianTranslation;
  final String phoneticTip;
  final String dialect; // 'pt_br', 'pt_pt', 'all'
  final String difficulty; // 'iniciante', 'intermediario', 'avancado'

  const SpeechExercise({
    required this.id,
    required this.category,
    required this.targetPortuguese,
    required this.russianTranslation,
    required this.phoneticTip,
    this.dialect = 'all',
    this.difficulty = 'iniciante',
  });

  @override
  List<Object?> get props => [
        id,
        category,
        targetPortuguese,
        russianTranslation,
        phoneticTip,
        dialect,
        difficulty,
      ];
}
