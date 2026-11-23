import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import '../../domain/entities/radio_novela_entities.dart';
import '../../domain/repositories/radio_novela_repository.dart';
import '../cubit/radio_player_cubit.dart';
import '../cubit/radio_player_state.dart';
import '../widgets/drama_line_bubble.dart';

class RadioPlayerScreen extends StatelessWidget {
  final AudioDramaEntity drama;

  const RadioPlayerScreen({
    super.key,
    required this.drama,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RadioPlayerCubit(
        drama: drama,
        repository: context.read<RadioNovelaRepository>(),
        audioService: context.read<HybridAudioPlaybackService>(),
        srsRepository: context.read<SrsRepository>(),
      ),
      child: const _RadioPlayerView(),
    );
  }
}

class _RadioPlayerView extends StatelessWidget {
  const _RadioPlayerView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
      builder: (context, state) {
        final drama = state.drama;
        final scene = state.currentScene;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drama.titlePt,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${drama.setting} • ${drama.dialectFlag} ${drama.dialectLabel}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            actions: [
              PopupMenuButton<double>(
                icon: const Icon(Icons.speed_rounded),
                tooltip: 'Скорость речи',
                onSelected: (rate) =>
                    context.read<RadioPlayerCubit>().setSpeechRate(rate),
                itemBuilder: (ctx) => [
                  CheckedPopupMenuItem(
                    value: 0.85,
                    checked: state.speechRate == 0.85,
                    child: const Text('0.85x Медленно'),
                  ),
                  CheckedPopupMenuItem(
                    value: 1.0,
                    checked: state.speechRate == 1.0,
                    child: const Text('1.0x Нормально'),
                  ),
                  CheckedPopupMenuItem(
                    value: 1.15,
                    checked: state.speechRate == 1.15,
                    child: const Text('1.15x Быстро'),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (val) {
                  final cubit = context.read<RadioPlayerCubit>();
                  if (val == 'translation') cubit.toggleTranslation();
                  if (val == 'stage_direction') cubit.toggleStageDirection();
                  if (val == 'autoplay') cubit.toggleAutoPlay();
                },
                itemBuilder: (ctx) => [
                  CheckedPopupMenuItem(
                    value: 'translation',
                    checked: state.showTranslation,
                    child: const Text('Показывать перевод'),
                  ),
                  CheckedPopupMenuItem(
                    value: 'stage_direction',
                    checked: state.showStageDirection,
                    child: const Text('Театральные ремарки'),
                  ),
                  CheckedPopupMenuItem(
                    value: 'autoplay',
                    checked: state.isAutoPlay,
                    child: const Text('Автовоспроизведение'),
                  ),
                ],
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(6),
              child: LinearProgressIndicator(
                value: state.progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 12, bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Radio tuning soundboard banner
                _buildRadioSoundboard(context, state),
                const SizedBox(height: 12),

                // Scene Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Сцена ${scene.sceneNumber}: ${scene.sceneTitlePt}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${state.currentLineIndex + 1}/${scene.lines.length}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            scene.atmosphericNoteRu,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Lines list
                ...List.generate(scene.lines.length, (idx) {
                  final line = scene.lines[idx];
                  final isCurrent = idx == state.currentLineIndex;
                  final char = drama.characters.firstWhere(
                    (c) => c.id == line.characterId,
                    orElse: () => DramaCharacterEntity(
                      id: line.characterId,
                      namePt: line.characterName,
                      roleRu: '',
                      voiceEmoji: '🎙️',
                      accentNoteRu: '',
                    ),
                  );

                  return DramaLineBubble(
                    line: line,
                    character: char,
                    isCurrent: isCurrent,
                    showTranslation: state.showTranslation,
                    showStageDirection: state.showStageDirection,
                    onPlayAudio: () {
                      context.read<RadioPlayerCubit>().playCurrentLine();
                    },
                    onAddToFsrs: () async {
                      final success =
                          await context.read<RadioPlayerCubit>().addToFsrs(line);
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Реплика «${line.textPt}» добавлена в FSRS! 📻',
                            ),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  );
                }),

                // Interactive Choice at climax
                if (scene.interactiveChoice != null) ...[
                  const SizedBox(height: 12),
                  _buildInteractiveChoiceCard(context, state, scene.interactiveChoice!),
                ],

                // Completion Card
                if (state.isCompleted) ...[
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Text('📻✨', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Спектакль завершён!',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              Text(
                                'Вы успешно прослушали спектакль «${drama.titlePt}». Практика аудирования зафиксирована.',
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
                ],
              ],
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: state.isFirstLine
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          context.read<RadioPlayerCubit>().previousLine();
                        },
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Назад'),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (state.isPlayingAudio) {
                      context.read<RadioPlayerCubit>().stopAudio();
                    } else {
                      context.read<RadioPlayerCubit>().playCurrentLine();
                    }
                  },
                  icon: Icon(
                    state.isPlayingAudio
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  tooltip: state.isPlayingAudio ? 'Пауза' : 'Слушать',
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.read<RadioPlayerCubit>().nextLine();
                    },
                    icon: Icon(
                      state.isEpisodeFinished
                          ? Icons.check_circle_rounded
                          : Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                    label: Text(
                      state.isEpisodeFinished
                          ? 'Завершить'
                          : (state.isLastLineInScene ? 'След. сцена' : 'Далее'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadioSoundboard(BuildContext context, RadioPlayerState state) {
    final drama = state.drama;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.radio_rounded, color: Colors.amber, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'RÁDIO TEATRO FM 98.4',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'ON AIR',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  drama.ambientSoundRu,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveChoiceCard(
    BuildContext context,
    RadioPlayerState state,
    DramaInteractiveChoice choice,
  ) {
    final theme = Theme.of(context);
    final isChosen = state.chosenOptionId == choice.id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.alt_route_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  choice.promptRu,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!isChosen)
            FilledButton.tonalIcon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.read<RadioPlayerCubit>().selectChoice(choice.id);
              },
              icon: const Icon(Icons.touch_app_rounded, size: 18),
              label: Text(choice.optionPt),
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Поворот сюжета:',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    choice.consequencePt,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    choice.consequenceRu,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
