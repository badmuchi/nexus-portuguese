import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/gastronomy_repository.dart';
import '../cubit/recipe_cook_cubit.dart';
import '../cubit/recipe_cook_state.dart';
import '../widgets/recipe_step_view.dart';

class RecipeCookingScreen extends StatelessWidget {
  final RecipeEntity recipe;

  const RecipeCookingScreen({super.key, required this.recipe});

  static Route<void> route({required RecipeEntity recipe}) {
    return MaterialPageRoute(
      builder: (_) => RecipeCookingScreen(recipe: recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => RecipeCookCubit(
        recipe: recipe,
        repository: ctx.read<GastronomyRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.titlePt,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${recipe.region} • ${recipe.servings} порций',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: recipe.isPtPt
                    ? Colors.red.withValues(alpha: 0.15)
                    : Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                recipe.isPtPt ? '🇵🇹 PT-PT' : '🇧🇷 PT-BR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: recipe.isPtPt ? Colors.red.shade700 : Colors.green.shade700,
                ),
              ),
            ),
            BlocBuilder<RecipeCookCubit, RecipeCookState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Начать сначала',
                  onPressed: () => context.read<RecipeCookCubit>().restartCooking(),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<RecipeCookCubit, RecipeCookState>(
          builder: (context, state) {
            if (state.isRecipeCompleted) {
              return _buildCompletionView(context, state);
            }

            final progress = (state.currentStepIndex + 1) / state.recipe.steps.length;

            return Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                Expanded(
                  child: RecipeStepView(
                    step: state.currentStep,
                    stepNumber: state.currentStepIndex + 1,
                    totalSteps: state.recipe.steps.length,
                    isTimerRunning: state.isTimerRunning,
                    remainingTimerSeconds: state.remainingTimerSeconds,
                    isTimerFinished: state.isTimerFinished,
                    onPlayAudio: () => context.read<RecipeCookCubit>().playStepAudio(),
                    onStartTimer: () => context.read<RecipeCookCubit>().startTimer(),
                    onPauseTimer: () => context.read<RecipeCookCubit>().pauseTimer(),
                    onResetTimer: () => context.read<RecipeCookCubit>().resetTimer(),
                    onNext: () => context.read<RecipeCookCubit>().nextStep(),
                    onPrevious: state.currentStepIndex > 0
                        ? () => context.read<RecipeCookCubit>().previousStep()
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompletionView(BuildContext context, RecipeCookState state) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              state.recipe.iconEmoji,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 72),
            ),
            const SizedBox(height: 16),
            Text(
              'Parabéns, Chef! 🎉',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Вы приготовили ${state.recipe.titlePt} (${state.recipe.titleRu})!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🌟 ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Секрет шефа',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.recipe.secretTipRu,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<RecipeCookCubit>().restartCooking(),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Приготовить ещё раз',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text(
                'Вернуться в меню рецептов',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
