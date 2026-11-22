import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/portuguese_song_entity.dart';
import '../../domain/entities/song_lyric_line_entity.dart';
import '../cubit/song_player_cubit.dart';
import '../cubit/song_player_state.dart';
import '../widgets/karaoke_lyric_tile.dart';
import '../widgets/music_controls_bar.dart';
import '../widgets/song_quiz_tile.dart';

class SongPlayerScreen extends StatefulWidget {
  const SongPlayerScreen({super.key});

  @override
  State<SongPlayerScreen> createState() => _SongPlayerScreenState();
}

class _SongPlayerScreenState extends State<SongPlayerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _vinylAnimController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _vinylAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
  }

  @override
  void dispose() {
    _vinylAnimController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToActiveLine(int index) {
    if (!_scrollController.hasClients) return;
    // Each lyric tile is roughly 90-120px tall
    final targetOffset = (index * 110.0).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _addLyricToSrs(
    BuildContext context,
    PortugueseSong song,
    SongLyricLine line,
  ) async {
    HapticFeedback.mediumImpact();
    try {
      final srsRepo = context.read<SrsRepository>();
      final card = SrsCardEntity(
        id: 'song_${song.id}_${line.id}_${DateTime.now().millisecondsSinceEpoch}',
        portuguese: line.textPt,
        russianTranslation: line.translationRu,
        partOfSpeech: 'frase',
        category: 'musica',
        dialect: song.dialect,
        examplePortuguese: line.textPt,
        exampleRussian: line.translationRu,
        notes: '${song.titlePt} (${song.artist})${line.poeticNoteRu != null ? " • ${line.poeticNoteRu}" : ""}',
        fsrsState: 'newCard',
        stability: 0.0,
        difficulty: 0.0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      );

      await srsRepo.addCard(card);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Строка песни добавлена в карточки FSRS! 🎵'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SongPlayerCubit, SongPlayerState>(
      listener: (context, state) {
        if (state.isPlaying) {
          if (!_vinylAnimController.isAnimating) {
            _vinylAnimController.repeat();
          }
        } else {
          _vinylAnimController.stop();
        }

        if (!state.isQuizMode) {
          _scrollToActiveLine(state.currentLineIndex);
        }

        if (state.isSongCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Партитура пройдена! Запись сохранена в прогресс 🎉'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SongPlayerCubit>();
        final song = state.song;
        final primaryColor = Color(song.primaryColorHex);
        final accentColor = Color(song.accentColorHex);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              song.titlePt,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Начать сначала',
                onPressed: () {
                  cubit.resetProgress();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              _SongHeaderCard(
                song: song,
                primaryColor: primaryColor,
                accentColor: accentColor,
                vinylController: _vinylAnimController,
                isPlaying: state.isPlaying,
                quizScore: state.isQuizMode ? state.quizScore : null,
              ),
              Expanded(
                child: state.isQuizMode
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            SongQuizTile(
                              line: state.currentLine,
                              selectedOption: state.selectedQuizOption,
                              isOptionCorrect: state.isOptionCorrect,
                              onSelectOption: (opt) {
                                HapticFeedback.mediumImpact();
                                cubit.selectQuizOption(opt);
                              },
                              onNextLine: () {
                                HapticFeedback.selectionClick();
                                cubit.nextLine();
                              },
                              primaryColor: primaryColor,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: OutlinedButton.icon(
                                onPressed: () => _addLyricToSrs(context, song, state.currentLine),
                                icon: const Icon(Icons.bookmark_add_outlined),
                                label: const Text('Добавить эту строку в FSRS'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(top: 8, bottom: 20),
                        itemCount: song.lyrics.length,
                        itemBuilder: (context, index) {
                          final line = song.lyrics[index];
                          final isActive = index == state.currentLineIndex;
                          final isCompleted = state.completedLineIndices.contains(index);

                          return KaraokeLyricTile(
                            line: line,
                            isActive: isActive,
                            isCompleted: isCompleted,
                            showTranslation: state.showTranslation,
                            primaryColor: primaryColor,
                            accentColor: accentColor,
                            onPlay: () {
                              cubit.playLine(index);
                            },
                            onAddToSrs: () => _addLyricToSrs(context, song, line),
                          );
                        },
                      ),
              ),
              MusicControlsBar(
                isPlaying: state.isPlaying,
                isQuizMode: state.isQuizMode,
                showTranslation: state.showTranslation,
                playbackSpeed: state.playbackSpeed,
                progress: state.progress,
                primaryColor: primaryColor,
                onTogglePlayPause: () {
                  HapticFeedback.mediumImpact();
                  cubit.togglePlayPause();
                },
                onPrevious: () {
                  HapticFeedback.selectionClick();
                  cubit.previousLine();
                },
                onNext: () {
                  HapticFeedback.selectionClick();
                  cubit.nextLine();
                },
                onToggleQuizMode: () {
                  HapticFeedback.lightImpact();
                  cubit.toggleQuizMode();
                },
                onToggleTranslation: () {
                  HapticFeedback.lightImpact();
                  cubit.toggleTranslation();
                },
                onSpeedChanged: (speed) {
                  HapticFeedback.selectionClick();
                  cubit.setPlaybackSpeed(speed);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SongHeaderCard extends StatelessWidget {
  final PortugueseSong song;
  final Color primaryColor;
  final Color accentColor;
  final AnimationController vinylController;
  final bool isPlaying;
  final int? quizScore;

  const _SongHeaderCard({
    required this.song,
    required this.primaryColor,
    required this.accentColor,
    required this.vinylController,
    required this.isPlaying,
    required this.quizScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: vinylController,
            builder: (context, child) {
              return Transform.rotate(
                angle: vinylController.value * 2 * math.pi,
                child: child,
              );
            },
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black87,
                border: Border.all(color: primaryColor, width: 2),
                boxShadow: isPlaying
                    ? [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor,
                  ),
                  child: Center(
                    child: Text(
                      song.coverEmoji,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${song.genre.emoji} ${song.genre.labelPt}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${song.dialectFlag} ${song.cefrLevel}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (quizScore != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$quizScore pts 🏆',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  song.artist,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song.culturalIntroRu,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
