import 'dart:math';
import 'package:equatable/equatable.dart';

class PortugueseBadge extends Equatable {
  final String id;
  final String titlePt;
  final String titleRu;
  final String descriptionRu;
  final String iconEmoji;
  final bool isUnlocked;
  final double progress;
  final String progressDisplay;

  const PortugueseBadge({
    required this.id,
    required this.titlePt,
    required this.titleRu,
    required this.descriptionRu,
    required this.iconEmoji,
    required this.isUnlocked,
    required this.progress,
    required this.progressDisplay,
  });

  static List<PortugueseBadge> evaluateAll({
    required int scenesCompletedCount,
    required double phoneticMasteryAvg,
    required String? cefrLevel,
    required double cefrScorePercentage,
    required int grammarLogsCount,
    required int reviewsCount,
    required int listeningLogsCount,
    required int dialoguesCount,
    required int currentStreak,
    required int maxStreak,
    required double fluencyScore,
  }) {
    final highestStreak = max(currentStreak, maxStreak);

    return [
      // 1. Elétrico 28
      PortugueseBadge(
        id: 'badge_eletrico',
        titlePt: 'Elétrico 28',
        titleRu: 'Лиссабонский трамвай',
        descriptionRu: 'Пройти хотя бы 2 живые сцены в Лиссабоне',
        iconEmoji: '🚊',
        isUnlocked: scenesCompletedCount >= 2,
        progress: (scenesCompletedCount / 2).clamp(0.0, 1.0),
        progressDisplay: '$scenesCompletedCount / 2 сцен',
      ),

      // 2. Garota de Ipanema
      PortugueseBadge(
        id: 'badge_ipanema',
        titlePt: 'Garota de Ipanema',
        titleRu: 'Пляжи Копакабаны',
        descriptionRu: 'Завершить 4 ситуации в сценах жизни',
        iconEmoji: '🌊',
        isUnlocked: scenesCompletedCount >= 4,
        progress: (scenesCompletedCount / 4).clamp(0.0, 1.0),
        progressDisplay: '$scenesCompletedCount / 4 сцен',
      ),

      // 3. Mestre do Til
      PortugueseBadge(
        id: 'badge_nasal',
        titlePt: 'Mestre do Til',
        titleRu: 'Повелитель носового ão',
        descriptionRu: 'Достичь 75%+ мастерства в тренажёре носовых звуков',
        iconEmoji: '👃',
        isUnlocked: phoneticMasteryAvg >= 75.0,
        progress: (phoneticMasteryAvg / 75.0).clamp(0.0, 1.0),
        progressDisplay: '${phoneticMasteryAvg.round()}% / 75%',
      ),

      // 4. Relâmpago dos Verbos
      PortugueseBadge(
        id: 'badge_sprint',
        titlePt: 'Relâmpago dos Verbos',
        titleRu: 'Спринтер спряжений',
        descriptionRu: 'Выполнить 20+ грамматических спряжений в VerboSprint',
        iconEmoji: '⚡️',
        isUnlocked: grammarLogsCount >= 20,
        progress: (grammarLogsCount / 20).clamp(0.0, 1.0),
        progressDisplay: '$grammarLogsCount / 20 форм',
      ),

      // 5. Cirurgião da Crase
      PortugueseBadge(
        id: 'badge_crase',
        titlePt: 'Cirurgião da Crase',
        titleRu: 'Знаток слияний (Crase)',
        descriptionRu: '10 успешных ответов на слияния предлогов',
        iconEmoji: '🎯',
        isUnlocked: grammarLogsCount >= 10,
        progress: (grammarLogsCount / 10).clamp(0.0, 1.0),
        progressDisplay: '$grammarLogsCount / 10 ответов',
      ),

      // 6. Poliglota CEFR
      PortugueseBadge(
        id: 'badge_cefr',
        titlePt: 'Poliglota CEFR',
        titleRu: 'Сертификат CEFR',
        descriptionRu: 'Пройти диагностику уровня CEFR',
        iconEmoji: '🏆',
        isUnlocked: cefrLevel != null,
        progress: cefrLevel != null ? 1.0 : 0.0,
        progressDisplay: cefrLevel != null ? 'Уровень $cefrLevel' : 'Не пройден',
      ),

      // 7. Três Dias Firmes
      PortugueseBadge(
        id: 'badge_streak_3',
        titlePt: 'Três Dias Firmes',
        titleRu: 'Ударный старт (3 дня)',
        descriptionRu: 'Поддерживать огонь обучения 3 дня подряд',
        iconEmoji: '🥉',
        isUnlocked: highestStreak >= 3,
        progress: (highestStreak / 3).clamp(0.0, 1.0),
        progressDisplay: '$highestStreak / 3 дней',
      ),

      // 8. Fogo Sagrado
      PortugueseBadge(
        id: 'badge_streak_7',
        titlePt: 'Fogo Sagrado',
        titleRu: 'Огонь познания (7 дней)',
        descriptionRu: 'Непрерывный недельный стрик занятий',
        iconEmoji: '🔥',
        isUnlocked: highestStreak >= 7,
        progress: (highestStreak / 7).clamp(0.0, 1.0),
        progressDisplay: '$highestStreak / 7 дней',
      ),

      // 9. Memória de Elefante
      PortugueseBadge(
        id: 'badge_fsrs_30',
        titlePt: 'Memória de Elefante',
        titleRu: 'Крепкая память FSRS',
        descriptionRu: 'Совершить 30+ интервальных повторений карточек',
        iconEmoji: '🧠',
        isUnlocked: reviewsCount >= 30,
        progress: (reviewsCount / 30).clamp(0.0, 1.0),
        progressDisplay: '$reviewsCount / 30 повторов',
      ),

      // 10. Ouvido de Ouro
      PortugueseBadge(
        id: 'badge_listening',
        titlePt: 'Ouvido de Ouro',
        titleRu: 'Золотой слух',
        descriptionRu: 'Выполнить 10 упражнений аудирования',
        iconEmoji: '🎧',
        isUnlocked: listeningLogsCount >= 10,
        progress: (listeningLogsCount / 10).clamp(0.0, 1.0),
        progressDisplay: '$listeningLogsCount / 10 диктантов',
      ),

      // 11. Tagarela em Lisboa
      PortugueseBadge(
        id: 'badge_dialogues',
        titlePt: 'Tagarela em Lisboa',
        titleRu: 'Собеседник в кафе',
        descriptionRu: 'Выбрать 10 реплик в интерактивных диалогах',
        iconEmoji: '🗣',
        isUnlocked: dialoguesCount >= 10,
        progress: (dialoguesCount / 10).clamp(0.0, 1.0),
        progressDisplay: '$dialoguesCount / 10 реплик',
      ),

      // 12. Carioca Adotivo
      PortugueseBadge(
        id: 'badge_fluency_50',
        titlePt: 'Carioca Adotivo',
        titleRu: 'Почти местный (50% Fluência)',
        descriptionRu: 'Достичь общего индекса беглости 50%+',
        iconEmoji: '🇧🇷',
        isUnlocked: fluencyScore >= 50.0,
        progress: (fluencyScore / 50.0).clamp(0.0, 1.0),
        progressDisplay: '${fluencyScore.round()}% / 50%',
      ),
    ];
  }

  @override
  List<Object?> get props => [
        id,
        titlePt,
        titleRu,
        descriptionRu,
        iconEmoji,
        isUnlocked,
        progress,
        progressDisplay,
      ];
}
