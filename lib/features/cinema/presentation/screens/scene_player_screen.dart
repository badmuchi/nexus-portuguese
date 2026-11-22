import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/movie_scene_entity.dart';
import '../../domain/repositories/cinema_repository.dart';
import '../cubit/scene_player_cubit.dart';
import '../cubit/scene_player_state.dart';
import '../widgets/cinema_dialogue_bubble.dart';
import '../widgets/scene_playback_controls.dart';

class ScenePlayerScreen extends StatefulWidget {
  final MovieSceneEntity scene;

  const ScenePlayerScreen({super.key, required this.scene});

  static Route<void> route({required MovieSceneEntity scene}) {
    return MaterialPageRoute(
      builder: (_) => ScenePlayerScreen(scene: scene),
    );
  }

  @override
  State<ScenePlayerScreen> createState() => _ScenePlayerScreenState();
}

class _ScenePlayerScreenState extends State<ScenePlayerScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToCurrentLine(int index) {
    if (_scrollController.hasClients) {
      final target = (index * 130.0).clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showSceneInfo(BuildContext context) {
    final theme = Theme.of(context);
    final scene = widget.scene;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scroll) => SingleChildScrollView(
          controller: scroll,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(scene.iconEmoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${scene.movieTitlePt} (${scene.releaseYear})',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${scene.dialectFlag} ${scene.region} • ${scene.genre}',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                'Контекст сцены',
                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(scene.sceneContextRu, style: theme.textTheme.bodyMedium?.copyWith(height: 1.35)),
              const SizedBox(height: 16),
              Text(
                'Культурный подтекст и сленг',
                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...scene.culturalKeytakeawaysRu.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🎬 ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text(
                          item,
                          style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ScenePlayerCubit(
        scene: widget.scene,
        repository: ctx.read<CinemaRepository>(),
        audioService: ctx.read<HybridAudioPlaybackService>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.scene.movieTitlePt,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.scene.movieTitleRu} (${widget.scene.releaseYear})',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              tooltip: 'О сцене и контексте',
              onPressed: () => _showSceneInfo(context),
            ),
            BlocBuilder<ScenePlayerCubit, ScenePlayerState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Начать сначала',
                  onPressed: () => context.read<ScenePlayerCubit>().restart(),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<ScenePlayerCubit, ScenePlayerState>(
          listener: (context, state) {
            _scrollToCurrentLine(state.currentLineIndex);
          },
          builder: (context, state) {
            if (state.isSceneCompleted) {
              return _buildCompletionView(context, state);
            }

            return Column(
              children: [
                LinearProgressIndicator(
                  value: state.progress,
                  minHeight: 4,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: widget.scene.dialogueLines.length,
                    itemBuilder: (context, index) {
                      final line = widget.scene.dialogueLines[index];
                      final isSelected = index == state.currentLineIndex;

                      return CinemaDialogueBubble(
                        line: line,
                        lineNumber: index + 1,
                        totalLines: widget.scene.dialogueLines.length,
                        isSelected: isSelected,
                        isPlaying: isSelected && state.isPlaying,
                        isDubbingMode: state.isDubbingMode,
                        dialect: widget.scene.dialect,
                        movieTitle: widget.scene.movieTitlePt,
                        onPlayAudio: () {
                          context.read<ScenePlayerCubit>().selectLine(index);
                          context.read<ScenePlayerCubit>().playCurrentLineAudio();
                        },
                        onTap: () {
                          context.read<ScenePlayerCubit>().selectLine(index);
                        },
                      );
                    },
                  ),
                ),
                ScenePlaybackControls(
                  isPlaying: state.isPlaying,
                  isAutoPlay: state.isAutoPlay,
                  isDubbingMode: state.isDubbingMode,
                  isFirstLine: state.currentLineIndex == 0,
                  isLastLine: state.isLastLine,
                  onPlayLine: () => context.read<ScenePlayerCubit>().playCurrentLineAudio(),
                  onNextLine: () => context.read<ScenePlayerCubit>().nextLine(),
                  onPreviousLine: state.currentLineIndex > 0
                      ? () => context.read<ScenePlayerCubit>().previousLine()
                      : null,
                  onToggleAutoPlay: () => context.read<ScenePlayerCubit>().toggleAutoPlay(),
                  onToggleDubbing: () => context.read<ScenePlayerCubit>().toggleDubbingMode(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompletionView(BuildContext context, ScenePlayerState state) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              state.scene.iconEmoji,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'Cena Concluída! 🎬',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Вы полностью разобрали диалоги из «${state.scene.movieTitlePt}» (${state.scene.movieTitleRu})!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Главные культурные выводы сцены',
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...state.scene.culturalKeytakeawaysRu.map(
                    (takeaway) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• $takeaway',
                        style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<ScenePlayerCubit>().restart(),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Слушать сцену ещё раз',
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
                'Вернуться в синематеку',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
