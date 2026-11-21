import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/level_quiz_question.dart';
import '../../domain/entities/level_quiz_result.dart';
import '../cubit/assessment_cubit.dart';
import '../cubit/assessment_state.dart';

class LevelCertificateCard extends StatelessWidget {
  final LevelQuizResult result;
  final VoidCallback onRetake;

  const LevelCertificateCard({
    super.key,
    required this.result,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssessmentCubit, AssessmentState>(
      builder: (context, state) {
        final isSavingToFsrs = state is AssessmentCompleted && state.isSavingToFsrs;
        final addedCount = state is AssessmentCompleted ? state.addedToFsrsCount : 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CertificateHeader(result: result),
              const SizedBox(height: 24),
              _SkillBreakdownSection(skillScores: result.skillScores),
              const SizedBox(height: 24),
              _RecommendationsSection(recommendations: result.recommendations),
              const SizedBox(height: 24),
              _MistakesFsrsSection(
                mistakes: result.mistakes,
                isSavingToFsrs: isSavingToFsrs,
                addedCount: addedCount,
                onSaveToFsrs: () {
                  context.read<AssessmentCubit>().saveMistakesToFsrs();
                },
              ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: onRetake,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Пересдать тест заново'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CertificateHeader extends StatelessWidget {
  final LevelQuizResult result;

  const _CertificateHeader({required this.result});

  Color _levelColor(CefrLevel level) {
    switch (level) {
      case CefrLevel.a1:
        return Colors.blue;
      case CefrLevel.a2:
        return Colors.teal;
      case CefrLevel.b1:
        return Colors.indigo;
      case CefrLevel.b2:
        return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _levelColor(result.level);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            theme.colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                result.level.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            result.levelTitleRu,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Точность ответов: ${result.scorePercentage.round()}% (${result.correctAnswers} из ${result.totalQuestions})',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            result.level.descriptionRu,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SkillBreakdownSection extends StatelessWidget {
  final Map<SkillFocus, double> skillScores;

  const _SkillBreakdownSection({required this.skillScores});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.radar_rounded, color: theme.colorScheme.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                'Профиль языковых навыков',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...skillScores.entries.map((entry) {
            final skill = entry.key;
            final score = entry.value;
            final percent = (score / 100.0).clamp(0.0, 1.0);

            final barColor = score >= 75
                ? Colors.green
                : (score >= 50 ? Colors.orange : Colors.redAccent);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        skill.titleRu,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${score.round()}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: barColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _RecommendationsSection extends StatelessWidget {
  final List<String> recommendations;

  const _RecommendationsSection({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: Colors.amber, size: 22),
              SizedBox(width: 8),
              Text(
                'Рекомендации для роста',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recommendations.map(
            (rec) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Expanded(
                    child: Text(
                      rec,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
                    ),
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

class _MistakesFsrsSection extends StatelessWidget {
  final List<LevelQuizQuestion> mistakes;
  final bool isSavingToFsrs;
  final int addedCount;
  final VoidCallback onSaveToFsrs;

  const _MistakesFsrsSection({
    required this.mistakes,
    required this.isSavingToFsrs,
    required this.addedCount,
    required this.onSaveToFsrs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (mistakes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ни одной ошибки! Превосходный результат теста.',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ошибок в тесте: ${mistakes.length}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Хотите закрепить сложные конструкции? Добавьте их в умные интервальные повторения FSRS в один клик.',
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: (isSavingToFsrs || addedCount > 0) ? null : onSaveToFsrs,
                icon: isSavingToFsrs
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(addedCount > 0 ? Icons.check_circle_rounded : Icons.add_card_rounded),
                label: Text(
                  addedCount > 0
                      ? 'Добавлено в FSRS ($addedCount)'
                      : 'Добавить ${mistakes.length} ошибок в FSRS',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Разбор ошибок:',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...mistakes.map((m) => _MistakeCard(mistake: m)),
      ],
    );
  }
}

class _MistakeCard extends StatelessWidget {
  final LevelQuizQuestion mistake;

  const _MistakeCard({required this.mistake});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final correctAnswer = mistake.options[mistake.correctOptionIndex];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  mistake.skill.titleRu,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                mistake.level.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mistake.prompt,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodySmall,
                      children: [
                        const TextSpan(
                          text: 'Правильно: ',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        TextSpan(
                          text: correctAnswer,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' — ${mistake.explanationRu}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
