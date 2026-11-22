import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/speech/speech_recognition_service.dart';
import 'package:nexus_portuguese_app/features/morphology/presentation/widgets/sentence_xray_sheet.dart';
import '../../domain/entities/podcast_track_entity.dart';
import '../../domain/repositories/auditorio_repository.dart';
import '../cubit/podcast_player_cubit.dart';
import '../cubit/podcast_player_state.dart';
import '../widgets/audio_controls_bar.dart';
import '../widgets/shadowing_recorder_sheet.dart';
import '../widgets/transcript_snippet_tile.dart';

class PodcastPlayerScreen extends StatelessWidget {
  final PodcastTrack track;

  const PodcastPlayerScreen({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context) {
    final repository = context.read<AuditorioRepository>();
    final audio = context.read<HybridAudioPlaybackService>();
    final speech = context.read<SpeechRecognitionService>();

    return BlocProvider<PodcastPlayerCubit>(
      create: (_) => PodcastPlayerCubit(
        track: track,
        repository: repository,
        audioService: audio,
        speechService: speech,
      ),
      child: const _PodcastPlayerView(),
    );
  }
}

class _PodcastPlayerView extends StatefulWidget {
  const _PodcastPlayerView();

  @override
  State<_PodcastPlayerView> createState() => _PodcastPlayerViewState();
}

class _PodcastPlayerViewState extends State<_PodcastPlayerView> {
  final _scrollController = ScrollController();

  void _scrollToSnippet(int index) {
    if (!_scrollController.hasClients) return;
    final targetOffset = (index * 170.0).clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<PodcastPlayerCubit, PodcastPlayerState>(
      listenWhen: (prev, curr) => prev.currentSnippetIndex != curr.currentSnippetIndex,
      listener: (context, state) {
        _scrollToSnippet(state.currentSnippetIndex);
      },
      builder: (context, state) {
        final cubit = context.read<PodcastPlayerCubit>();
        final track = state.track;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.titlePt,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${track.dialectFlag} ${track.dialectLabel} • CEFR ${track.cefrLevel}',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: LinearProgressIndicator(
                value: state.overallProgress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          body: Column(
            children: [
              _TrackHeroBanner(track: track, theme: theme),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: track.transcript.length,
                  itemBuilder: (context, index) {
                    final snippet = track.transcript[index];
                    final isCurrent = index == state.currentSnippetIndex;
                    final isCompleted = state.completedSnippetIndices.contains(index);

                    return TranscriptSnippetTile(
                      snippet: snippet,
                      isCurrent: isCurrent,
                      isCompleted: isCompleted,
                      showTranslation: state.showTranslation,
                      onPlaySnippet: () => cubit.seekToSnippet(index),
                      onOpenShadowing: () {
                        ShadowingRecorderSheet.show(
                          context,
                          snippet: snippet,
                          isPtPt: track.isPtPt,
                        );
                      },
                      onOpenXRay: () {
                        SentenceXRaySheet.show(
                          context,
                          sentencePortuguese: snippet.textPt,
                          translationRussian: snippet.translationRu,
                        );
                      },
                    );
                  },
                ),
              ),
              if (state.isCompleted)
                _CompletionBanner(
                  onRestart: () => cubit.seekToSnippet(0),
                  theme: theme,
                ),
              AudioControlsBar(
                isPlaying: state.isPlaying,
                playbackSpeed: state.playbackSpeed,
                isLoopSnippet: state.isLoopSnippet,
                showTranslation: state.showTranslation,
                onTogglePlayPause: () => cubit.togglePlayPause(),
                onPreviousSnippet: () => cubit.previousSnippet(),
                onNextSnippet: () => cubit.nextSnippet(),
                onSpeedChanged: (speed) => cubit.setPlaybackSpeed(speed),
                onToggleLoop: () => cubit.toggleLoopSnippet(),
                onToggleTranslation: () => cubit.toggleTranslation(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TrackHeroBanner extends StatelessWidget {
  final PodcastTrack track;
  final ThemeData theme;

  const _TrackHeroBanner({
    required this.track,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(track.primaryColorHex).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(track.coverEmoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.titleRu,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Нажимайте на слова во фразе для перевода и добавления в FSRS',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontSize: 11,
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

class _CompletionBanner extends StatelessWidget {
  final VoidCallback onRestart;
  final ThemeData theme;

  const _CompletionBanner({
    required this.onRestart,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade600),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Parabéns! Подкаст полностью прослушан!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  'Прогресс сохранен в Centro de Conquistas',
                  style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onRestart,
            child: const Text('Сначала'),
          ),
        ],
      ),
    );
  }
}
