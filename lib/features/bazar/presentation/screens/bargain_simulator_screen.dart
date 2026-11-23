import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/bazar_entities.dart';
import '../../domain/repositories/bazar_repository.dart';
import '../cubit/bargain_simulator_cubit.dart';
import '../cubit/bargain_simulator_state.dart';

class BargainSimulatorScreen extends StatelessWidget {
  final BargainScenarioEntity scenario;

  const BargainSimulatorScreen({
    super.key,
    required this.scenario,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => BargainSimulatorCubit(
        scenario: scenario,
        repository: ctx.read<BazarRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: const _BargainSimulatorView(),
    );
  }
}

class _BargainSimulatorView extends StatelessWidget {
  const _BargainSimulatorView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<BargainSimulatorCubit, BargainSimulatorState>(
      builder: (context, state) {
        final cubit = context.read<BargainSimulatorCubit>();
        final scenario = state.scenario;
        final step = state.currentStep;

        final totalDiscount = scenario.initialPrice - state.currentPrice;
        final savingsPercent =
            ((totalDiscount / scenario.initialPrice) * 100).clamp(0, 100).round();

        return Scaffold(
          appBar: AppBar(
            title: Text('Торг: ${scenario.itemNamePt}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Начать сначала',
                onPressed: () => cubit.restart(),
              ),
            ],
          ),
          body: Directionality(
            textDirection: TextDirection.ltr,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Product & Vendor Card
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            scenario.itemEmoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${scenario.itemNamePt} (${scenario.itemNameRu})',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${scenario.marketName} • Продавец ${scenario.vendorName}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Price progress meter
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Начальная цена',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '${scenario.currencySymbol}${scenario.initialPrice.toStringAsFixed(2)}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: colorScheme.error,
                                  decoration: state.currentPrice < scenario.initialPrice
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Текущая цена',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '${scenario.currencySymbol}${state.currentPrice.toStringAsFixed(2)}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Честная цель',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '${scenario.currencySymbol}${scenario.targetFairPrice.toStringAsFixed(2)}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: (state.currentStepIndex + (state.hasOfferedCurrent ? 1 : 0)) /
                            scenario.steps.length,
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Раунд ${state.currentStepIndex + 1} из ${scenario.steps.length}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (savingsPercent > 0)
                            Text(
                              'Скидка: -$savingsPercent%',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Success celebration banner
                if (state.isSuccess) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.green.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('🤝', style: TextStyle(fontSize: 36)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Сделка заключена! Parabéns!',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Вы успешно сторговались до ${scenario.currencySymbol}${state.currentPrice.toStringAsFixed(2)} и сэкономили ${scenario.currencySymbol}${totalDiscount.toStringAsFixed(2)} (-$savingsPercent%)!',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Buyer Dialogue Box
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Тактика покупателя',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => cubit.playBuyerAudio(),
                              icon: Icon(
                                state.isPlayingAudio
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_down_rounded,
                                color: colorScheme.primary,
                              ),
                              tooltip: 'Прослушать произношение фразы',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          step.buyerTacticRu,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '«${step.buyerPhrasePt}»',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step.buyerPhraseRu,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (!state.hasOfferedCurrent)
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => cubit.applyTactic(),
                              icon: const Icon(Icons.arrow_downward_rounded),
                              label: Text(
                                'Предложить ${scenario.currencySymbol}${step.offeredPrice.toStringAsFixed(2)}',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Vendor Dialogue Response Box (shows after tactic applied)
                if (state.hasOfferedCurrent) ...[
                  Card(
                    elevation: 0,
                    color: colorScheme.secondaryContainer.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: colorScheme.secondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Ответ продавца (${scenario.vendorName})',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.secondary,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => cubit.playVendorAudio(),
                                icon: Icon(
                                  state.isPlayingAudio
                                      ? Icons.volume_up_rounded
                                      : Icons.volume_down_rounded,
                                  color: colorScheme.secondary,
                                ),
                                tooltip: 'Слушать ответ продавца',
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '«${step.vendorResponsePt}»',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step.vendorResponseRu,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!state.isLastStep)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: () => cubit.nextStep(),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Следующий раунд торга'),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.done_all_rounded),
                        label: const Text('Завершить торг и вернуться'),
                      ),
                    ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
